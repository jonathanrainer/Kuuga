`timescale 1ns / 1ps

/* Cache: Data Memory, Single Port, 1024 blocks */

import nway_cache_def::*;

module nway_cache_data
#(
    CACHE_BLOCKS = 128
) 
(
    input bit               clk,
    input cache_data_req_type    data_req,       // Data Request/Command (RW, Valid etc.)
    input cache_data_type   data_write,     // Write Port (128-bit line)
    output cache_data_type  data_read
);
    cache_data_type data_mem[0:CACHE_BLOCKS-1];
    
    initial
    begin
        for (int i = 0; i < CACHE_BLOCKS; i++) data_mem[i] = '0;
    end
    
    assign data_read = data_mem[data_req.cache_index];
    
    always_ff @(posedge(clk)) 
    begin
        if (data_req.we) 
        begin
            data_mem[data_req.cache_index] <= data_write;
        end
    end
    
    
endmodule

/* Cache: Tag Memory, Single port, 1024 blocks*/

module nway_cache_tag
#(
    CACHE_BLOCKS = 128
)
(
    input bit                clk,
    input cache_tag_req_type tag_req,        // Tag Request/Command (RW, Valid etc.)
    input cache_tag_type     tag_write,      // Write Port    
    output cache_tag_type    tag_read,       // Read Port
    
    input bit [TAGMSB:0] addr_to_check,
    input bit recheck_necessary,
    output bit wb_necessary,
    output bit indexed_cache_entry_valid
);
    (* dont_touch = "yes" *) cache_tag_type tag_mem[0:CACHE_BLOCKS-1];
    bit [$clog2(CACHE_BLOCKS)-(SETMSB+1)-1:0] fifo_tracker [2**(SETMSB+1)-1:0] = '{default:0};
    
    initial
    begin
        for (int i = 0; i < CACHE_BLOCKS; i++) tag_mem[i] = '0;
    end
    
    always_ff@(posedge(clk)) 
    begin
        if (tag_req.we) 
        begin
            tag_mem[tag_write.cache_index] <= tag_write;
            fifo_tracker[tag_write.cache_index % 2**(SETMSB)] <= (fifo_tracker[tag_write.cache_index % 2**(SETMSB)] + 1) % 2**(SETMSB);
        end
    end
    
    always_comb
    begin
        automatic bit tag_found = 1'b0;
        automatic bit [$clog2(CACHE_BLOCKS)-(SETMSB+1)-1:0] last_bits = 0;
        automatic bit last_bits_found = 1'b0;
        for (int i = 0; i < 2**($clog2(CACHE_BLOCKS)-SETMSB+1); i++)
        begin
            automatic bit [$clog2(CACHE_BLOCKS)-(SETMSB+1)-1:0] offset = i;
            if(tag_req.tag_to_find == tag_mem[{tag_req.set, offset}].tag)
            begin
                tag_found = 1'b1;
                last_bits = offset;
                last_bits_found = 1'b1;
                break;
            end
            else if ((tag_mem[{tag_req.set, offset}].valid  == 1'b0) && !last_bits_found) 
            begin
                last_bits = offset;
                last_bits_found = 1'b1;
                break;
            end
        end
        if (tag_found || last_bits_found) 
        begin
            // At this point we've either found the tag or found an empty slot into which we can put the tag. We don't need to update
            // the FIFO Tracker until the set is full which is handled below.
            tag_read = tag_mem[{tag_req.set, last_bits}];
            tag_read.cache_index = {tag_req.set, last_bits};
        end
        else  
        begin
            // If we get to this point then we haven't found the tag we need and also there are no empty spaces anymore. So we have to use the
            // FIFO Tracker
            tag_read = tag_mem[{tag_req.set, fifo_tracker[tag_req.set]}];
            tag_read.cache_index = {tag_req.set, fifo_tracker[tag_req.set]};
        end
    end
    
    always_comb
    begin
        if (recheck_necessary)
        begin
            automatic bit [TAGMSB-TAGLSB:0] tag = addr_to_check[TAGMSB:TAGLSB];
            automatic bit [SETMSB-SETLSB:0] set = addr_to_check[SETMSB:SETLSB];
            automatic bit [$clog2(CACHE_BLOCKS)-1:0] index = '0;
            automatic integer indexes_occupied = 0;
            automatic bit index_found = 0;
            for (int i = 0; i < 2**($clog2(CACHE_BLOCKS)-SETMSB-1); i++)
            begin
                automatic bit [$clog2(CACHE_BLOCKS)-(SETMSB+1)-1:0] offset = i;
                if (!((tag_mem[{set, offset}].valid == 1'b0) || (tag_mem[{set, offset}].dirty == 1'b0))) indexes_occupied++;
                if(tag == tag_mem[{set, offset}].tag)
                begin
                    index = {set,offset};
                    index_found = 1;
                    break;
                end
            end
            if (index_found)
            begin
                wb_necessary = !((tag_mem[index].valid == 1'b0) || (tag_mem[index].dirty == 1'b0));
                indexed_cache_entry_valid = tag_mem[index].valid && tag_mem[index].tag == tag;
            end
            else 
            begin
                wb_necessary = 1'b0;
                indexed_cache_entry_valid = 1'b0;
            end
        end
    end
    
endmodule
    
/* Cache FSM */

module nway_cache_fsm
(
    input bit clk, 
    input bit rst,
    input cpu_req_type      cpu_req,    // CPU Request Input (CPU->cache)
    input mem_data_type     mem_data,   // Memory Response (memory->cache)
    
    input bit [TAGMSB:0] addr_to_check,
    input bit recheck_necessary,
    output bit wb_necessary,
    output bit indexed_cache_entry_valid,

    output mem_req_type     mem_req,    // Memory Request (cache->memory)
    output cpu_result_type  cpu_res,     // Cache Result (cache->CPU)
    
    output [$clog2(CACHE_BLOCKS)-1:0] index_affected,
    output [31:0] data_read_o,
    output [31:0] data_write_o
   
);

    /* Write clock */
    typedef enum {idle, compare_tag, allocate, write_back} cache_state_type;
    
    /* FSM state register */
    cache_state_type    vstate, rstate;
    
    /* Interface signals to tag memory*/
    cache_tag_type  tag_read;   //tag read result
    cache_tag_type  tag_write;  //tag write data
    cache_tag_req_type  tag_req;    //tag request
    
    /* Interface signals to cache data memory*/
    cache_data_type data_read;  //cache line read data
    cache_data_type data_write; //cache line write data
    cache_data_req_type  data_req;   //data req
    
    /* Temporary variable for cache controller result*/
    cpu_result_type v_cpu_res;
    
    /* Temporary variable for memory controller request*/
    mem_req_type    v_mem_req;
    
    // Counters
    int data_requests_counter;
    int cache_hit_counter;
    int cache_miss_counter;
    
    always_comb 
    begin
        /*-------------------------Default values for all signals------------*/
        /* No state change by default */
        vstate = rstate;
        v_cpu_res = '{default: 0}; 
        tag_write = '{default: 0};
    
        /* Read tag by default */
        tag_req.we = '0;
        /*Direct map index for tag */
        tag_req.set = cpu_req.addr[SETMSB:SETLSB];
        tag_req.tag_to_find = cpu_req.addr[TAGMSB:TAGLSB];
        
        /*Read current cache line by default */
        data_req.we = '0;
        /*Direct map index for cache data */
        data_req.cache_index = tag_read.cache_index;
        
        /* Modify correct word (32-bit) based on address */
        data_write = data_read;
        data_write = cpu_req.data;
        
        v_cpu_res.data = data_read;
        
        /* Memory request address (sampled from CPU request) */
        v_mem_req.addr = cpu_req.addr;
        /* Memory request data (used in write)*/
        v_mem_req.data = data_read;
        v_mem_req.rw = '0;
        v_mem_req.valid = '0; 
    
        //------------------------------------Cache FSM-------------------------
    
        unique case(rstate)
            /* Idle state */
            idle : 
            begin
                /* If there is a CPU request, then compare cache tag */
                if (cpu_req.valid) 
                begin
                    vstate = compare_tag;
                    v_cpu_res.checked = '0;
                end
            end 
            /* Compare_tag state */
            compare_tag : 
            begin
                /* Cache hit (tag match and cache entry is valid) */
                if (cpu_req.addr[TAGMSB:TAGLSB] == tag_read.tag && tag_read.valid) 
                begin
                    v_cpu_res.ready = '1;
                    /* Write hit */
                    if (cpu_req.rw) 
                    begin
                        /* Read/modify cache line */
                        tag_req.we = '1; data_req.we = '1;
                        /* No change in tag*/
                        tag_write.tag = tag_read.tag;
                        tag_write.valid = '1;
                        /* Cache line is dirty */
                        tag_write.dirty = '1;
                        tag_write.cache_index = tag_read.cache_index;
                    end
                    /*xaction is finished*/
                    vstate = idle;
                end
                /* Cache miss */
                else 
                begin
                    /* Generate new tag */
                    tag_req.we = '1;
                    tag_write.valid = '1;
                    /* New tag */
                    tag_write.tag = cpu_req.addr[TAGMSB:TAGLSB];
                    /* Cache line is dirty if write */
                    tag_write.dirty = cpu_req.rw;
                    tag_write.cache_index = tag_read.cache_index;
                    /*Generate memory request on miss */
                    v_mem_req.valid = '1;
                    /* Compulsory miss or miss with clean block*/
                    if (tag_read.valid == 1'b0 || tag_read.dirty == 1'b0) vstate = allocate;
                    else 
                    begin
                        /* Miss with dirty line*/
                        /* Write back address*/
                        v_mem_req.addr = {tag_read.tag, tag_req.set};
                        v_mem_req.rw = '1;
                        /* Wait till write is completed*/
                        vstate = write_back;
                    end
                end
                v_cpu_res.checked = '1;
		v_cpu_res.cache_index = tag_read.cache_index;
            end
            /* Wait for allocating a new cache line */
            allocate: 
            begin 
                /* Memory controller has responded */
                if (mem_data.ready) 
                begin
                    /* Re-compare tag for write miss (need modify correct word) */
                    vstate = compare_tag;
                    data_write = mem_data.data;
                    /* Update cache line data */
                    data_req.cache_index = tag_read.cache_index;
                    data_req.we = '1;
                end
            end
            /* Wait for writing back dirty cache line */
            write_back : 
            begin
                /* Write back is completed */
                if (mem_data.ready)
                begin
                    /* Issue new memory request (allocating a new line) */
                    v_mem_req.valid = '1;
                    v_mem_req.rw = '0;
                    vstate = allocate;
                end
            end
        endcase
        mem_req = v_mem_req;     // Connect to output ports
        cpu_res = v_cpu_res;
    end
    
    always_ff @(posedge(clk)) 
    begin
        if (rst) rstate <= idle; // Reset to idle state
        else 
        begin
            rstate <= vstate;
        end
    end
    
    /*connect cache tag/data memory*/
    nway_cache_tag #(CACHE_BLOCKS) ctag(.*);
    nway_cache_data #(CACHE_BLOCKS) cdata(.*);
    
    assign index_affected = data_req.cache_index;
    assign data_read_o = data_read;
    assign data_write_o = data_write;
    
    endmodule
