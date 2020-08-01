onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib you_rom_opt

do {wave.do}

view wave
view structure
view signals

do {you_rom.udo}

run -all

quit -force
