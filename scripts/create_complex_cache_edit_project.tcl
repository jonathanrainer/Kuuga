# Get the directory where this script resides
set thisDir 	[file dirname [info script]]
set workDir 	[file join $thisDir .. work]
set godaiDir	[file join $thisDir .. Godai]
set gouramDir 	[file join $thisDir .. Gouram]
set core2AXIDir	[file join $thisDir .. core2axi]

set projectName Kuuga_Complex_Cache

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

lappend rtlFilesFull [file join $thisDir .. rtl standard_cache.sv]
lappend rtlFilesFull [file join $thisDir .. rtl trace_assisted_cache.sv]
lappend includeFilesFull [file join $thisDir .. rtl trace_assisted_cache_config.sv]

set simOnlyFiles {}

# Create project 
create_project -part xc7vx485tffg1761-2  -force $projectName [file join $workDir]

#add_files -fileset sim_1 $simOnlyFiles
add_files -norecurse $rtlFilesFull
add_files -norecurse $includeFilesFull
#set_property top simple_cache_tb [get_filesets sim_1]

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Set project properties
set obj [get_projects $projectName]
set_property "board_part" "xilinx.com:vc707:part0:1.0" $obj
set_property "simulator_language" "Mixed" $obj
set_property "target_language" "Verilog" $obj

set block_design_name complex_cache_test

source [file join $thisDir block_diagrams $block_design_name.tcl]
make_wrapper -files [get_files $block_design_name.bd] -top -import
set_property top $block_design_name [get_filesets sources_1]
