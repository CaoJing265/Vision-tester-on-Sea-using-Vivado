onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib r41_opt

do {wave.do}

view wave
view structure
view signals

do {r41.udo}

run -all

quit -force
