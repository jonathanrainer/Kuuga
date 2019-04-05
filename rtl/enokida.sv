import cache_def::*;
import gouram_datatypes::*;
import trace_repository_datatypes::*;

module enokida
#(
    ADDR_WIDTH = 16,
    DATA_WIDTH = 32,
    CACHE_BLOCKS = 128
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
    input bit                       trace_capture_enable,
    input bit                       lock,
    input integer                   counter
);

    bit rst;
    assign rst = !rst_n;
    
    cpu_req_type cpu_req = '{default: 0};
    mem_data_type mem_data = '{default: 0};
    mem_req_type mem_req = '{default: 0};
    cpu_result_type cpu_res = '{default: 0};
    
    bit [ADDR_WIDTH-1:0] cached_addr;
    bit [DATA_WIDTH-1:0] cached_data;
    
    dm_cache_fsm #(CACHE_BLOCKS) standard_cache(
        .clk(clk),
        .*
    );
    
    integer signed counter_offset = -1;
    integer req_counter = 0;
    integer sync_time = 0;
    
    trace_format trace_out;
    trace_format cached_trace = '{default:0};
    bit processing_complete;
    bit req;
    bit entry_valid;
    
    bit [ADDR_WIDTH-1:0] addr_done;
    bit marked;
    bit marked_valid;
    bit mark_done;
    
    trace_repository trace_repo(
        .trace_req(req),
        .*
    );
    
    enum bit [3:0] {
        IDLE,
        MAKE_REQ_TO_CACHE,
        CACHE_HIT_GNT,
        CACHE_HIT_DATA,
        SERVICE_WRITE_BACK_WAIT_GNT,
        SERVICE_WRITE_BACK_WAIT_RVALID,
        SERVICE_CACHE_MISS_MEM,
        SERVICE_CACHE_MISS_TRACE,
        UPDATE_TRACE_REPO
     } state;
     
     // 1 is to indicate the request is coming from the Trace Repo
     // 0 indicates otherwise
     bit mem_trace_flag = 0;
     
    initial
    begin
         initialise_device();
    end 
 
    // Trace Executing Part
    
    always_ff@(posedge clk)
    begin
        if (proc_cache_data_req_i) req_counter <= req_counter+1;
        else req_counter <= 0;
    end
    
    always_ff @(posedge clk)
    begin
        if (!rst_n) initialise_device();
        else
        begin
            unique case (state)
                IDLE:
                begin
                    if (trace_capture_enable)
                    begin
                        assign cache_mem_data_req_o = proc_cache_data_req_i;
                        assign cache_mem_data_addr_o = proc_cache_data_addr_i;
                        assign cache_mem_data_we_o = proc_cache_data_we_i;
                        assign cache_mem_data_be_o = proc_cache_data_be_i;
                        assign cache_mem_data_wdata_o = proc_cache_data_wdata_i;
                        assign proc_cache_data_gnt_o =  cache_mem_data_gnt_i;
                        assign proc_cache_data_rvalid_o = cache_mem_data_rvalid_i;
                        assign proc_cache_data_rdata_o = cache_mem_data_rdata_i;
                    end
                    else if (processing_complete) state <= IDLE;
                    else if (lock)
                    begin
                         req <= 1'b1;
                         state <= MAKE_REQ_TO_CACHE;
                    end
                end
                MAKE_REQ_TO_CACHE:
                begin
                    automatic bit cached_trace_present = (cached_trace.instruction != 0);
                    mem_data.ready <= 1'b0;
                    assign proc_cache_data_rvalid_o = 1'b0;
                    assign proc_cache_data_rdata_o = 32'b0;
                    if (entry_valid || cached_trace_present) 
                    begin
                        if (counter_offset == -1 && sync_time == 0) sync_time <= trace_out.mem_trans_time_start;
                        if (sync_time != 0 && counter_offset == -1 && proc_cache_data_req_i) counter_offset <= counter - sync_time - req_counter;
                        else
                        begin
                            // No need to request anymore
                            req <= 1'b0;
                            // If it's the case that a memory request is waiting as well then give that priority
                            if (proc_cache_data_req_i && counter >= trace_out.mem_trans_time_start)
                            begin
                                // Store the trace so it can be quickly used later on
                                if (!cached_trace_present) cached_trace <= trace_out;
                                cpu_req.addr <= proc_cache_data_addr_i;
                                cpu_req.rw <= proc_cache_data_we_i;
                                cpu_req.data <= (proc_cache_data_we_i) ? proc_cache_data_wdata_i : 0;
                                cpu_req.valid <= 1'b1;
                                mem_trace_flag <= 1'b0;
                                state <= CACHE_HIT_GNT;
                            end
                            else
                            begin
                                cpu_req.addr <= (cached_trace_present) ? cached_trace.mem_addr : trace_out.mem_addr;
                                cpu_req.rw <= check_store((cached_trace_present) ? cached_trace.instruction : trace_out.instruction);
                                cpu_req.data <= 32'b0;
                                cpu_req.valid <= 1'b1;
                                mem_trace_flag <= 1'b1;
                                if (cached_trace_present) cached_trace <= '{default:0};
                                state <= CACHE_HIT_GNT;
                            end
                        end
                    end
                end
                CACHE_HIT_GNT:
                begin
                    if (cpu_res.checked)
                    begin
                        cpu_req.valid <= 1'b0;
                        if(cpu_res.ready)
                        begin
                            assign proc_cache_data_gnt_o = 1'b1;
                            state <= CACHE_HIT_DATA;
                        end
                        else if (mem_req.rw) 
                        begin
                            cached_addr <= mem_req.addr;
                            cached_data <= mem_req.data;
                            state <= SERVICE_WRITE_BACK_WAIT_GNT;
                        end
                        else 
                        begin
                            state <= (mem_trace_flag) ? SERVICE_CACHE_MISS_TRACE : SERVICE_CACHE_MISS_MEM;
                        end
                    end
                end  
                CACHE_HIT_DATA:
                begin
                    assign proc_cache_data_gnt_o = 1'b0;
                    assign proc_cache_data_rvalid_o = 1'b1;
                    assign proc_cache_data_rdata_o = (cpu_req.rw) ? 32'h00000000 : cpu_res.data;
                    state <= UPDATE_TRACE_REPO;
                end
                SERVICE_WRITE_BACK_WAIT_GNT:
                begin
                    if (mem_req.valid && !cache_mem_data_gnt_i)
                    begin
                        assign cache_mem_data_req_o = 1'b1;
                        assign cache_mem_data_addr_o = cached_addr;
                        assign cache_mem_data_we_o = 1'b1;
                        assign cache_mem_data_be_o = 4'hf;
                        assign cache_mem_data_wdata_o = cached_data;
                    end
                    else if (mem_req.valid && cache_mem_data_gnt_i)
                    begin
                        assign cache_mem_data_req_o = 1'b0;
                        assign cache_mem_data_addr_o = 1'b0;
                        assign cache_mem_data_we_o = 1'b0;
                        assign cache_mem_data_be_o = 4'h0;
                        assign cache_mem_data_wdata_o = 32'h00000000;
                        state <= SERVICE_WRITE_BACK_WAIT_RVALID;
                    end
                end
                SERVICE_WRITE_BACK_WAIT_RVALID:
                begin
                     if(cache_mem_data_rvalid_i)
                     begin
                        mem_data.ready <= 1'b1;
                        state <= SERVICE_CACHE_MISS_MEM;
                     end
                end
                SERVICE_CACHE_MISS_MEM:
                begin
                    mem_data.ready <= 1'b0;
                    if(!cache_mem_data_rvalid_i) 
                    begin
                        assign cache_mem_data_req_o = proc_cache_data_req_i;
                        assign proc_cache_data_gnt_o = cache_mem_data_gnt_i;
                        assign proc_cache_data_rvalid_o = cache_mem_data_rvalid_i;
                        assign cache_mem_data_addr_o = proc_cache_data_addr_i;
                        assign cache_mem_data_we_o = proc_cache_data_we_i;
                        assign cache_mem_data_be_o = proc_cache_data_be_i;
                        assign proc_cache_data_rdata_o = cache_mem_data_rdata_i;
                        assign cache_mem_data_wdata_o = proc_cache_data_wdata_i;
                    end 
                    else 
                    begin
                        mem_data.data <= cache_mem_data_rdata_i;
                        mem_data.ready <= 1'b1;
                        assign cache_mem_data_req_o = 1'b0;
                        assign proc_cache_data_gnt_o = 1'b0;
                        assign proc_cache_data_rvalid_o = 1'b0;
                        assign cache_mem_data_addr_o = 16'b0;
                        assign cache_mem_data_we_o = 1'b0;
                        assign cache_mem_data_be_o = 1'b0;
                        assign proc_cache_data_rdata_o = 32'b0;
                        assign cache_mem_data_wdata_o = 32'b0;
                        state <= UPDATE_TRACE_REPO;
                    end 
                end
                SERVICE_CACHE_MISS_TRACE:
                begin
                    if (!cache_mem_data_rvalid_i)
                    begin
                        assign cache_mem_data_req_o = 1'b1;
                        assign cache_mem_data_addr_o = cpu_req.addr;
                        assign cache_mem_data_we_o = cpu_req.rw;
                        assign cache_mem_data_be_o = 4'hF;
                        assign cache_mem_data_wdata_o = cpu_req.data;
                    end
                    else
                    begin
                        mem_data.data <= cache_mem_data_rdata_i;
                        mem_data.ready <= 1'b1;
                        assign cache_mem_data_req_o = 1'b0;
                        assign cache_mem_data_addr_o = 16'b0;
                        assign cache_mem_data_we_o = 0;
                        assign cache_mem_data_be_o = 4'h0;
                        assign cache_mem_data_wdata_o = 32'b0;
                        state <= (cpu_req.rw) ? IDLE : UPDATE_TRACE_REPO;
                    end
                end
                UPDATE_TRACE_REPO:
                begin
                    addr_done <= cpu_req.addr;
                    if (marked && marked_valid) state <= IDLE;
                end
            endcase
        end
    end
    
    task initialise_device();
        begin
            state <= IDLE;
            req <= 1'b0;
            counter_offset <= -1;
            req_counter <= 0;
        end
    endtask
    
    function bit check_store(input bit[INSTR_DATA_WIDTH-1:0] instruction);
        return !(instruction ==? 32'h??????83 || instruction ==? 32'h??????03);
        endfunction

endmodule
