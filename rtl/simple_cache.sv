`timescale 1ns / 1ps

import cache_def::*;

module simple_cache
#(
    ADDR_WIDTH = 16,
    DATA_WIDTH = 32,
    CACHE_BLOCKS = 128
)
(

     // Clock and Reset
    input logic                             clk_i,
    input logic                             rst_ni,

    // Core Memory Protocol (Input from Processor)
    input  logic                            in_data_req_i,
    output logic                            in_data_gnt_o,
    output logic                            in_data_rvalid_o,
    input  logic [ADDR_WIDTH-1:0]           in_data_addr_i,
    input  logic                            in_data_we_i,
    input  logic [DATA_WIDTH/8-1:0]         in_data_be_i,
    output logic [DATA_WIDTH-1:0]           in_data_rdata_o,
    input  logic [DATA_WIDTH-1:0]           in_data_wdata_i,
    
    // Core Memory Protocol (Output to Memory, Used on Cache Miss)
    output  logic                            out_data_req_o,
    input   logic                            out_data_gnt_i,
    input   logic                            out_data_rvalid_i,
    output  logic [ADDR_WIDTH-1:0]           out_data_addr_o,
    output  logic                            out_data_we_o,
    output  logic [DATA_WIDTH/8-1:0]         out_data_be_o,
    input   logic [DATA_WIDTH-1:0]           out_data_rdata_i,
    output  logic [DATA_WIDTH-1:0]           out_data_wdata_o
);

    bit rst;
    cpu_req_type cpu_req = '{default: 0};
    mem_data_type mem_data = '{default: 0};
    mem_req_type mem_req = '{default: 0};
    cpu_result_type cpu_res = '{default: 0};
    
    bit [ADDR_WIDTH-1:0] cached_addr;
    bit [DATA_WIDTH-1:0] cached_data;

    assign rst = !rst_ni;

    dm_cache_fsm #(CACHE_BLOCKS) cache_imp(
        .clk(clk_i),
        .*
    );
    
    enum bit [2:0] {
        WAIT_ON_REQ                     =   3'b000,
        CACHE_HIT_GNT                   =   3'b001,
        CACHE_HIT_DATA                  =   3'b010,
        SERVICE_WRITE_BACK_WAIT_GNT     =   3'b011,
        SERVICE_WRITE_BACK_WAIT_RVALID  =   3'b100,
        SERVICE_CACHE_MISS              =   3'b101
    } state;
    
    initial
    begin
        initialise_module();
    end
    
    
    always_ff @(posedge clk_i)
    begin
        if (!rst_ni) initialise_module();
        unique case (state)
            WAIT_ON_REQ:
            begin
                mem_data.ready <= 1'b0;
                assign in_data_rvalid_o = 1'b0;
                assign in_data_rdata_o = 32'b0;
                if(in_data_req_i)
                begin
                    cpu_req.addr <= in_data_addr_i;
                    if (in_data_we_i) 
                    begin
                        cpu_req.data <= in_data_wdata_i;
                        cpu_req.rw <= 1'b1;
                    end
                    else 
                    begin
                        cpu_req.data <= 32'b0;
                        cpu_req.rw <= 1'b0;
                    end
                    cpu_req.valid <= 1'b1;
                    state <= CACHE_HIT_GNT;     
                end
            end
            CACHE_HIT_GNT:
            begin
                if (cpu_res.checked)
                begin
                    cpu_req.valid <= 1'b0;
                    if(cpu_res.ready)
                    begin
                        assign in_data_gnt_o = 1'b1;
                        state <= CACHE_HIT_DATA;
                    end
                    else if (mem_req.rw) 
                    begin
                        cached_addr <= mem_req.addr;
                        cached_data <= mem_req.data;
                        state <= SERVICE_WRITE_BACK_WAIT_GNT;
                    end
                    else state <= SERVICE_CACHE_MISS;
                end
            end
            CACHE_HIT_DATA:
            begin
                assign in_data_gnt_o = 1'b0;
                assign in_data_rvalid_o = 1'b1;
                if (cpu_req.rw) assign in_data_rdata_o = 32'h00000000;
                else assign in_data_rdata_o = cpu_res.data;
                state <= WAIT_ON_REQ;
            end
            SERVICE_WRITE_BACK_WAIT_GNT:
            begin
                if (mem_req.valid && !out_data_gnt_i)
                begin
                    assign out_data_req_o = 1'b1;
                    assign out_data_addr_o = cached_addr;
                    assign out_data_we_o = 1'b1;
                    assign out_data_be_o = 4'hf;
                    assign out_data_wdata_o = cached_data;
                end
                else if (mem_req.valid && out_data_gnt_i)
                begin
                    assign out_data_req_o = 1'b0;
                    assign out_data_addr_o = 1'b0;
                    assign out_data_we_o = 1'b0;
                    assign out_data_be_o = 4'h0;
                    assign out_data_wdata_o = 32'h00000000;
                    state <= SERVICE_WRITE_BACK_WAIT_RVALID;
                end
            end
            SERVICE_WRITE_BACK_WAIT_RVALID:
            begin
                if(out_data_rvalid_i) 
                begin
                    mem_data.ready <= 1'b1;
                    state <= SERVICE_CACHE_MISS;
                end
            end
            SERVICE_CACHE_MISS:
            begin
                mem_data.ready <= 1'b0;
                if(!out_data_rvalid_i) 
                begin
                    assign out_data_req_o = in_data_req_i;
                    assign in_data_gnt_o = out_data_gnt_i;
                    assign in_data_rvalid_o = out_data_rvalid_i;
                    assign out_data_addr_o = in_data_addr_i;
                    assign out_data_we_o = in_data_we_i;
                    assign out_data_be_o = in_data_be_i;
                    assign in_data_rdata_o = out_data_rdata_i;
                    assign out_data_wdata_o = in_data_wdata_i;
                end
                else 
                begin
                    mem_data.data <= out_data_rdata_i;
                    mem_data.ready <= 1'b1;
                    assign out_data_req_o = 1'b0;
                    assign in_data_gnt_o = 1'b0;
                    assign in_data_rvalid_o = 1'b0;
                    assign out_data_addr_o = 16'b0;
                    assign out_data_we_o = 1'b0;
                    assign out_data_be_o = 1'b0;
                    assign in_data_rdata_o = 32'b0;
                    assign out_data_wdata_o = 32'b0;
                    state <= WAIT_ON_REQ;
                end
            end
        endcase        
    end
    
    task initialise_module();
        state <= WAIT_ON_REQ;
    endtask

endmodule
