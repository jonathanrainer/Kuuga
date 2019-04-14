import trace_repository_datatypes::*;

module trace_repository
#(
    TRACE_ENTRIES = 2048,
    DATA_ADDR_WIDTH = 16
)
(
    input clk,
    input rst_n,

    // Capture Inputs
    input trace_format trace_in,
    input bit trace_capture_enable,
    input bit lock,
    
    // Requests from Enokida
    input bit trace_req,
    input bit cancel,
    output trace_format trace_out,
    output bit [$clog2(TRACE_ENTRIES)-1:0] trace_index_o,
    output bit entry_valid,
    output bit cancelled,
    output bit processing_complete,
    
    // Requests to Mark Entries Done
    input bit [$clog2(TRACE_ENTRIES)-1:0] index_done,
    input bit mark_done,
    input bit processing_flag,
    output bit mark_done_valid,
    
    // Requests to Check the Status of a Trace Entry
    input bit [$clog2(TRACE_ENTRIES)-1:0] trace_index_i,
    output bit retired,
    
    // Requests to find a trace entry from an address
    input bit [DATA_ADDR_WIDTH-1:0] addr_in,
    input bit get_index,
    output bit [$clog2(TRACE_ENTRIES)-1:0] index_o,
    output bit index_valid
    
   
);

    trace_repo_entry trace_entries[0:TRACE_ENTRIES-1];
    integer signed capture_pointer = -1;
    integer next_available = 0;
    
    enum bit {
        LISTEN_FOR_REQ,
        WAIT_FOR_VALID
    } state;
    
    initial
    begin
        initialise_device();
    end
    
    always_ff @(posedge clk)
    begin
        if (!rst_n) initialise_device();
        if (!lock)
        begin
            if (trace_capture_enable && (trace_entries[capture_pointer].trace_entry != trace_in)) 
            begin
                trace_entries[capture_pointer+1].trace_entry <= trace_in;
                trace_entries[capture_pointer+1].processing <= 1'b0;
                trace_entries[capture_pointer+1].retired <= 1'b0;
                capture_pointer <= capture_pointer + 1;
            end
        end
    end
    
    always_ff @(posedge clk)
    begin
        unique case (state)
            LISTEN_FOR_REQ:
            begin
                if (trace_req) 
                begin
                    automatic bit end_reached = 1'b1;
                    for (int i = 0; i < capture_pointer; i++)
                    begin
                        if(!(trace_entries[i].processing || trace_entries[i].retired))
                        begin
                            next_available <= i;
                            if (can_next_available_be_executed(i))
                            begin
                                trace_out <= trace_entries[i].trace_entry;
                                trace_index_o <= i;
                                entry_valid <= 1'b1;
                                state <= LISTEN_FOR_REQ;
                                end_reached = 1'b0;
                                break;
                            end
                            else if (cancel) 
                            begin
                                cancelled <= 1'b1;
                                end_reached = 1'b0;
                                break;
                            end
                            else 
                            begin
                                state <= WAIT_FOR_VALID;
                                end_reached = 1'b0;
                                break;
                            end
                        end
                    end
                    if (end_reached) processing_complete <= 1'b1;
                end
                else
                begin
                    entry_valid <= 1'b0;
                    cancelled <= 1'b0;
                end
             end
             WAIT_FOR_VALID:
             begin
                if (can_next_available_be_executed(next_available))
                begin
                    trace_out <= trace_entries[next_available].trace_entry;
                    trace_index_o <= next_available;
                    trace_entries[next_available].processing <= 1'b1;
                    entry_valid <= 1'b1;
                    state <= LISTEN_FOR_REQ;
                end
                else if (cancel)
                begin
                    cancelled <= 1'b1;
                    state <= LISTEN_FOR_REQ;
                end
             end
        endcase
       
        
    end
    
    always_ff @(posedge clk)
    begin
        if (mark_done)
        begin
            trace_entries[index_done].processing = processing_flag;
            trace_entries[index_done].retired = !processing_flag;
            mark_done_valid <= 1'b1;
        end
        else mark_done_valid <= 1'b0;
    end
    
    always_comb
    begin
        retired = trace_entries[trace_index_i].retired;
    end
    
    always_ff @(posedge clk)
    begin
        if (get_index)
        begin
            for (int i = 0; i < capture_pointer; i++)
            begin
                if (trace_entries[i].trace_entry.mem_addr == addr_in && !trace_entries[i].retired) 
                begin
                    index_o = i;
                    index_valid <= 1'b1;
                    break;
                end
            end
        end
        else index_valid <= 1'b0;
    end 
    
    function can_next_available_be_executed(input integer next_available);
        for(int i = next_available - 1; i > -1; i--)
        begin
            if(trace_entries[i].trace_entry.mem_addr == trace_entries[next_available].trace_entry.mem_addr && !trace_entries[i].retired) return 1'b0;
        end
        return 1'b1;
    endfunction

endmodule
