onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+r51 -L xil_defaultlib -L xpm -L blk_mem_gen_v8_4_1 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.r51 xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {r51.udo}

run -all

endsim

quit -force
