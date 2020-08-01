onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib l41_opt

do {wave.do}

view wave
view structure
view signals

do {l41.udo}

run -all

quit -force
