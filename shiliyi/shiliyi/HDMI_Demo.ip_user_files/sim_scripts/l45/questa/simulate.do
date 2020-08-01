onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib l45_opt

do {wave.do}

view wave
view structure
view signals

do {l45.udo}

run -all

quit -force
