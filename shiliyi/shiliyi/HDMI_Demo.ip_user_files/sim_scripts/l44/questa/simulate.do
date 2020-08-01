onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib l44_opt

do {wave.do}

view wave
view structure
view signals

do {l44.udo}

run -all

quit -force
