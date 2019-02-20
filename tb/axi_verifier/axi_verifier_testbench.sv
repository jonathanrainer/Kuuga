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
import axi_verifier_axi_vip_0_1_pkg::*;
import axi_verifier_axi_vip_1_1_pkg::*;
import gouram_datatypes::*;

module axi_verifier_testbench();

    localparam MEM_SIZE = 34;

    logic clk;
    logic rst_n;
    bit finish_flag;
    
    bit[32-1:0] mem_rd_data;
    trace_format trace_out;

    axi_verifier DUT(
        .clk_100MHz(clk),
        .reset_rtl(rst_n),
        .trace_out(trace_out)
    );

    axi_verifier_axi_vip_0_1_slv_mem_t instr_agent;
    axi_verifier_axi_vip_1_1_slv_mem_t data_agent;
    
    bit [31:0] mem[MEM_SIZE];
    
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
        mem[0]  = 32'h10000113; // ADDI R0, 0x100, R2
        mem[1]  = 32'h00100093; // ADDI R0, 0x1, R1
        mem[2]  = 32'h401101B3; // SUB R2, R1, R3 (R3 := R2 - R1)
        mem[3]  = 32'h00002283; // LW R0, 0x0, R5
        mem[4]  = 32'h00402303; // LW R0, 0x4, R6
        mem[5]  = 32'h06302823; // SW R0, 0x70, R3
        mem[6]  = 32'h07002E03; // LW R0, 0x70, R28
        mem[7]  = 32'hF4918067; // JALR R3, -0x48, R0 
        mem[18] = 32'h026283B3; // MUL R5 R6 R7
        mem[19] = 32'h0253B433; // Divide R6 R7 R8 (R8 := R7/R6)
        mem[20] = 32'h006386B3; // ADD R6 R7 R13
        mem[21] = 32'h06D02C23; // SW R0, 0x74, R13
        mem[22] = 32'h0000006F; // Loop on this address
        mem[32] = 32'hF81FF06F; // Jump to Address 0
        mem[33] = 32'h0000006F; // Trap Address
        for (int i = 0; i < MEM_SIZE; i++) backdoor_instr_mem_write(i*4, mem[i], 4'b1111);
        // Set up the device to run
        clk = 0;
        rst_n = 0;
        #50 rst_n = 1;
        finish_flag = 0;
    end
    
    always
    begin
        #5 clk = ~clk;
        if (trace_out != null && trace_out.instruction == 32'h07002e03) $finish;   
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
