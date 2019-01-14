
################################################################
# This is a generated script based on design: axi_verifier
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
# source axi_verifier_script.tcl

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
set design_name axi_verifier

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
jonathan-rainer.com:Kuuga:Core2AXI:1.2\
jonathan-rainer.com:Kuuga:Godai:1.0\
jonathan-rainer.com:Kuuga:Gouram:1.1\
xilinx.com:ip:axi_vip:1.1\
xilinx.com:ip:proc_sys_reset:5.0\
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

  # Create ports
  set clk_100MHz [ create_bd_port -dir I -type clk clk_100MHz ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
 ] $clk_100MHz
  set reset_rtl [ create_bd_port -dir I -type rst reset_rtl ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $reset_rtl
  set trace_out [ create_bd_port -dir O -from 608 -to 0 -type data trace_out ]

  # Create instance: Core2AXI_Data, and set properties
  set Core2AXI_Data [ create_bd_cell -type ip -vlnv jonathan-rainer.com:Kuuga:Core2AXI:1.2 Core2AXI_Data ]

  # Create instance: Core2AXI_Inst, and set properties
  set Core2AXI_Inst [ create_bd_cell -type ip -vlnv jonathan-rainer.com:Kuuga:Core2AXI:1.2 Core2AXI_Inst ]

  # Create instance: Godai_0, and set properties
  set Godai_0 [ create_bd_cell -type ip -vlnv jonathan-rainer.com:Kuuga:Godai:1.0 Godai_0 ]

  # Create instance: Gouram_0, and set properties
  set Gouram_0 [ create_bd_cell -type ip -vlnv jonathan-rainer.com:Kuuga:Gouram:1.1 Gouram_0 ]

  # Create instance: axi_vip_0, and set properties
  set axi_vip_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_0 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_0

  # Create instance: axi_vip_1, and set properties
  set axi_vip_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_1 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_1

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]
  set_property -dict [ list \
   CONFIG.RESET_BOARD_INTERFACE {Custom} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $proc_sys_reset_0

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
  connect_bd_intf_net -intf_net Core2AXI_0_M_AXI [get_bd_intf_pins Core2AXI_Inst/M_AXI] [get_bd_intf_pins axi_vip_0/S_AXI]
  connect_bd_intf_net -intf_net Core2AXI_1_M_AXI [get_bd_intf_pins Core2AXI_Data/M_AXI] [get_bd_intf_pins axi_vip_1/S_AXI]

  # Create port connections
  connect_bd_net -net Core2AXI_0_data_gnt_o [get_bd_pins Core2AXI_Inst/data_gnt_o] [get_bd_pins Godai_0/instr_gnt_i] [get_bd_pins Gouram_0/instr_grant]
  connect_bd_net -net Core2AXI_0_data_rdata_o [get_bd_pins Core2AXI_Inst/data_rdata_o] [get_bd_pins Godai_0/instr_rdata_i] [get_bd_pins Gouram_0/instr_rdata]
  connect_bd_net -net Core2AXI_0_data_rvalid_o [get_bd_pins Core2AXI_Inst/data_rvalid_o] [get_bd_pins Godai_0/instr_rvalid_i] [get_bd_pins Gouram_0/instr_rvalid]
  connect_bd_net -net Core2AXI_1_data_gnt_o [get_bd_pins Core2AXI_Data/data_gnt_o] [get_bd_pins Godai_0/data_gnt_i] [get_bd_pins Gouram_0/data_mem_grant]
  connect_bd_net -net Core2AXI_1_data_rdata_o [get_bd_pins Core2AXI_Data/data_rdata_o] [get_bd_pins Godai_0/data_rdata_i]
  connect_bd_net -net Core2AXI_1_data_rvalid_o [get_bd_pins Core2AXI_Data/data_rvalid_o] [get_bd_pins Godai_0/data_rvalid_i] [get_bd_pins Gouram_0/data_mem_rvalid]
  connect_bd_net -net Godai_0_branch_decision_o [get_bd_pins Godai_0/branch_decision_o] [get_bd_pins Gouram_0/branch_decision]
  connect_bd_net -net Godai_0_branch_req_o [get_bd_pins Godai_0/branch_req_o] [get_bd_pins Gouram_0/branch_req]
  connect_bd_net -net Godai_0_data_addr_o [get_bd_pins Core2AXI_Data/data_addr_i] [get_bd_pins Godai_0/data_addr_o] [get_bd_pins Gouram_0/data_mem_addr]
  connect_bd_net -net Godai_0_data_be_o [get_bd_pins Core2AXI_Data/data_be_i] [get_bd_pins Godai_0/data_be_o]
  connect_bd_net -net Godai_0_data_req_o [get_bd_pins Core2AXI_Data/data_req_i] [get_bd_pins Godai_0/data_req_o] [get_bd_pins Gouram_0/data_mem_req]
  connect_bd_net -net Godai_0_data_wdata_o [get_bd_pins Core2AXI_Data/data_wdata_i] [get_bd_pins Godai_0/data_wdata_o]
  connect_bd_net -net Godai_0_data_we_o [get_bd_pins Core2AXI_Data/data_we_i] [get_bd_pins Godai_0/data_we_o]
  connect_bd_net -net Godai_0_ex_ready_o [get_bd_pins Godai_0/ex_ready_o] [get_bd_pins Gouram_0/ex_ready]
  connect_bd_net -net Godai_0_id_ready_o [get_bd_pins Godai_0/id_ready_o] [get_bd_pins Gouram_0/id_ready]
  connect_bd_net -net Godai_0_if_busy_o [get_bd_pins Godai_0/if_busy_o] [get_bd_pins Gouram_0/if_busy]
  connect_bd_net -net Godai_0_if_ready_o [get_bd_pins Godai_0/if_ready_o] [get_bd_pins Gouram_0/if_ready]
  connect_bd_net -net Godai_0_illegal_instr_o [get_bd_pins Godai_0/illegal_instr_o] [get_bd_pins Gouram_0/illegal_instruction]
  connect_bd_net -net Godai_0_instr_addr_o [get_bd_pins Core2AXI_Inst/data_addr_i] [get_bd_pins Godai_0/instr_addr_o] [get_bd_pins Gouram_0/instr_addr]
  connect_bd_net -net Godai_0_instr_req_o [get_bd_pins Core2AXI_Inst/data_req_i] [get_bd_pins Godai_0/instr_req_o] [get_bd_pins Gouram_0/instr_req]
  connect_bd_net -net Godai_0_is_decoding_o [get_bd_pins Godai_0/is_decoding_o] [get_bd_pins Gouram_0/is_decoding]
  connect_bd_net -net Godai_0_jump_done_o [get_bd_pins Godai_0/jump_done_o] [get_bd_pins Gouram_0/jump_done]
  connect_bd_net -net Godai_0_wb_ready_o [get_bd_pins Godai_0/wb_ready_o] [get_bd_pins Gouram_0/wb_ready]
  connect_bd_net -net Gouram_0_trace_data_o [get_bd_ports trace_out] [get_bd_pins Gouram_0/trace_data_o]
  connect_bd_net -net clk_100MHz_1 [get_bd_ports clk_100MHz] [get_bd_pins Core2AXI_Data/M_AXI_ACLK] [get_bd_pins Core2AXI_Inst/M_AXI_ACLK] [get_bd_pins Godai_0/clk] [get_bd_pins Gouram_0/clk] [get_bd_pins axi_vip_0/aclk] [get_bd_pins axi_vip_1/aclk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins Core2AXI_Data/M_AXI_ARESETN] [get_bd_pins Core2AXI_Inst/M_AXI_ARESETN] [get_bd_pins Godai_0/rst_n] [get_bd_pins Gouram_0/rst] [get_bd_pins axi_vip_0/aresetn] [get_bd_pins axi_vip_1/aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
  connect_bd_net -net reset_rtl_1 [get_bd_ports reset_rtl] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins Core2AXI_Inst/data_we_i] [get_bd_pins Godai_0/data_err_i] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins Core2AXI_Inst/data_be_i] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins Core2AXI_Inst/data_wdata_i] [get_bd_pins Godai_0/irq_i] [get_bd_pins xlconstant_2/dout]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [get_bd_addr_spaces Core2AXI_Data/M_AXI] [get_bd_addr_segs axi_vip_1/S_AXI/Reg] SEG_axi_vip_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [get_bd_addr_spaces Core2AXI_Inst/M_AXI] [get_bd_addr_segs axi_vip_0/S_AXI/Reg] SEG_axi_vip_0_Reg


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


