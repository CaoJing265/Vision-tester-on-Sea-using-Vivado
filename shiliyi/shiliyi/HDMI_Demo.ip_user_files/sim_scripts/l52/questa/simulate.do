onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib l52_opt

do {wave.do}

view wave
view structure
view signals

do {l52.udo}

run -all

quit -force
