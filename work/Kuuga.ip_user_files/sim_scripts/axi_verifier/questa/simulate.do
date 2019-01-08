onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib axi_verifier_opt

do {wave.do}

view wave
view structure
view signals

do {axi_verifier.udo}

run -all

quit -force
