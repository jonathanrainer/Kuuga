-makelib xcelium_lib/xilinx_vip -sv \
  "/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
  "/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
  "/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
  "/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
  "/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
  "/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
  "/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
  "/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
  "/opt/Xilinx/Vivado/2018.2/data/xilinx_vip/hdl/rst_vip_if.sv" \
-endlib
-makelib xcelium_lib/xil_defaultlib -sv \
  "/opt/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
  "/opt/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
  "/opt/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "/opt/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib -sv \
  "../../../bd/axi_verifier/ipshared/511c/rtl/core2axi.sv" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/axi_verifier/ipshared/511c/rtl/core2axi_wrapper.v" \
  "../../../bd/axi_verifier/ip/axi_verifier_Core2AXI_0_0/sim/axi_verifier_Core2AXI_0_0.v" \
  "../../../bd/axi_verifier/ip/axi_verifier_Core2AXI_1_0/sim/axi_verifier_Core2AXI_1_0.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib -sv \
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
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/axi_verifier/ipshared/96c1/rtl/godai_wrapper.v" \
  "../../../bd/axi_verifier/ip/axi_verifier_Godai_0_0/sim/axi_verifier_Godai_0_0.v" \
-endlib
-makelib xcelium_lib/axi_infrastructure_v1_1_0 \
  "../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/smartconnect_v1_0 -sv \
  "../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/5bb9/hdl/sc_util_v1_0_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/axi_protocol_checker_v2_0_3 -sv \
  "../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/03a9/hdl/axi_protocol_checker_v2_0_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/xil_defaultlib -sv \
  "../../../bd/axi_verifier/ip/axi_verifier_axi_vip_0_0/sim/axi_verifier_axi_vip_0_0_pkg.sv" \
-endlib
-makelib xcelium_lib/axi_vip_v1_1_3 -sv \
  "../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/b9a8/hdl/axi_vip_v1_1_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/xil_defaultlib -sv \
  "../../../bd/axi_verifier/ip/axi_verifier_axi_vip_0_0/sim/axi_verifier_axi_vip_0_0.sv" \
  "../../../bd/axi_verifier/ip/axi_verifier_axi_vip_1_0/sim/axi_verifier_axi_vip_1_0_pkg.sv" \
  "../../../bd/axi_verifier/ip/axi_verifier_axi_vip_1_0/sim/axi_verifier_axi_vip_1_0.sv" \
-endlib
-makelib xcelium_lib/lib_cdc_v1_0_2 \
  "../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/proc_sys_reset_v5_0_12 \
  "../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/f86a/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/axi_verifier/ip/axi_verifier_proc_sys_reset_0_0/sim/axi_verifier_proc_sys_reset_0_0.vhd" \
-endlib
-makelib xcelium_lib/xlconstant_v1_1_5 \
  "../../../../Kuuga.srcs/sources_1/bd/axi_verifier/ipshared/f1c3/hdl/xlconstant_v1_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/axi_verifier/ip/axi_verifier_xlconstant_0_0/sim/axi_verifier_xlconstant_0_0.v" \
  "../../../bd/axi_verifier/ip/axi_verifier_xlconstant_1_0/sim/axi_verifier_xlconstant_1_0.v" \
  "../../../bd/axi_verifier/ip/axi_verifier_xlconstant_2_0/sim/axi_verifier_xlconstant_2_0.v" \
  "../../../bd/axi_verifier/sim/axi_verifier.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

