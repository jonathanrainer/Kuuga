onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+axi_verifier -L xilinx_vip -L xil_defaultlib -L xpm -L axi_infrastructure_v1_1_0 -L smartconnect_v1_0 -L axi_protocol_checker_v2_0_3 -L axi_vip_v1_1_3 -L lib_cdc_v1_0_2 -L proc_sys_reset_v5_0_12 -L xlconstant_v1_1_5 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.axi_verifier xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {axi_verifier.udo}

run -all

endsim

quit -force
