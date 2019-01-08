//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.2 (lin64) Build 2258646 Thu Jun 14 20:02:38 MDT 2018
//Date        : Tue Jan  8 08:34:18 2019
//Host        : ubuntu running 64-bit Ubuntu 18.04.1 LTS
//Command     : generate_target axi_verifier_wrapper.bd
//Design      : axi_verifier_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module axi_verifier_wrapper
   (clk_100MHz,
    reset_rtl);
  input clk_100MHz;
  input reset_rtl;

  wire clk_100MHz;
  wire reset_rtl;

  axi_verifier axi_verifier_i
       (.clk_100MHz(clk_100MHz),
        .reset_rtl(reset_rtl));
endmodule
