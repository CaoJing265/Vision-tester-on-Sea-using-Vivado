onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib l46_opt

do {wave.do}

view wave
view structure
view signals

do {l46.udo}

run -all

quit -force
