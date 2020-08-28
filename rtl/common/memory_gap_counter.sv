`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2020 09:41:24 AM
// Design Name: 
// Module Name: memory_gap_counter
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


module memory_gap_counter
(
    input bit       clk,
    input bit       rst_n,
    
    input bit      data_mem_req,
    input bit      data_mem_rvalid,
    output integer memory_gap,
    output bit     memory_gap_valid
);

     bit counting_flag;
     int memory_idle_cycles;
     enum bit {
             COUNT_IDLE,
             COUNT
          } count_state;

    
    always_ff @(posedge clk)
    begin
        if (!rst_n) initialise_device();
        else
        begin
         unique case (count_state)
               COUNT_IDLE:
               begin
                   memory_gap <= -1;
                   memory_gap_valid <= 1'b0;
                   if (data_mem_rvalid) 
                   begin
                       if (!data_mem_req)
                       begin
                           memory_idle_cycles <= 0;
                           count_state <= COUNT;
                       end
                       else
                       begin
                            memory_gap <= 0;
                            memory_gap_valid <= 1'b1;
                       end
                   end
               end
               COUNT:
               begin
                   if (data_mem_req) 
                   begin
                       memory_gap <= memory_idle_cycles;
                       memory_gap_valid <= 1'b1;
                       count_state <= COUNT_IDLE;
                   end
                   else memory_idle_cycles <= memory_idle_cycles + 1;
               end
           endcase
        end
    end
    
        task initialise_device();
        begin
            count_state <= COUNT;
            counting_flag <= 1'b1;
            memory_gap <= -1;
            memory_gap_valid <= 1'b0;
            memory_idle_cycles <= 0;
        end
    endtask
    
endmodule
