`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2019 10:52:55 AM
// Design Name: 
// Module Name: delay_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module delay_module
#(
    parameter INPUT_SIGNAL_WIDTH = 1,
    parameter CYCLES_TO_ADD = 1
)
(
    input bit clk,
    input bit rst_n,
    input bit [INPUT_SIGNAL_WIDTH-1:0] signal_in,
    input bit feedback_signal,
    input bit marker_signal,   
    output bit[INPUT_SIGNAL_WIDTH-1:0] signal_out
);

    bit [INPUT_SIGNAL_WIDTH-1:0] prev_signal = 1'b0;
    bit [INPUT_SIGNAL_WIDTH-1:0] cached_signal = 1'b0;
    bit [$clog2(CYCLES_TO_ADD)-1:0] delay_counter = 0;
    bit begin_count;

    enum bit [0:1] {
        IDLE,
        COUNTING,
        WAIT_FOR_DEASSERT,
        CHECK_FOR_REPEAT
    } state;
    

    always @(posedge clk)
    begin
        if (!rst_n) initialise_module();
        else 
        begin
            unique case(state)
                IDLE:
                begin
                    if (signal_in) 
                    begin
                        state <= COUNTING;
                        delay_counter <= CYCLES_TO_ADD - 1;
                        cached_signal <= signal_in;
                        signal_out <= 0;
                    end
                    else signal_out <= signal_in;
                end
                COUNTING:
                begin
                    if (delay_counter == 0) 
                    begin
                        state <= WAIT_FOR_DEASSERT;
                        signal_out <= cached_signal;
                    end
                    else 
                    begin
                        delay_counter <= delay_counter - 1;
                        signal_out <= 0;
                    end
                end
                WAIT_FOR_DEASSERT:
                begin
                    if (feedback_signal) signal_out <= 1'b0;
                    if (marker_signal)
                    begin
                       state <= CHECK_FOR_REPEAT;
                    end
                end
                CHECK_FOR_REPEAT:
                begin
                     if (signal_in)
                     begin
                         state <= COUNTING;
                         delay_counter <= CYCLES_TO_ADD - 1;
                         cached_signal <= signal_in;
                         signal_out <= 0;
                     end
                     else 
                     begin
                         state <= IDLE;
                         signal_out <= signal_in;
                     end 
                end
            endcase
            prev_signal <= signal_in;
       end
    end
    
    task initialise_module();
        prev_signal = 1'b0;
        delay_counter = 0;
    endtask

endmodule
