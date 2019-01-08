# Get the directory where this script resides
set thisDir 	[file dirname [info script]]
set workDir 	[file join $thisDir .. work]
set godaiCIP	[file join $thisDir .. Godai cip]
set gouramCIP 	[file join $thisDir .. Gouram cip]
set core2AXICIP	[file join $thisDir .. core2axi cip]

set simOnlyFiles {}
lappend simOnlyFiles [file join $thisDir .. tb axi_verifier axi_verifier_testbench.sv]
lappend simOnlyFiles [file join $thisDir .. wcfg axi_verifier_config.wcfg]

# Create project 
create_project -part xc7vx485tffg1761-2  -force Kuuga [file join $workDir]

# Add in the locations of pieces of custom IP 
set_property ip_repo_paths "$godaiCIP $gouramCIP $core2AXICIP" [current_fileset]
update_ip_catalog

add_files -fileset sim_1 $simOnlyFiles
set_property top axi_verifier_testbench [get_filesets sim_1]

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Set project properties
set obj [get_projects Kuuga]
set_property "board_part" "xilinx.com:vc707:part0:1.0" $obj
set_property "simulator_language" "Mixed" $obj
set_property "target_language" "Verilog" $obj

# Add in the new Block Diagrams
source [file join $thisDir block_diagrams axi_verifier.tcl]
