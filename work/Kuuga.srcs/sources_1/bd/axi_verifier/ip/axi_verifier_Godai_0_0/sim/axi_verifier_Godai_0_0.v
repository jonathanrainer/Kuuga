// (c) Copyright 1995-2019 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: jonathan-rainer.com:Kuuga:Godai:1.0
// IP Revision: 2

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "package_project" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module axi_verifier_Godai_0_0 (
  clk,
  rst_n,
  instr_req_o,
  instr_gnt_i,
  instr_rvalid_i,
  instr_addr_o,
  instr_rdata_i,
  data_req_o,
  data_gnt_i,
  data_rvalid_i,
  data_we_o,
  data_be_o,
  data_addr_o,
  data_wdata_o,
  data_rdata_i,
  data_err_i,
  irq_i,
  core_busy_o,
  if_busy_o,
  if_ready_o,
  id_ready_o,
  is_decoding_o,
  jump_done_o,
  data_req_id_o,
  ex_ready_o,
  wb_ready_o,
  illegal_instr_o
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN axi_verifier_clk_100MHz" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
input wire clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rst_n, POLARITY ACTIVE_LOW" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rst_n RST" *)
input wire rst_n;
output wire instr_req_o;
input wire instr_gnt_i;
input wire instr_rvalid_i;
output wire [31 : 0] instr_addr_o;
input wire [31 : 0] instr_rdata_i;
output wire data_req_o;
input wire data_gnt_i;
input wire data_rvalid_i;
output wire data_we_o;
output wire [7 : 0] data_be_o;
output wire [31 : 0] data_addr_o;
output wire [31 : 0] data_wdata_o;
input wire [31 : 0] data_rdata_i;
input wire data_err_i;
input wire [31 : 0] irq_i;
output wire core_busy_o;
output wire if_busy_o;
output wire if_ready_o;
output wire id_ready_o;
output wire is_decoding_o;
output wire jump_done_o;
output wire data_req_id_o;
output wire ex_ready_o;
output wire wb_ready_o;
output wire illegal_instr_o;

  godai_wrapper inst (
    .clk(clk),
    .rst_n(rst_n),
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
    .data_err_i(data_err_i),
    .irq_i(irq_i),
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
