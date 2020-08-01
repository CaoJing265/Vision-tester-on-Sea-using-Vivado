onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib r48_opt

do {wave.do}

view wave
view structure
view signals

do {r48.udo}

run -all

quit -force
