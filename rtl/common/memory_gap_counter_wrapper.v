`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2020 09:49:04 AM
// Design Name: 
// Module Name: memory_gap_counter_wrapper
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


module memory_gap_counter_wrapper
(
    input           clk,
    input           rst_n,
    
    input           data_mem_req,
    input           data_mem_rvalid,
    output [31:0]   memory_gap,
    output          memory_gap_valid
);

    memory_gap_counter mem_gap_counter (clk, rst_n, data_mem_req, data_mem_rvalid, memory_gap, memory_gap_valid);

endmodule
