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


module kuuga_sc_tb();

  localparam PERIOD = 5;

  bit reset;
  bit sys_diff_clock_clk_n;
  bit sys_diff_clock_clk_p;
  
  integer sim_counter;
    
    kuuga_sc k_top 
    (   
        .*
    );
   
    initial
    begin
        sim_counter = 0;
        reset = 0;
        #50 reset = 1;
    end

    always
    begin
        sys_diff_clock_clk_p = 1'b0;
        sys_diff_clock_clk_n = 1'b1;
        #(PERIOD/2) sys_diff_clock_clk_p = 1'b1;
        sys_diff_clock_clk_n = 1'b0;
        #(PERIOD/2);
        if (sys_diff_clock_clk_p && !sys_diff_clock_clk_n) sim_counter++;
        if (sim_counter == 4000) $finish;
    end

    
endmodule
