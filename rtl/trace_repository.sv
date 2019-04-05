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
    output trace_format trace_out,
    output bit entry_valid,
    output bit processing_complete,
    
    // Requests to Mark Entries Done
    input bit [DATA_ADDR_WIDTH-1:0] addr_done,
    input bit mark_done,
    output bit marked,
    output bit marked_valid
   
);

    trace_repo_entry trace_entries[0:TRACE_ENTRIES-1];
    integer signed capture_pointer = -1;
    integer signed action_pointer = -1;
    
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
    
    always_comb
    begin
        if (trace_req) 
        begin
            if (action_pointer == capture_pointer) processing_complete <= 1'b1;
            else
            begin
                for (int i = 1; i < capture_pointer; i++)
                begin
                    if(!(trace_entries[action_pointer+i].processing || trace_entries[action_pointer+i].retired))
                    begin
                        trace_out <= trace_entries[action_pointer+i].trace_entry;
                        trace_entries[action_pointer+i].processing = 1'b1;
                        action_pointer = action_pointer + i;
                        entry_valid = 1'b1;
                        break;
                    end
                end
            end
        end
        else entry_valid = 1'b0;
    end
    
    always_comb
    begin
        if(mark_done)
        begin
            for (int i = 0; i < capture_pointer; i++)
            begin
                if (trace_entries[i].trace_entry.mem_addr == addr_done && trace_entries[i].processing && !trace_entries[i].retired)
                begin
                    trace_entries[i].processing = 1'b0;
                    trace_entries[i].retired = 1'b1;
                    break;
                end
            end
            marked_valid = 1'b1;
        end
        else marked_valid = 1'b0;
    end
    
    task initialise_device();
        begin
            capture_pointer <= -1;
            action_pointer <= -1;
            entry_valid <= 1'b0;
            processing_complete <= 1'b0;
        end
    endtask 

endmodule
