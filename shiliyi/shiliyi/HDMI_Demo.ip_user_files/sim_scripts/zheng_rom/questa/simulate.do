onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib zheng_rom_opt

do {wave.do}

view wave
view structure
view signals

do {zheng_rom.udo}

run -all

quit -force
