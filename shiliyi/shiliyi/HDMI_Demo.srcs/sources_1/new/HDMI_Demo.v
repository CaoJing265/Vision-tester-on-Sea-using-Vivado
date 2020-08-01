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
    //RGBToDviʵ����
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
    //��Ƶ����
    Driver_HDMI Driver_HDMI0(
        .clk(clk_system),        //ʱ��
        .Rst(1),                 //��λ�ź�,�͵�ƽ��λ
        .Video_Mode(0),          //��Ƶ��ʽ
        .RGB_In(RGB_In),         //��������
        .RGB_Data(RGB_Data),     //�������
        .RGB_HSync(RGB_HSync),   //���ź�
        .RGB_VSync(RGB_VSync),   //���ź�
        .RGB_VDE(RGB_VDE),       //������Ч�ź�
        .Set_X(Set_X),           //ͼ������X
        .Set_Y(Set_Y),           //ͼ������Y
        .eye(eye),
        .Direct(Direct),
        .Single_Result(Single_Result),
        .Data(Data)
        );

endmodule
