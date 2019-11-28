import gouram_datatypes::*;
import dm_trace_repository_datatypes::*;

module enokida_dm
#(
    ADDR_WIDTH = 16,
    DATA_WIDTH = 32
)
(
    input bit clk,
    input bit rst_n,
    
    // RI5CY Protocol Input (Processor -> Cache)
    
    input bit                       proc_cache_data_req_i,
    input bit   [ADDR_WIDTH-1:0]    proc_cache_data_addr_i,
    input bit                       proc_cache_data_we_i,
    input bit   [DATA_WIDTH/8-1:0]  proc_cache_data_be_i,
    input bit   [DATA_WIDTH-1:0]    proc_cache_data_wdata_i,
    
    output bit                      proc_cache_data_gnt_o,
    output bit                      proc_cache_data_rvalid_o,
    output bit  [DATA_WIDTH-1:0]    proc_cache_data_rdata_o,
    
    // RI5CY Protocol Output (Cache -> Memory (Reserved for Cache Miss))
    
    input bit                       cache_mem_data_gnt_i,
    input bit                       cache_mem_data_rvalid_i,
    input bit   [DATA_WIDTH-1:0]    cache_mem_data_rdata_i,
    
    output bit                      cache_mem_data_req_o,
    output bit  [ADDR_WIDTH-1:0]    cache_mem_data_addr_o,
    output bit                      cache_mem_data_we_o,
    output bit  [DATA_WIDTH/8-1:0]  cache_mem_data_be_o,
    output bit  [DATA_WIDTH-1:0]    cache_mem_data_wdata_o,
    
    // Trace Input
    input trace_format              trace_in,
    input bit                       trace_ready,
    input bit                       trace_capture_enable,
    input bit                       lock,

    output int req_count,
    output int hit_count,
    output int miss_count
);

    bit rst;
    assign rst = !rst_n;
    
    cpu_req_type cpu_req;
    mem_data_type mem_data;
    mem_req_type mem_req;
    cpu_result_type cpu_res;
    
    bit [ADDR_WIDTH-1:0] cached_addr;
    bit [DATA_WIDTH-1:0] cached_data;
    
    bit [ADDR_WIDTH-1:0] addr_to_check;
    bit wb_necessary;
    bit indexed_cache_entry_valid;
    
    dm_cache_fsm #() dm_cache(
        .clk(clk),
        .*
    );
    
    trace_repo_data_entry trace_out;
    bit processing_complete;
    bit req;
    bit cancel;
    bit cancelled;
    bit entry_valid;
    
    bit [$clog2(TRACE_ENTRIES)-1:0] index_done;
    bit mark_done;
    bit processing_flag;
    bit mark_done_valid;
    bit mem_trace_flag;
    bit [ADDR_WIDTH-1:0] mem_addr; 
    
    bit [$clog2(TRACE_ENTRIES)-1:0] trace_index_o;
    
    bit [ADDR_WIDTH-1:0] addr_in;
    bit signed [$clog2(TRACE_ENTRIES)-1:0] index_o;
    bit get_index;
    bit index_valid;
  
    dm_trace_repository #(DATA_ADDR_WIDTH) trace_repo(
        .trace_req(req),
        .*
    );
    
    enum bit [4:0] {
        IDLE,
        CAPTURE_PHASE_GNT,
        CAPTURE_PHASE_RVALID,
        MAKE_REQ_TO_CACHE,
        CACHE_HIT_GNT,
        CACHE_HIT_DATA,
        UPDATE_MAPPING,
        SERVICE_WRITE_BACK_WAIT_GNT,
        SERVICE_WRITE_BACK_WAIT_RVALID,
        SERVICE_CACHE_MISS_MEM_LOAD_WAIT_GNT,
        SERVICE_CACHE_MISS_MEM_LOAD_WAIT_RVALID,
        SERVICE_CACHE_MISS_MEM_STORE,
        SERVICE_CACHE_MISS_TRACE_LOAD_WAIT_GNT,
        SERVICE_CACHE_MISS_TRACE_LOAD_WAIT_RVALID,
        SERVICE_CACHE_MISS_TRACE_STORE,
        UPDATE_TRACE_REPO,
        SLEEP
     } state;
    
     bit wb_necessary_temp = 0;
     bit prev_signals_saught = 0;
     bit cached_rvalid = 0;
     bit [DATA_WIDTH-1:0] cached_rdata = 32'b0;
     
     bit signed [$clog2(TRACE_ENTRIES)-1:0] mapping_cache_to_trace_index [0 : 2**(INDEXMSB-INDEXLSB + 1) - 1];
     bit first_stage_activity_ended;
     
    initial
    begin
         initialise_device();
    end 
 
    // Trace Executing Part
    
    always_ff @(posedge clk)
    begin
        if (!rst_n) initialise_device();
        else
        begin
            unique case (state)
                IDLE:
                begin
                    if (trace_capture_enable || !first_stage_activity_ended)
                    begin
                        proc_cache_data_rvalid_o <= 1'b0;
                        proc_cache_data_gnt_o <= 1'b0;
                        if (proc_cache_data_req_i && !cache_mem_data_gnt_i)
                        begin
                            cache_mem_data_req_o <= 1'b1;
                            cache_mem_data_addr_o <= proc_cache_data_addr_i;
                            cache_mem_data_we_o <= proc_cache_data_we_i;
                            cache_mem_data_be_o <= proc_cache_data_be_i;
                            cache_mem_data_wdata_o <= proc_cache_data_wdata_i;
                            state <= CAPTURE_PHASE_GNT;
                        end
                    end
                    else if (processing_complete) state <= IDLE;
                    else if (lock)
                    begin
                         cache_mem_data_req_o <= 1'b0;
                         cache_mem_data_addr_o <= 16'b0;
                         cache_mem_data_we_o <= 1'b0;
                         cache_mem_data_be_o <= 4'b0;
                         cache_mem_data_wdata_o <= 32'b0;
                         proc_cache_data_gnt_o <= 1'b0;
                         proc_cache_data_rvalid_o <= 1'b0;
                         proc_cache_data_rdata_o <= 32'b0;
                         req <= 1'b1;
                         prev_signals_saught <= 1'b0;
                         state <= MAKE_REQ_TO_CACHE;
                    end
                end
                CAPTURE_PHASE_GNT:
                begin
                    if (cache_mem_data_gnt_i) 
                    begin
                        if (cache_mem_data_addr_o == 0 && cache_mem_data_wdata_o == 0) first_stage_activity_ended <= 1'b1;
                        cache_mem_data_req_o <= 1'b0; 
                        proc_cache_data_gnt_o <= 1'b1;
                        state <= CAPTURE_PHASE_RVALID;
                        if (cache_mem_data_rvalid_i)
                        begin
                            proc_cache_data_rvalid_o <= 1'b1;
                            proc_cache_data_rdata_o <= cache_mem_data_rdata_i;
                            state <= IDLE;
                        end
                    end
                end
                CAPTURE_PHASE_RVALID:
                begin
                    proc_cache_data_gnt_o <= 1'b0;
                    if (cache_mem_data_rvalid_i)
                    begin
                        proc_cache_data_rvalid_o <= 1'b1;
                        proc_cache_data_rdata_o <= cache_mem_data_rdata_i;
                        state <= IDLE;
                    end
                end
                SLEEP:
                begin
                    // Continue to sleep unless it's the case that the blocking entry has been retired, or that a memory request starts
                    if (proc_cache_data_req_i) state <= MAKE_REQ_TO_CACHE;
                end
                MAKE_REQ_TO_CACHE:
                begin
                    mem_data.ready <= 1'b0;
                    proc_cache_data_rvalid_o <= 1'b0;
                    proc_cache_data_rdata_o <= 32'b0;
                    if ((entry_valid || proc_cache_data_req_i) && !prev_signals_saught)
                    begin
                        addr_to_check <= (proc_cache_data_req_i) ? proc_cache_data_addr_i : trace_out.mem_addr;
                        prev_signals_saught <= 1'b1;
                    end
                    else if (prev_signals_saught)
                    begin
                        req <= 1'b0;
                        // If it's the case that a memory request is waiting as well then give that priority
                        if (proc_cache_data_req_i)
                        begin
                            // Cancel a request to the Trace Repo if there is one.
                            cancel <= 1'b1;
                            cpu_req.addr <= proc_cache_data_addr_i;
                            cpu_req.rw <= proc_cache_data_we_i;
                            cpu_req.data <= (proc_cache_data_we_i) ? proc_cache_data_wdata_i : 0;
                            cpu_req.valid <= 1'b1;
                            mem_trace_flag <= 1'b0;
			                req_count <= req_count + 1;
                        end
                        else
                        begin
                            cpu_req.addr <= trace_out.mem_addr;
                            cpu_req.rw <= check_store(trace_out.instruction);
                            cpu_req.data <= 32'b0;
                            cpu_req.valid <= 1'b1;
                            mem_trace_flag <= 1'b1;
                        end
                        state <= CACHE_HIT_GNT;
                    end
                end
                CACHE_HIT_GNT:
                begin
                    if (cancelled) cancel <= 1'b0;
                    if (wb_necessary && !proc_cache_data_req_i) 
                    begin
                        addr_to_check <= cpu_req.addr;                        
                        state <= SLEEP;
                    end
                    if (!cpu_req.rw && indexed_cache_entry_valid && mem_trace_flag && !wb_necessary) 
                    begin
                        processing_flag <= 1'b1;
                        if (cpu_res.checked) 
                        begin
                            state <= UPDATE_TRACE_REPO;
                        end
                    end
                    else
                    begin
                        if (cpu_res.checked)
                        begin
                            cpu_req.valid <= 1'b0;
                            if(cpu_res.ready)
                            begin
                                if (!mem_trace_flag)
                                begin
                                    proc_cache_data_gnt_o <= 1'b1;
				    hit_count <= hit_count + 1;
                                    state <= CACHE_HIT_DATA;
                                end
                                else
                                begin
                                    processing_flag = 1'b1;
                                    mapping_cache_to_trace_index[cpu_req.addr[INDEXMSB:INDEXLSB]] <=  trace_index_o;
                                    state <= UPDATE_TRACE_REPO;
                                end
                            end
                            else if (mem_req.rw) 
                            begin
                                cached_addr <= mem_req.addr;
                                cached_data <= mem_req.data;
                                state <= SERVICE_WRITE_BACK_WAIT_GNT;
                            end
                            else 
                            begin
                                if (mem_trace_flag) state <= (check_store(trace_out.instruction)) ? SERVICE_CACHE_MISS_TRACE_STORE : SERVICE_CACHE_MISS_TRACE_LOAD_WAIT_GNT;
                                else state <= (proc_cache_data_we_i) ? SERVICE_CACHE_MISS_MEM_STORE : SERVICE_CACHE_MISS_MEM_LOAD_WAIT_GNT;
                            end
                        end
                    end
                end  
                CACHE_HIT_DATA:
                begin
                    proc_cache_data_gnt_o <= 1'b0;
                    proc_cache_data_rvalid_o <= 1'b1;
                    proc_cache_data_rdata_o <= (cpu_req.rw) ? 32'h00000000 : cpu_res.data;
                    processing_flag <= 1'b0;
                    state <= (mem_trace_flag) ? UPDATE_TRACE_REPO : UPDATE_MAPPING;
                end
                UPDATE_MAPPING:
                begin
                    proc_cache_data_rvalid_o <= 1'b0;
                    if (!get_index && !index_valid) 
                    begin
                        get_index <= 1'b1;
                        addr_in <= mem_req.addr;
                    end
                    else if (get_index && index_valid)
                    begin
                        get_index <= 1'b0;
                        mapping_cache_to_trace_index[cpu_req.addr[INDEXMSB:INDEXLSB]] <= index_o;
                        state <= UPDATE_TRACE_REPO;
                    end
                end
                SERVICE_WRITE_BACK_WAIT_GNT:
                begin
                    if (!cache_mem_data_gnt_i)
                    begin
                        cache_mem_data_req_o <= 1'b1;
                        cache_mem_data_addr_o <= cached_addr;
                        cache_mem_data_we_o <= 1'b1;
                        cache_mem_data_be_o <= 4'hf;
                        cache_mem_data_wdata_o <= cached_data;
                    end
                    else if (cache_mem_data_gnt_i)
                    begin
                        cache_mem_data_req_o <= 1'b0;
                        cache_mem_data_addr_o <= 16'b0;
                        cache_mem_data_we_o <= 1'b0;
                        cache_mem_data_be_o <= 4'h0;
                        cache_mem_data_wdata_o <= 32'h00000000;
                        state <= SERVICE_WRITE_BACK_WAIT_RVALID;
                    end
                end
                SERVICE_WRITE_BACK_WAIT_RVALID:
                begin
                     if(cache_mem_data_rvalid_i)
                     begin
                        mem_data.ready <= 1'b1;
                        if (mem_trace_flag) state <= (cpu_req.rw) ? SERVICE_CACHE_MISS_TRACE_STORE : SERVICE_CACHE_MISS_TRACE_LOAD_WAIT_GNT;
                        else state <= (cpu_req.rw) ? SERVICE_CACHE_MISS_MEM_STORE : SERVICE_CACHE_MISS_MEM_LOAD_WAIT_GNT;
                     end
                end
                SERVICE_CACHE_MISS_MEM_LOAD_WAIT_GNT:
                begin
                    mem_data.ready <= 1'b0;
                    if(!cache_mem_data_gnt_i && !cache_mem_data_req_o) 
                    begin
                        cache_mem_data_req_o <= proc_cache_data_req_i;
                        proc_cache_data_gnt_o <= cache_mem_data_gnt_i;
                        proc_cache_data_rvalid_o <= cache_mem_data_rvalid_i;
                        cache_mem_data_addr_o <= proc_cache_data_addr_i;
                        cache_mem_data_we_o <= proc_cache_data_we_i;
                        cache_mem_data_be_o <= proc_cache_data_be_i;
                        proc_cache_data_rdata_o <= cache_mem_data_rdata_i;
                        cache_mem_data_wdata_o <= proc_cache_data_wdata_i;
                        get_index <= 1'b1;
                        addr_in <= proc_cache_data_addr_i;
                    end 
                    else if (cache_mem_data_gnt_i)
                    begin
                        cache_mem_data_req_o <= 1'b0;
                        proc_cache_data_gnt_o <= 1'b1;
                        cache_mem_data_addr_o <= 16'b0;
                        cache_mem_data_we_o <= 1'b0;
                        cache_mem_data_be_o <= 1'b0;
                        state <= SERVICE_CACHE_MISS_MEM_LOAD_WAIT_RVALID;
                    end 
                end
                SERVICE_CACHE_MISS_MEM_LOAD_WAIT_RVALID:
                begin
                    proc_cache_data_gnt_o <= 1'b0;
                    if (cache_mem_data_rvalid_i) 
                    begin
                        cached_rvalid <= 1'b1;
                        cached_rdata <= cache_mem_data_rdata_i;
                    end
                    if ((cache_mem_data_rvalid_i || cached_rvalid) && index_valid)
                    begin
                        cached_rvalid <= 1'b0;
                        cached_rdata <= 32'b0;
                        get_index <= 1'b0;
                        proc_cache_data_rvalid_o <= 1'b1;
                        proc_cache_data_rdata_o <= (cached_rvalid) ? cached_rdata : cache_mem_data_rdata_i;
                        processing_flag <= 1'b0;
                        mem_data.data <= (cached_rvalid) ? cached_rdata : cache_mem_data_rdata_i;
                        mem_data.ready <= 1'b1;
                        mapping_cache_to_trace_index[mem_req.addr[INDEXMSB:INDEXLSB]] <= index_o;
			miss_count <= miss_count + 1;
                        state <= UPDATE_TRACE_REPO;
                    end
                end
                SERVICE_CACHE_MISS_MEM_STORE:
                begin
                    if (!get_index && !index_valid) 
                    begin
                        if (!proc_cache_data_gnt_o) proc_cache_data_gnt_o <= 1'b1;
                        get_index <= 1'b1;
                        addr_in <= proc_cache_data_addr_i;
                    end
                    else if (get_index && !index_valid) proc_cache_data_gnt_o <= 1'b0;
                    else 
                    begin
                        proc_cache_data_gnt_o <= 1'b0;
                        proc_cache_data_rvalid_o <= 1'b1;
                        mem_data.data <= proc_cache_data_wdata_i;
                        mem_data.ready <= 1'b1;
                        mapping_cache_to_trace_index[mem_req.addr[INDEXMSB:INDEXLSB]] <= index_o;
                        get_index <= 1'b0;
                        processing_flag <= 1'b0;
		        miss_count <= miss_count + 1;
                        state <= UPDATE_TRACE_REPO;
                    end
                end  
                SERVICE_CACHE_MISS_TRACE_LOAD_WAIT_GNT:
                begin
                    mem_data.ready <= 1'b0;
                    if (!cache_mem_data_gnt_i && !cache_mem_data_req_o)
                    begin
                        cache_mem_data_req_o <= 1'b1;
                        cache_mem_data_addr_o <= cpu_req.addr;
                        cache_mem_data_we_o <= cpu_req.rw;
                        cache_mem_data_be_o <= 4'hF;
                        cache_mem_data_wdata_o <= cpu_req.data;
                    end
                    else if (cache_mem_data_gnt_i)
                    begin
                        cache_mem_data_req_o <= 1'b0;
                        cache_mem_data_addr_o <= 16'b0;
                        cache_mem_data_we_o <= 1'b0;
                        cache_mem_data_be_o <= 4'h0;
                        cache_mem_data_wdata_o <= 32'b0;
                        state <= SERVICE_CACHE_MISS_TRACE_LOAD_WAIT_RVALID;
                    end
                end
                SERVICE_CACHE_MISS_TRACE_LOAD_WAIT_RVALID:
                begin
                    if (cache_mem_data_rvalid_i)
                    begin
                        mem_data.data <= cache_mem_data_rdata_i;
                        mem_data.ready <= 1'b1;
                        processing_flag <= 1'b1;
                        state <= UPDATE_TRACE_REPO;
                    end
                end
                SERVICE_CACHE_MISS_TRACE_STORE:
                begin
                    mem_data.ready <= 1'b1;
                    mapping_cache_to_trace_index[mem_req.addr[INDEXMSB:INDEXLSB]] <= trace_index_o;
                    processing_flag <= 1'b1;
                    state <= UPDATE_TRACE_REPO;
                end
                UPDATE_TRACE_REPO:
                begin
                    proc_cache_data_rvalid_o <= 1'b0;
                    if(mem_trace_flag) 
                    begin
                        index_done <= trace_index_o;
                    end
                    else index_done <= mapping_cache_to_trace_index[mem_req.addr[INDEXMSB:INDEXLSB]];
                    mem_addr <= mem_req.addr;
                    mark_done <= 1'b1;
                    state <= IDLE;
                end
            endcase
            if (mark_done && mark_done_valid) mark_done <= 1'b0;
        end
    end
    
    task initialise_device();
        begin
            state <= IDLE;
            req <= 1'b0;
            mark_done <= 0;
	        hit_count <= 0;
            miss_count <= 0;
            req_count <= 0;
            first_stage_activity_ended <= 0;
        end
    endtask
    
    function bit check_store(input bit[INSTR_DATA_WIDTH-1:0] instruction);
        return !(instruction ==? 32'h??????83 || instruction ==? 32'h??????03);
        endfunction

endmodule
