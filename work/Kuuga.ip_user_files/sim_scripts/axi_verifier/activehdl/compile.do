vlib work
vlib activehdl

vlib activehdl/xilinx_vip
vlib activehdl/xil_defaultlib
vlib activehdl/xpm
vlib activehdl/axi_infrastructure_v1_1_0
vlib activehdl/smartconnect_v1_0
vlib activehdl/axi_protocol_checker_v2_0_3
vlib activehdl/axi_vip_v1_1_3
vlib activehdl/lib_cdc_v1_0_2
vlib activehdl/proc_sys_reset_v5_0_12
vlib activehdl/xlconstant_v1_1_5

vmap xilinx_vip activehdl/xilinx_vip
vmap xil_defaultlib activehdl/xil_defaultlib
vmap xpm activehdl/xpm
vmap axi_infrastructure_v1_1_0 activehdl/axi_infrastructure_v1_1_0
vmap smartconnect_v1_0 activehdl/smartconnect_v1_0
vmap axi_protocol_checker_v2_0_3 activehdl/axi_protocol_checker_v2_0_3
vmap axi_vip_v1_1_3 activehdl/axi_vip_v1_1_3
vmap lib_cdc_v1_0_2 activehdl/lib_cdc_v1_0_2
vmap proc_sys_reset_v5_0_12 activehdl/proc_sys_reset_v5_0_12
vmap xlconstant_v1_1_5 activehdl/xlconstant_v1_1_5

vlog -work xilinx_vip  -sv2k12 "+incdir+../../../bd/axi_verifier/ipshared/96c1/include" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/verilog" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/96c1/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../bd/axi_verifier/ipshared/96c1/include" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/verilog" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/96c1/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../bd/axi_verifier/ipshared/96c1/include" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/verilog" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/96c1/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"/opt/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"/opt/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
"/opt/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93 \
"/opt/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../bd/axi_verifier/ipshared/96c1/include" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/verilog" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/96c1/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../bd/axi_verifier/ipshared/96c1/include" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/verilog" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/96c1/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../bd/axi_verifier/ipshared/511c/rtl/core2axi.sv" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../bd/axi_verifier/ipshared/96c1/include" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/verilog" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/96c1/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../bd/axi_verifier/ipshared/96c1/include" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/verilog" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/96c1/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../bd/axi_verifier/ipshared/511c/rtl/core2axi_wrapper.v" \
"../../../bd/axi_verifier/ip/axi_verifier_Core2AXI_0_0/sim/axi_verifier_Core2AXI_0_0.v" \
"../../../bd/axi_verifier/ip/axi_verifier_Core2AXI_1_0/sim/axi_verifier_Core2AXI_1_0.v" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../bd/axi_verifier/ipshared/96c1/include" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/verilog" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/96c1/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../bd/axi_verifier/ipshared/96c1/include" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/verilog" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/96c1/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../bd/axi_verifier/ipshared/96c1/include/riscv_defines.sv" \
"../../../bd/axi_verifier/ipshared/96c1/rtl/alu.sv" \
"../../../bd/axi_verifier/ipshared/96c1/rtl/alu_div.sv" \
"../../../bd/axi_verifier/ipshared/96c1/rtl/cluster_clock_gating.sv" \
"../../../bd/axi_verifier/ipshared/96c1/rtl/compressed_decoder.sv" \
"../../../bd/axi_verifier/ipshared/96c1/rtl/controller.sv" \
"../../../bd/axi_verifier/ipshared/96c1/rtl/cs_registers.sv" \
"../../../bd/axi_verifier/ipshared/96c1/rtl/debug_unit.sv" \
"../../../bd/axi_verifier/ipshared/96c1/rtl/decoder.sv" \
"../../../bd/axi_verifier/ipshared/96c1/rtl/ex_stage.sv" \
"../../../bd/axi_verifier/ipshared/96c1/rtl/exc_controller.sv" \
"../../../bd/axi_verifier/ipshared/96c1/rtl/hwloop_controller.sv" \
"../../../bd/axi_verifier/ipshared/96c1/rtl/hwloop_regs.sv" \
"../../../bd/axi_verifier/ipshared/96c1/rtl/id_stage.sv" \
"../../../bd/axi_verifier/ipshared/96c1/rtl/if_stage.sv" \
"../../../bd/axi_verifier/ipshared/96c1/rtl/load_store_unit.sv" \
"../../../bd/axi_verifier/ipshared/96c1/rtl/mult.sv" \
"../../../bd/axi_verifier/ipshared/96c1/rtl/prefetch_buffer.sv" \
"../../../bd/axi_verifier/ipshared/96c1/rtl/register_file_ff.sv" \
"../../../bd/axi_verifier/ipshared/96c1/include/riscv_config.sv" \
"../../../bd/axi_verifier/ipshared/96c1/rtl/riscv_core.sv" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../bd/axi_verifier/ipshared/96c1/include" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/verilog" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/96c1/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../bd/axi_verifier/ipshared/96c1/include" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/verilog" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/96c1/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../bd/axi_verifier/ipshared/96c1/rtl/godai_wrapper.v" \
"../../../bd/axi_verifier/ip/axi_verifier_Godai_0_0/sim/axi_verifier_Godai_0_0.v" \

vlog -work axi_infrastructure_v1_1_0  -v2k5 "+incdir+../../../bd/axi_verifier/ipshared/96c1/include" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/verilog" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/96c1/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../bd/axi_verifier/ipshared/96c1/include" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/verilog" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/96c1/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work smartconnect_v1_0  -sv2k12 "+incdir+../../../bd/axi_verifier/ipshared/96c1/include" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/verilog" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/96c1/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../bd/axi_verifier/ipshared/96c1/include" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/verilog" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/96c1/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/sc_util_v1_0_vl_rfs.sv" \

vlog -work axi_protocol_checker_v2_0_3  -sv2k12 "+incdir+../../../bd/axi_verifier/ipshared/96c1/include" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/verilog" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/96c1/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../bd/axi_verifier/ipshared/96c1/include" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/verilog" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/96c1/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/03a9/hdl/axi_protocol_checker_v2_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../bd/axi_verifier/ipshared/96c1/include" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/verilog" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/96c1/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../bd/axi_verifier/ipshared/96c1/include" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/verilog" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/96c1/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../bd/axi_verifier/ip/axi_verifier_axi_vip_0_0/sim/axi_verifier_axi_vip_0_0_pkg.sv" \

vlog -work axi_vip_v1_1_3  -sv2k12 "+incdir+../../../bd/axi_verifier/ipshared/96c1/include" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/verilog" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/96c1/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../bd/axi_verifier/ipshared/96c1/include" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/verilog" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/96c1/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/b9a8/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../bd/axi_verifier/ipshared/96c1/include" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/verilog" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/96c1/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../bd/axi_verifier/ipshared/96c1/include" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/verilog" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/96c1/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../bd/axi_verifier/ip/axi_verifier_axi_vip_0_0/sim/axi_verifier_axi_vip_0_0.sv" \
"../../../bd/axi_verifier/ip/axi_verifier_axi_vip_1_0/sim/axi_verifier_axi_vip_1_0_pkg.sv" \
"../../../bd/axi_verifier/ip/axi_verifier_axi_vip_1_0/sim/axi_verifier_axi_vip_1_0.sv" \

vcom -work lib_cdc_v1_0_2 -93 \
"../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_12 -93 \
"../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/f86a/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/axi_verifier/ip/axi_verifier_proc_sys_reset_0_0/sim/axi_verifier_proc_sys_reset_0_0.vhd" \

vlog -work xlconstant_v1_1_5  -v2k5 "+incdir+../../../bd/axi_verifier/ipshared/96c1/include" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/verilog" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/96c1/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../bd/axi_verifier/ipshared/96c1/include" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/verilog" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/96c1/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/f1c3/hdl/xlconstant_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../bd/axi_verifier/ipshared/96c1/include" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/verilog" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/96c1/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" "+incdir+../../../bd/axi_verifier/ipshared/96c1/include" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/verilog" "+incdir+../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/96c1/include" "+incdir+/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/include" \
"../../../bd/axi_verifier/ip/axi_verifier_xlconstant_0_0/sim/axi_verifier_xlconstant_0_0.v" \
"../../../bd/axi_verifier/ip/axi_verifier_xlconstant_1_0/sim/axi_verifier_xlconstant_1_0.v" \
"../../../bd/axi_verifier/ip/axi_verifier_xlconstant_2_0/sim/axi_verifier_xlconstant_2_0.v" \
"../../../bd/axi_verifier/sim/axi_verifier.v" \

vlog -work xil_defaultlib \
"glbl.v"

