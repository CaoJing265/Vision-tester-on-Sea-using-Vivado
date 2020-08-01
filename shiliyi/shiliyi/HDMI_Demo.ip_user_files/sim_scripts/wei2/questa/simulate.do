onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib wei2_opt

do {wave.do}

view wave
view structure
view signals

do {wei2.udo}

run -all

quit -force
