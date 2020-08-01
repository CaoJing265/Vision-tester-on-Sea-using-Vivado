onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib yanl_opt

do {wave.do}

view wave
view structure
view signals

do {yanl.udo}

run -all

quit -force
