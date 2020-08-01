onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib r45_opt

do {wave.do}

view wave
view structure
view signals

do {r45.udo}

run -all

quit -force
