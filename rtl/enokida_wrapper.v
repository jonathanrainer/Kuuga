`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2019 01:40:41 PM
// Design Name: 
// Module Name: trace_assisted_cache_wrapper
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


module enokida_wrapper
#(
    ADDR_WIDTH = 16,
    DATA_WIDTH = 32,
    TRACE_ENTRIES = 2048
)
(
    input clk,
    input rst_n,
    
    // RI5CY Protocol Input (Processor -> Cache)
    
    input                       proc_cache_data_req_i,
    input   [ADDR_WIDTH-1:0]    proc_cache_data_addr_i,
    input                       proc_cache_data_we_i,
    input   [DATA_WIDTH/8-1:0]  proc_cache_data_be_i,
    input   [DATA_WIDTH-1:0]    proc_cache_data_wdata_i,
    
    output                      proc_cache_data_gnt_o,
    output                      proc_cache_data_rvalid_o,
    output  [DATA_WIDTH-1:0]    proc_cache_data_rdata_o,
    
    // RI5CY Protocol Output (Cache -> Memory (Reserved for LSU))
    
    input                       cache_mem_data_gnt_i,
    input                       cache_mem_data_rvalid_i,
    input   [DATA_WIDTH-1:0]    cache_mem_data_rdata_i,
    
    output                      cache_mem_data_req_o,
    output  [ADDR_WIDTH-1:0]    cache_mem_data_addr_o,
    output                      cache_mem_data_we_o,
    output  [DATA_WIDTH/8-1:0]  cache_mem_data_be_o,
    output  [DATA_WIDTH-1:0]    cache_mem_data_wdata_o,
    
    // Trace Input
    input   [127:0]             trace_in,
    input                       trace_capture_enable,
    input                       lock,
    input   [31:0]              counter
);

    enokida #(ADDR_WIDTH, DATA_WIDTH, TRACE_ENTRIES) tac(
        clk, rst_n,
        proc_cache_data_req_i, proc_cache_data_addr_i, proc_cache_data_we_i, proc_cache_data_be_i,
        proc_cache_data_wdata_i, proc_cache_data_gnt_o, proc_cache_data_rvalid_o, proc_cache_data_rdata_o,
        cache_mem_data_gnt_i, cache_mem_data_rvalid_i, cache_mem_data_rdata_i,
        cache_mem_data_req_o, cache_mem_data_addr_o, cache_mem_data_we_o,
        cache_mem_data_be_o, cache_mem_data_wdata_o, trace_in,
        trace_capture_enable, lock, counter
    );

endmodule
