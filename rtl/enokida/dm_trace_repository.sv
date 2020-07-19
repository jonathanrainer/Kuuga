import dm_trace_repository_datatypes::*;
import dm_cache_def::*;
import gouram_datatypes::*;

module dm_trace_repository
#(
    DATA_ADDR_WIDTH = 16,
    DATA_DATA_WIDTH = 32,
    ACTIVE_SET_ENTRIES = 8
)
(
    input clk,
    input rst_n,

    // Capture Inputs
    input trace_format trace_in,
    input bit trace_capture_enable,
    input bit trace_ready,
    input bit lock,
    
    // Requests from Enokida
    input bit trace_req,
    input bit cancel,
    (* dont_touch = "yes" *) output trace_repo_data_entry trace_out,
    output bit [$clog2(TRACE_ENTRIES)-1:0] trace_index_o,
    output bit entry_valid,
    output bit cancelled,
    output bit processing_complete,
    
    // Requests to Mark Entries Done
    input bit [$clog2(TRACE_ENTRIES)-1:0] index_done,
    input bit mark_done,
    input bit processing_flag,
    input bit mem_trace_flag,
    input bit [DATA_ADDR_WIDTH-1:0] mem_addr,
    input bit hit_miss_in,
    input bit load_store_in,
    output bit mark_done_valid,
    
    // Requests to find a trace entry from an address
    input bit [DATA_ADDR_WIDTH-1:0] addr_in,
    input bit get_index,
    output bit signed [$clog2(TRACE_ENTRIES)-1:0] index_o,
    output bit index_valid,
    
    // Tracking Outputs
    output integer h_l_counter,
    output integer hph_l_counter,
    output integer hpm_l_counter,
    output integer h_s_counter,
    output integer hph_s_counter,
    output integer hpm_s_counter,
    output integer m_l_counter,
    output integer m_s_counter
  
);

    bit [DATA_ADDR_WIDTH + DATA_DATA_WIDTH-1:0] trace_entries_data_o;
    bit [DATA_ADDR_WIDTH + DATA_DATA_WIDTH-1:0] trace_entries_data_i;
    bit [$clog2(TRACE_ENTRIES)-1:0] trace_entries_addr_i;
    bit trace_entries_ena_i;
    bit trace_entries_wea_i;
       
    localparam READ_LATENCY = 1;

   xpm_memory_spram #(
      .ADDR_WIDTH_A($clog2(TRACE_ENTRIES)),              // DECIMAL
      .AUTO_SLEEP_TIME(0),           // DECIMAL
      .BYTE_WRITE_WIDTH_A((DATA_ADDR_WIDTH + DATA_DATA_WIDTH)),       // DECIMAL
      .ECC_MODE("no_ecc"),           // String
      .MEMORY_INIT_FILE("none"),     // String
      .MEMORY_INIT_PARAM("0"),       // String
      .MEMORY_OPTIMIZATION("true"),  // String
      .MEMORY_PRIMITIVE("block"),     // String
      .MEMORY_SIZE((DATA_ADDR_WIDTH + DATA_DATA_WIDTH)*TRACE_ENTRIES),            // DECIMAL
      .MESSAGE_CONTROL(0),           // DECIMAL
      .READ_DATA_WIDTH_A(DATA_ADDR_WIDTH + DATA_DATA_WIDTH),        // DECIMAL
      .READ_LATENCY_A(READ_LATENCY),            // DECIMAL
      .READ_RESET_VALUE_A("FF"),      // String
      .USE_MEM_INIT(0),              // DECIMAL
      .WAKEUP_TIME("disable_sleep"), // String
      .WRITE_DATA_WIDTH_A(DATA_ADDR_WIDTH + DATA_DATA_WIDTH),       // DECIMAL
      .WRITE_MODE_A("no_change")    // String
   )
   xpm_trace_entries (

      .douta(trace_entries_data_o),                   // READ_DATA_WIDTH_A-bit output: Data output for port A read operations.

      .addra(trace_entries_addr_i),                   // ADDR_WIDTH_A-bit input: Address for port A write and read operations.
      .clka(clk),                     // 1-bit input: Clock signal for port A.
      .dina(trace_entries_data_i),                     // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
      .ena(trace_entries_ena_i),                       // 1-bit input: Memory enable signal for port A. Must be high on clock
                                       // cycles when read or write operations are initiated. Pipelined
                                       // internally.

      .regcea(1'b1),                 // 1-bit input: Clock Enable for the last register stage on the output
                                       // data path.

      .rsta(~rst_n),                     // 1-bit input: Reset signal for the final port A output register stage.
                                       // Synchronously resets output port douta to the value specified by
                                       // parameter READ_RESET_VALUE_A.

      .wea(trace_entries_wea_i),                        // WRITE_DATA_WIDTH_A-bit input: Write enable vector for port A input
                                       // data port dina. 1 bit wide when word-wide writes are used. In
                                       // byte-wide write configurations, each bit controls the writing one
                                       // byte of dina to address addra. For example, to synchronously write
                                       // only bits [15-8] of dina when WRITE_DATA_WIDTH_A is 32, wea would be
                                       // 4'b0010.
      .sleep(1'b0),
      .injectsbiterra(1'b0),
      .injectdbiterra(1'b0)
   );
    
    bit [$clog2(TRACE_ENTRIES)-1:0] last_addr;
    (* dont_touch = "yes" *) integer signed capture_pointer;
    (* dont_touch = "yes" *) integer signed action_pointer;
    (* dont_touch = "yes" *) integer signed committed_counter;
    (* dont_touch = "yes" *) integer next_available;
    (* dont_touch = "yes" *) trace_repo_data_entry trace;
    bit trace_valid;
    bit [$clog2(READ_LATENCY):0] latency_counter;
    
    enum bit [1:0] {
        LISTEN_FOR_REQ,
        WAIT_FOR_VALID,
        GET_TRACE_FROM_MEMORY
    } state;
        
    (* dont_touch = "yes" *) active_set_entry active_set [ACTIVE_SET_ENTRIES-1:0];
    (* dont_touch = "yes" *) bit signed [$clog2(ACTIVE_SET_ENTRIES):0] active_set_processing_pointer;
    (* dont_touch = "yes" *) bit signed [$clog2(ACTIVE_SET_ENTRIES):0] active_set_retired_pointer;
    
    (* dont_touch = "yes" *) cache_tracker_t cache_tracker [CACHE_BLOCKS-1:0];
    
    initial
    begin
        initialise_device();
    end
    
    always_ff @(posedge clk)
    begin
        if (!rst_n) initialise_device();
        else if (!lock)
        begin
            if (trace_capture_enable && trace_ready) 
            begin
                trace_entries_addr_i <= capture_pointer+1;
                trace_entries_wea_i <= 1'b1;
                trace_entries_ena_i <= 1'b1;
                trace_entries_data_i <= {trace_in.mem_addr, trace_in.instruction};
                capture_pointer <= capture_pointer + 1;
            end
            else
            begin
                trace_entries_wea_i <= 1'b0;
                trace_entries_ena_i <= 1'b0;
            end
        end
        else 
        begin
            unique case (state)
                LISTEN_FOR_REQ:
                begin
                    automatic bit next_trace_ready = (action_pointer + 1 == last_addr) && trace_valid;
                    if (next_trace_ready && trace_req) 
                    begin
                        if (committed_counter == capture_pointer + 1) processing_complete <= 1'b1;
                        else
                        begin
                            next_available <= action_pointer+1;
                            if (can_next_available_be_executed(trace.mem_addr))
                            begin
                                trace_out <= trace;
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
                        if (!next_trace_ready)
                        begin
                            trace_valid <= 1'b0;
                            trace_entries_addr_i <= action_pointer+1;
                            trace_entries_ena_i <= 1'b1;
                            last_addr <= action_pointer+1;
                            latency_counter <= READ_LATENCY;
                            state <= GET_TRACE_FROM_MEMORY;
                        end
                    end
                 end
                 GET_TRACE_FROM_MEMORY:
                 begin
                    if (latency_counter > 0) latency_counter <= latency_counter-1;
                    else
                    begin
                        state <= LISTEN_FOR_REQ;
                        trace.mem_addr <= trace_entries_data_o[DATA_ADDR_WIDTH+DATA_DATA_WIDTH-1:DATA_DATA_WIDTH];
                        trace.instruction <= trace_entries_data_o[DATA_DATA_WIDTH:0];
                        trace_valid <= 1'b1;
                    end
                 end
                 WAIT_FOR_VALID:
                 begin
                    if (can_next_available_be_executed(trace.mem_addr))
                    begin
                        trace_out <= trace;
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
                // If something is being marked as done there are 4 ways this might be possible:
                //      - It's a trace that still has to be executed via the system
                //      - It's a memory transaction that is enacting something a trace set up
                //      - It's a memory transaction that is enacting something without a trace setup
                // Case 1 (Trace but not done by system)
                if (mem_trace_flag && processing_flag)
                begin
                    active_set[(active_set_processing_pointer + 1) % ACTIVE_SET_ENTRIES].trace_index <= index_done;
                    active_set[(active_set_processing_pointer + 1) % ACTIVE_SET_ENTRIES].mem_addr <= mem_addr;
                    active_set[(active_set_processing_pointer + 1) % ACTIVE_SET_ENTRIES].trace_hit_miss_flag <= hit_miss_in;
                    active_set_processing_pointer <= (active_set_processing_pointer + 1) % ACTIVE_SET_ENTRIES;
                end
                // Case 2 (Trace already done and now system completes it)
                else if (!mem_trace_flag && active_set_processing_pointer != active_set_retired_pointer)
                begin
                    if (active_set_processing_pointer == active_set_retired_pointer) active_set_processing_pointer <= (active_set_processing_pointer + 1) % ACTIVE_SET_ENTRIES;
                    active_set_retired_pointer <= (active_set_retired_pointer + 1) % ACTIVE_SET_ENTRIES;
                    committed_counter <= committed_counter + 1;
                    // Update appropriate counter now the memory operation is complete
                    if (hit_miss_in) 
                    begin
                        // The system sees a hit in the cache
                        automatic active_set_entry entry = active_set[(active_set_retired_pointer + 1) % ACTIVE_SET_ENTRIES];
                        // Check if the corresponding trace entry in the active set hit or missed
                        if (entry.trace_hit_miss_flag)
                        begin
                            // If it's a load then update the Hit + Pre-Emptive Hit Load Counter 
                            if (load_store_in) 
                            begin
                                hpm_s_counter <= hpm_s_counter + 1;
                            end
                            // Otherwise update the Hit + Pre-Emptive Hit Store Counter
                            else 
                                hpm_l_counter <= hpm_l_counter + 1;
                            end
                        end
                        else
                        begin
                            // If it's a load then update the Hit + Pre-Emptive Miss Load Counter 
                            if (load_store_in) 
                            begin
                                hph_s_counter <= hph_s_counter + 1;
                            end
                            // If it's a store then update the Hit + Pre-Emptive Miss Stire Counter 
                            else 
                            begin
                                hph_l_counter <= hph_l_counter + 1;
                            end  
                        end
                    // No need for an else clause here because if something happened pre-emptively it should be impossible for the 
                    // cache to miss.
                end
                // Case 3 (Trace not done by the processing 
                else
                begin
                    active_set[(active_set_retired_pointer + 1) % ACTIVE_SET_ENTRIES].trace_index <= index_done;
                    active_set[(active_set_retired_pointer + 1) % ACTIVE_SET_ENTRIES].mem_addr <= mem_addr;
                    active_set_retired_pointer <= (active_set_retired_pointer + 1) % ACTIVE_SET_ENTRIES;
                    if (active_set_retired_pointer == active_set_processing_pointer) active_set_processing_pointer <= (active_set_processing_pointer + 1) % ACTIVE_SET_ENTRIES;
                    committed_counter <= committed_counter + 1;
                    if (hit_miss_in) 
                    begin
                        if (load_store_in)
                        begin
                            m_s_counter <= m_s_counter + 1;
                        end
                        else
                        begin
                            m_l_counter <= m_l_counter + 1;
                        end
                    end
                    else
                    begin
                        if (load_store_in)
                        begin
                            h_s_counter <= h_s_counter + 1;
                        end
                        else
                            h_l_counter <= h_l_counter + 1;
                        begin
                        end
                    end
                end
                cache_tracker[mem_addr[INDEXMSB:INDEXLSB]].trace_index <= index_done;
                cache_tracker[mem_addr[INDEXMSB:INDEXLSB]].mem_addr <= mem_addr;
                cache_tracker[mem_addr[INDEXMSB:INDEXLSB]].occupied <= 1'b1;
                cache_tracker[mem_addr[INDEXMSB:INDEXLSB]].processing <= processing_flag;
                if (processing_flag) action_pointer <= action_pointer + 1;
                if (((index_done > action_pointer) || (action_pointer==-1)) && !processing_flag) action_pointer <= action_pointer+1;
                mark_done_valid <= 1'b1;
            end
            else mark_done_valid <= 1'b0;
            if (get_index && !index_valid)
            begin
                automatic bit index_found = 1'b0;
                for (int i = 0; i < ACTIVE_SET_ENTRIES; i++)
                begin
                    automatic bit [$clog2(ACTIVE_SET_ENTRIES)-1:0] active_set_index = ((active_set_retired_pointer == -1) ? 0 : active_set_retired_pointer) + i % ACTIVE_SET_ENTRIES;
                    if (active_set_index == active_set_processing_pointer + 1 || active_set_processing_pointer == active_set_retired_pointer) break;
                    if (active_set[active_set_index].mem_addr == addr_in) 
                    begin
                        index_o <= active_set[active_set_index].trace_index;
                        index_found = 1'b1;
                        break;
                    end
                end
                if (!index_found) index_o <= active_set[active_set_processing_pointer].trace_index+1;
                index_valid <= 1'b1;
            end
            else index_valid <= 1'b0;
       end
    end
    
    
    function can_next_available_be_executed(input bit [DATA_ADDR_WIDTH-1:0] mem_addr);
        automatic cache_tracker_t cache_tracker_entry = cache_tracker[mem_addr[INDEXMSB:INDEXLSB]];
        if (!cache_tracker_entry.occupied) return 1'b1;
        else return mem_addr == cache_tracker_entry.mem_addr && !cache_tracker_entry.processing;
    endfunction
    
    task initialise_device();
        capture_pointer <= -1;
        action_pointer <= -1;
        committed_counter <= 0;
        next_available <= 0;
        active_set_processing_pointer <= -1;
        active_set_retired_pointer <= -1;
        trace_valid <= 1'b0;
        h_l_counter <= 0;
        hph_l_counter <= 0;
        hpm_l_counter <= 0;
        h_s_counter  <= 0;
        hph_s_counter <= 0;
        hpm_s_counter <= 0;
        m_l_counter  <= 0;
        m_s_counter   <= 0;
    endtask

endmodule
