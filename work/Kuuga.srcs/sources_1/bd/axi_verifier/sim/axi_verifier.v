//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.2 (lin64) Build 2258646 Thu Jun 14 20:02:38 MDT 2018
//Date        : Tue Jan  8 08:34:18 2019
//Host        : ubuntu running 64-bit Ubuntu 18.04.1 LTS
//Command     : generate_target axi_verifier.bd
//Design      : axi_verifier
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "axi_verifier,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=axi_verifier,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=9,numReposBlks=9,numNonXlnxBlks=3,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "axi_verifier.hwdef" *) 
module axi_verifier
   (clk_100MHz,
    reset_rtl);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_100MHZ CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_100MHZ, CLK_DOMAIN axi_verifier_clk_100MHz, FREQ_HZ 100000000, PHASE 0.000" *) input clk_100MHz;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET_RTL RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET_RTL, POLARITY ACTIVE_LOW" *) input reset_rtl;

  wire [31:0]Core2AXI_0_M_AXI_ARADDR;
  wire [1:0]Core2AXI_0_M_AXI_ARBURST;
  wire [3:0]Core2AXI_0_M_AXI_ARCACHE;
  wire [0:0]Core2AXI_0_M_AXI_ARID;
  wire [7:0]Core2AXI_0_M_AXI_ARLEN;
  wire Core2AXI_0_M_AXI_ARLOCK;
  wire [2:0]Core2AXI_0_M_AXI_ARPROT;
  wire [3:0]Core2AXI_0_M_AXI_ARQOS;
  wire Core2AXI_0_M_AXI_ARREADY;
  wire [2:0]Core2AXI_0_M_AXI_ARSIZE;
  wire [0:0]Core2AXI_0_M_AXI_ARUSER;
  wire Core2AXI_0_M_AXI_ARVALID;
  wire [31:0]Core2AXI_0_M_AXI_AWADDR;
  wire [1:0]Core2AXI_0_M_AXI_AWBURST;
  wire [3:0]Core2AXI_0_M_AXI_AWCACHE;
  wire [0:0]Core2AXI_0_M_AXI_AWID;
  wire [7:0]Core2AXI_0_M_AXI_AWLEN;
  wire Core2AXI_0_M_AXI_AWLOCK;
  wire [2:0]Core2AXI_0_M_AXI_AWPROT;
  wire [3:0]Core2AXI_0_M_AXI_AWQOS;
  wire Core2AXI_0_M_AXI_AWREADY;
  wire [2:0]Core2AXI_0_M_AXI_AWSIZE;
  wire [0:0]Core2AXI_0_M_AXI_AWUSER;
  wire Core2AXI_0_M_AXI_AWVALID;
  wire [0:0]Core2AXI_0_M_AXI_BID;
  wire Core2AXI_0_M_AXI_BREADY;
  wire [1:0]Core2AXI_0_M_AXI_BRESP;
  wire [0:0]Core2AXI_0_M_AXI_BUSER;
  wire Core2AXI_0_M_AXI_BVALID;
  wire [31:0]Core2AXI_0_M_AXI_RDATA;
  wire [0:0]Core2AXI_0_M_AXI_RID;
  wire Core2AXI_0_M_AXI_RLAST;
  wire Core2AXI_0_M_AXI_RREADY;
  wire [1:0]Core2AXI_0_M_AXI_RRESP;
  wire [0:0]Core2AXI_0_M_AXI_RUSER;
  wire Core2AXI_0_M_AXI_RVALID;
  wire [31:0]Core2AXI_0_M_AXI_WDATA;
  wire Core2AXI_0_M_AXI_WLAST;
  wire Core2AXI_0_M_AXI_WREADY;
  wire [3:0]Core2AXI_0_M_AXI_WSTRB;
  wire [0:0]Core2AXI_0_M_AXI_WUSER;
  wire Core2AXI_0_M_AXI_WVALID;
  wire Core2AXI_0_data_gnt_o;
  wire [31:0]Core2AXI_0_data_rdata_o;
  wire Core2AXI_0_data_rvalid_o;
  wire [31:0]Core2AXI_1_M_AXI_ARADDR;
  wire [1:0]Core2AXI_1_M_AXI_ARBURST;
  wire [3:0]Core2AXI_1_M_AXI_ARCACHE;
  wire [0:0]Core2AXI_1_M_AXI_ARID;
  wire [7:0]Core2AXI_1_M_AXI_ARLEN;
  wire Core2AXI_1_M_AXI_ARLOCK;
  wire [2:0]Core2AXI_1_M_AXI_ARPROT;
  wire [3:0]Core2AXI_1_M_AXI_ARQOS;
  wire Core2AXI_1_M_AXI_ARREADY;
  wire [2:0]Core2AXI_1_M_AXI_ARSIZE;
  wire [0:0]Core2AXI_1_M_AXI_ARUSER;
  wire Core2AXI_1_M_AXI_ARVALID;
  wire [31:0]Core2AXI_1_M_AXI_AWADDR;
  wire [1:0]Core2AXI_1_M_AXI_AWBURST;
  wire [3:0]Core2AXI_1_M_AXI_AWCACHE;
  wire [0:0]Core2AXI_1_M_AXI_AWID;
  wire [7:0]Core2AXI_1_M_AXI_AWLEN;
  wire Core2AXI_1_M_AXI_AWLOCK;
  wire [2:0]Core2AXI_1_M_AXI_AWPROT;
  wire [3:0]Core2AXI_1_M_AXI_AWQOS;
  wire Core2AXI_1_M_AXI_AWREADY;
  wire [2:0]Core2AXI_1_M_AXI_AWSIZE;
  wire [0:0]Core2AXI_1_M_AXI_AWUSER;
  wire Core2AXI_1_M_AXI_AWVALID;
  wire [0:0]Core2AXI_1_M_AXI_BID;
  wire Core2AXI_1_M_AXI_BREADY;
  wire [1:0]Core2AXI_1_M_AXI_BRESP;
  wire [0:0]Core2AXI_1_M_AXI_BUSER;
  wire Core2AXI_1_M_AXI_BVALID;
  wire [31:0]Core2AXI_1_M_AXI_RDATA;
  wire [0:0]Core2AXI_1_M_AXI_RID;
  wire Core2AXI_1_M_AXI_RLAST;
  wire Core2AXI_1_M_AXI_RREADY;
  wire [1:0]Core2AXI_1_M_AXI_RRESP;
  wire [0:0]Core2AXI_1_M_AXI_RUSER;
  wire Core2AXI_1_M_AXI_RVALID;
  wire [31:0]Core2AXI_1_M_AXI_WDATA;
  wire Core2AXI_1_M_AXI_WLAST;
  wire Core2AXI_1_M_AXI_WREADY;
  wire [3:0]Core2AXI_1_M_AXI_WSTRB;
  wire [0:0]Core2AXI_1_M_AXI_WUSER;
  wire Core2AXI_1_M_AXI_WVALID;
  wire Core2AXI_1_data_gnt_o;
  wire [31:0]Core2AXI_1_data_rdata_o;
  wire Core2AXI_1_data_rvalid_o;
  wire [31:0]Godai_0_data_addr_o;
  wire [7:0]Godai_0_data_be_o;
  wire Godai_0_data_req_o;
  wire [31:0]Godai_0_data_wdata_o;
  wire Godai_0_data_we_o;
  wire [31:0]Godai_0_instr_addr_o;
  wire Godai_0_instr_req_o;
  wire clk_100MHz_1;
  wire [0:0]proc_sys_reset_0_peripheral_aresetn;
  wire reset_rtl_1;
  wire [0:0]xlconstant_0_dout;
  wire [3:0]xlconstant_1_dout;
  wire [31:0]xlconstant_2_dout;

  assign clk_100MHz_1 = clk_100MHz;
  assign reset_rtl_1 = reset_rtl;
  axi_verifier_Core2AXI_0_0 Core2AXI_0
       (.M_AXI_ACLK(clk_100MHz_1),
        .M_AXI_ARADDR(Core2AXI_0_M_AXI_ARADDR),
        .M_AXI_ARBURST(Core2AXI_0_M_AXI_ARBURST),
        .M_AXI_ARCACHE(Core2AXI_0_M_AXI_ARCACHE),
        .M_AXI_ARESETN(proc_sys_reset_0_peripheral_aresetn),
        .M_AXI_ARID(Core2AXI_0_M_AXI_ARID),
        .M_AXI_ARLEN(Core2AXI_0_M_AXI_ARLEN),
        .M_AXI_ARLOCK(Core2AXI_0_M_AXI_ARLOCK),
        .M_AXI_ARPROT(Core2AXI_0_M_AXI_ARPROT),
        .M_AXI_ARQOS(Core2AXI_0_M_AXI_ARQOS),
        .M_AXI_ARREADY(Core2AXI_0_M_AXI_ARREADY),
        .M_AXI_ARSIZE(Core2AXI_0_M_AXI_ARSIZE),
        .M_AXI_ARUSER(Core2AXI_0_M_AXI_ARUSER),
        .M_AXI_ARVALID(Core2AXI_0_M_AXI_ARVALID),
        .M_AXI_AWADDR(Core2AXI_0_M_AXI_AWADDR),
        .M_AXI_AWBURST(Core2AXI_0_M_AXI_AWBURST),
        .M_AXI_AWCACHE(Core2AXI_0_M_AXI_AWCACHE),
        .M_AXI_AWID(Core2AXI_0_M_AXI_AWID),
        .M_AXI_AWLEN(Core2AXI_0_M_AXI_AWLEN),
        .M_AXI_AWLOCK(Core2AXI_0_M_AXI_AWLOCK),
        .M_AXI_AWPROT(Core2AXI_0_M_AXI_AWPROT),
        .M_AXI_AWQOS(Core2AXI_0_M_AXI_AWQOS),
        .M_AXI_AWREADY(Core2AXI_0_M_AXI_AWREADY),
        .M_AXI_AWSIZE(Core2AXI_0_M_AXI_AWSIZE),
        .M_AXI_AWUSER(Core2AXI_0_M_AXI_AWUSER),
        .M_AXI_AWVALID(Core2AXI_0_M_AXI_AWVALID),
        .M_AXI_BID(Core2AXI_0_M_AXI_BID),
        .M_AXI_BREADY(Core2AXI_0_M_AXI_BREADY),
        .M_AXI_BRESP(Core2AXI_0_M_AXI_BRESP),
        .M_AXI_BUSER(Core2AXI_0_M_AXI_BUSER),
        .M_AXI_BVALID(Core2AXI_0_M_AXI_BVALID),
        .M_AXI_RDATA(Core2AXI_0_M_AXI_RDATA),
        .M_AXI_RID(Core2AXI_0_M_AXI_RID),
        .M_AXI_RLAST(Core2AXI_0_M_AXI_RLAST),
        .M_AXI_RREADY(Core2AXI_0_M_AXI_RREADY),
        .M_AXI_RRESP(Core2AXI_0_M_AXI_RRESP),
        .M_AXI_RUSER(Core2AXI_0_M_AXI_RUSER),
        .M_AXI_RVALID(Core2AXI_0_M_AXI_RVALID),
        .M_AXI_WDATA(Core2AXI_0_M_AXI_WDATA),
        .M_AXI_WLAST(Core2AXI_0_M_AXI_WLAST),
        .M_AXI_WREADY(Core2AXI_0_M_AXI_WREADY),
        .M_AXI_WSTRB(Core2AXI_0_M_AXI_WSTRB),
        .M_AXI_WUSER(Core2AXI_0_M_AXI_WUSER),
        .M_AXI_WVALID(Core2AXI_0_M_AXI_WVALID),
        .data_addr_i(Godai_0_instr_addr_o),
        .data_be_i(xlconstant_1_dout),
        .data_gnt_o(Core2AXI_0_data_gnt_o),
        .data_rdata_o(Core2AXI_0_data_rdata_o),
        .data_req_i(Godai_0_instr_req_o),
        .data_rvalid_o(Core2AXI_0_data_rvalid_o),
        .data_wdata_i(xlconstant_2_dout),
        .data_we_i(xlconstant_0_dout));
  axi_verifier_Core2AXI_1_0 Core2AXI_1
       (.M_AXI_ACLK(clk_100MHz_1),
        .M_AXI_ARADDR(Core2AXI_1_M_AXI_ARADDR),
        .M_AXI_ARBURST(Core2AXI_1_M_AXI_ARBURST),
        .M_AXI_ARCACHE(Core2AXI_1_M_AXI_ARCACHE),
        .M_AXI_ARESETN(proc_sys_reset_0_peripheral_aresetn),
        .M_AXI_ARID(Core2AXI_1_M_AXI_ARID),
        .M_AXI_ARLEN(Core2AXI_1_M_AXI_ARLEN),
        .M_AXI_ARLOCK(Core2AXI_1_M_AXI_ARLOCK),
        .M_AXI_ARPROT(Core2AXI_1_M_AXI_ARPROT),
        .M_AXI_ARQOS(Core2AXI_1_M_AXI_ARQOS),
        .M_AXI_ARREADY(Core2AXI_1_M_AXI_ARREADY),
        .M_AXI_ARSIZE(Core2AXI_1_M_AXI_ARSIZE),
        .M_AXI_ARUSER(Core2AXI_1_M_AXI_ARUSER),
        .M_AXI_ARVALID(Core2AXI_1_M_AXI_ARVALID),
        .M_AXI_AWADDR(Core2AXI_1_M_AXI_AWADDR),
        .M_AXI_AWBURST(Core2AXI_1_M_AXI_AWBURST),
        .M_AXI_AWCACHE(Core2AXI_1_M_AXI_AWCACHE),
        .M_AXI_AWID(Core2AXI_1_M_AXI_AWID),
        .M_AXI_AWLEN(Core2AXI_1_M_AXI_AWLEN),
        .M_AXI_AWLOCK(Core2AXI_1_M_AXI_AWLOCK),
        .M_AXI_AWPROT(Core2AXI_1_M_AXI_AWPROT),
        .M_AXI_AWQOS(Core2AXI_1_M_AXI_AWQOS),
        .M_AXI_AWREADY(Core2AXI_1_M_AXI_AWREADY),
        .M_AXI_AWSIZE(Core2AXI_1_M_AXI_AWSIZE),
        .M_AXI_AWUSER(Core2AXI_1_M_AXI_AWUSER),
        .M_AXI_AWVALID(Core2AXI_1_M_AXI_AWVALID),
        .M_AXI_BID(Core2AXI_1_M_AXI_BID),
        .M_AXI_BREADY(Core2AXI_1_M_AXI_BREADY),
        .M_AXI_BRESP(Core2AXI_1_M_AXI_BRESP),
        .M_AXI_BUSER(Core2AXI_1_M_AXI_BUSER),
        .M_AXI_BVALID(Core2AXI_1_M_AXI_BVALID),
        .M_AXI_RDATA(Core2AXI_1_M_AXI_RDATA),
        .M_AXI_RID(Core2AXI_1_M_AXI_RID),
        .M_AXI_RLAST(Core2AXI_1_M_AXI_RLAST),
        .M_AXI_RREADY(Core2AXI_1_M_AXI_RREADY),
        .M_AXI_RRESP(Core2AXI_1_M_AXI_RRESP),
        .M_AXI_RUSER(Core2AXI_1_M_AXI_RUSER),
        .M_AXI_RVALID(Core2AXI_1_M_AXI_RVALID),
        .M_AXI_WDATA(Core2AXI_1_M_AXI_WDATA),
        .M_AXI_WLAST(Core2AXI_1_M_AXI_WLAST),
        .M_AXI_WREADY(Core2AXI_1_M_AXI_WREADY),
        .M_AXI_WSTRB(Core2AXI_1_M_AXI_WSTRB),
        .M_AXI_WUSER(Core2AXI_1_M_AXI_WUSER),
        .M_AXI_WVALID(Core2AXI_1_M_AXI_WVALID),
        .data_addr_i(Godai_0_data_addr_o),
        .data_be_i(Godai_0_data_be_o[3:0]),
        .data_gnt_o(Core2AXI_1_data_gnt_o),
        .data_rdata_o(Core2AXI_1_data_rdata_o),
        .data_req_i(Godai_0_data_req_o),
        .data_rvalid_o(Core2AXI_1_data_rvalid_o),
        .data_wdata_i(Godai_0_data_wdata_o),
        .data_we_i(Godai_0_data_we_o));
  axi_verifier_Godai_0_0 Godai_0
       (.clk(clk_100MHz_1),
        .data_addr_o(Godai_0_data_addr_o),
        .data_be_o(Godai_0_data_be_o),
        .data_err_i(xlconstant_0_dout),
        .data_gnt_i(Core2AXI_1_data_gnt_o),
        .data_rdata_i(Core2AXI_1_data_rdata_o),
        .data_req_o(Godai_0_data_req_o),
        .data_rvalid_i(Core2AXI_1_data_rvalid_o),
        .data_wdata_o(Godai_0_data_wdata_o),
        .data_we_o(Godai_0_data_we_o),
        .instr_addr_o(Godai_0_instr_addr_o),
        .instr_gnt_i(Core2AXI_0_data_gnt_o),
        .instr_rdata_i(Core2AXI_0_data_rdata_o),
        .instr_req_o(Godai_0_instr_req_o),
        .instr_rvalid_i(Core2AXI_0_data_rvalid_o),
        .irq_i(xlconstant_2_dout),
        .rst_n(proc_sys_reset_0_peripheral_aresetn));
  axi_verifier_axi_vip_0_0 axi_vip_0
       (.aclk(clk_100MHz_1),
        .aresetn(proc_sys_reset_0_peripheral_aresetn),
        .s_axi_araddr(Core2AXI_0_M_AXI_ARADDR),
        .s_axi_arburst(Core2AXI_0_M_AXI_ARBURST),
        .s_axi_arcache(Core2AXI_0_M_AXI_ARCACHE),
        .s_axi_arid(Core2AXI_0_M_AXI_ARID),
        .s_axi_arlen(Core2AXI_0_M_AXI_ARLEN),
        .s_axi_arlock(Core2AXI_0_M_AXI_ARLOCK),
        .s_axi_arprot(Core2AXI_0_M_AXI_ARPROT),
        .s_axi_arqos(Core2AXI_0_M_AXI_ARQOS),
        .s_axi_arready(Core2AXI_0_M_AXI_ARREADY),
        .s_axi_arsize(Core2AXI_0_M_AXI_ARSIZE),
        .s_axi_aruser(Core2AXI_0_M_AXI_ARUSER),
        .s_axi_arvalid(Core2AXI_0_M_AXI_ARVALID),
        .s_axi_awaddr(Core2AXI_0_M_AXI_AWADDR),
        .s_axi_awburst(Core2AXI_0_M_AXI_AWBURST),
        .s_axi_awcache(Core2AXI_0_M_AXI_AWCACHE),
        .s_axi_awid(Core2AXI_0_M_AXI_AWID),
        .s_axi_awlen(Core2AXI_0_M_AXI_AWLEN),
        .s_axi_awlock(Core2AXI_0_M_AXI_AWLOCK),
        .s_axi_awprot(Core2AXI_0_M_AXI_AWPROT),
        .s_axi_awqos(Core2AXI_0_M_AXI_AWQOS),
        .s_axi_awready(Core2AXI_0_M_AXI_AWREADY),
        .s_axi_awsize(Core2AXI_0_M_AXI_AWSIZE),
        .s_axi_awuser(Core2AXI_0_M_AXI_AWUSER),
        .s_axi_awvalid(Core2AXI_0_M_AXI_AWVALID),
        .s_axi_bid(Core2AXI_0_M_AXI_BID),
        .s_axi_bready(Core2AXI_0_M_AXI_BREADY),
        .s_axi_bresp(Core2AXI_0_M_AXI_BRESP),
        .s_axi_buser(Core2AXI_0_M_AXI_BUSER),
        .s_axi_bvalid(Core2AXI_0_M_AXI_BVALID),
        .s_axi_rdata(Core2AXI_0_M_AXI_RDATA),
        .s_axi_rid(Core2AXI_0_M_AXI_RID),
        .s_axi_rlast(Core2AXI_0_M_AXI_RLAST),
        .s_axi_rready(Core2AXI_0_M_AXI_RREADY),
        .s_axi_rresp(Core2AXI_0_M_AXI_RRESP),
        .s_axi_ruser(Core2AXI_0_M_AXI_RUSER),
        .s_axi_rvalid(Core2AXI_0_M_AXI_RVALID),
        .s_axi_wdata(Core2AXI_0_M_AXI_WDATA),
        .s_axi_wlast(Core2AXI_0_M_AXI_WLAST),
        .s_axi_wready(Core2AXI_0_M_AXI_WREADY),
        .s_axi_wstrb(Core2AXI_0_M_AXI_WSTRB),
        .s_axi_wuser(Core2AXI_0_M_AXI_WUSER),
        .s_axi_wvalid(Core2AXI_0_M_AXI_WVALID));
  axi_verifier_axi_vip_1_0 axi_vip_1
       (.aclk(clk_100MHz_1),
        .aresetn(proc_sys_reset_0_peripheral_aresetn),
        .s_axi_araddr(Core2AXI_1_M_AXI_ARADDR),
        .s_axi_arburst(Core2AXI_1_M_AXI_ARBURST),
        .s_axi_arcache(Core2AXI_1_M_AXI_ARCACHE),
        .s_axi_arid(Core2AXI_1_M_AXI_ARID),
        .s_axi_arlen(Core2AXI_1_M_AXI_ARLEN),
        .s_axi_arlock(Core2AXI_1_M_AXI_ARLOCK),
        .s_axi_arprot(Core2AXI_1_M_AXI_ARPROT),
        .s_axi_arqos(Core2AXI_1_M_AXI_ARQOS),
        .s_axi_arready(Core2AXI_1_M_AXI_ARREADY),
        .s_axi_arsize(Core2AXI_1_M_AXI_ARSIZE),
        .s_axi_aruser(Core2AXI_1_M_AXI_ARUSER),
        .s_axi_arvalid(Core2AXI_1_M_AXI_ARVALID),
        .s_axi_awaddr(Core2AXI_1_M_AXI_AWADDR),
        .s_axi_awburst(Core2AXI_1_M_AXI_AWBURST),
        .s_axi_awcache(Core2AXI_1_M_AXI_AWCACHE),
        .s_axi_awid(Core2AXI_1_M_AXI_AWID),
        .s_axi_awlen(Core2AXI_1_M_AXI_AWLEN),
        .s_axi_awlock(Core2AXI_1_M_AXI_AWLOCK),
        .s_axi_awprot(Core2AXI_1_M_AXI_AWPROT),
        .s_axi_awqos(Core2AXI_1_M_AXI_AWQOS),
        .s_axi_awready(Core2AXI_1_M_AXI_AWREADY),
        .s_axi_awsize(Core2AXI_1_M_AXI_AWSIZE),
        .s_axi_awuser(Core2AXI_1_M_AXI_AWUSER),
        .s_axi_awvalid(Core2AXI_1_M_AXI_AWVALID),
        .s_axi_bid(Core2AXI_1_M_AXI_BID),
        .s_axi_bready(Core2AXI_1_M_AXI_BREADY),
        .s_axi_bresp(Core2AXI_1_M_AXI_BRESP),
        .s_axi_buser(Core2AXI_1_M_AXI_BUSER),
        .s_axi_bvalid(Core2AXI_1_M_AXI_BVALID),
        .s_axi_rdata(Core2AXI_1_M_AXI_RDATA),
        .s_axi_rid(Core2AXI_1_M_AXI_RID),
        .s_axi_rlast(Core2AXI_1_M_AXI_RLAST),
        .s_axi_rready(Core2AXI_1_M_AXI_RREADY),
        .s_axi_rresp(Core2AXI_1_M_AXI_RRESP),
        .s_axi_ruser(Core2AXI_1_M_AXI_RUSER),
        .s_axi_rvalid(Core2AXI_1_M_AXI_RVALID),
        .s_axi_wdata(Core2AXI_1_M_AXI_WDATA),
        .s_axi_wlast(Core2AXI_1_M_AXI_WLAST),
        .s_axi_wready(Core2AXI_1_M_AXI_WREADY),
        .s_axi_wstrb(Core2AXI_1_M_AXI_WSTRB),
        .s_axi_wuser(Core2AXI_1_M_AXI_WUSER),
        .s_axi_wvalid(Core2AXI_1_M_AXI_WVALID));
  axi_verifier_proc_sys_reset_0_0 proc_sys_reset_0
       (.aux_reset_in(1'b1),
        .dcm_locked(1'b1),
        .ext_reset_in(reset_rtl_1),
        .mb_debug_sys_rst(1'b0),
        .peripheral_aresetn(proc_sys_reset_0_peripheral_aresetn),
        .slowest_sync_clk(clk_100MHz_1));
  axi_verifier_xlconstant_0_0 xlconstant_0
       (.dout(xlconstant_0_dout));
  axi_verifier_xlconstant_1_0 xlconstant_1
       (.dout(xlconstant_1_dout));
  axi_verifier_xlconstant_2_0 xlconstant_2
       (.dout(xlconstant_2_dout));
endmodule
