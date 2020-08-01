`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/13 13:58:34
// Design Name: 
// Module Name: Driver_HDMI
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
`define Video_Mode_1024_768 0
`define Video_Mode_1280_720 1

module Driver_HDMI(
    input clk,                          //时钟
    input Rst,                         //复位信号,低电平复位
    input [3:0]eye,
    input [1:0]Direct,
    input [2:0]Single_Result, 
    input [15:0]Data,
    input Video_Mode,                   //视频格式
    input [23:0]RGB_In,                 //输入数据
    output reg [23:0]RGB_Data,              //输出数据
    output reg RGB_HSync=0,            //行信号
    output reg RGB_VSync=0,            //场信号
    output reg RGB_VDE=0,              //数据有效信号
    output reg [11:0]Set_X=0,          //图像坐标X
    output reg [11:0]Set_Y=0           //图像坐标Y
   
    );
    parameter H_ACTIVE_1280_720 = 16'd1280;
    parameter H_FP_1280_720 = 16'd110;
    parameter H_SYNC_1280_720 = 16'd40;
    parameter H_BP_1280_720 = 16'd220; 
    parameter V_ACTIVE_1280_720 = 16'd720;
    parameter V_FP_1280_720     = 16'd5;
    parameter V_SYNC_1280_720  = 16'd5;
    parameter V_BP_1280_720    = 16'd20;
    parameter H_TOTAL_1280_720 = H_ACTIVE_1280_720 + H_FP_1280_720 + H_SYNC_1280_720 + H_BP_1280_720;
    parameter V_TOTAL_1280_720 = V_ACTIVE_1280_720 + V_FP_1280_720 + V_SYNC_1280_720 + V_BP_1280_720;
    
    parameter H_ACTIVE_1024_768 = 16'd1024;
    parameter H_FP_1024_768 = 16'd24;
    parameter H_SYNC_1024_768 = 16'd136;
    parameter H_BP_1024_768 = 16'd148; 
    parameter V_ACTIVE_1024_768 = 16'd768;
    parameter V_FP_1024_768     = 16'd3;
    parameter V_SYNC_1024_768  = 16'd6;
    parameter V_BP_1024_768    = 16'd29;
    parameter H_TOTAL_1024_768 = H_ACTIVE_1024_768 + H_FP_1024_768 + H_SYNC_1024_768 + H_BP_1024_768;
    parameter V_TOTAL_1024_768 = V_ACTIVE_1024_768 + V_FP_1024_768 + V_SYNC_1024_768 + V_BP_1024_768;
    
    reg [11:0]H_ACTIVE=0;   //行有效长度（像素时钟周期个数）
    reg [11:0]H_FP=0;       //行同步前肩长度
    reg [11:0]H_SYNC=0;     //行同步长度
    reg [11:0]H_BP=0;       //行同步后肩长度
    reg [11:0]V_ACTIVE=0;   //场有效长度（行的个数）
    reg [11:0]V_FP=0;       //场同步前肩长度
    reg [11:0]V_SYNC= 0;    //场同步长度
    reg [11:0]V_BP=0;       //场同步后肩长度
    reg [11:0]H_TOTAL=0;    //行总长度
    reg [11:0]V_TOTAL=0;    //场总长度
    
    //行,场信号计数
    reg [11:0]HSync_Cnt=0;
    reg [11:0]VSync_Cnt=0;
    //行,场有效信号
    reg H_De=0;
    reg V_De=0;
    
    //RGB信号连线
 //   assign RGB_Data=RGB_In;
    //图像X,Y坐标获取
    always@(posedge clk or negedge Rst)
        begin
            //低电平复位
            if(!Rst)
                begin
                    Set_X<=0;
                    Set_Y<=0;
                end
            else
                begin
                    //行信号有效时,开始获取X坐标
                    if(HSync_Cnt>=H_FP + H_SYNC + H_BP - 1)
                        Set_X <= HSync_Cnt-(H_FP + H_SYNC + H_BP - 1);
                    //场信号有效时,开始获取Y坐标
                    if(VSync_Cnt>=V_FP + V_SYNC + V_BP - 1)
                        Set_Y<=VSync_Cnt-(V_FP + V_SYNC + V_BP - 1);
                end
        end
    //图像格式获取
    always@(*)
        begin
            case(Video_Mode)
                `Video_Mode_1024_768:
                    begin
                        H_ACTIVE=H_ACTIVE_1024_768;   //行有效长度（像素时钟周期个数）
                        H_FP=H_FP_1024_768;           //行同步前肩长度
                        H_SYNC=H_SYNC_1024_768;       //行同步长度
                        H_BP=H_BP_1024_768;           //行同步后肩长度
                        V_ACTIVE=V_ACTIVE_1024_768;   //场有效长度（行的个数）
                        V_FP=V_FP_1024_768;           //场同步前肩长度
                        V_SYNC=V_SYNC_1024_768;       //场同步长度
                        V_BP=V_BP_1024_768;           //场同步后肩长度
                        H_TOTAL=H_TOTAL_1024_768;     //行总长度
                        V_TOTAL=V_TOTAL_1024_768;     //场总长度
                    end
                `Video_Mode_1280_720:
                    begin
                        H_ACTIVE=H_ACTIVE_1280_720;    //行有效长度（像素时钟周期个数）
                        H_FP=H_FP_1280_720;            //行同步前肩长度
                        H_SYNC=H_SYNC_1280_720;        //行同步长度
                        H_BP=H_BP_1280_720;            //行同步后肩长度
                        V_ACTIVE=V_ACTIVE_1280_720;    //场有效长度（行的个数）
                        V_FP=V_FP_1280_720;            //场同步前肩长度
                        V_SYNC=V_SYNC_1280_720;        //场同步长度
                        V_BP=V_BP_1280_720;            //场同步后肩长度
                        H_TOTAL=H_TOTAL_1280_720;      //行总长度
                        V_TOTAL=V_TOTAL_1280_720;      //场总长度
                    end
            endcase
        end
    //行计数
    always@(posedge clk or negedge Rst)
        begin
            //低电平复位
            if(!Rst)
                HSync_Cnt<=0;
            else
                begin
                    //行计数到最大值清零
                    if(HSync_Cnt==H_TOTAL-1)
                        HSync_Cnt<=0;
                    else
                        HSync_Cnt<=HSync_Cnt+1;
                end
        end
    //场计数
    always@(posedge clk or negedge Rst)
        begin
            //低电平复位
            if(!Rst)
                VSync_Cnt<=0;
            else
                begin
                    //行计数到H_FP-1时,场计数
                    if(HSync_Cnt==H_FP-1)
                        begin
                            //场计数到最大值清零
                            if(VSync_Cnt==V_TOTAL-1)
                                VSync_Cnt<=0;
                            else
                                VSync_Cnt<=VSync_Cnt+1;
                        end
                end
        end
    //行信号有效
    always@(posedge clk or negedge Rst)
        begin
            //低电平复位
            if(!Rst)
                H_De<=0;
            else
                begin
                    //行计数满足一个周期,行信号开始有效
                    if(HSync_Cnt==H_FP + H_SYNC + H_BP - 1)
                        H_De<=1;
                    //行计数到最大值,行信号开始无效
                    else if(HSync_Cnt==H_TOTAL-1)
                        H_De<=0;                    
                end
        end
    //场信号有效
    always@(posedge clk or negedge Rst)
        begin
            //低电平复位
            if(!Rst)
                V_De<=0;
            else
                begin
                    //行计数为H_FP-1，即行同步开始时
                    if(HSync_Cnt==H_FP-1)
                        begin
                            //场计数满足一个周期,场信号有效
                            if(VSync_Cnt==V_FP + V_SYNC + V_BP - 1)
                                V_De<=1;
                            //场计数到最大值,场信号开始无效
                            else if(VSync_Cnt==V_TOTAL-1)
                                V_De<=0;
                        end    
                end
        end
    //数据有效信号输出
    always@(posedge clk or negedge Rst)
        begin
            //低电平复位
            if(!Rst)
                RGB_VDE<=0;
            else
                //数据有效信号输出
                RGB_VDE<=H_De&V_De;                
        end  
    //行信号输出
    always@(posedge clk or negedge Rst)
        begin
            //低电平复位
            if(!Rst)
                RGB_HSync<=0;
            else
                begin
                    //行同步开始时,行信号开始为高
                    if(HSync_Cnt==H_FP-1)
                        RGB_HSync<=1;
                    //行同步结束时,行信号开始为低
                    else if(HSync_Cnt==H_FP + H_SYNC - 1)
                        RGB_HSync<=0;
                end                
        end   
    //场信号输出
    always@(posedge clk or negedge Rst)           
        begin
            //低电平复位
            if(!Rst)
                RGB_VSync<=0;
            else
                begin
                    //行同步开始时
                    if(HSync_Cnt==H_FP-1)
                        begin
                            //场同步开始时,场信号为高
                            if(VSync_Cnt==V_FP-1)
                                RGB_VSync<=1;
                            //场同步结束时,场信号开始为低
                            else if(VSync_Cnt==V_FP + V_SYNC - 1)
                                RGB_VSync<=0;
                        end
                end
        end

/****************************图片存储************************/
        `define shi_x 10'd100    //图片宽度
        `define shi_y 10'd100    //图片高度
        `define origin_x1  10'd270    //图片显示起点（x,y）
        `define origin_y1  10'd300
        `define origin_x2  10'd380    //图片显示起点（x,y）
        `define origin_y2  10'd300
        `define origin_x3  10'd490    //图片显示起点（x,y）
        `define origin_y3  10'd300
        `define origin_x4  10'd600    //图片显示起点（x,y）
        `define origin_y4  10'd300
        wire  one_add;    //图片位置信号
        wire  one_en;    //图片使能信号
        wire  two_add;    //图片位置信号
        wire  two_en;    //图片使能信号
        wire  three_add;    //图片位置信号
        wire  three_en;    //图片使能信号
        wire  four_add;    //图片位置信号
        wire  four_en;    //图片使能信号
       reg [13 : 0] shi_addra;
        wire [0 : 0] shi_douta;
 /*       shi_rom shi (
          .clka(clk),    // input wire clka
          .ena(1),      // input wire ena
          .addra(shi_addra),  // input wire [13 : 0] addra
          .douta(shi_douta)  // output wire [0 : 0] douta
        );
       reg [13 : 0] ce_addra;
       wire [0 : 0] ce_douta;
       ce_rom ce (
         .clka(clk),    // input wire clka
         .ena(1),      // input wire ena
        .addra(ce_addra),  // input wire [13 : 0] addra
         .douta(ce_douta)  // output wire [0 : 0] douta
       );*/
        reg [13 : 0] kai_addra;
        wire [0 : 0] kai_douta;
        kai_rom kai (
          .clka(clk),    // input wire clka
          .ena(1),      // input wire ena
          .addra(kai_addra),  // input wire [13 : 0] addra
          .douta(kai_douta)  // output wire [0 : 0] douta
        );
        reg [13 : 0] si_addra;
        wire [0 : 0] si_douta;
        si_rom si (
          .clka(clk),    // input wire clka
          .ena(1),      // input wire ena
          .addra(si_addra),  // input wire [13 : 0] addra
          .douta(si_douta)  // output wire [0 : 0] douta
        );
  /*     reg [13 : 0] dan_addra;
        wire [0 : 0] dan_douta;
        dan_rom dan (
          .clka(clk),    // input wire clka
          .ena(1),      // input wire ena
          .addra(dan_addra),  // input wire [13 : 0] addra
          .douta(dan_douta)  // output wire [0 : 0] douta
        ); 
        reg [13 : 0] yan_addra;
        wire [0 : 0] yan_douta;
        yan_rom yan (
          .clka(clk),    // input wire clka
          .ena(1),      // input wire ena
          .addra(yan_addra),  // input wire [13 : 0] addra
          .douta(yan_douta)  // output wire [0 : 0] douta
        );*/
        reg [13 : 0] wan_addra;
        wire [0 : 0] wan_douta;
        wan_rom wan (
          .clka(clk),    // input wire clka
          .ena(1),      // input wire ena
          .addra(wan_addra),  // input wire [13 : 0] addra
          .douta(wan_douta)  // output wire [0 : 0] douta
        ); 
/*        reg [13 : 0] cheng_addra;
        wire [0 : 0] cheng_douta;
        cheng_rom cheng (
          .clka(clk),    // input wire clka
          .ena(1),      // input wire ena
          .addra(cheng_addra),  // input wire [13 : 0] addra
          .douta(cheng_douta)  // output wire [0 : 0] douta
        ); */
  /*      reg [13 : 0] zheng_addra;
        wire [0 : 0] zheng_douta;
        zheng_rom zheng (
          .clka(clk),    // input wire clka
          .ena(1),      // input wire ena
          .addra(zheng_addra),  // input wire [13 : 0] addra
          .douta(zheng_douta)  // output wire [0 : 0] douta
        ); 
        reg [13 : 0] que_addra;
        wire [0 : 0] que_douta;
        que_rom que (
          .clka(clk),    // input wire clka
          .ena(1),      // input wire ena
          .addra(que_addra),  // input wire [13 : 0] addra
          .douta(que_douta)  // output wire [0 : 0] douta
        );  
        reg [13 : 0] cuo_addra;
        wire [0 : 0] cuo_douta;
        cuo_rom cuo (
          .clka(clk),    // input wire clka
          .ena(1),      // input wire ena
          .addra(cuo_addra),  // input wire [13 : 0] addra
          .douta(cuo_douta)  // output wire [0 : 0] douta
        );  
        reg [13 : 0] wu_addra;
        wire [0 : 0] wu_douta;
        wu_rom wu (
          .clka(clk),    // input wire clka
          .ena(1),      // input wire ena
          .addra(wu_addra),  // input wire [13 : 0] addra
          .douta(wu_douta)  // output wire [0 : 0] douta
        ); */
       reg [13 : 0] xiao_addra;
        wire [0 : 0] xiao_douta;
        xiao_rom xiao (
          .clka(clk),    // input wire clka
          .ena(1),      // input wire ena
          .addra(xiao_addra),  // input wire [13 : 0] addra
          .douta(xiao_douta)  // output wire [0 : 0] douta
        ); 
        reg [13 : 0] ku_addra;
        wire [0 : 0] ku_douta;
        ku_rom ku (
          .clka(clk),    // input wire clka
          .ena(1),      // input wire ena
          .addra(ku_addra),  // input wire [13 : 0] addra
          .douta(ku_douta)  // output wire [0 : 0] douta
        ); 
/*         reg [13 : 0] zuo_addra;
        wire [0 : 0] zuo_douta;
        zuo_rom zuo (
          .clka(clk),    // input wire clka
          .ena(1),      // input wire ena
          .addra(zuo_addra),  // input wire [13 : 0] addra
          .douta(zuo_douta)  // output wire [0 : 0] douta
        );
        reg [13 : 0] you_addra;
        wire [0 : 0] you_douta;
        you_rom you (
          .clka(clk),    // input wire clka
          .ena(1),      // input wire ena
          .addra(you_addra),  // input wire [13 : 0] addra
          .douta(you_douta)  // output wire [0 : 0] douta
        ); */
  /*      reg [13 : 0] wei_addra;
        wire [0 : 0] wei_douta;
        wei_rom wei (
          .clka(clk),    // input wire clka
          .ena(1),      // input wire ena
          .addra(wei_addra),  // input wire [13 : 0] addra
          .douta(wei_douta)  // output wire [0 : 0] douta
        ); 
/**********************************汉字位置确定********************************/  
                                                        
                //组合电路,用于生成图片位置信号
                assign  one_add = (Set_X >= `origin_x1 - 10'd3 ) && (Set_X < `origin_x1 + `shi_x - 10'd3 ) && (Set_Y >= `origin_y1) && (Set_Y < `origin_y1 + `shi_y); 
                //组合电路,用于生成图片使能信号
                assign  one_en = (Set_X >= `origin_x1) && (Set_X < `origin_x1 + `shi_x) && (Set_Y >= `origin_y1) && (Set_Y < `origin_y1 + `shi_y);     
                //组合电路,用于生成图片位置信号
                assign  two_add = (Set_X >= `origin_x2 - 10'd3 ) && (Set_X < `origin_x2 + `shi_x - 10'd3 ) && (Set_Y >= `origin_y2) && (Set_Y < `origin_y1 + `shi_y); 
                //组合电路,用于生成图片使能信号
                assign  two_en = (Set_X >= `origin_x2) && (Set_X < `origin_x2 + `shi_x) && (Set_Y >= `origin_y2) && (Set_Y < `origin_y2 + `shi_y);   
                //组合电路,用于生成图片位置信号
                assign  three_add = (Set_X >= `origin_x3 - 10'd3 ) && (Set_X < `origin_x3 + `shi_x - 10'd3 ) && (Set_Y >= `origin_y3) && (Set_Y < `origin_y3 + `shi_y); 
                 //组合电路,用于生成图片使能信号
                assign  three_en = (Set_X >= `origin_x3) && (Set_X < `origin_x3 + `shi_x) && (Set_Y >= `origin_y3) && (Set_Y < `origin_y3 + `shi_y);     
                //组合电路,用于生成图片位置信号
                assign  four_add = (Set_X >= `origin_x4 - 10'd3 ) && (Set_X < `origin_x4 + `shi_x - 10'd3 ) && (Set_Y >= `origin_y4) && (Set_Y < `origin_y4 + `shi_y); 
                  //组合电路,用于生成图片使能信号
                assign   four_en = (Set_X >= `origin_x4) && (Set_X < `origin_x4 + `shi_x) && (Set_Y >= `origin_y4) && (Set_Y < `origin_y4 + `shi_y);     
                
reg [24:0] R_data;
reg [24:0] W_data;
reg [24:0] Dan_data;
reg [24:0] Shuang_data;
reg [24:0] Kai_data;      
/********************************************测试开始******************************************/ 

        always @ (posedge clk) 
        begin
                 if( (Set_X == `origin_x2 - 10'd3) && (Set_Y == `origin_y2 ) &&  two_add )  //图片起始点 地址清0
                     kai_addra<= 15'd0;
                 else if( two_add)  //图片生成位置
                 kai_addra = kai_addra + 1'b1;
        end
        always @ (posedge clk) 
        begin
                 if( (Set_X == `origin_x3 - 10'd3) && (Set_Y == `origin_y3 ) &&  three_add )  //图片起始点 地址清0
                     si_addra<= 15'd0;
                 else if( three_add)  //图片生成位置
                 si_addra = si_addra + 1'b1;
        end
 
        always @ (posedge clk)  //每个时钟上升沿赋值
        begin   
                    if(two_en)
                             begin
                             if(kai_douta==0)
                             Kai_data<= 24'hffffff;
                             else
                             Kai_data<= 0;   //图片RGB数据
                             end
                   else if(three_en)
                                       begin
                                       if(si_douta==0)
                                       Kai_data<= 24'hffffff;
                                       else
                                       Kai_data<= 0;   //图片RGB数据
                                       end                                                         
                   else
                   Kai_data<= 24'hffffff;
          end
/***********************************单眼完成***************************************/
    /*    always @ (posedge clk) 
begin
         if( (Set_X == `origin_x1 - 10'd3) && (Set_Y == `origin_y1 ) &&  one_add )  //图片起始点 地址清0
             dan_addra<= 15'd0;
         else if( one_add)  //图片生成位置
         dan_addra = dan_addra + 1'b1;
end
always @ (posedge clk) 
begin
         if( (Set_X == `origin_x2 - 10'd3) && (Set_Y == `origin_y2 ) &&  two_add )  //图片起始点 地址清0
             yan_addra<= 15'd0;
         else if( two_add)  //图片生成位置
         yan_addra = yan_addra + 1'b1;
end */
always @ (posedge clk) 
begin
         if( (Set_X == `origin_x3 - 10'd3) && (Set_Y == `origin_y3 ) &&  three_add )  //图片起始点 地址清0
             wan_addra<= 15'd0;
         else if( three_add)  //图片生成位置
         wan_addra = wan_addra + 1'b1;
end
/*always @ (posedge clk) 
begin
         if( (Set_X == `origin_x4 - 10'd3) && (Set_Y == `origin_y4 ) &&  four_add )  //图片起始点 地址清0
             cheng_addra<= 15'd0;
         else if( four_add)  //图片生成位置
         cheng_addra = cheng_addra + 1'b1;
end    */    
always @ (posedge clk)  //每个时钟上升沿赋值
begin   

            if(three_en)
                               begin
                               if(wan_douta==0)
                               Dan_data<= 24'hffffff;
                               else
                               Dan_data<= 0;   //图片RGB数据
                               end                                                          
           else
           Dan_data<= 24'hffffff;
end

     
/*********************************************测试结果显示设置*************************************************/   
        `define rx1  10'd270    
        `define rx2  10'd380    
        `define rx3  10'd490    
        `define rx4  10'd600    
        `define ry1  10'd150
        `define ry2  10'd320 
        `define ry3  10'd420
        
        wire  add1;    //图片位置信号
        wire  en1;    //图片使能信号     
        wire  add2;    //图片位置信号
        wire  en2;    //图片使能信号    
        wire  add3;    //图片位置信号
        wire  en3;    //图片使能信号    
        wire  add4;    //图片位置信号
        wire  en4;    //图片使能信号    
        wire  add5;    //图片位置信号
        wire  en5;    //图片使能信号  
        wire  add6;    //图片位置信号
        wire  en6;    //图片使能信号 
        wire  add7;    //图片位置信号
        wire  en7;    //图片使能信号 
        wire  add8;    //图片位置信号
        wire  en8;    //图片使能信号 
        wire  add9;    //图片位置信号
        wire  en9;    //图片使能信号 
        wire  add10;    //图片位置信号
        wire  en10;    //图片使能信号 
        wire  add11;    //图片位置信号
        wire  en11;    //图片使能信号   
        wire  add12;    //图片位置信号
        wire  en12;    //图片使能信号                                    
         //第一排      
                assign  add1 = (Set_X >= `rx1 - 10'd3 ) && (Set_X < `rx1 + `shi_x - 10'd3 ) && (Set_Y >= `ry1) && (Set_Y < `ry1 + `shi_y); 
                assign  en1 = (Set_X >= `rx1) && (Set_X < `rx1 + `shi_x) && (Set_Y >= `ry1) && (Set_Y < `ry1 + `shi_y);           
                assign  add2 = (Set_X >= `rx2 - 10'd3 ) && (Set_X < `rx2 + `shi_x - 10'd3 ) && (Set_Y >= `ry1) && (Set_Y < `ry1 + `shi_y);   
                assign  en2 = (Set_X >= `rx2) && (Set_X < `rx2 + `shi_x) && (Set_Y >= `ry1) && (Set_Y < `ry1 + `shi_y);      
                assign  add3 = (Set_X >= `rx3 - 10'd3 ) && (Set_X < `rx3 + `shi_x - 10'd3 ) && (Set_Y >= `ry1) && (Set_Y < `ry1 + `shi_y);      
                assign  en3 = (Set_X >= `rx3) && (Set_X < `rx3 + `shi_x) && (Set_Y >= `ry1) && (Set_Y < `ry1 + `shi_y);     
                assign  add4 = (Set_X >= `rx4 - 10'd3 ) && (Set_X < `rx4 + `shi_x - 10'd3 ) && (Set_Y >= `ry1) && (Set_Y < `ry1 + `shi_y); 
                assign  en4 = (Set_X >= `rx4) && (Set_X < `rx4 + `shi_x) && (Set_Y >= `ry1) && (Set_Y < `ry1 + `shi_y);      
        //第二排左眼视力
          assign  add5 = (Set_X >= `rx1 - 10'd3 ) && (Set_X < `rx1 + `shi_x - 10'd3 ) && (Set_Y >= `ry2) && (Set_Y < `ry2 + `shi_y); 
          assign  en5 = (Set_X >= `rx1) && (Set_X < `rx1 + `shi_x) && (Set_Y >= `ry2) && (Set_Y < `ry2 + `shi_y);           
          assign  add6 = (Set_X >= `rx2 - 10'd3 ) && (Set_X < `rx2 + `shi_x - 10'd3 ) && (Set_Y >= `ry2) && (Set_Y < `ry2 + `shi_y);   
          assign  en6 = (Set_X >= `rx2) && (Set_X < `rx2 + `shi_x) && (Set_Y >= `ry2) && (Set_Y < `ry2 + `shi_y);      
          assign  add7 = (Set_X >= `rx3 - 10'd3 ) && (Set_X < `rx3 + `shi_x - 10'd3 ) && (Set_Y >= `ry2) && (Set_Y < `ry2 + `shi_y);      
          assign  en7 = (Set_X >= `rx3) && (Set_X < `rx3 + `shi_x) && (Set_Y >= `ry2) && (Set_Y < `ry2 + `shi_y);     
          assign  add8 = (Set_X >= `rx4 - 10'd3 ) && (Set_X < `rx4 + `shi_x - 10'd3 ) && (Set_Y >= `ry2) && (Set_Y < `ry2 + `shi_y); 
          assign  en8 = (Set_X >= `rx4) && (Set_X < `rx4 + `shi_x) && (Set_Y >= `ry2) && (Set_Y < `ry2 + `shi_y);          
          //第三排右眼视力
            assign  add9 = (Set_X >= `rx1 - 10'd3 ) && (Set_X < `rx1 + `shi_x - 10'd3 ) && (Set_Y >= `ry3) && (Set_Y < `ry3 + `shi_y); 
            assign  en9 = (Set_X >= `rx1) && (Set_X < `rx1 + `shi_x) && (Set_Y >= `ry1) && (Set_Y < `ry3 + `shi_y);           
            assign  add10 = (Set_X >= `rx2 - 10'd3 ) && (Set_X < `rx2 + `shi_x - 10'd3 ) && (Set_Y >= `ry3) && (Set_Y < `ry3 + `shi_y);   
            assign  en10 = (Set_X >= `rx2) && (Set_X < `rx2 + `shi_x) && (Set_Y >= `ry3) && (Set_Y < `ry3 + `shi_y);      
            assign  add11 = (Set_X >= `rx3 - 10'd3 ) && (Set_X < `rx3 + `shi_x - 10'd3 ) && (Set_Y >= `ry3) && (Set_Y < `ry3 + `shi_y);      
            assign  en11 = (Set_X >= `rx3) && (Set_X < `rx3 + `shi_x) && (Set_Y >= `ry3) && (Set_Y < `ry3 + `shi_y);     
            assign  add12 = (Set_X >= `rx4 - 10'd3 ) && (Set_X < `rx4 + `shi_x - 10'd3 ) && (Set_Y >= `ry3) && (Set_Y < `ry3 + `shi_y); 
            assign  en12 = (Set_X >= `rx4) && (Set_X < `rx4 + `shi_x) && (Set_Y >= `ry3) && (Set_Y < `ry3 + `shi_y);          
   /**********************************视力结果存储****************************************/ 
 /*   reg [13 : 0] ce2_addra;
   wire [0 : 0] ce2_douta;
   ce2 ce2 (
     .clka(clk),    // input wire clka
     .ena(1),      // input wire ena
     .addra(ce2_addra),  // input wire [13 : 0] addra
     .douta(ce2_douta)  // output wire [0 : 0] douta
   );
   reg [13 : 0] shi2_addra;
   wire [0 : 0] shi2_douta;
   shi2 shi2 (
     .clka(clk),    // input wire clka
     .ena(1),      // input wire ena
     .addra(shi2_addra),  // input wire [13 : 0] addra
     .douta(shi2_douta)  // output wire [0 : 0] douta
   );
   reg [13 : 0] wan2_addra;
   wire [0 : 0] wan2_douta;
   wan2 wan2 (
     .clka(clk),    // input wire clka
     .ena(1),      // input wire ena
     .addra(wan2_addra),  // input wire [13 : 0] addra
     .douta(wan2_douta)  // output wire [0 : 0] douta
   );
        reg [13 : 0] cheng2_addra;
        wire [0 : 0] cheng2_douta;
        cheng2 cheng2 (
          .clka(clk),    // input wire clka
          .ena(1),      // input wire ena
          .addra(cheng2_addra),  // input wire [13 : 0] addra
          .douta(cheng2_douta)  // output wire [0 : 0] douta
        );
        reg [13 : 0] yanr_addra;
        wire [0 : 0]  yanr_douta;
         yanr  yanr (
          .clka(clk),    // input wire clka
          .ena(1),      // input wire ena
          .addra( yanr_addra),  // input wire [13 : 0] addra
          .douta( yanr_douta)  // output wire [0 : 0] douta
        );
        reg [13 : 0] yanl_addra;
        wire [0 : 0]  yanl_douta;
         yanl  yanl (
          .clka(clk),    // input wire clka
          .ena(1),      // input wire ena
          .addra( yanl_addra),  // input wire [13 : 0] addra
          .douta( yanl_douta)  // output wire [0 : 0] douta
        );
             reg [13 : 0] wei2_addra;
         wire [0 : 0] wei2_douta;
         wei2 wei2 (
           .clka(clk),    // input wire clka
           .ena(1),      // input wire ena
           .addra(wei2_addra),  // input wire [13 : 0] addra
           .douta(wei2_douta)  // output wire [0 : 0] douta
         );*/
 /*      reg [13 : 0] l40_addra;
       wire [0 : 0]  l40_douta;
        l40  l40 (
         .clka(clk),    // input wire clka
         .ena(1),      // input wire ena
         .addra( l40_addra),  // input wire [13 : 0] addra
         .douta( l40_douta)  // output wire [0 : 0] douta
       );
      reg [13 : 0] r40_addra;
      wire [0 : 0]  r40_douta;
       r40  r40 (
        .clka(clk),    // input wire clka
        .ena(1),      // input wire ena
        .addra( r40_addra),  // input wire [13 : 0] addra
        .douta( r40_douta)  // output wire [0 : 0] douta
      );
         reg [13 : 0] r41_addra;
        wire [0 : 0]  r41_douta;
         r41  r41 (
          .clka(clk),    // input wire clka
          .ena(1),      // input wire ena
          .addra( r41_addra),  // input wire [13 : 0] addra
          .douta( r41_douta)  // output wire [0 : 0] douta
        );
          reg [13 : 0] l41_addra;
       wire [0 : 0]  l41_douta;
        l41  l41 (
         .clka(clk),    // input wire clka
         .ena(1),      // input wire ena
         .addra( l41_addra),  // input wire [13 : 0] addra
         .douta( l41_douta)  // output wire [0 : 0] douta
       );
          reg [13 : 0] r42_addra;
      wire [0 : 0]  r42_douta;
       r42  r42 (
        .clka(clk),    // input wire clka
        .ena(1),      // input wire ena
        .addra( r42_addra),  // input wire [13 : 0] addra
        .douta( r42_douta)  // output wire [0 : 0] douta
      );
        reg [13 : 0] l42_addra;
     wire [0 : 0]  l42_douta;
      l42  l42 (
       .clka(clk),    // input wire clka
       .ena(1),      // input wire ena
       .addra( l42_addra),  // input wire [13 : 0] addra
       .douta( l42_douta)  // output wire [0 : 0] douta
     );
           reg [13 : 0] r43_addra;
    wire [0 : 0]  r43_douta;
     r43  r43 (
      .clka(clk),    // input wire clka
      .ena(1),      // input wire ena
      .addra( r43_addra),  // input wire [13 : 0] addra
      .douta( r43_douta)  // output wire [0 : 0] douta
    );
      reg [13 : 0] l43_addra;
   wire [0 : 0]  l43_douta;
    l43  l43 (
     .clka(clk),    // input wire clka
     .ena(1),      // input wire ena
     .addra( l43_addra),  // input wire [13 : 0] addra
     .douta( l43_douta)  // output wire [0 : 0] douta
   );*/
  reg [13 : 0] r44_addra;
  wire [0 : 0]  r44_douta;
   r44  r44 (
    .clka(clk),    // input wire clka
    .ena(1),      // input wire ena
    .addra( r44_addra),  // input wire [13 : 0] addra
    .douta( r44_douta)  // output wire [0 : 0] douta
  );
    reg [13 : 0] l44_addra;
 wire [0 : 0]  l44_douta;
  l44  l44 (
   .clka(clk),    // input wire clka
   .ena(1),      // input wire ena
   .addra( l44_addra),  // input wire [13 : 0] addra
   .douta( l44_douta)  // output wire [0 : 0] douta
 );
reg [13 : 0] r45_addra;
wire [0 : 0]  r45_douta;
 r45  r45 (
  .clka(clk),    // input wire clka
  .ena(1),      // input wire ena
  .addra( r45_addra),  // input wire [13 : 0] addra
  .douta( r45_douta)  // output wire [0 : 0] douta
);
  reg [13 : 0] l45_addra;
wire [0 : 0]  l45_douta;
l45  l45 (
 .clka(clk),    // input wire clka
 .ena(1),      // input wire ena
 .addra( l45_addra),  // input wire [13 : 0] addra
 .douta( l45_douta)  // output wire [0 : 0] douta
);
reg [13 : 0] r46_addra;
wire [0 : 0]  r46_douta;
 r46  r46 (
  .clka(clk),    // input wire clka
  .ena(1),      // input wire ena
  .addra( r46_addra),  // input wire [13 : 0] addra
  .douta( r46_douta)  // output wire [0 : 0] douta
);
  reg [13 : 0] l46_addra;
wire [0 : 0]  l46_douta;
l46  l46 (
 .clka(clk),    // input wire clka
 .ena(1),      // input wire ena
 .addra( l46_addra),  // input wire [13 : 0] addra
 .douta( l46_douta)  // output wire [0 : 0] douta
);
reg [13 : 0] r47_addra;
wire [0 : 0]  r47_douta;
 r47  r47 (
  .clka(clk),    // input wire clka
  .ena(1),      // input wire ena
  .addra( r47_addra),  // input wire [13 : 0] addra
  .douta( r47_douta)  // output wire [0 : 0] douta
);
  reg [13 : 0] l47_addra;
wire [0 : 0]  l47_douta;
l47  l47 (
 .clka(clk),    // input wire clka
 .ena(1),      // input wire ena
 .addra( l47_addra),  // input wire [13 : 0] addra
 .douta( l47_douta)  // output wire [0 : 0] douta
);
reg [13 : 0] r48_addra;
wire [0 : 0]  r48_douta;
 r48  r48 (
  .clka(clk),    // input wire clka
  .ena(1),      // input wire ena
  .addra( r48_addra),  // input wire [13 : 0] addra
  .douta( r48_douta)  // output wire [0 : 0] douta
);
  reg [13 : 0] l48_addra;
wire [0 : 0]  l48_douta;
l48  l48 (
 .clka(clk),    // input wire clka
 .ena(1),      // input wire ena
 .addra( l48_addra),  // input wire [13 : 0] addra
 .douta( l48_douta)  // output wire [0 : 0] douta
);
reg [13 : 0] r49_addra;
wire [0 : 0]  r49_douta;
 r49  r49 (
  .clka(clk),    // input wire clka
  .ena(1),      // input wire ena
  .addra( r49_addra),  // input wire [13 : 0] addra
  .douta( r49_douta)  // output wire [0 : 0] douta
);
  reg [13 : 0] l49_addra;
wire [0 : 0]  l49_douta;
l49  l49 (
 .clka(clk),    // input wire clka
 .ena(1),      // input wire ena
 .addra( l49_addra),  // input wire [13 : 0] addra
 .douta( l49_douta)  // output wire [0 : 0] douta
);
reg [13 : 0] r50_addra;
wire [0 : 0]  r50_douta;
 r50  r50 (
  .clka(clk),    // input wire clka
  .ena(1),      // input wire ena
  .addra( r50_addra),  // input wire [13 : 0] addra
  .douta( r50_douta)  // output wire [0 : 0] douta
);
  reg [13 : 0] l50_addra;
wire [0 : 0]  l50_douta;
l50  l50 (
 .clka(clk),    // input wire clka
 .ena(1),      // input wire ena
 .addra( l50_addra),  // input wire [13 : 0] addra
 .douta( l50_douta)  // output wire [0 : 0] douta
);
/*reg [13 : 0] r51_addra;
wire [0 : 0]  r51_douta;
 r51  r51 (
  .clka(clk),    // input wire clka
  .ena(1),      // input wire ena
  .addra( r51_addra),  // input wire [13 : 0] addra
  .douta( r51_douta)  // output wire [0 : 0] douta
);
  reg [13 : 0] l51_addra;
wire [0 : 0]  l51_douta;
l51  l51 (
 .clka(clk),    // input wire clka
 .ena(1),      // input wire ena
 .addra( l51_addra),  // input wire [13 : 0] addra
 .douta( l51_douta)  // output wire [0 : 0] douta
);
reg [13 : 0] r52_addra;
wire [0 : 0]  r52_douta;
 r52  r52 (
  .clka(clk),    // input wire clka
  .ena(1),      // input wire ena
  .addra( r52_addra),  // input wire [13 : 0] addra
  .douta( r52_douta)  // output wire [0 : 0] douta
);
  reg [13 : 0] l52_addra;
wire [0 : 0]  l52_douta;
l52  l52(
 .clka(clk),    // input wire clka
 .ena(1),      // input wire ena
 .addra( l52_addra),  // input wire [13 : 0] addra
 .douta( l52_douta)  // output wire [0 : 0] douta
);
reg [13 : 0] r53_addra;
wire [0 : 0]  r53_douta;
 r53  r53 (
  .clka(clk),    // input wire clka
  .ena(1),      // input wire ena
  .addra( r53_addra),  // input wire [13 : 0] addra
  .douta( r53_douta)  // output wire [0 : 0] douta
);
  reg [13 : 0] l53_addra;
wire [0 : 0]  l53_douta;
l53  l53(
 .clka(clk),    // input wire clka
 .ena(1),      // input wire ena
 .addra( l53_addra),  // input wire [13 : 0] addra
 .douta( l53_douta)  // output wire [0 : 0] douta
);*/

/*************************************测试完成****************************************/
/* always @ (posedge clk) 
begin
if( (Set_X == `rx1 - 10'd3) && (Set_Y == `ry1 ) &&  add1 )  //图片起始点 地址清0
ce2_addra<= 15'd0;
else if( add1)  //图片生成位置
ce2_addra = ce2_addra + 1'b1;
end
always @ (posedge clk) 
begin
if( (Set_X == `rx2 - 10'd3) && (Set_Y == `ry1 ) &&  add2 )  //图片起始点 地址清0
shi2_addra<= 15'd0;
else if( add2)  //图片生成位置
shi2_addra = shi2_addra + 1'b1;
end
always @ (posedge clk) 
begin
if( (Set_X == `rx3 - 10'd3) && (Set_Y == `ry1 ) &&  add3 )  //图片起始点 地址清0
wan2_addra<= 15'd0;
else if( add3)  //图片生成位置
wan2_addra = wan2_addra + 1'b1;
end
always @ (posedge clk) 
begin
if( (Set_X == `rx4 - 10'd3) && (Set_Y == `ry1 ) &&  add4 )  //图片起始点 地址清0
cheng2_addra<= 15'd0;
else if( add4)  //图片生成位置
cheng2_addra = cheng2_addra + 1'b1;
end               
*/
//左眼视力
 /*always @ (posedge clk) 
begin
if( (Set_X == `rx1 - 10'd3) && (Set_Y == `ry2 ) &&  add5 )  //图片起始点 地址清0
zuo_addra<= 15'd0;
else if( add5)  //图片生成位置
zuo_addra = zuo_addra + 1'b1;
end
always @ (posedge clk) 
begin
if( (Set_X == `rx2 - 10'd3) && (Set_Y == `ry2 ) &&  add6 )  //图片起始点 地址清0
yanl_addra<= 15'd0;
else if( add6)  //图片生成位置
yanl_addra = yanl_addra + 1'b1;
end
always @ (posedge clk) 
begin
if( (Set_X == `rx3 - 10'd3) && (Set_Y == `ry2 ) &&  add7 )  //图片起始点 地址清0
wei_addra<= 15'd0;
else if( add7)  //图片生成位置
wei_addra = wei_addra + 1'b1;
end*/
always @ (posedge clk) 
begin
if( (Set_X == `rx4 - 10'd3) && (Set_Y == `ry2 ) &&  add8 )  //图片起始点 地址清0
begin
/*l40_addra<= 15'd0;
l41_addra<= 15'd0;
l42_addra<= 15'd0;
l43_addra<= 15'd0;*/
l44_addra<= 15'd0;
l45_addra<= 15'd0;
l46_addra<= 15'd0;
l47_addra<= 15'd0;
l48_addra<= 15'd0;
l49_addra<= 15'd0;
l50_addra<= 15'd0;
/*l51_addra<= 15'd0;
l52_addra<= 15'd0;
l53_addra<= 15'd0;*/
end
else if( add8)  //图片生成位置
begin
/*l40_addra = l40_addra + 1'b1;
l41_addra = l41_addra + 1'b1;
l42_addra = l42_addra + 1'b1;
l43_addra = l43_addra + 1'b1;*/
l44_addra = l44_addra + 1'b1;
l45_addra = l45_addra + 1'b1;
l46_addra = l46_addra + 1'b1;
l47_addra = l47_addra + 1'b1;
l48_addra = l48_addra + 1'b1;
l49_addra = l49_addra + 1'b1;
l50_addra = l50_addra + 1'b1;
/*l51_addra = l51_addra + 1'b1;
l52_addra = l52_addra + 1'b1;
l53_addra = l53_addra + 1'b1;*/
end
end 
//右眼视力
/* always @ (posedge clk) 
begin
if( (Set_X == `rx1 - 10'd3) && (Set_Y == `ry3 ) &&  add9 )  //图片起始点 地址清0
you_addra<= 15'd0;
else if( add9)  //图片生成位置
you_addra = you_addra + 1'b1;
end
always @ (posedge clk) 
begin
if( (Set_X == `rx2 - 10'd3) && (Set_Y == `ry3 ) &&  add10 )  //图片起始点 地址清0
yanr_addra<= 15'd0;
else if( add10)  //图片生成位置
yanr_addra = yanr_addra + 1'b1;
end
always @ (posedge clk) 
begin
if( (Set_X == `rx3 - 10'd3) && (Set_Y == `ry3 ) &&  add11 )  //图片起始点 地址清0
wei2_addra<= 15'd0;
else if( add11)  //图片生成位置
wei2_addra = wei2_addra + 1'b1;
end*/
always @ (posedge clk) 
begin
if( (Set_X == `rx4 - 10'd3) && (Set_Y == `ry3 ) &&  add12 )  //图片起始点 地址清0
begin
/*r40_addra<= 15'd0;
r42_addra<= 15'd0;
r43_addra<= 15'd0;*/
r44_addra<= 15'd0;
r45_addra<= 15'd0;
r46_addra<= 15'd0;
r47_addra<= 15'd0;
r48_addra<= 15'd0;
r49_addra<= 15'd0;
r50_addra<= 15'd0;
/*r51_addra<= 15'd0;
r52_addra<= 15'd0;
r53_addra<= 15'd0;*/
end
else if( add12)  //图片生成位置
begin
/*r40_addra = r40_addra + 1'b1;
r41_addra = r41_addra + 1'b1;
r42_addra = r42_addra + 1'b1;
r43_addra = r43_addra + 1'b1;*/
r44_addra = r44_addra + 1'b1;
r45_addra = r45_addra + 1'b1;
r46_addra = r46_addra + 1'b1;
r47_addra = r47_addra + 1'b1;
r48_addra = r48_addra + 1'b1;
r49_addra = r49_addra + 1'b1;
r50_addra = r50_addra + 1'b1;
/*r51_addra = r51_addra + 1'b1;
r52_addra = r52_addra + 1'b1;
r53_addra = r53_addra + 1'b1;*/
end
end  
always @ (posedge clk)  //每个时钟上升沿赋值
begin   
  /* if(  en1 )
   begin
   if(ce2_douta==0)
   Shuang_data<= 24'hffffff;
   else
   Shuang_data<= 0;   //图片RGB数据
   end
   else if(en2)
             begin
             if(shi2_douta==0)
             Shuang_data<= 24'hffffff;
             else
             Shuang_data<= 0;   //图片RGB数据
             end
   else if(en3)
                       begin
                       if(wan2_douta==0)
                       Shuang_data<= 24'hffffff;
                       else
                       Shuang_data<= 0;   //图片RGB数据
                       end
   else if(en4)
                                 begin
                                 if(cheng2_douta==0)
                                 Shuang_data<= 24'hffffff;
                                 else
                                 Shuang_data<= 0;   //图片RGB数据
                                 end                                                            
*/

 /*  if( en5 )
  begin
  if(zuo_douta==0)
  Shuang_data<= 24'hffffff;
  else
  Shuang_data<= 0;   //图片RGB数据
  end
  else if(en6)
            begin
            if(yanl_douta==0)
            Shuang_data<= 24'hffffff;
            else
            Shuang_data<= 0;   //图片RGB数据
            end
  else if(en7)
                      begin
                      if(wei_douta==0)
                      Shuang_data<= 24'hffffff;
                      else
                      Shuang_data<= 0;   //图片RGB数据
                      end*/
   if(en8)
    begin
                case(Data[15:8])
           8'h40:     
                    Shuang_data<= 24'hffffff;
                
           8'h41:  Shuang_data<= 24'hffffff;
           8'h42:   Shuang_data<= 24'hffffff;
           8'h43:   Shuang_data<= 24'hffffff;
           8'h44:  begin     
                if(l44_douta==0)
               Shuang_data<= 24'hffffff;
                else                             
                Shuang_data<= 0;   //图片RGB数据              
               end  
           8'h45:  begin     
               if(l45_douta==0)
                 Shuang_data<= 24'hffffff;
                else                             
                Shuang_data<= 0;   //图片RGB数据              
                end  
          8'h46:  begin     
                     if(l46_douta==0)
                       Shuang_data<= 24'hffffff;
                      else                             
                      Shuang_data<= 0;   //图片RGB数据              
                      end  
           8'h47:  begin     
                           if(l47_douta==0)
                             Shuang_data<= 24'hffffff;
                            else                             
                            Shuang_data<= 0;   //图片RGB数据              
                            end    
           8'h48:  begin     
                                            if(l48_douta==0)
                                              Shuang_data<= 24'hffffff;
                                             else                             
                                             Shuang_data<= 0;   //图片RGB数据              
                                             end   
         8'h49:  begin     
             if(l49_douta==0)
               Shuang_data<= 24'hffffff;
             else                             
           Shuang_data<= 0;   //图片RGB数据              
            end   
             8'h50:  begin     
                 if(l50_douta==0)
                Shuang_data<= 24'hffffff;
                 else                             
                 Shuang_data<= 0;   //图片RGB数据              
                end 
            8'h51: Shuang_data<= 24'hffffff;
             8'h52:  Shuang_data<= 24'hffffff;
              8'h53:  Shuang_data<= 24'hffffff;                                                                                                                                                                                                                                                                                                                                                                                                                                                              
                endcase    
     end                                                     
/* else  if( en9 )
  begin
  if(you_douta==0)
  Shuang_data<= 24'hffffff;
  else
  Shuang_data<= 0;   //图片RGB数据
  end
  else if(en10)
            begin
            if(yanr_douta==0)
            Shuang_data<= 24'hffffff;
            else
            Shuang_data<= 0;   //图片RGB数据
            end
  else if(en11)
                      begin
                      if(wei2_douta==0)
                      Shuang_data<= 24'hffffff;
                      else
                      Shuang_data<= 0;   //图片RGB数据
                      end*/
  else if(en12)
                case(Data[7:0])
8'h40:   Shuang_data<= 24'hffffff;        
        
8'h41:    Shuang_data<= 24'hffffff;      
                 
8'h42:       Shuang_data<= 24'hffffff;
8'h43:  Shuang_data<= 24'hffffff;
8'h44:  begin     
  if(r44_douta==0)
 Shuang_data<= 24'hffffff;
  else                             
  Shuang_data<= 0;   //图片RGB数据              
 end  
8'h45:  begin     
 if(r45_douta==0)
   Shuang_data<= 24'hffffff;
  else                             
  Shuang_data<= 0;   //图片RGB数据              
  end  
8'h46:  begin     
       if(r46_douta==0)
         Shuang_data<= 24'hffffff;
        else                             
        Shuang_data<= 0;   //图片RGB数据              
        end  
8'h47:  begin     
             if(r47_douta==0)
               Shuang_data<= 24'hffffff;
              else                             
              Shuang_data<= 0;   //图片RGB数据              
              end    
8'h48:  begin     
                              if(r48_douta==0)
                                Shuang_data<= 24'hffffff;
                               else                             
                               Shuang_data<= 0;   //图片RGB数据              
                               end   
8'h49:  begin     
if(r49_douta==0)
 Shuang_data<= 24'hffffff;
else                             
Shuang_data<= 0;   //图片RGB数据              
end   
8'h50:  begin     
   if(r50_douta==0)
  Shuang_data<= 24'hffffff;
   else                             
   Shuang_data<= 0;   //图片RGB数据              
  end 
8'h51: Shuang_data<= 24'hffffff;
8'h52:  Shuang_data<= 24'hffffff;
8'h53:  Shuang_data<= 24'hffffff;                                                                                                                                                                                                                                                                                                                                                                                                                                                            
  endcase                                                             
  else
  Shuang_data<= 24'hffffff;
end
/****************************回答正确******************************/
 /*       always @ (posedge clk) 
begin
 if( (Set_X == `origin_x1 - 10'd3) && (Set_Y == `origin_y1 ) &&  one_add )  //图片起始点 地址清0
     zheng_addra<= 15'd0;
 else if( one_add)  //图片生成位置
 zheng_addra = zheng_addra + 1'b1;
end*/
always @ (posedge clk) 
begin
 if( (Set_X == `origin_x2 - 10'd3) && (Set_Y == `origin_y2 ) &&  two_add )  //图片起始点 地址清0
     xiao_addra<= 15'd0;
 else if( two_add)  //图片生成位置
 xiao_addra = xiao_addra + 1'b1;
end

always @ (posedge clk)  //每个时钟上升沿赋值
begin   
   if(  one_en )
   begin
 
    if(two_en)
             begin
             if(xiao_douta==0)
             R_data<= 24'h00ff00;
             else
             R_data<= 24'h00ff00;   //图片RGB数据
             end                                     
   else
   
   R_data<= 24'hffffff;
end
end
/***************************************回答错误*******************************/

always @ (posedge clk) 
begin
if( (Set_X == `origin_x2 - 10'd3) && (Set_Y == `origin_y2 ) &&  two_add )  //图片起始点 地址清0
ku_addra<= 15'd0;
else if( two_add)  //图片生成位置
ku_addra = ku_addra + 1'b1;
end
always @ (posedge clk)  //每个时钟上升沿赋值
begin   
 if(two_en)
     begin
     if(ku_douta==0)
     W_data<= 24'hffffff;
     else
     W_data<= 0;   //图片RGB数据
     end                                         
else
W_data<= 24'hffffff;
end   


reg [24:0] n_data;
reg [24:0] s_data;
reg [24:0] w_data;
reg [24:0] e_data;

        reg [9:0]length=10'd490;
        reg [9:0]length2=10'd245;
        reg [9:0]length5=10'd98;
        reg [9:0]vvvbegin=10'd173;
        reg [9:0]hhhbegin=10'd562;     
 
       
 
        always @(posedge clk)//视标显示部分
        begin
        if(Single_Result==3'd1)
        RGB_Data <= R_data;
        else if(Single_Result==3'd2)
        RGB_Data <= W_data;
        else if(Single_Result==3'd3)
        RGB_Data <= Dan_data;
        else if(Single_Result==3'd4)
        RGB_Data <= Shuang_data;
        else if(Single_Result==3'd5)
        RGB_Data <= Kai_data;
        else
        begin
        case(eye)//视标大小
        4'd0:
        begin
                length<=10'd490;//边长7.26 3.7
                length2<=10'd245;
                length5<=10'd98;
                vvvbegin<=10'd173;
                hhhbegin<=10'd562;
               case(Direct)
               2'd0: RGB_Data <= n_data;//向上
               2'd1: RGB_Data <= s_data; //向下
               2'd2: RGB_Data <= w_data;//向左
               2'd3: RGB_Data <= e_data;//向右
               endcase
        end
        4'd1:
        begin
                length<=10'd390;//边长5.76  3.8
                length2<=10'd195;
                length5<=10'd78;
                vvvbegin<=10'd223;
                hhhbegin<=10'd632;
               case(Direct)
               2'd0: RGB_Data <= n_data;//向上
               2'd1: RGB_Data <= s_data; //向下
               2'd2: RGB_Data <= w_data;//向左
               2'd3: RGB_Data <= e_data;//向右
               endcase
        end
        4'd2:
        begin
                length<=10'd310;//边长4.58 3.9
                length2<=10'd155;
                length5<=10'd62;
                vvvbegin<=10'd263;
                hhhbegin<=10'd652;
               case(Direct)
               2'd0: RGB_Data <= n_data;//向上
               2'd1: RGB_Data <= s_data; //向下
               2'd2: RGB_Data <= w_data;//向左
               2'd3: RGB_Data <= e_data;//向右
               endcase
        end
        4'd3:
        begin
                length<=10'd250;//边长3.64  4.0
                length2<=10'd125;
                length5<=10'd50;
                vvvbegin<=10'd293;
                hhhbegin<=10'd682;
               case(Direct)
               2'd0: RGB_Data <= n_data;//向上
               2'd1: RGB_Data <= s_data; //向下
               2'd2: RGB_Data <= w_data;//向左
               2'd3: RGB_Data <= e_data;//向右
               endcase
        end
        4'd4:
        begin
                length<=10'd200;//边长2.89  4.1
                length2<=10'd100;
                length5<=10'd40;
                vvvbegin<=10'd318;
                hhhbegin<=10'd707;
               case(Direct)
               2'd0: RGB_Data <= n_data;//向上
               2'd1: RGB_Data <= s_data; //向下
               2'd2: RGB_Data <= w_data;//向左
               2'd3: RGB_Data <= e_data;//向右
               endcase
        end
        4'd5:
        begin
                length<=10'd160;//边长2.30  4.2
                length2<=10'd80;
                length5<=10'd32;
                vvvbegin<=10'd338;
                hhhbegin<=10'd727;
               case(Direct)
               2'd0: RGB_Data <= n_data;//向上
               2'd1: RGB_Data <= s_data; //向下
               2'd2: RGB_Data <= w_data;//向左
               2'd3: RGB_Data <= e_data;//向右
               endcase
        end
        4'd6:
        begin
                length<=10'd120;//边长1.82   4.3
                length2<=10'd60;
                length5<=10'd24;
                vvvbegin<=10'd358;
                hhhbegin<=10'd747;
               case(Direct)
               2'd0: RGB_Data <= n_data;//向上
               2'd1: RGB_Data <= s_data; //向下
               2'd2: RGB_Data <= w_data;//向左
               2'd3: RGB_Data <= e_data;//向右
               endcase
        end
        4'd7:
        begin
                length<=10'd100;//边长1.45 4.4
                length2<=10'd50;
                length5<=10'd20;
                vvvbegin<=10'd368;
                hhhbegin<=10'd757;
               case(Direct)
               2'd0: RGB_Data <= n_data;//向上
               2'd1: RGB_Data <= s_data; //向下
               2'd2: RGB_Data <= w_data;//向左
               2'd3: RGB_Data <= e_data;//向右
               endcase
        end
        4'd8:
        begin
                length<=10'd80;//边长1.15 4.5
                length2<=10'd40;
                length5<=10'd16;
                vvvbegin<=10'd378;
                hhhbegin<=10'd767;
               case(Direct)
               2'd0: RGB_Data <= n_data;//向上
               2'd1: RGB_Data <= s_data; //向下
               2'd2: RGB_Data <= w_data;//向左
               2'd3: RGB_Data <= e_data;//向右
               endcase
        end
        4'd9:
        begin
                length<=10'd60;//边长0.91  4.6
                length2<=10'd30;
                length5<=10'd12;
                vvvbegin<=10'd388;
                hhhbegin<=10'd777;
               case(Direct)
               2'd0: RGB_Data <= n_data;//向上
               2'd1: RGB_Data <= s_data; //向下
               2'd2: RGB_Data <= w_data;//向左
               2'd3: RGB_Data <= e_data;//向右
               endcase
        end
        4'd10:
        begin
                length<=10'd50;//边长0.73    4.7
                length2<=10'd25;
                length5<=10'd10;
                vvvbegin<=10'd393;
                hhhbegin<=10'd782;
               case(Direct)
               2'd0: RGB_Data <= n_data;//向上
               2'd1: RGB_Data <= s_data; //向下
               2'd2: RGB_Data <= w_data;//向左
               2'd3: RGB_Data <= e_data;//向右
               endcase
        end
        4'd11:
        begin
                length<=10'd40;//边长0.58  4.8
                length2<=10'd20;
                length5<=10'd8;
                vvvbegin<=10'd398;
                hhhbegin<=10'd787;
               case(Direct)
               2'd0: RGB_Data <= n_data;//向上
               2'd1: RGB_Data <= s_data; //向下
               2'd2: RGB_Data <= w_data;//向左
               2'd3: RGB_Data <= e_data;//向右
               endcase
        end
        4'd12:
        begin
                length<=10'd30;//边长0.46   4.9
                length2<=10'd15;
                length5<=10'd6;
                vvvbegin<=10'd403;
                hhhbegin<=10'd792;
               case(Direct)
               2'd0: RGB_Data <= n_data;//向上
               2'd1: RGB_Data <= s_data; //向下
               2'd2: RGB_Data <= w_data;//向左
               2'd3: RGB_Data <= e_data;//向右
               endcase
        end
        4'd13:
        begin
                length<=10'd25;//边长0.36   5.0
                length2<=10'd12;
                length5<=10'd5;
                vvvbegin<=10'd406;
                hhhbegin<=10'd795;
               case(Direct)
               2'd0: RGB_Data <= n_data;//向上
               2'd1: RGB_Data <= s_data; //向下
               2'd2: RGB_Data <= w_data;//向左
               2'd3: RGB_Data <= e_data;//向右
               endcase
        end
        endcase
        end
        end       
    
always @(posedge clk)//向上视标
        begin
         if(VSync_Cnt<(vvvbegin))
         n_data<=24'hffffff;//white
        else if(VSync_Cnt<(vvvbegin+length-length5))
                   begin
                   if(HSync_Cnt<hhhbegin)
                   n_data<=24'hffffff;
                   else if(HSync_Cnt<(hhhbegin+length5))
                   n_data<=3'h0;
                   else if(HSync_Cnt<(hhhbegin+length5+length5))
                   n_data<=24'hffffff;
                   else if(HSync_Cnt<(hhhbegin+length5+length5+length5))
                   n_data<=3'h0;
                   else if(HSync_Cnt<(hhhbegin+length5+length5+length5+length5))
                   n_data<=24'hffffff;
                   else if(HSync_Cnt<(hhhbegin+length5+length5+length5+length5+length5))
                   n_data<=3'h0;
                   else
                   n_data<=24'hffffff;
                   end
         else if(VSync_Cnt<(vvvbegin+length))
                   begin
                   if(HSync_Cnt<hhhbegin)
                   n_data<=24'hffffff;
                   else if(HSync_Cnt<(hhhbegin+length))
                   n_data<=3'h0;
                   else 
                   n_data<=24'hffffff;
                   end
        else
        n_data<=24'hffffff;
        end  
 always @(posedge clk)//向下视标
        begin
         if(VSync_Cnt<(vvvbegin))
         s_data<=24'hffffff;//white
         else if(VSync_Cnt<(vvvbegin+length5))
                   begin
                   if(HSync_Cnt<hhhbegin)
                   s_data<=24'hffffff;
                   else if(HSync_Cnt<(hhhbegin+length))
                   s_data<=3'h0;
                   else 
                   s_data<=24'hffffff;
                   end
        else if(VSync_Cnt<(vvvbegin+length))
                   begin
                   if(HSync_Cnt<hhhbegin)
                   s_data<=24'hffffff;
                   else if(HSync_Cnt<(hhhbegin+length5))
                   s_data<=3'h0;
                   else if(HSync_Cnt<(hhhbegin+length5+length5))
                   s_data<=24'hffffff;
                   else if(HSync_Cnt<(hhhbegin+length5+length5+length5))
                   s_data<=3'h0;
                   else if(HSync_Cnt<(hhhbegin+length5+length5+length5+length5))
                   s_data<=24'hffffff;
                   else if(HSync_Cnt<(hhhbegin+length5+length5+length5+length5+length5))
                   s_data<=3'h0;
                   else
                   s_data<=24'hffffff;
                   end
        else
        s_data<=24'hffffff;
        end
        always @(posedge clk)//向左视标
        begin
         if(HSync_Cnt<(hhhbegin))
         w_data<=24'hffffff;//white
        else if(HSync_Cnt<(hhhbegin+length-length5))
                   begin
                   if(VSync_Cnt<vvvbegin)
                   w_data<=24'hffffff;
                   else if(VSync_Cnt<(vvvbegin+length5))
                   w_data<=3'h0;
                   else if(VSync_Cnt<(vvvbegin+length5+length5))
                   w_data<=24'hffffff;
                   else if(VSync_Cnt<(vvvbegin+length5+length5+length5))
                   w_data<=3'h0;
                   else if(VSync_Cnt<(vvvbegin+length5+length5+length5+length5))
                   w_data<=24'hffffff;
                   else if(VSync_Cnt<(vvvbegin+length5+length5+length5+length5+length5))
                   w_data<=3'h0;
                   else
                   w_data<=24'hffffff;
                   end
         else if(HSync_Cnt<(hhhbegin+length))
                   begin
                   if(VSync_Cnt<vvvbegin)
                   w_data<=24'hffffff;
                   else if(VSync_Cnt<(vvvbegin+length))
                   w_data<=3'h0;
                   else 
                   w_data<=24'hffffff;
                   end
        else
        w_data<=24'hffffff;
        end
        always @(posedge clk)//向右视标
        begin
         if(HSync_Cnt<(hhhbegin))
         e_data<=24'hffffff;//white
         else if(HSync_Cnt<(hhhbegin+length5))
                   begin
                   if(VSync_Cnt<vvvbegin)
                   e_data<=24'hffffff;
                   else if(VSync_Cnt<(vvvbegin+length))
                   e_data<=3'h0;
                   else 
                   e_data<=24'hffffff;
                   end
        else if(HSync_Cnt<(hhhbegin+length))
                   begin
                   if(VSync_Cnt<vvvbegin)
                   e_data<=24'hffffff;
                   else if(VSync_Cnt<(vvvbegin+length5))
                   e_data<=3'h0;
                   else if(VSync_Cnt<(vvvbegin+length5+length5))
                   e_data<=24'hffffff;
                   else if(VSync_Cnt<(vvvbegin+length5+length5+length5))
                   e_data<=3'h0;
                   else if(VSync_Cnt<(vvvbegin+length5+length5+length5+length5))
                   e_data<=24'hffffff;
                   else if(VSync_Cnt<(vvvbegin+length5+length5+length5+length5+length5))
                   e_data<=3'h0;
                   else
                   e_data<=24'hffffff;
                   end
        else
        e_data<=24'hffffff;
        end     

endmodule

