
################################################################
# This is a generated script based on design: kuuga_ila_ext_memory
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2018.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source kuuga_ila_ext_memory_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# core2axi_wrapper, core2axi_wrapper, godai_wrapper, gouram_wrapper

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7vx485tffg1761-2
   set_property BOARD_PART xilinx.com:vc707:part0:1.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name kuuga_ila_ext_memory

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_bram_ctrl:4.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:system_ila:1.1\
xilinx.com:ip:xlconstant:1.1\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
core2axi_wrapper\
core2axi_wrapper\
godai_wrapper\
gouram_wrapper\
"

   set list_mods_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_msg_id "BD_TCL-008" "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set sys_diff_clock [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_diff_clock ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
   ] $sys_diff_clock

  # Create ports
  set data_bram_addr_a [ create_bd_port -dir O -from 15 -to 0 data_bram_addr_a ]
  set data_bram_clk_a [ create_bd_port -dir O -type clk data_bram_clk_a ]
  set data_bram_en_a [ create_bd_port -dir O data_bram_en_a ]
  set data_bram_rddata_a [ create_bd_port -dir I -from 31 -to 0 data_bram_rddata_a ]
  set data_bram_rst_a [ create_bd_port -dir O -type rst data_bram_rst_a ]
  set data_bram_we_a [ create_bd_port -dir O -from 3 -to 0 data_bram_we_a ]
  set data_bram_wrdata_a [ create_bd_port -dir O -from 31 -to 0 data_bram_wrdata_a ]
  set inst_bram_addr_a [ create_bd_port -dir O -from 15 -to 0 inst_bram_addr_a ]
  set inst_bram_clk_a [ create_bd_port -dir O -type clk inst_bram_clk_a ]
  set inst_bram_en_a [ create_bd_port -dir O inst_bram_en_a ]
  set inst_bram_rddata_a [ create_bd_port -dir I -from 31 -to 0 inst_bram_rddata_a ]
  set inst_bram_rst_a [ create_bd_port -dir O -type rst inst_bram_rst_a ]
  set inst_bram_we_a [ create_bd_port -dir O -from 3 -to 0 inst_bram_we_a ]
  set inst_bram_wrdata_a [ create_bd_port -dir O -from 31 -to 0 inst_bram_wrdata_a ]
  set reset [ create_bd_port -dir I -type rst reset ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset

  # Create instance: Core2AXI_Data, and set properties
  set block_name core2axi_wrapper
  set block_cell_name Core2AXI_Data
  if { [catch {set Core2AXI_Data [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $Core2AXI_Data eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.C_M_AXI_ADDR_WIDTH {16} \
 ] $Core2AXI_Data

  # Create instance: Core2AXI_Instruction, and set properties
  set block_name core2axi_wrapper
  set block_cell_name Core2AXI_Instruction
  if { [catch {set Core2AXI_Instruction [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $Core2AXI_Instruction eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.C_M_AXI_ADDR_WIDTH {16} \
 ] $Core2AXI_Instruction

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctrl_0 ]
  set_property -dict [ list \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_0

  # Create instance: axi_bram_ctrl_1, and set properties
  set axi_bram_ctrl_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctrl_1 ]
  set_property -dict [ list \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_1

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_JITTER {178.053} \
   CONFIG.CLKOUT1_PHASE_ERROR {89.971} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {10} \
   CONFIG.CLKOUT2_JITTER {112.316} \
   CONFIG.CLKOUT2_PHASE_ERROR {89.971} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {100} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLK_IN1_BOARD_INTERFACE {sys_diff_clock} \
   CONFIG.ENABLE_CLOCK_MONITOR {false} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {5.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {100.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {10} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {2} \
   CONFIG.PRIMITIVE {MMCM} \
   CONFIG.RESET_BOARD_INTERFACE {reset} \
   CONFIG.USE_BOARD_FLOW {true} \
   CONFIG.USE_LOCKED {false} \
 ] $clk_wiz_0

  # Create instance: godai_wrapper_0, and set properties
  set block_name godai_wrapper
  set block_cell_name godai_wrapper_0
  if { [catch {set godai_wrapper_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $godai_wrapper_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.DATA_ADDR_WIDTH {16} \
   CONFIG.INSTR_ADDR_WIDTH {16} \
 ] $godai_wrapper_0

  # Create instance: gouram_wrapper_0, and set properties
  set block_name gouram_wrapper
  set block_cell_name gouram_wrapper_0
  if { [catch {set gouram_wrapper_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $gouram_wrapper_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]
  set_property -dict [ list \
   CONFIG.RESET_BOARD_INTERFACE {reset} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $proc_sys_reset_0

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.ALL_PROBE_SAME_MU_CNT {2} \
   CONFIG.C_ADV_TRIGGER {true} \
   CONFIG.C_BRAM_CNT {394} \
   CONFIG.C_DATA_DEPTH {32768} \
   CONFIG.C_EN_STRG_QUAL {1} \
   CONFIG.C_INPUT_PIPE_STAGES {2} \
   CONFIG.C_MON_TYPE {NATIVE} \
   CONFIG.C_NUM_MONITOR_SLOTS {1} \
   CONFIG.C_NUM_OF_PROBES {30} \
   CONFIG.C_PROBE0_MU_CNT {2} \
   CONFIG.C_PROBE10_MU_CNT {2} \
   CONFIG.C_PROBE10_WIDTH {4} \
   CONFIG.C_PROBE11_MU_CNT {2} \
   CONFIG.C_PROBE11_WIDTH {32} \
   CONFIG.C_PROBE12_MU_CNT {2} \
   CONFIG.C_PROBE12_WIDTH {128} \
   CONFIG.C_PROBE13_MU_CNT {2} \
   CONFIG.C_PROBE13_WIDTH {1} \
   CONFIG.C_PROBE14_MU_CNT {2} \
   CONFIG.C_PROBE15_MU_CNT {2} \
   CONFIG.C_PROBE15_WIDTH {32} \
   CONFIG.C_PROBE16_MU_CNT {2} \
   CONFIG.C_PROBE17_MU_CNT {2} \
   CONFIG.C_PROBE18_MU_CNT {2} \
   CONFIG.C_PROBE18_WIDTH {4} \
   CONFIG.C_PROBE19_MU_CNT {2} \
   CONFIG.C_PROBE19_WIDTH {16} \
   CONFIG.C_PROBE1_MU_CNT {2} \
   CONFIG.C_PROBE1_WIDTH {16} \
   CONFIG.C_PROBE20_MU_CNT {2} \
   CONFIG.C_PROBE21_MU_CNT {2} \
   CONFIG.C_PROBE21_WIDTH {32} \
   CONFIG.C_PROBE22_MU_CNT {2} \
   CONFIG.C_PROBE22_WIDTH {16} \
   CONFIG.C_PROBE23_MU_CNT {2} \
   CONFIG.C_PROBE24_MU_CNT {2} \
   CONFIG.C_PROBE24_WIDTH {32} \
   CONFIG.C_PROBE25_MU_CNT {2} \
   CONFIG.C_PROBE25_WIDTH {32} \
   CONFIG.C_PROBE26_MU_CNT {2} \
   CONFIG.C_PROBE27_MU_CNT {2} \
   CONFIG.C_PROBE28_MU_CNT {2} \
   CONFIG.C_PROBE28_WIDTH {4} \
   CONFIG.C_PROBE29_MU_CNT {2} \
   CONFIG.C_PROBE2_MU_CNT {2} \
   CONFIG.C_PROBE3_MU_CNT {2} \
   CONFIG.C_PROBE3_WIDTH {32} \
   CONFIG.C_PROBE4_MU_CNT {2} \
   CONFIG.C_PROBE5_MU_CNT {2} \
   CONFIG.C_PROBE5_WIDTH {16} \
   CONFIG.C_PROBE6_MU_CNT {2} \
   CONFIG.C_PROBE7_MU_CNT {2} \
   CONFIG.C_PROBE7_WIDTH {32} \
   CONFIG.C_PROBE8_MU_CNT {2} \
   CONFIG.C_PROBE9_MU_CNT {2} \
   CONFIG.C_PROBE_WIDTH_PROPAGATION {MANUAL} \
   CONFIG.C_SLOT {0} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:bram_rtl:1.0} \
 ] $system_ila_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {4} \
 ] $xlconstant_1

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_2

  # Create interface connections
  connect_bd_intf_net -intf_net Core2AXI_Instruction_M_AXI [get_bd_intf_pins Core2AXI_Instruction/M_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
  connect_bd_intf_net -intf_net core2axi_wrapper_0_M_AXI [get_bd_intf_pins Core2AXI_Data/M_AXI] [get_bd_intf_pins axi_bram_ctrl_1/S_AXI]
  connect_bd_intf_net -intf_net sys_diff_clock_1 [get_bd_intf_ports sys_diff_clock] [get_bd_intf_pins clk_wiz_0/CLK_IN1_D]

  # Create port connections
  connect_bd_net -net Core2AXI_0_data_gnt_o [get_bd_pins Core2AXI_Instruction/data_gnt_o] [get_bd_pins godai_wrapper_0/instr_gnt_i] [get_bd_pins system_ila_0/probe2]
  connect_bd_net -net Core2AXI_0_data_gnt_o1 [get_bd_pins Core2AXI_Data/data_gnt_o] [get_bd_pins godai_wrapper_0/data_gnt_i] [get_bd_pins system_ila_0/probe13]
  connect_bd_net -net Core2AXI_0_data_rdata_o [get_bd_pins Core2AXI_Instruction/data_rdata_o] [get_bd_pins godai_wrapper_0/instr_rdata_i] [get_bd_pins gouram_wrapper_0/instr_rdata] [get_bd_pins system_ila_0/probe3]
  connect_bd_net -net Core2AXI_0_data_rdata_o1 [get_bd_pins Core2AXI_Data/data_rdata_o] [get_bd_pins godai_wrapper_0/data_rdata_i] [get_bd_pins system_ila_0/probe15]
  connect_bd_net -net Core2AXI_0_data_rvalid_o [get_bd_pins Core2AXI_Instruction/data_rvalid_o] [get_bd_pins godai_wrapper_0/instr_rvalid_i] [get_bd_pins gouram_wrapper_0/instr_rvalid] [get_bd_pins system_ila_0/probe4]
  connect_bd_net -net Core2AXI_0_data_rvalid_o1 [get_bd_pins Core2AXI_Data/data_rvalid_o] [get_bd_pins godai_wrapper_0/data_rvalid_i] [get_bd_pins gouram_wrapper_0/data_mem_rvalid] [get_bd_pins system_ila_0/probe14]
  connect_bd_net -net Godai_0_data_addr_o [get_bd_pins Core2AXI_Data/data_addr_i] [get_bd_pins godai_wrapper_0/data_addr_o] [get_bd_pins gouram_wrapper_0/data_mem_addr] [get_bd_pins system_ila_0/probe19]
  connect_bd_net -net Godai_0_data_be_o [get_bd_pins Core2AXI_Data/data_be_i] [get_bd_pins godai_wrapper_0/data_be_o] [get_bd_pins system_ila_0/probe18]
  connect_bd_net -net Godai_0_data_req_o [get_bd_pins Core2AXI_Data/data_req_i] [get_bd_pins godai_wrapper_0/data_req_o] [get_bd_pins gouram_wrapper_0/data_mem_req] [get_bd_pins system_ila_0/probe16]
  connect_bd_net -net Godai_0_data_wdata_o [get_bd_pins Core2AXI_Data/data_wdata_i] [get_bd_pins godai_wrapper_0/data_wdata_o] [get_bd_pins system_ila_0/probe21]
  connect_bd_net -net Godai_0_data_we_o [get_bd_pins Core2AXI_Data/data_we_i] [get_bd_pins godai_wrapper_0/data_we_o] [get_bd_pins system_ila_0/probe17]
  connect_bd_net -net Godai_0_instr_addr_o [get_bd_pins Core2AXI_Instruction/data_addr_i] [get_bd_pins godai_wrapper_0/instr_addr_o] [get_bd_pins system_ila_0/probe1]
  connect_bd_net -net Godai_0_instr_req_o [get_bd_pins Core2AXI_Instruction/data_req_i] [get_bd_pins godai_wrapper_0/instr_req_o] [get_bd_pins system_ila_0/probe0]
  connect_bd_net -net Godai_0_jump_done_o [get_bd_pins godai_wrapper_0/jump_done_o] [get_bd_pins gouram_wrapper_0/jump_done] [get_bd_pins system_ila_0/probe20]
  connect_bd_net -net axi_bram_ctrl_0_bram_addr_a [get_bd_ports inst_bram_addr_a] [get_bd_pins axi_bram_ctrl_0/bram_addr_a] [get_bd_pins system_ila_0/probe5]
  connect_bd_net -net axi_bram_ctrl_0_bram_clk_a [get_bd_ports inst_bram_clk_a] [get_bd_pins axi_bram_ctrl_0/bram_clk_a] [get_bd_pins system_ila_0/probe6]
  connect_bd_net -net axi_bram_ctrl_0_bram_en_a [get_bd_ports inst_bram_en_a] [get_bd_pins axi_bram_ctrl_0/bram_en_a] [get_bd_pins system_ila_0/probe8]
  connect_bd_net -net axi_bram_ctrl_0_bram_rst_a [get_bd_ports inst_bram_rst_a] [get_bd_pins axi_bram_ctrl_0/bram_rst_a] [get_bd_pins system_ila_0/probe9]
  connect_bd_net -net axi_bram_ctrl_0_bram_we_a [get_bd_ports inst_bram_we_a] [get_bd_pins axi_bram_ctrl_0/bram_we_a] [get_bd_pins system_ila_0/probe10]
  connect_bd_net -net axi_bram_ctrl_0_bram_wrdata_a [get_bd_ports inst_bram_wrdata_a] [get_bd_pins axi_bram_ctrl_0/bram_wrdata_a] [get_bd_pins system_ila_0/probe7]
  connect_bd_net -net axi_bram_ctrl_1_bram_addr_a [get_bd_ports data_bram_addr_a] [get_bd_pins axi_bram_ctrl_1/bram_addr_a] [get_bd_pins system_ila_0/probe22]
  connect_bd_net -net axi_bram_ctrl_1_bram_clk_a [get_bd_ports data_bram_clk_a] [get_bd_pins axi_bram_ctrl_1/bram_clk_a] [get_bd_pins system_ila_0/probe23]
  connect_bd_net -net axi_bram_ctrl_1_bram_en_a [get_bd_ports data_bram_en_a] [get_bd_pins axi_bram_ctrl_1/bram_en_a] [get_bd_pins system_ila_0/probe26]
  connect_bd_net -net axi_bram_ctrl_1_bram_rst_a [get_bd_ports data_bram_rst_a] [get_bd_pins axi_bram_ctrl_1/bram_rst_a] [get_bd_pins system_ila_0/probe27]
  connect_bd_net -net axi_bram_ctrl_1_bram_we_a [get_bd_ports data_bram_we_a] [get_bd_pins axi_bram_ctrl_1/bram_we_a] [get_bd_pins system_ila_0/probe28]
  connect_bd_net -net axi_bram_ctrl_1_bram_wrdata_a [get_bd_ports data_bram_wrdata_a] [get_bd_pins axi_bram_ctrl_1/bram_wrdata_a] [get_bd_pins system_ila_0/probe24]
  connect_bd_net -net bram_rddata_a_0_1 [get_bd_ports data_bram_rddata_a] [get_bd_pins axi_bram_ctrl_1/bram_rddata_a] [get_bd_pins system_ila_0/probe25]
  connect_bd_net -net bram_rddata_a_0_2 [get_bd_ports inst_bram_rddata_a] [get_bd_pins axi_bram_ctrl_0/bram_rddata_a] [get_bd_pins system_ila_0/probe11]
  connect_bd_net -net clk_100MHz_1 [get_bd_pins Core2AXI_Data/M_AXI_ACLK] [get_bd_pins Core2AXI_Instruction/M_AXI_ACLK] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins axi_bram_ctrl_1/s_axi_aclk] [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins godai_wrapper_0/clk] [get_bd_pins gouram_wrapper_0/clk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins system_ila_0/probe29]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins system_ila_0/clk]
  connect_bd_net -net gouram_wrapper_0_trace_data_o [get_bd_pins gouram_wrapper_0/trace_data_o] [get_bd_pins system_ila_0/probe12]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins Core2AXI_Data/M_AXI_ARESETN] [get_bd_pins Core2AXI_Instruction/M_AXI_ARESETN] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins axi_bram_ctrl_1/s_axi_aresetn] [get_bd_pins godai_wrapper_0/rst_n] [get_bd_pins gouram_wrapper_0/rst_n] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
  connect_bd_net -net reset_1 [get_bd_ports reset] [get_bd_pins clk_wiz_0/reset] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins Core2AXI_Instruction/data_we_i] [get_bd_pins godai_wrapper_0/data_err_i] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins Core2AXI_Instruction/data_be_i] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins Core2AXI_Instruction/data_wdata_i] [get_bd_pins godai_wrapper_0/irq_i] [get_bd_pins xlconstant_2/dout]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [get_bd_addr_spaces Core2AXI_Data/M_AXI] [get_bd_addr_segs axi_bram_ctrl_1/S_AXI/Mem0] SEG_axi_bram_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [get_bd_addr_spaces Core2AXI_Instruction/M_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] SEG_axi_bram_ctrl_0_Mem0


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


