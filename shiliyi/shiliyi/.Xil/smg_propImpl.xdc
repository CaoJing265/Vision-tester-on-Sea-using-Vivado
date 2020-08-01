set_property SRC_FILE_INFO {cfile:f:/Summer_xilinx/shiliyi/HDMI_Demo.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc rfile:../HDMI_Demo.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc id:1 order:EARLY scoped_inst:clk_10/inst} [current_design]
set_property SRC_FILE_INFO {cfile:F:/Summer_xilinx/shiliyi/HDMI_Demo.srcs/constrs_1/new/system.xdc rfile:../HDMI_Demo.srcs/constrs_1/new/system.xdc id:2} [current_design]
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.1
set_property src_info {type:XDC file:2 line:17 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN A4 [get_ports DQ]
set_property src_info {type:XDC file:2 line:18 export:INPUT save:INPUT read:READ} [current_design]
set_property IOSTANDARD LVCMOS33 [get_ports DQ]
