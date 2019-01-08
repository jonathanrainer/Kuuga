`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jonathan Rainer
// 
// Create Date: 12/14/2018 08:11:38 AM
// Design Name: Godai
// Module Name: godai_wrapper
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

`include "../include/godai_defines.sv"

module godai_wrapper
(
    // Generic Signals
    input clk,
    input rst_n,
    
    // Instruction Memory Interface
    output                   instr_req_o,
    input                    instr_gnt_i,
    input                    instr_rvalid_i,
    output [`ADDR_WIDTH-1:0]  instr_addr_o,
    input  [`DATA_WIDTH-1:0]  instr_rdata_i,
    
    // Data Memory Interface
    output                      data_req_o,
    input                       data_gnt_i,
    input                       data_rvalid_i,
    output                      data_we_o,
    output [(`DATA_WIDTH/4)-1:0] data_be_o,
    output [`ADDR_WIDTH-1:0]     data_addr_o,
    output [`DATA_WIDTH-1:0]     data_wdata_o,
    input  [`DATA_WIDTH-1:0]     data_rdata_i,
    input                       data_err_i,
    
    // Interrupt 
    input [31:0] irq_i,
    
    // CPU Control
    output core_busy_o,
    
    // Tracing Signals
    output if_busy_o,
    output if_ready_o,
    output id_ready_o,
    output is_decoding_o,
    output jump_done_o,
    output data_req_id_o,
    output ex_ready_o,
    output wb_ready_o,
    output illegal_instr_o
        
);
    
    riscv_core 
    #(
        0, `DATA_WIDTH
    )
    core
    (
        .clk_i(clk),
        .rst_ni(rst_n),
        .clock_en_i(1'b1),
        .test_en_i(1'b0),
        .boot_addr_i(32'h20),
        .core_id_i(1'b0),
        .cluster_id_i(1'b0),
        .instr_req_o(instr_req_o),
        .instr_gnt_i(instr_gnt_i),
        .instr_rvalid_i(instr_rvalid_i),
        .instr_addr_o(instr_addr_o),
        .instr_rdata_i(instr_rdata_i),
        .data_req_o(data_req_o),
        .data_gnt_i(data_gnt_i),
        .data_rvalid_i(data_rvalid_i),
        .data_we_o(data_we_o),
        .data_be_o(data_be_o),
        .data_addr_o(data_addr_o),
        .data_wdata_o(data_wdata_o),
        .data_rdata_i(data_rdata_i),
        .irq_i(irq_i),
        .fetch_enable_i(1'b1),
        .core_busy_o(core_busy_o),
        .if_busy_o(if_busy_o),
        .if_ready_o(if_ready_o),
        .id_ready_o(id_ready_o),
        .is_decoding_o(is_decoding_o),
        .jump_done_o(jump_done_o),
        .data_req_id_o(data_req_id_o),
        .ex_ready_o(ex_ready_o),
        .wb_ready_o(wb_ready_o),
        .illegal_instr_o(illegal_instr_o)
    );

endmodule
