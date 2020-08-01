onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib r40_opt

do {wave.do}

view wave
view structure
view signals

do {r40.udo}

run -all

quit -force
