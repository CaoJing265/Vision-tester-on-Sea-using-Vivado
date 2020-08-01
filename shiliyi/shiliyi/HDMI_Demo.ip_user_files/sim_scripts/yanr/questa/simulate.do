onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib yanr_opt

do {wave.do}

view wave
view structure
view signals

do {yanr.udo}

run -all

quit -force
