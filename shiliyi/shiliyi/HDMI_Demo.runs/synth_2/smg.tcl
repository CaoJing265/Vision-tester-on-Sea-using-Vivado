# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7s25ftgb196-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.cache/wt [current_project]
set_property parent.project_path C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_repo_paths c:/Users/Qzzzz/IP [current_project]
set_property ip_output_repo c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/new/Driver_HDMI.v
  C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/new/HDMI_Demo.v
  C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/new/Result_Data.v
  C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/new/button.v
  C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/new/random_number.v
  C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/new/shili_control.v
  C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/new/smg.v
}
read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/r52/r52.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/r52/r52_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/l51/l51.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/l51/l51_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/r45/r45.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/r45/r45_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/l42/l42.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/l42/l42_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/l41/l41.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/l41/l41_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/wei2/wei2.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/wei2/wei2_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/yanl/yanl.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/yanl/yanl_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/yanr/yanr.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/yanr/yanr_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/cheng2/cheng2.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/cheng2/cheng2_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/wan2/wan2.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/wan2/wan2_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/shi2/shi2.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/shi2/shi2_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/ce2/ce2.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/ce2/ce2_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/kai_rom/kai_rom.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/kai_rom/kai_rom_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/si_rom/si_rom.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/si_rom/si_rom_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/dan_rom/dan_rom.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/dan_rom/dan_rom_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/yan_rom/yan_rom.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/yan_rom/yan_rom_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/wan_rom/wan_rom.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/wan_rom/wan_rom_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/cheng_rom/cheng_rom.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/cheng_rom/cheng_rom_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/ku_rom/ku_rom.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/ku_rom/ku_rom_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/xiao_rom/xiao_rom.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/xiao_rom/xiao_rom_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/rgb2dvi_0/rgb2dvi_0.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/rgb2dvi_0/src/rgb2dvi.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/rgb2dvi_0/src/rgb2dvi_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/rgb2dvi_0/src/rgb2dvi_clocks.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/r41/r41.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/r41/r41_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/zuo_rom/zuo_rom.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/zuo_rom/zuo_rom_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/you_rom/you_rom.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/you_rom/you_rom_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/wei_rom/wei_rom.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/wei_rom/wei_rom_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/r40/r40.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/r40/r40_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/l40/l40.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/l40/l40_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/r42/r42.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/r42/r42_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/r43/r43.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/r43/r43_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/l43/l43.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/l43/l43_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/l44/l44.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/l44/l44_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/r44/r44.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/r44/r44_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/l45/l45.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/l45/l45_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/l46/l46.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/l46/l46_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/r46/r46.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/r46/r46_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/r47/r47.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/r47/r47_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/l47/l47.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/l47/l47_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/r48/r48.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/r48/r48_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/l48/l48.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/l48/l48_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/r49/r49.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/r49/r49_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/l49/l49.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/l49/l49_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/r50/r50.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/r50/r50_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/l50/l50.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/l50/l50_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/r51/r51.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/r51/r51_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/l52/l52.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/l52/l52_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/l53/l53.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/l53/l53_ooc.xdc]

read_ip -quiet C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/r53/r53.xci
set_property used_in_implementation false [get_files -all c:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/sources_1/ip/r53/r53_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/constrs_1/new/system.xdc
set_property used_in_implementation false [get_files C:/Users/Qzzzz/Desktop/shiliyi/shiliyi/HDMI_Demo.srcs/constrs_1/new/system.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param ips.enableIPCacheLiteLoad 0
close [open __synthesis_is_running__ w]

synth_design -top smg -part xc7s25ftgb196-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef smg.dcp
create_report "synth_2_synth_report_utilization_0" "report_utilization -file smg_utilization_synth.rpt -pb smg_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]