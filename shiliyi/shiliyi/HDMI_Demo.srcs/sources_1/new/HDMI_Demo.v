`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/13 13:55:11
// Design Name: 
// Module Name: HDMI_Demo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module HDMI_Demo(
    input clock_my,
    input [3:0]eye,
    input [1:0]Direct,
    input [2:0]Single_Result,
    input [15:0]Data,
    output TMDS_Tx_Clk_N,
    output TMDS_Tx_Clk_P,
    output [2:0]TMDS_Tx_Data_N,
    output [2:0]TMDS_Tx_Data_P
    );

    reg clk_system;
    wire [23:0]RGB_Data;
    wire [23:0]RGB_In;
    wire RGB_HSync;
    wire RGB_VSync;
    wire RGB_VDE;
    wire [11:0]Set_X;
    wire [11:0]Set_Y;
   
    always @(posedge clock_my)
    begin
    clk_system = ~clk_system;
    end
    //RGBToDvi实例化
    rgb2dvi_0 rgb2dvi(
        .TMDS_Clk_p(TMDS_Tx_Clk_P),
        .TMDS_Clk_n(TMDS_Tx_Clk_N),
        .TMDS_Data_p(TMDS_Tx_Data_P),
        .TMDS_Data_n(TMDS_Tx_Data_N),
        .aRst_n(1),
        .vid_pData(RGB_Data),
        .vid_pVDE(RGB_VDE),
        .vid_pHSync(RGB_HSync),
        .vid_pVSync(RGB_VSync),
        .PixelClk(clk_system));
    //视频产生
    Driver_HDMI Driver_HDMI0(
        .clk(clk_system),        //时钟
        .Rst(1),                 //复位信号,低电平复位
        .Video_Mode(0),          //视频格式
        .RGB_In(RGB_In),         //输入数据
        .RGB_Data(RGB_Data),     //输出数据
        .RGB_HSync(RGB_HSync),   //行信号
        .RGB_VSync(RGB_VSync),   //场信号
        .RGB_VDE(RGB_VDE),       //数据有效信号
        .Set_X(Set_X),           //图像坐标X
        .Set_Y(Set_Y),           //图像坐标Y
        .eye(eye),
        .Direct(Direct),
        .Single_Result(Single_Result),
        .Data(Data)
        );

endmodule
