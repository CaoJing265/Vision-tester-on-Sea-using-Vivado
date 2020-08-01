onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib r51_opt

do {wave.do}

view wave
view structure
view signals

do {r51.udo}

run -all

quit -force
