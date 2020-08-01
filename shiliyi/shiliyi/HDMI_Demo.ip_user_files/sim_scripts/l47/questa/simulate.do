onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib l47_opt

do {wave.do}

view wave
view structure
view signals

do {l47.udo}

run -all

quit -force
