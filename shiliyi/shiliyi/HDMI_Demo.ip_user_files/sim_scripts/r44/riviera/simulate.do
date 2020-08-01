onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+r44 -L xil_defaultlib -L xpm -L blk_mem_gen_v8_4_1 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.r44 xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {r44.udo}

run -all

endsim

quit -force
