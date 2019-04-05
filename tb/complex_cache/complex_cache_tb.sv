`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2019 11:54:50 AM
// Design Name: 
// Module Name: simple_cache_tb
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

import axi_vip_pkg::*;
import complex_cache_test_axi_vip_0_0_pkg::*;
import complex_cache_test_axi_vip_1_0_pkg::*;
import gouram_datatypes::*;

module complex_cache_tb;

    localparam MEM_SIZE = 4096;
    
    integer sim_counter = 0;
    bit reset;
    bit clk;
    
    bit[32-1:0] mem_rd_data;
    bit [31:0] mem[MEM_SIZE] = '{default: 32'b0};
    bit [31:0] data_mem[MEM_SIZE] = '{default: 32'b0};
    
    complex_cache_test_axi_vip_1_0_slv_mem_t instr_agent;
    complex_cache_test_axi_vip_0_0_slv_mem_t data_agent;
    
    complex_cache_test_wrapper kuuga_inst(
        .rst_n(reset),
        .clk(clk)
    );

   
   always
   begin
        #5 clk = ~clk;
        if (clk) sim_counter++;
        if (sim_counter == 10000) $finish;
        //if (sim_counter == 32'h4c) $stop;
   end
   
   initial 
       begin
           // Build up a set of agents to control the AXI VIP Blocks
           instr_agent = new("InstructionVIP", complex_cache_tb.kuuga_inst.complex_cache_test_i.axi_vip_1.inst.IF);
           instr_agent.set_agent_tag("Instruction Memory Agent");
           instr_agent.set_verbosity(0);  
           data_agent = new("DataVIP", complex_cache_tb.kuuga_inst.complex_cache_test_i.axi_vip_0.inst.IF);
           data_agent.set_agent_tag("Data Memory Agent");
           data_agent.set_verbosity(0);
           instr_agent.start_slave();
           data_agent.start_slave();
           // Do some backdoor memory access to set up the program that will be accessed throughout the 
           // test
           mem[32] = 32'h2400006f;
           mem[33] = 32'h27c0006f;
           mem[128] = 32'hfe010113;
           mem[129] = 32'h00112e23;
           mem[130] = 32'h00812c23;
           mem[131] = 32'h02010413;
           mem[132] = 32'hfea42623;
           mem[133] = 32'hfec42783;
           mem[134] = 32'h00079663;
           mem[135] = 32'h00100793;
           mem[136] = 32'h0200006f;
           mem[137] = 32'hfec42783;
           mem[138] = 32'hfff78793;
           mem[139] = 32'h00078513;
           mem[140] = 32'hfd1ff0ef;
           mem[141] = 32'h00050713;
           mem[142] = 32'hfec42783;
           mem[143] = 32'h02f707b3;
           mem[144] = 32'h00078513;
           mem[145] = 32'h01c12083;
           mem[146] = 32'h01812403;
           mem[147] = 32'h02010113;
           mem[148] = 32'h00008067;
           mem[149] = 32'hfe010113;
           mem[150] = 32'h00112e23;
           mem[151] = 32'h00812c23;
           mem[152] = 32'h02010413;
           mem[153] = 32'hfe042423;
           mem[154] = 32'h00500793;
           mem[155] = 32'hfef42223;
           mem[156] = 32'hfe042623;
           mem[157] = 32'h0280006f;
           mem[158] = 32'hfec42503;
           mem[159] = 32'hf85ff0ef;
           mem[160] = 32'h00050713;
           mem[161] = 32'hfe842783;
           mem[162] = 32'h00e787b3;
           mem[163] = 32'hfef42423;
           mem[164] = 32'hfec42783;
           mem[165] = 32'h00178793;
           mem[166] = 32'hfef42623;
           mem[167] = 32'hfe442783;
           mem[168] = 32'hfec42703;
           mem[169] = 32'hfce7dae3;
           mem[170] = 32'hfe842783;
           mem[171] = 32'h00078513;
           mem[172] = 32'h01c12083;
           mem[173] = 32'h01812403;
           mem[174] = 32'h02010113;
           mem[175] = 32'h00008067;
           mem[176] = 32'h00010137;
           mem[177] = 32'hf0010113;
           mem[178] = 32'hf8dff0ef;
           mem[179] = 32'h00002083;
           mem[180] = 32'h00010137;
           mem[181] = 32'hf0010113;
           mem[182] = 32'hD69ff0ef;
           mem[183] = 32'h0040006f;
           mem[184] = 32'h0000006f;
           for (int i = 0; i < MEM_SIZE; i++) 
           begin
                if (mem[i] != 32'b0) backdoor_instr_mem_write(i*4, mem[i], 4'b1111);
                else backdoor_instr_mem_write(i*4, i, 4'b1111);
           end
           // Set up the device to run
           clk = 0;
           reset = 0;
           #50 reset = 1;
       end
   
       /*************************************************************************************************
   * Task backdoor_mem_write shows how to write to some address of memory with data and strobe 
   * information.
   * User has to make sure that the inputs to this task has to follow below rules to match
   * memory width, also user has to make sure that strobe bits can not be asserted on if lower 
   * than the address offset.
   * Address offset calculation is: address offset = address &((1 << (log2(DATA_WIDTH/8)) -1))
   *  input xil_axi_ulong                         addr, 
   *  input bit [DATA_WIDTH-1:0]                  wr_data
   *  input bit [(DATA_WIDTH/8)-1:0]              wr_strb 
   *************************************************************************************************/
   task backdoor_instr_mem_write(
     input xil_axi_ulong                         addr, 
     input bit [32-1:0]           wr_data,
     input bit [(32/8)-1:0]       wr_strb ={(32/8){1'b1}}
   );
     instr_agent.mem_model.backdoor_memory_write(addr, wr_data, wr_strb);
   endtask
   
   task backdoor_data_mem_write(
        input xil_axi_ulong                         addr, 
        input bit [32-1:0]           wr_data,
        input bit [(32/8)-1:0]       wr_strb ={(32/8){1'b1}}
      );
        data_agent.mem_model.backdoor_memory_write(addr, wr_data, wr_strb);
      endtask
   
   task set_instr_mem_default_value_rand();
       instr_agent.mem_model.set_memory_fill_policy(XIL_AXI_MEMORY_FILL_RANDOM);
     endtask
   
   task backdoor_instr_mem_read(
         input xil_axi_ulong mem_rd_addr,
         output bit [32-1:0] mem_rd_data
        );
         mem_rd_data= instr_agent.mem_model.backdoor_memory_read(mem_rd_addr);
     
   endtask
    
endmodule
