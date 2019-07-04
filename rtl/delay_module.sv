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
    output bit[INPUT_SIGNAL_WIDTH-1:0] signal_out
);

    bit prev_signal = 1'b0;
    bit [$clog2(CYCLES_TO_ADD)-1:0] delay_counter = 0;
    bit begin_count;

    enum bit {
        IDLE,
        COUNTING
    } state;
    
    always_comb
    begin
        signal_out = 0;
        begin_count = 1'b0;
        if (signal_in && !prev_signal && !begin_count) 
        begin
            begin_count = 1'b1;
            signal_out = 0;
        end
        else if (state == IDLE) signal_out = signal_in;
    end

    always @(posedge clk)
    begin
        if (!rst_n) initialise_module();
        else 
        begin
            unique case(state)
                IDLE:
                begin
                    if (begin_count) 
                    begin
                        state <= COUNTING;
                        delay_counter <= CYCLES_TO_ADD;
                    end
                end
                COUNTING:
                begin
                    if (delay_counter == 0) 
                    begin
                        state <= IDLE;
                    end
                    else delay_counter <= delay_counter - 1;
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
