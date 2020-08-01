onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib r53_opt

do {wave.do}

view wave
view structure
view signals

do {r53.udo}

run -all

quit -force
