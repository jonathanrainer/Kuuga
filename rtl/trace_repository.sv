import trace_repository_datatypes::*;
import cache_def::*;

module trace_repository
#(
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
    output trace_repo_data_entry trace_out,
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
    output bit signed [$clog2(TRACE_ENTRIES)-1:0] index_o,
    output bit index_valid
    
   
);

    (* ram_style = "block" *) (* dont_touch = "yes" *) trace_repo_entry trace_entries[0:TRACE_ENTRIES-1];
    trace_format last_entry;
    integer signed capture_pointer;
    integer signed action_pointer;
    integer next_available;
    
    enum bit {
        LISTEN_FOR_REQ,
        WAIT_FOR_VALID
    } state;
    
    (* ram_style = "block" *) (* dont_touch = "yes" *) cache_tracker_t cache_tracker [2**(INDEXMSB-INDEXLSB + 1)];
    (* ram_style = "block" *) (* dont_touch = "yes" *) bit [$clog2(TRACE_ENTRIES)-1:0] trace_index_list [0:2**(INDEXMSB-INDEXLSB+1)-1][0:TRACE_INDEXES_STORED-1];
    
    initial
    begin
        initialise_device();
    end
    
    always_ff @(posedge clk)
    begin
        if (!rst_n) initialise_device();
        else if (!lock)
        begin
            if (trace_capture_enable && (last_entry != trace_in)) 
            begin
                last_entry <= trace_in;
                trace_entries[capture_pointer+1].trace_entry.mem_addr <= trace_in.mem_addr;
                trace_entries[capture_pointer+1].trace_entry.instruction <= trace_in.instruction;
                trace_entries[capture_pointer+1].processing <= 0;
                trace_entries[capture_pointer+1].retired <= 0;
                trace_index_list[trace_in.mem_addr[INDEXMSB:INDEXLSB]][cache_tracker[trace_in.mem_addr[INDEXMSB:INDEXLSB]].next_available_position] <= capture_pointer+1;
                cache_tracker[trace_in.mem_addr[INDEXMSB:INDEXLSB]].next_available_position <= cache_tracker[trace_in.mem_addr[INDEXMSB:INDEXLSB]].next_available_position + 1;
                capture_pointer <= capture_pointer + 1;
                if (cache_tracker[trace_in.mem_addr[INDEXMSB:INDEXLSB]].next_available_position == 0) cache_tracker[trace_in.mem_addr[INDEXMSB:INDEXLSB]].current_occupant <= -1;
            end
        end
        else 
        begin
            unique case (state)
                LISTEN_FOR_REQ:
                begin
                    if (trace_req) 
                    begin
                        if (action_pointer == capture_pointer) processing_complete <= 1'b1;
                        else
                        begin
                            next_available <= action_pointer+1;
                            if (can_next_available_be_executed(action_pointer+1))
                            begin
                                trace_out <= trace_entries[action_pointer+1].trace_entry;
                                trace_index_o <= action_pointer+1;
                                entry_valid <= 1'b1;
                                state <= LISTEN_FOR_REQ;
                            end
                            else if (cancel)  cancelled <= 1'b1;
                            else state <= WAIT_FOR_VALID;
                        end
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
            if (mark_done && !mark_done_valid)
            begin
                trace_entries[index_done].processing <= processing_flag;                
                trace_entries[index_done].retired <= !processing_flag;
                if (cache_tracker[trace_entries[index_done].trace_entry.mem_addr[INDEXMSB:INDEXLSB]].current_occupant == -1) cache_tracker[trace_entries[index_done].trace_entry.mem_addr[INDEXMSB:INDEXLSB]].current_occupant <= 0;
                else if (cache_tracker[trace_entries[index_done].trace_entry.mem_addr[INDEXMSB:INDEXLSB]].current_occupant > -1 && !processing_flag) 
                begin
                    cache_tracker[trace_entries[index_done].trace_entry.mem_addr[INDEXMSB:INDEXLSB]].current_occupant <= cache_tracker[trace_entries[index_done].trace_entry.mem_addr[INDEXMSB:INDEXLSB]].current_occupant + 1;
                end
                if (processing_flag) action_pointer <= action_pointer + 1;
                if (index_done > action_pointer && !processing_flag) action_pointer <= action_pointer+1;
                mark_done_valid <= 1'b1;
            end
            else mark_done_valid <= 1'b0;
            if (get_index)
            begin
                automatic trace_repo_entry present_entry = trace_entries[trace_index_list[addr_in[INDEXMSB:INDEXLSB]][cache_tracker[addr_in[INDEXMSB:INDEXLSB]].current_occupant]];
                if ((present_entry.trace_entry.mem_addr == addr_in && !present_entry.retired) || cache_tracker[addr_in[INDEXMSB:INDEXLSB]].current_occupant >= TRACE_ENTRIES)
                begin
                    index_o <= (cache_tracker[addr_in[INDEXMSB:INDEXLSB]].current_occupant == -1) ? trace_index_list[addr_in[INDEXMSB:INDEXLSB]][0] : trace_index_list[addr_in[INDEXMSB:INDEXLSB]][cache_tracker[addr_in[INDEXMSB:INDEXLSB]].current_occupant];
                end
                else index_o <= trace_index_list[addr_in[INDEXMSB:INDEXLSB]][cache_tracker[addr_in[INDEXMSB:INDEXLSB]].current_occupant+1];
                index_valid <= 1'b1;
            end
            else index_valid <= 1'b0;
       end
    end
    
    always_comb
    begin
        retired = trace_entries[trace_index_i].retired;
    end
    
    function can_next_available_be_executed(input integer next_available);
        automatic bit [DATA_ADDR_WIDTH-1:0] addr_to_check = trace_entries[next_available].trace_entry.mem_addr;
        automatic trace_repo_entry entry_to_check = trace_entries[cache_tracker[addr_to_check[INDEXMSB:INDEXLSB]].current_occupant];
        if (cache_tracker[addr_to_check[INDEXMSB:INDEXLSB]].current_occupant == -1) return 1'b1;
        else return entry_to_check.trace_entry.mem_addr == addr_to_check && entry_to_check.retired;
    endfunction
    
    task initialise_device();
        capture_pointer <= -1;
        action_pointer <= -1;
        next_available <= 0;
    endtask

endmodule
