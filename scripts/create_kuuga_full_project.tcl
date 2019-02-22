# Get the directory where this script resides
set thisDir 	[file dirname [info script]]
set workDir 	[file join $thisDir .. work]
set godaiDir	[file join $thisDir .. Godai]
set gouramDir 	[file join $thisDir .. Gouram]
set core2AXIDir	[file join $thisDir .. core2axi]

set projectName Kuuga

source [file join $godaiDir scripts godai_manifest.tcl]
source [file join $gouramDir scripts gouram_manifest.tcl]
source [file join $core2AXIDir scripts core2axi_manifest.tcl]

set RTLFileListNames [concat [list $core2AXIRTLFiles $core2AXIDir] [list $GodaiRTLFiles $godaiDir] [list $GouramRTLFiles $gouramDir]]
set IncludeFileListNames [concat [list $GodaiIncludeFiles $godaiDir] [list $GouramIncludeFiles $gouramDir]]

set rtlFilesFull {}
set includeFilesFull {}

foreach {ls dir} $RTLFileListNames {
	foreach f $ls {
		lappend rtlFilesFull [file join $dir rtl $f]
	} 
}

foreach {ls dir} $IncludeFileListNames {
	foreach f $ls {
		lappend includeFilesFull [file join $dir include $f]
	} 
}

# Create project 
create_project -part xc7vx485tffg1761-2  -force $projectName [file join $workDir]

add_files -fileset sources_1 [file join $thisDir .. rtl kuuga_top.v]
add_files -fileset sources_1 [file join $thisDir .. mem test_data.mem]
add_files -norecurse $rtlFilesFull
add_files -norecurse $includeFilesFull
set_property top kuuga_ila_top [get_filesets sources_1]

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Set project properties
set obj [get_projects $projectName]
set_property "board_part" "xilinx.com:vc707:part0:1.0" $obj
set_property "simulator_language" "Mixed" $obj
set_property "target_language" "Verilog" $obj

source [file join $thisDir block_diagrams kuuga_full_system.tcl]
