# Set up script variables
set thisDir 	[file dirname [info script]]
set kuugaRoot   [file join $thisDir .. ..]
set instContents [file join $kuugaRoot mem test_data.mem]
set finalBitfile [file join $kuugaRoot bitfiles final.bit]
set loggingLocation [file join $kuugaRoot mem updatemem_debug.txt]

# Create the baseline bit file & probes file and write them out to a known location
set raw_bit_file [file join $kuugaRoot bitfiles raw.bit]
set raw_probes_file [file join $kuugaRoot debug probes.ltx]
set raw_mmi [file join $kuugaRoot mem layout.mmi]
open_run impl_1
write_bitstream -force $raw_bit_file
write_debug_probes -force $raw_probes_file
write_mem_info -force $raw_mmi

# Program the Device & Extract the Triggers to a file
open_hw
disconnect_hw_server -quiet
connect_hw_server -url localhost:12345
current_hw_target [get_hw_targets */xilinx_tcf/Digilent/000000007071A]
set_property PARAM.FREQUENCY 3750000 [get_hw_targets */xilinx_tcf/Digilent/000000007071A]
open_hw_target
set_property PROBES.FILE $raw_probes_file [get_hw_devices xc7vx485t_0]
set_property FULL_PROBES.FILE $raw_probes_file [get_hw_devices xc7vx485t_0]
set_property PROGRAM.FILE $raw_bit_file [get_hw_devices xc7vx485t_0]
program_hw_devices [get_hw_devices xc7vx485t_0]
refresh_hw_device [lindex [get_hw_devices xc7vx485t_0] 0]
set ilaTriggers [file join $kuugaRoot debug ila_triggers.tas]
run_hw_ila -force -file $ilaTriggers [get_hw_ilas hw_ila_1]

# Add triggers into the design
current_design impl_1
refresh_design
apply_hw_ila_trigger $ilaTriggers
set triggersBitfile [file join $kuugaRoot bitfiles triggers.bit]
write_bitstream -force $triggersBitfile

# Run updatemem with mem files from params
exec updatemem -debug -force -meminfo $raw_mmi -data $instContents -bit $triggersBitfile -proc xpm_inst_mem/xpm_memory_base_inst -out $finalBitfile > $loggingLocation
