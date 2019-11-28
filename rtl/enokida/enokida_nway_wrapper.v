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


module enokida_nway_wrapper
#(
    ADDR_WIDTH = 16,
    DATA_WIDTH = 32
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
    input   [159:0]             trace_in,
    input                       trace_capture_enable,
    input                       lock,
    input                       trace_ready,

    output [31:0] req_count,
    output [31:0] hit_count,
    output [31:0] miss_count,
    
    output [6:0] index_affected,
    output [31:0] data_read_o,
    output [31:0] data_write_o,
    output [15:0] index_done_o,
    output [6:0] cache_index_o,
    output mark_done_o,
    output processing_flag_o,
    output mark_done_valid_o,
    output mem_trace_flag_o
);

    enokida_nway #(ADDR_WIDTH, DATA_WIDTH) tac(
        clk, rst_n,
        proc_cache_data_req_i, proc_cache_data_addr_i, proc_cache_data_we_i, proc_cache_data_be_i,
        proc_cache_data_wdata_i, proc_cache_data_gnt_o, proc_cache_data_rvalid_o, proc_cache_data_rdata_o,
        cache_mem_data_gnt_i, cache_mem_data_rvalid_i, cache_mem_data_rdata_i,
        cache_mem_data_req_o, cache_mem_data_addr_o, cache_mem_data_we_o,
        cache_mem_data_be_o, cache_mem_data_wdata_o, trace_in,
        trace_capture_enable, lock, trace_ready, req_count, hit_count, miss_count,
        index_affected, data_read_o, data_write_o, index_done_o, cache_index_o, mark_done_o,
        processing_flag_o, mark_done_valid_o, mem_trace_flag_o
    );

endmodule
