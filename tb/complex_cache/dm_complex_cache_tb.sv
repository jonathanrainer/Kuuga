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
import kuuga_cc_dm_sim_axi_vip_0_0_pkg::*;
import kuuga_cc_dm_sim_axi_vip_1_0_pkg::*;
import gouram_datatypes::*;

module cc_dm_tb;

    localparam MEM_SIZE = 16384;
    
    integer sim_counter = 0;
    bit reset;
    bit clk;
    bit test_sig;
    
    bit[32-1:0] mem_rd_data;
    bit [31:0] mem[MEM_SIZE] = '{default: 32'b0};
    bit [31:0] data_mem[MEM_SIZE] = '{default: 32'b0};
    
    int req_count;
    int hit_count;
    int miss_count;
    int instr_count;
    
    kuuga_cc_dm_sim_axi_vip_0_0_slv_mem_t instr_agent;
    kuuga_cc_dm_sim_axi_vip_1_0_slv_mem_t data_agent;
    
    kuuga_cc_dm_sim_wrapper kuuga_inst(
        .rst_n(reset),
        .clk(clk)
    );

   always
   begin
        #5 clk = ~clk;
        if (clk) sim_counter++;
        if (clk && kuuga_inst.kuuga_cc_dm_sim_i.gouram_wrapper_0.lock) $stop;
        if (clk && kuuga_inst.kuuga_cc_dm_sim_i.enokida_dm_wrapper_0.inst.tac.processing_complete) $finish;
   end
   
   initial 
       begin
           // Build up a set of agents to control the AXI VIP Blocks
           instr_agent = new("InstructionVIP",cc_dm_tb.kuuga_inst.kuuga_cc_dm_sim_i.axi_vip_0.inst.IF);
           instr_agent.set_agent_tag("Instruction Memory Agent");
           instr_agent.set_verbosity(0);  
           data_agent = new("DataVIP", cc_dm_tb.kuuga_inst.kuuga_cc_dm_sim_i.axi_vip_1.inst.IF);
           data_agent.set_agent_tag("Data Memory Agent");
           data_agent.set_verbosity(0);
           instr_agent.start_slave();
           data_agent.start_slave();
           // Do some backdoor memory access to set up the program that will be accessed throughout the 
           // test
           $readmemh("lms_cc_dm_instruction_memory.mem", mem);
           $readmemh("lms_cc_dm_data_memory.mem", data_mem);
           for (int i = 0; i < MEM_SIZE; i++) 
           begin
                if (mem[i] != 32'b0) backdoor_instr_mem_write(i*4, mem[i], 4'b1111);
                else backdoor_instr_mem_write(i*4, i, 4'b1111);
           end
           for (int i = 0; i < MEM_SIZE; i++) 
           begin
               if (data_mem[i] != 32'b0) backdoor_data_mem_write(i*4, data_mem[i], 4'b1111);
               else backdoor_data_mem_write(i*4, i, 4'b1111);
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
