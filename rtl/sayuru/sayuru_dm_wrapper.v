`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2019 11:57:41 AM
// Design Name: 
// Module Name: simple_cache_wrapper
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


module sayuru_dm_wrapper
#(
    ADDR_WIDTH = 16,
    DATA_WIDTH = 32
)
(
     // Clock and Reset
    input clk,
    input rst_n,

    // Core Memory Protocol (Input from Processor)
    input                           in_data_req_i,
    output                          in_data_gnt_o,
    output                          in_data_rvalid_o,
    input   [ADDR_WIDTH-1:0]        in_data_addr_i,
    input                           in_data_we_i,
    input   [DATA_WIDTH/8 - 1:0]    in_data_be_i,
    output  [DATA_WIDTH-1:0]        in_data_rdata_o,
    input   [DATA_WIDTH-1:0]        in_data_wdata_i,
    
    // Core Memory Protocol (Output to Memory, Used on Cache Miss)
    output                          out_data_req_o,
    input                           out_data_gnt_i,
    input                           out_data_rvalid_i,
    output   [ADDR_WIDTH-1:0]       out_data_addr_o,
    output                          out_data_we_o,
    output   [DATA_WIDTH/8 - 1:0]   out_data_be_o,
    input    [DATA_WIDTH-1:0]       out_data_rdata_i,
    output   [DATA_WIDTH-1:0]       out_data_wdata_o,

    output   [31:0] trans_count,
    output   [31:0] hit_count,
    output   [31:0] miss_count
);


    sayuru_dm #(ADDR_WIDTH, DATA_WIDTH) sayuru 
    (
        clk, rst_n, in_data_req_i, in_data_gnt_o, in_data_rvalid_o,
        in_data_addr_i, in_data_we_i, in_data_be_i, in_data_rdata_o,
        in_data_wdata_i, out_data_req_o, out_data_gnt_i, out_data_rvalid_i,
        out_data_addr_o, out_data_we_o, out_data_be_o, out_data_rdata_i,
        out_data_wdata_o, trans_count, hit_count, miss_count
    );

endmodule
