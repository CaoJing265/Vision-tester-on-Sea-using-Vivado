onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib l40_opt

do {wave.do}

view wave
view structure
view signals

do {l40.udo}

run -all

quit -force
