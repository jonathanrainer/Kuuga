module core2axi_wrapper
#(
    // Base address of targeted slave
    parameter  C_M_TARGET_SLAVE_BASE_ADDR	= 32'h40000000,
    // Burst Length. Supports 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths
    parameter integer C_M_AXI_BURST_LEN	= 16,
    // Thread ID Width
    parameter integer C_M_AXI_ID_WIDTH	= 1,
    // Width of Address Bus
    parameter integer C_M_AXI_ADDR_WIDTH	= 32,
    // Width of Data Bus
    parameter integer C_M_AXI_DATA_WIDTH	= 32,
    // Width of User Write Address Bus
    parameter integer C_M_AXI_AWUSER_WIDTH	= 0,
    // Width of User Read Address Bus
    parameter integer C_M_AXI_ARUSER_WIDTH	= 0,
    // Width of User Write Data Bus
    parameter integer C_M_AXI_WUSER_WIDTH	= 0,
    // Width of User Read Data Bus
    parameter integer C_M_AXI_RUSER_WIDTH	= 0,
    // Width of User Response Bus
    parameter integer C_M_AXI_BUSER_WIDTH	= 0,
    parameter C_M_AXI_REGISTERED_GRANT   = "FALSE"           // "TRUE"|"FALSE"
)
(
    // Clock and Reset
    input                           M_AXI_ACLK,
    input                           M_AXI_ARESETN,
    input                           data_req_i,
    output                          data_gnt_o,
    output                          data_rvalid_o,
    input  [C_M_AXI_ADDR_WIDTH-1:0] data_addr_i,
    input                           data_we_i,
    input  [3:0]                    data_be_i,
    output [31:0]                   data_rdata_o,
    input  [31:0]                   data_wdata_i,

    // ---------------------------------------------------------
    // AXI TARG Port Declarations ------------------------------
    // ---------------------------------------------------------
    //AXI write address bus -------------- // USED// -----------
    output [C_M_AXI_ID_WIDTH-1:0]       M_AXI_AWID,
    output [C_M_AXI_ADDR_WIDTH-1:0]     M_AXI_AWADDR,
    output [7:0]                        M_AXI_AWLEN,
    output [2:0]                        M_AXI_AWSIZE,
    output [1:0]                        M_AXI_AWBURST,
    output                              M_AXI_AWLOCK,
    output [3:0]                        M_AXI_AWCACHE,
    output [2:0]                        M_AXI_AWPROT,
    output [C_M_AXI_AWUSER_WIDTH-1:0]   M_AXI_AWUSER,
    output [3:0]                        M_AXI_AWQOS,
    output                              M_AXI_AWVALID,
    input                               M_AXI_AWREADY,
    // ---------------------------------------------------------

    //AXI write data bus -------------- // USED// --------------
    output [C_M_AXI_DATA_WIDTH-1:0]     M_AXI_WDATA,
    output [C_M_AXI_DATA_WIDTH/8-1:0]   M_AXI_WSTRB,
    output                              M_AXI_WLAST,
    output [C_M_AXI_WUSER_WIDTH-1:0]    M_AXI_WUSER,
    output                              M_AXI_WVALID,
    input                               M_AXI_WREADY,
    // ---------------------------------------------------------

    //AXI write response bus -------------- // USED// ----------
    input  [C_M_AXI_ID_WIDTH-1:0]       M_AXI_BID,
    input  [1:0]                        M_AXI_BRESP,
    input                               M_AXI_BVALID,
    input  [C_M_AXI_BUSER_WIDTH-1:0]    M_AXI_BUSER,
    output                              M_AXI_BREADY,
    // ---------------------------------------------------------

    //AXI read address bus -------------------------------------
    output [C_M_AXI_ID_WIDTH-1:0]       M_AXI_ARID,
    output [C_M_AXI_ADDR_WIDTH-1:0]     M_AXI_ARADDR,
    output [7:0]                        M_AXI_ARLEN,
    output [2:0]                        M_AXI_ARSIZE,
    output [1:0]                        M_AXI_ARBURST,
    output                              M_AXI_ARLOCK,
    output [3:0]                        M_AXI_ARCACHE,
    output [2:0]                        M_AXI_ARPROT,
    output [C_M_AXI_ARUSER_WIDTH-1:0]   M_AXI_ARUSER,
    output [3:0]                        M_AXI_ARQOS,
    output                              M_AXI_ARVALID,
    input                               M_AXI_ARREADY,
    // ---------------------------------------------------------

    //AXI read data bus ----------------------------------------
    input  [C_M_AXI_ID_WIDTH-1:0]       M_AXI_RID,
    input  [C_M_AXI_DATA_WIDTH-1:0]     M_AXI_RDATA,
    input  [1:0]                        M_AXI_RRESP,
    input                               M_AXI_RLAST,
    input  [C_M_AXI_RUSER_WIDTH-1:0]    M_AXI_RUSER,
    input                               M_AXI_RVALID,
    output                              M_AXI_RREADY
    // ---------------------------------------------------------
  );

	core2axi #(
	   C_M_AXI_ADDR_WIDTH,
	   C_M_AXI_DATA_WIDTH,
	   C_M_AXI_DATA_WIDTH,
	   C_M_AXI_ID_WIDTH,
	   C_M_AXI_AWUSER_WIDTH,
	   C_M_AXI_REGISTERED_GRANT
	   ) 
	mod(
	   .clk_i(M_AXI_ACLK),
	   .rst_ni(M_AXI_ARESETN),
	   .data_req_i(data_req_i),
	   .data_gnt_o(data_gnt_o),
	   .data_rvalid_o(data_rvalid_o),
	   .data_addr_i(data_addr_i),
	   .data_we_i(data_we_i),
	   .data_be_i(data_be_i),
	   .data_rdata_o(data_rdata_o),
	   .data_wdata_i(data_wdata_i),
	   .aw_id_o(M_AXI_AWID),
	   .aw_addr_o(M_AXI_AWADDR),
	   .aw_len_o(M_AXI_AWLEN),
	   .aw_size_o(M_AXI_AWSIZE),
	   .aw_burst_o(M_AXI_AWBURST),
	   .aw_lock_o(M_AXI_AWLOCK),
	   .aw_cache_o(M_AXI_AWCACHE),
	   .aw_prot_o(M_AXI_AWPROT),
	   .aw_user_o(M_AXI_AWUSER),
	   .aw_qos_o(M_AXI_AWQOS),
	   .aw_valid_o(M_AXI_AWVALID),
	   .aw_ready_i(M_AXI_AWREADY),
	   .w_data_o(M_AXI_WDATA),
	   .w_strb_o(M_AXI_WSTRB),
	   .w_last_o(M_AXI_WLAST),
	   .w_user_o(M_AXI_WUSER),
	   .w_valid_o(M_AXI_WVALID),
	   .w_ready_i(M_AXI_WREADY),
	   .b_id_i(M_AXI_BID),
	   .b_resp_i(M_AXI_BRESP),
	   .b_valid_i(M_AXI_BVALID),
	   .b_user_i(M_AXI_BUSER),
	   .b_ready_o(M_AXI_BREADY),
	   .ar_id_o(M_AXI_ARID),
	   .ar_addr_o(M_AXI_ARADDR),
	   .ar_len_o(M_AXI_ARLEN),
	   .ar_size_o(M_AXI_ARSIZE),
	   .ar_burst_o(M_AXI_ARBURST),
	   .ar_lock_o(M_AXI_ARLOCK),
	   .ar_cache_o(M_AXI_ARCACHE),
	   .ar_prot_o(M_AXI_ARPROT),
	   .ar_user_o(M_AXI_ARUSER),
	   .ar_qos_o(M_AXI_ARQOS),
	   .ar_valid_o(M_AXI_ARVALID),
	   .ar_ready_i(M_AXI_ARREADY),
	   .r_id_i(M_AXI_RID),
	   .r_data_i(M_AXI_RDATA),
	   .r_resp_i(M_AXI_RRESP),
	   .r_last_i(M_AXI_RLAST),
	   .r_user_i(M_AXI_RUSER),
	   .r_valid_i(M_AXI_RVALID),
	   .r_ready_o(M_AXI_RREADY)
	);

endmodule
