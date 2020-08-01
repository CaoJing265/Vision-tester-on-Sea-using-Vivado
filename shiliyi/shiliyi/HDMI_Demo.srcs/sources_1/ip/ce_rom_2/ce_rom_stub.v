// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Thu Oct 31 09:27:20 2019
// Host        : DESKTOP-52TN4RU running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               D:/SEAEnglish/example2/HDMI_Demo/HDMI_Demo/HDMI_Demo/HDMI_Demo.srcs/sources_1/ip/ce_rom_2/ce_rom_stub.v
// Design      : ce_rom
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7s25ftgb196-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_1,Vivado 2018.2" *)
module ce_rom(clka, ena, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,addra[13:0],douta[0:0]" */;
  input clka;
  input ena;
  input [13:0]addra;
  output [0:0]douta;
endmodule
