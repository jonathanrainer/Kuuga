`timescale 1ns / 1ps

import cache_def::*;

module simple_cache
#(
    ADDR_WIDTH = 16,
    DATA_WIDTH = 32
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
    cpu_req_type cpu_req;
    mem_data_type mem_data;
    mem_req_type mem_req;
    cpu_result_type cpu_res;
    
    bit [ADDR_WIDTH-1:0] cached_addr;
    bit [DATA_WIDTH-1:0] cached_data;
    
    bit [ADDR_WIDTH-1:0] addr_to_check;
    bit wb_necessary;
    bit indexed_cache_entry_valid;

    assign rst = !rst_ni;

    dm_cache_fsm cache_imp(
        .clk(clk_i),
        .*
    );
    
    enum bit [2:0] {
        WAIT_ON_REQ,
        CACHE_HIT_GNT,
        CACHE_HIT_DATA,
        SERVICE_WRITE_BACK_WAIT_GNT,
        SERVICE_WRITE_BACK_WAIT_RVALID,
        SERVICE_CACHE_MISS
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
                in_data_rvalid_o <= 1'b0;
                in_data_rdata_o <= 32'b0;
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
                        in_data_gnt_o <= 1'b1;
                        state <= CACHE_HIT_DATA;
                    end
                    else if (mem_req.rw) 
                    begin
                        cached_addr <= mem_req.addr;
                        cached_data <= mem_req.data;
                        state <= SERVICE_WRITE_BACK_WAIT_GNT;
                    end
                    else 
                    begin
                        out_data_req_o <= in_data_req_i;
                        out_data_addr_o <= in_data_addr_i;
                        out_data_we_o <= in_data_we_i;
                        out_data_be_o <= in_data_be_i;
                        out_data_wdata_o <= in_data_wdata_i;
                        state <= SERVICE_CACHE_MISS;
                    end
                end
            end
            CACHE_HIT_DATA:
            begin
                in_data_gnt_o <= 1'b0;
                in_data_rvalid_o <= 1'b1;
                if (cpu_req.rw) in_data_rdata_o <= 32'h00000000;
                else in_data_rdata_o <= cpu_res.data;
                state <= WAIT_ON_REQ;
            end
            SERVICE_WRITE_BACK_WAIT_GNT:
            begin
                if (!out_data_gnt_i)
                begin
                    out_data_req_o <= 1'b1;
                    out_data_addr_o <= cached_addr;
                    out_data_we_o <= 1'b1;
                    out_data_be_o <= 4'hf;
                    out_data_wdata_o <= cached_data;
                end
                else if (out_data_gnt_i)
                begin
                    out_data_req_o <= 1'b0;
                    out_data_addr_o <= 1'b0;
                    out_data_we_o <= 1'b0;
                    out_data_be_o <= 4'h0;
                    out_data_wdata_o <= 32'h00000000;
                    state <= SERVICE_WRITE_BACK_WAIT_RVALID;
                end
            end
            SERVICE_WRITE_BACK_WAIT_RVALID:
            begin
                if(out_data_rvalid_i) 
                begin
                    mem_data.ready <= 1'b1;
                    out_data_req_o <= in_data_req_i;
                    out_data_addr_o <= in_data_addr_i;
                    out_data_we_o <= in_data_we_i;
                    out_data_be_o <= in_data_be_i;
                    out_data_wdata_o <= in_data_wdata_i;
                    state <= SERVICE_CACHE_MISS;
                end
            end
            SERVICE_CACHE_MISS:
            begin
                mem_data.ready <= 1'b0;
                if(!out_data_rvalid_i) 
                begin
                    in_data_gnt_o <= out_data_gnt_i;
                    in_data_rvalid_o <= out_data_rvalid_i;
                    in_data_rdata_o <= out_data_rdata_i;
                end
                else
                begin
                    mem_data.data <= (!out_data_we_o) ? out_data_rdata_i : out_data_wdata_o;
                    mem_data.ready <= 1'b1;
                    out_data_req_o <= 1'b0;
                    in_data_gnt_o <= 1'b0;
                    in_data_rvalid_o <= 1'b1;
                    out_data_addr_o <= 16'b0;
                    out_data_we_o <= 1'b0;
                    out_data_be_o <= 1'b0;
                    in_data_rdata_o <= out_data_rdata_i;
                    out_data_wdata_o <= 32'b0;
                    state <= WAIT_ON_REQ;
                end
            end
        endcase
        addr_to_check <= '0;        
    end
    
    task initialise_module();
        state <= WAIT_ON_REQ;
        in_data_gnt_o <= 1'b0;
        in_data_rvalid_o <= 1'b0;
        in_data_rdata_o <= 32'b0;
        out_data_req_o <= 1'b0;
        out_data_addr_o <= 16'b0;
        out_data_we_o <= 1'b0;
        out_data_be_o <= 1'b0;
        out_data_wdata_o <= 32'b0;
    endtask

endmodule
