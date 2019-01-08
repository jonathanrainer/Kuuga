`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2019 11:49:41 AM
// Design Name: 
// Module Name: axi_verifier_testbench
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
import axi_verifier_axi_vip_0_0_pkg::*;
import axi_verifier_axi_vip_1_0_pkg::*;

module axi_verifier_testbench();

    logic clk;
    logic rst_n;
    bit finish_flag;
    
    bit[32-1:0] mem_rd_data;
    bit[0:608] trace_out;

    axi_verifier DUT(
        .clk_100MHz(clk),
        .reset_rtl(rst_n),
        .trace_out(trace_out)
    );

    axi_verifier_axi_vip_0_0_slv_mem_t instr_agent;
    axi_verifier_axi_vip_1_0_slv_mem_t data_agent;
    
    initial 
    begin
        // Build up a set of agents to control the AXI VIP Blocks
        instr_agent = new("InstructionVIP",axi_verifier_testbench.DUT.axi_vip_0.inst.IF);
        instr_agent.set_agent_tag("Instruction Memory Agent");
        instr_agent.set_verbosity(0);  
        data_agent = new("DataVIP",axi_verifier_testbench.DUT.axi_vip_1.inst.IF);
        data_agent.set_agent_tag("Data Memory Agent");
        data_agent.set_verbosity(0);
        instr_agent.start_slave();
        data_agent.start_slave();
        // Do some backdoor memory access to set up the program that will be accessed throughout the 
        // test
        set_instr_mem_default_value_rand();
        backdoor_instr_mem_write(32'h80, 32'hF81FF06F, 4'b1111);
        backdoor_instr_mem_read(32'h80, mem_rd_data);
        // Set up the device to run
        clk = 0;
        rst_n = 0;
        #50 rst_n = 1;
        finish_flag = 0;
        #1000 $finish;
    end
    
    always
    begin
        #5 clk = ~clk;        
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
