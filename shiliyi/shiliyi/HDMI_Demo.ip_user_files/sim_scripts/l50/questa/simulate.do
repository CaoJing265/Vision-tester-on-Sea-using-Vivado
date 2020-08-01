onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib l50_opt

do {wave.do}

view wave
view structure
view signals

do {l50.udo}

run -all

quit -force
