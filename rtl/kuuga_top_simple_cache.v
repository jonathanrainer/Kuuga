`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2019 11:06:55 AM
// Design Name: 
// Module Name: kuuga_ila_top
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


module kuuga_sc (
    reset,
    sys_diff_clock_clk_n,
    sys_diff_clock_clk_p
);
    
  input reset;
  input sys_diff_clock_clk_n;
  input sys_diff_clock_clk_p;

  wire reset;
  wire sys_diff_clock_clk_n;
  wire sys_diff_clock_clk_p;
  wire inst_clk;
  wire inst_rst;
  wire [31:0] inst_douta;
  wire [15:0] inst_addra; 
  wire [31:0] inst_dina;
  wire inst_ena;
  wire [3:0] inst_wea;
  wire data_clk;
  wire data_rst;
  wire [31:0] data_douta;
  wire [15:0] data_addra; 
  wire [31:0] data_dina;
  wire data_ena;
  wire [3:0] data_wea;
  
  wire [15:0] bram_inst_word_addr;
  wire [15:0] bram_data_word_addr;
  
  assign bram_inst_word_addr = inst_addra >> 2;
  assign bram_data_word_addr = data_addra >> 2;
    
    kuuga_simple_cache k_top 
    (   
        .reset(reset),
        .sys_diff_clock_clk_n(sys_diff_clock_clk_n),
        .sys_diff_clock_clk_p(sys_diff_clock_clk_p),
        .data_bram_addr_a(data_addra),
        .data_bram_clk_a(data_clk),
        .data_bram_wrdata_a(data_dina),
        .data_bram_rddata_a(data_douta),
        .data_bram_en_a(data_ena),
        .data_bram_rst_a(data_rst),
        .data_bram_we_a(data_wea),
        .inst_bram_addr_a(inst_addra),
        .inst_bram_clk_a(inst_clk),
        .inst_bram_wrdata_a(inst_dina),
        .inst_bram_rddata_a(inst_douta),
        .inst_bram_en_a(inst_ena),
        .inst_bram_rst_a(inst_rst),
        .inst_bram_we_a(inst_wea)
    );
    
     (* DONT_TOUCH = "true" *) xpm_memory_spram #(
          .ADDR_WIDTH_A(16),              // DECIMAL
          .AUTO_SLEEP_TIME(0),           // DECIMAL
          .BYTE_WRITE_WIDTH_A(32),       // DECIMAL
          .ECC_MODE("no_ecc"),           // String
          .MEMORY_INIT_FILE("data_dummy_data.mem"),     // String
          .MEMORY_INIT_PARAM(""),       // String
          .MEMORY_OPTIMIZATION("false"),  // String
          .MEMORY_PRIMITIVE("block"),     // String
          .MEMORY_SIZE(1048576),            // DECIMAL
          .MESSAGE_CONTROL(0),           // DECIMAL
          .READ_DATA_WIDTH_A(32),        // DECIMAL
          .READ_LATENCY_A(1),            // DECIMAL
          .READ_RESET_VALUE_A("EE"),      // String
          .USE_MEM_INIT(1),              // DECIMAL
          .WAKEUP_TIME("disable_sleep"), // String
          .WRITE_DATA_WIDTH_A(32),       // DECIMAL
          .WRITE_MODE_A("read_first")    // String
       )
       xpm_data_mem (
    
          .douta(data_douta),                   // READ_DATA_WIDTH_A-bit output: Data output for port A read operations.
    
          .addra(bram_data_word_addr),                   // ADDR_WIDTH_A-bit input: Address for port A write and read operations.
          .clka(data_clk),                     // 1-bit input: Clock signal for port A.
          .dina(data_dina),                     // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
          .ena(data_ena),                       // 1-bit input: Memory enable signal for port A. Must be high on clock
                                           // cycles when read or write operations are initiated. Pipelined
                                           // internally.
  
    
          .rsta(data_rst),                     // 1-bit input: Reset signal for the final port A output register stage.
                                           // Synchronously resets output port douta to the value specified by
                                           // parameter READ_RESET_VALUE_A.
    
          .wea(data_wea),                        // WRITE_DATA_WIDTH_A-bit input: Write enable vector for port A input
                                           // data port dina. 1 bit wide when word-wide writes are used. In
                                           // byte-wide write configurations, each bit controls the writing one
                                           // byte of dina to address addra. For example, to synchronously write
                                           // only bits [15-8] of dina when WRITE_DATA_WIDTH_A is 32, wea would be
                                           // 4'b0010.
          .regcea(1'b1)
    
       );
       
       (* DONT_TOUCH = "true" *) xpm_memory_spram #(
         .ADDR_WIDTH_A(16),              // DECIMAL
         .AUTO_SLEEP_TIME(0),           // DECIMAL
         .BYTE_WRITE_WIDTH_A(32),       // DECIMAL
         .ECC_MODE("no_ecc"),           // String
         .MEMORY_INIT_FILE("inst_dummy_data.mem"),     // String
         .MEMORY_INIT_PARAM(""),       // String
         .MEMORY_OPTIMIZATION("false"),  // String
         .MEMORY_PRIMITIVE("block"),     // String
         .MEMORY_SIZE(1048576),         // DECIMAL
         .MESSAGE_CONTROL(0),           // DECIMAL
         .READ_DATA_WIDTH_A(32),        // DECIMAL
         .READ_LATENCY_A(1),            // DECIMAL
         .READ_RESET_VALUE_A("FF"),      // String
         .USE_MEM_INIT(1),              // DECIMAL
         .WAKEUP_TIME("disable_sleep"), // String
         .WRITE_DATA_WIDTH_A(32),       // DECIMAL
         .WRITE_MODE_A("read_first")    // String
      )
      xpm_inst_mem (
   
         .douta(inst_douta),                   // READ_DATA_WIDTH_A-bit output: Data output for port A read operations.
   
         .addra(bram_inst_word_addr),                   // ADDR_WIDTH_A-bit input: Address for port A write and read operations.
         .clka(inst_clk),                     // 1-bit input: Clock signal for port A.
         .dina(inst_dina),                     // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
         .ena(inst_ena),                       // 1-bit input: Memory enable signal for port A. Must be high on clock
                                          // cycles when read or write operations are initiated. Pipelined
                                          // internally.
 
   
         .rsta(inst_rst),                     // 1-bit input: Reset signal for the final port A output register stage.
                                          // Synchronously resets output port douta to the value specified by
                                          // parameter READ_RESET_VALUE_A.
   
         .wea(inst_wea),                        // WRITE_DATA_WIDTH_A-bit input: Write enable vector for port A input
                                          // data port dina. 1 bit wide when word-wide writes are used. In
                                          // byte-wide write configurations, each bit controls the writing one
                                          // byte of dina to address addra. For example, to synchronously write
                                          // only bits [15-8] of dina when WRITE_DATA_WIDTH_A is 32, wea would be
                                          // 4'b0010.
         .regcea(1'b1)
   
      );

    
endmodule
