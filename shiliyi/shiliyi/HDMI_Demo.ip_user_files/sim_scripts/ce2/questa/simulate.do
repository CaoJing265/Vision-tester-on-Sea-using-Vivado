onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib ce2_opt

do {wave.do}

view wave
view structure
view signals

do {ce2.udo}

run -all

quit -force
