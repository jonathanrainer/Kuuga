`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2019 11:06:10 AM
// Design Name: 
// Module Name: delay_module_wrapper
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


module delay_module_wrapper
#(
    parameter INPUT_SIGNAL_WIDTH = 1,
    parameter CYCLES_TO_ADD = 1
)
(
    input clk,
    input rst_n,
    input [INPUT_SIGNAL_WIDTH-1:0] signal_in,   
    output [INPUT_SIGNAL_WIDTH-1:0] signal_out
);

   delay_module #(INPUT_SIGNAL_WIDTH, CYCLES_TO_ADD) inst (clk, rst_n, signal_in, signal_out);

endmodule
