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
    input clk,                          //ʱ��
    input Rst,                         //��λ�ź�,�͵�ƽ��λ
    input [3:0]eye,
    input [1:0]Direct,
    input [2:0]Single_Result, 
    input [15:0]Data,
    input Video_Mode,                   //��Ƶ��ʽ
    input [23:0]RGB_In,                 //��������
    output reg [23:0]RGB_Data,              //�������
    output reg RGB_HSync=0,            //���ź�
    output reg RGB_VSync=0,            //���ź�
    output reg RGB_VDE=0,              //������Ч�ź�
    output reg [11:0]Set_X=0,          //ͼ������X
    output reg [11:0]Set_Y=0           //ͼ������Y
   
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
    
    reg [11:0]H_ACTIVE=0;   //����Ч���ȣ�����ʱ�����ڸ�����
    reg [11:0]H_FP=0;       //��ͬ��ǰ�糤��
    reg [11:0]H_SYNC=0;     //��ͬ������
    reg [11:0]H_BP=0;       //��ͬ����糤��
    reg [11:0]V_ACTIVE=0;   //����Ч���ȣ��еĸ�����
    reg [11:0]V_FP=0;       //��ͬ��ǰ�糤��
    reg [11:0]V_SYNC= 0;    //��ͬ������
    reg [11:0]V_BP=0;       //��ͬ����糤��
    reg [11:0]H_TOTAL=0;    //���ܳ���
    reg [11:0]V_TOTAL=0;    //���ܳ���
    
    //��,���źż���
    reg [11:0]HSync_Cnt=0;
    reg [11:0]VSync_Cnt=0;
    //��,����Ч�ź�
    reg H_De=0;
    reg V_De=0;
    
    //RGB�ź�����
 //   assign RGB_Data=RGB_In;
    //ͼ��X,Y�����ȡ
    always@(posedge clk or negedge Rst)
        begin
            //�͵�ƽ��λ
            if(!Rst)
                begin
                    Set_X<=0;
                    Set_Y<=0;
                end
            else
                begin
                    //���ź���Чʱ,��ʼ��ȡX����
                    if(HSync_Cnt>=H_FP + H_SYNC + H_BP - 1)
                        Set_X <= HSync_Cnt-(H_FP + H_SYNC + H_BP - 1);
                    //���ź���Чʱ,��ʼ��ȡY����
                    if(VSync_Cnt>=V_FP + V_SYNC + V_BP - 1)
                        Set_Y<=VSync_Cnt-(V_FP + V_SYNC + V_BP - 1);
                end
        end
    //ͼ���ʽ��ȡ
    always@(*)
        begin
            case(Video_Mode)
                `Video_Mode_1024_768:
                    begin
                        H_ACTIVE=H_ACTIVE_1024_768;   //����Ч���ȣ�����ʱ�����ڸ�����
                        H_FP=H_FP_1024_768;           //��ͬ��ǰ�糤��
                        H_SYNC=H_SYNC_1024_768;       //��ͬ������
                        H_BP=H_BP_1024_768;           //��ͬ����糤��
                        V_ACTIVE=V_ACTIVE_1024_768;   //����Ч���ȣ��еĸ�����
                        V_FP=V_FP_1024_768;           //��ͬ��ǰ�糤��
                        V_SYNC=V_SYNC_1024_768;       //��ͬ������
                        V_BP=V_BP_1024_768;           //��ͬ����糤��
                        H_TOTAL=H_TOTAL_1024_768;     //���ܳ���
                        V_TOTAL=V_TOTAL_1024_768;     //���ܳ���
                    end
                `Video_Mode_1280_720:
                    begin
                        H_ACTIVE=H_ACTIVE_1280_720;    //����Ч���ȣ�����ʱ�����ڸ�����
                        H_FP=H_FP_1280_720;            //��ͬ��ǰ�糤��
                        H_SYNC=H_SYNC_1280_720;        //��ͬ������
                        H_BP=H_BP_1280_720;            //��ͬ����糤��
                        V_ACTIVE=V_ACTIVE_1280_720;    //����Ч���ȣ��еĸ�����
                        V_FP=V_FP_1280_720;            //��ͬ��ǰ�糤��
                        V_SYNC=V_SYNC_1280_720;        //��ͬ������
                        V_BP=V_BP_1280_720;            //��ͬ����糤��
                        H_TOTAL=H_TOTAL_1280_720;      //���ܳ���
                        V_TOTAL=V_TOTAL_1280_720;      //���ܳ���
                    end
            endcase
        end
    //�м���
    always@(posedge clk or negedge Rst)
        begin
            //�͵�ƽ��λ
            if(!Rst)
                HSync_Cnt<=0;
            else
                begin
                    //�м��������ֵ����
                    if(HSync_Cnt==H_TOTAL-1)
                        HSync_Cnt<=0;
                    else
                        HSync_Cnt<=HSync_Cnt+1;
                end
        end
    //������
    always@(posedge clk or negedge Rst)
        begin
            //�͵�ƽ��λ
            if(!Rst)
                VSync_Cnt<=0;
            else
                begin
                    //�м�����H_FP-1ʱ,������
                    if(HSync_Cnt==H_FP-1)
                        begin
                            //�����������ֵ����
                            if(VSync_Cnt==V_TOTAL-1)
                                VSync_Cnt<=0;
                            else
                                VSync_Cnt<=VSync_Cnt+1;
                        end
                end
        end
    //���ź���Ч
    always@(posedge clk or negedge Rst)
        begin
            //�͵�ƽ��λ
            if(!Rst)
                H_De<=0;
            else
                begin
                    //�м�������һ������,���źſ�ʼ��Ч
                    if(HSync_Cnt==H_FP + H_SYNC + H_BP - 1)
                        H_De<=1;
                    //�м��������ֵ,���źſ�ʼ��Ч
                    else if(HSync_Cnt==H_TOTAL-1)
                        H_De<=0;                    
                end
        end
    //���ź���Ч
    always@(posedge clk or negedge Rst)
        begin
            //�͵�ƽ��λ
            if(!Rst)
                V_De<=0;
            else
                begin
                    //�м���ΪH_FP-1������ͬ����ʼʱ
                    if(HSync_Cnt==H_FP-1)
                        begin
                            //����������һ������,���ź���Ч
                            if(VSync_Cnt==V_FP + V_SYNC + V_BP - 1)
                                V_De<=1;
                            //�����������ֵ,���źſ�ʼ��Ч
                            else if(VSync_Cnt==V_TOTAL-1)
                                V_De<=0;
                        end    
                end
        end
    //������Ч�ź����
    always@(posedge clk or negedge Rst)
        begin
            //�͵�ƽ��λ
            if(!Rst)
                RGB_VDE<=0;
            else
                //������Ч�ź����
                RGB_VDE<=H_De&V_De;                
        end  
    //���ź����
    always@(posedge clk or negedge Rst)
        begin
            //�͵�ƽ��λ
            if(!Rst)
                RGB_HSync<=0;
            else
                begin
                    //��ͬ����ʼʱ,���źſ�ʼΪ��
                    if(HSync_Cnt==H_FP-1)
                        RGB_HSync<=1;
                    //��ͬ������ʱ,���źſ�ʼΪ��
                    else if(HSync_Cnt==H_FP + H_SYNC - 1)
                        RGB_HSync<=0;
                end                
        end   
    //���ź����
    always@(posedge clk or negedge Rst)           
        begin
            //�͵�ƽ��λ
            if(!Rst)
                RGB_VSync<=0;
            else
                begin
                    //��ͬ����ʼʱ
                    if(HSync_Cnt==H_FP-1)
                        begin
                            //��ͬ����ʼʱ,���ź�Ϊ��
                            if(VSync_Cnt==V_FP-1)
                                RGB_VSync<=1;
                            //��ͬ������ʱ,���źſ�ʼΪ��
                            else if(VSync_Cnt==V_FP + V_SYNC - 1)
                                RGB_VSync<=0;
                        end
                end
        end

/****************************ͼƬ�洢************************/
        `define shi_x 10'd100    //ͼƬ���
        `define shi_y 10'd100    //ͼƬ�߶�
        `define origin_x1  10'd270    //ͼƬ��ʾ��㣨x,y��
        `define origin_y1  10'd300
        `define origin_x2  10'd380    //ͼƬ��ʾ��㣨x,y��
        `define origin_y2  10'd300
        `define origin_x3  10'd490    //ͼƬ��ʾ��㣨x,y��
        `define origin_y3  10'd300
        `define origin_x4  10'd600    //ͼƬ��ʾ��㣨x,y��
        `define origin_y4  10'd300
        wire  one_add;    //ͼƬλ���ź�
        wire  one_en;    //ͼƬʹ���ź�
        wire  two_add;    //ͼƬλ���ź�
        wire  two_en;    //ͼƬʹ���ź�
        wire  three_add;    //ͼƬλ���ź�
        wire  three_en;    //ͼƬʹ���ź�
        wire  four_add;    //ͼƬλ���ź�
        wire  four_en;    //ͼƬʹ���ź�
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
/**********************************����λ��ȷ��********************************/  
                                                        
                //��ϵ�·,��������ͼƬλ���ź�
                assign  one_add = (Set_X >= `origin_x1 - 10'd3 ) && (Set_X < `origin_x1 + `shi_x - 10'd3 ) && (Set_Y >= `origin_y1) && (Set_Y < `origin_y1 + `shi_y); 
                //��ϵ�·,��������ͼƬʹ���ź�
                assign  one_en = (Set_X >= `origin_x1) && (Set_X < `origin_x1 + `shi_x) && (Set_Y >= `origin_y1) && (Set_Y < `origin_y1 + `shi_y);     
                //��ϵ�·,��������ͼƬλ���ź�
                assign  two_add = (Set_X >= `origin_x2 - 10'd3 ) && (Set_X < `origin_x2 + `shi_x - 10'd3 ) && (Set_Y >= `origin_y2) && (Set_Y < `origin_y1 + `shi_y); 
                //��ϵ�·,��������ͼƬʹ���ź�
                assign  two_en = (Set_X >= `origin_x2) && (Set_X < `origin_x2 + `shi_x) && (Set_Y >= `origin_y2) && (Set_Y < `origin_y2 + `shi_y);   
                //��ϵ�·,��������ͼƬλ���ź�
                assign  three_add = (Set_X >= `origin_x3 - 10'd3 ) && (Set_X < `origin_x3 + `shi_x - 10'd3 ) && (Set_Y >= `origin_y3) && (Set_Y < `origin_y3 + `shi_y); 
                 //��ϵ�·,��������ͼƬʹ���ź�
                assign  three_en = (Set_X >= `origin_x3) && (Set_X < `origin_x3 + `shi_x) && (Set_Y >= `origin_y3) && (Set_Y < `origin_y3 + `shi_y);     
                //��ϵ�·,��������ͼƬλ���ź�
                assign  four_add = (Set_X >= `origin_x4 - 10'd3 ) && (Set_X < `origin_x4 + `shi_x - 10'd3 ) && (Set_Y >= `origin_y4) && (Set_Y < `origin_y4 + `shi_y); 
                  //��ϵ�·,��������ͼƬʹ���ź�
                assign   four_en = (Set_X >= `origin_x4) && (Set_X < `origin_x4 + `shi_x) && (Set_Y >= `origin_y4) && (Set_Y < `origin_y4 + `shi_y);     
                
reg [24:0] R_data;
reg [24:0] W_data;
reg [24:0] Dan_data;
reg [24:0] Shuang_data;
reg [24:0] Kai_data;      
/********************************************���Կ�ʼ******************************************/ 

        always @ (posedge clk) 
        begin
                 if( (Set_X == `origin_x2 - 10'd3) && (Set_Y == `origin_y2 ) &&  two_add )  //ͼƬ��ʼ�� ��ַ��0
                     kai_addra<= 15'd0;
                 else if( two_add)  //ͼƬ����λ��
                 kai_addra = kai_addra + 1'b1;
        end
        always @ (posedge clk) 
        begin
                 if( (Set_X == `origin_x3 - 10'd3) && (Set_Y == `origin_y3 ) &&  three_add )  //ͼƬ��ʼ�� ��ַ��0
                     si_addra<= 15'd0;
                 else if( three_add)  //ͼƬ����λ��
                 si_addra = si_addra + 1'b1;
        end
 
        always @ (posedge clk)  //ÿ��ʱ�������ظ�ֵ
        begin   
                    if(two_en)
                             begin
                             if(kai_douta==0)
                             Kai_data<= 24'hffffff;
                             else
                             Kai_data<= 0;   //ͼƬRGB����
                             end
                   else if(three_en)
                                       begin
                                       if(si_douta==0)
                                       Kai_data<= 24'hffffff;
                                       else
                                       Kai_data<= 0;   //ͼƬRGB����
                                       end                                                         
                   else
                   Kai_data<= 24'hffffff;
          end
/***********************************�������***************************************/
    /*    always @ (posedge clk) 
begin
         if( (Set_X == `origin_x1 - 10'd3) && (Set_Y == `origin_y1 ) &&  one_add )  //ͼƬ��ʼ�� ��ַ��0
             dan_addra<= 15'd0;
         else if( one_add)  //ͼƬ����λ��
         dan_addra = dan_addra + 1'b1;
end
always @ (posedge clk) 
begin
         if( (Set_X == `origin_x2 - 10'd3) && (Set_Y == `origin_y2 ) &&  two_add )  //ͼƬ��ʼ�� ��ַ��0
             yan_addra<= 15'd0;
         else if( two_add)  //ͼƬ����λ��
         yan_addra = yan_addra + 1'b1;
end */
always @ (posedge clk) 
begin
         if( (Set_X == `origin_x3 - 10'd3) && (Set_Y == `origin_y3 ) &&  three_add )  //ͼƬ��ʼ�� ��ַ��0
             wan_addra<= 15'd0;
         else if( three_add)  //ͼƬ����λ��
         wan_addra = wan_addra + 1'b1;
end
/*always @ (posedge clk) 
begin
         if( (Set_X == `origin_x4 - 10'd3) && (Set_Y == `origin_y4 ) &&  four_add )  //ͼƬ��ʼ�� ��ַ��0
             cheng_addra<= 15'd0;
         else if( four_add)  //ͼƬ����λ��
         cheng_addra = cheng_addra + 1'b1;
end    */    
always @ (posedge clk)  //ÿ��ʱ�������ظ�ֵ
begin   

            if(three_en)
                               begin
                               if(wan_douta==0)
                               Dan_data<= 24'hffffff;
                               else
                               Dan_data<= 0;   //ͼƬRGB����
                               end                                                          
           else
           Dan_data<= 24'hffffff;
end

     
/*********************************************���Խ����ʾ����*************************************************/   
        `define rx1  10'd270    
        `define rx2  10'd380    
        `define rx3  10'd490    
        `define rx4  10'd600    
        `define ry1  10'd150
        `define ry2  10'd320 
        `define ry3  10'd420
        
        wire  add1;    //ͼƬλ���ź�
        wire  en1;    //ͼƬʹ���ź�     
        wire  add2;    //ͼƬλ���ź�
        wire  en2;    //ͼƬʹ���ź�    
        wire  add3;    //ͼƬλ���ź�
        wire  en3;    //ͼƬʹ���ź�    
        wire  add4;    //ͼƬλ���ź�
        wire  en4;    //ͼƬʹ���ź�    
        wire  add5;    //ͼƬλ���ź�
        wire  en5;    //ͼƬʹ���ź�  
        wire  add6;    //ͼƬλ���ź�
        wire  en6;    //ͼƬʹ���ź� 
        wire  add7;    //ͼƬλ���ź�
        wire  en7;    //ͼƬʹ���ź� 
        wire  add8;    //ͼƬλ���ź�
        wire  en8;    //ͼƬʹ���ź� 
        wire  add9;    //ͼƬλ���ź�
        wire  en9;    //ͼƬʹ���ź� 
        wire  add10;    //ͼƬλ���ź�
        wire  en10;    //ͼƬʹ���ź� 
        wire  add11;    //ͼƬλ���ź�
        wire  en11;    //ͼƬʹ���ź�   
        wire  add12;    //ͼƬλ���ź�
        wire  en12;    //ͼƬʹ���ź�                                    
         //��һ��      
                assign  add1 = (Set_X >= `rx1 - 10'd3 ) && (Set_X < `rx1 + `shi_x - 10'd3 ) && (Set_Y >= `ry1) && (Set_Y < `ry1 + `shi_y); 
                assign  en1 = (Set_X >= `rx1) && (Set_X < `rx1 + `shi_x) && (Set_Y >= `ry1) && (Set_Y < `ry1 + `shi_y);           
                assign  add2 = (Set_X >= `rx2 - 10'd3 ) && (Set_X < `rx2 + `shi_x - 10'd3 ) && (Set_Y >= `ry1) && (Set_Y < `ry1 + `shi_y);   
                assign  en2 = (Set_X >= `rx2) && (Set_X < `rx2 + `shi_x) && (Set_Y >= `ry1) && (Set_Y < `ry1 + `shi_y);      
                assign  add3 = (Set_X >= `rx3 - 10'd3 ) && (Set_X < `rx3 + `shi_x - 10'd3 ) && (Set_Y >= `ry1) && (Set_Y < `ry1 + `shi_y);      
                assign  en3 = (Set_X >= `rx3) && (Set_X < `rx3 + `shi_x) && (Set_Y >= `ry1) && (Set_Y < `ry1 + `shi_y);     
                assign  add4 = (Set_X >= `rx4 - 10'd3 ) && (Set_X < `rx4 + `shi_x - 10'd3 ) && (Set_Y >= `ry1) && (Set_Y < `ry1 + `shi_y); 
                assign  en4 = (Set_X >= `rx4) && (Set_X < `rx4 + `shi_x) && (Set_Y >= `ry1) && (Set_Y < `ry1 + `shi_y);      
        //�ڶ�����������
          assign  add5 = (Set_X >= `rx1 - 10'd3 ) && (Set_X < `rx1 + `shi_x - 10'd3 ) && (Set_Y >= `ry2) && (Set_Y < `ry2 + `shi_y); 
          assign  en5 = (Set_X >= `rx1) && (Set_X < `rx1 + `shi_x) && (Set_Y >= `ry2) && (Set_Y < `ry2 + `shi_y);           
          assign  add6 = (Set_X >= `rx2 - 10'd3 ) && (Set_X < `rx2 + `shi_x - 10'd3 ) && (Set_Y >= `ry2) && (Set_Y < `ry2 + `shi_y);   
          assign  en6 = (Set_X >= `rx2) && (Set_X < `rx2 + `shi_x) && (Set_Y >= `ry2) && (Set_Y < `ry2 + `shi_y);      
          assign  add7 = (Set_X >= `rx3 - 10'd3 ) && (Set_X < `rx3 + `shi_x - 10'd3 ) && (Set_Y >= `ry2) && (Set_Y < `ry2 + `shi_y);      
          assign  en7 = (Set_X >= `rx3) && (Set_X < `rx3 + `shi_x) && (Set_Y >= `ry2) && (Set_Y < `ry2 + `shi_y);     
          assign  add8 = (Set_X >= `rx4 - 10'd3 ) && (Set_X < `rx4 + `shi_x - 10'd3 ) && (Set_Y >= `ry2) && (Set_Y < `ry2 + `shi_y); 
          assign  en8 = (Set_X >= `rx4) && (Set_X < `rx4 + `shi_x) && (Set_Y >= `ry2) && (Set_Y < `ry2 + `shi_y);          
          //��������������
            assign  add9 = (Set_X >= `rx1 - 10'd3 ) && (Set_X < `rx1 + `shi_x - 10'd3 ) && (Set_Y >= `ry3) && (Set_Y < `ry3 + `shi_y); 
            assign  en9 = (Set_X >= `rx1) && (Set_X < `rx1 + `shi_x) && (Set_Y >= `ry1) && (Set_Y < `ry3 + `shi_y);           
            assign  add10 = (Set_X >= `rx2 - 10'd3 ) && (Set_X < `rx2 + `shi_x - 10'd3 ) && (Set_Y >= `ry3) && (Set_Y < `ry3 + `shi_y);   
            assign  en10 = (Set_X >= `rx2) && (Set_X < `rx2 + `shi_x) && (Set_Y >= `ry3) && (Set_Y < `ry3 + `shi_y);      
            assign  add11 = (Set_X >= `rx3 - 10'd3 ) && (Set_X < `rx3 + `shi_x - 10'd3 ) && (Set_Y >= `ry3) && (Set_Y < `ry3 + `shi_y);      
            assign  en11 = (Set_X >= `rx3) && (Set_X < `rx3 + `shi_x) && (Set_Y >= `ry3) && (Set_Y < `ry3 + `shi_y);     
            assign  add12 = (Set_X >= `rx4 - 10'd3 ) && (Set_X < `rx4 + `shi_x - 10'd3 ) && (Set_Y >= `ry3) && (Set_Y < `ry3 + `shi_y); 
            assign  en12 = (Set_X >= `rx4) && (Set_X < `rx4 + `shi_x) && (Set_Y >= `ry3) && (Set_Y < `ry3 + `shi_y);          
   /**********************************��������洢****************************************/ 
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

/*************************************�������****************************************/
/* always @ (posedge clk) 
begin
if( (Set_X == `rx1 - 10'd3) && (Set_Y == `ry1 ) &&  add1 )  //ͼƬ��ʼ�� ��ַ��0
ce2_addra<= 15'd0;
else if( add1)  //ͼƬ����λ��
ce2_addra = ce2_addra + 1'b1;
end
always @ (posedge clk) 
begin
if( (Set_X == `rx2 - 10'd3) && (Set_Y == `ry1 ) &&  add2 )  //ͼƬ��ʼ�� ��ַ��0
shi2_addra<= 15'd0;
else if( add2)  //ͼƬ����λ��
shi2_addra = shi2_addra + 1'b1;
end
always @ (posedge clk) 
begin
if( (Set_X == `rx3 - 10'd3) && (Set_Y == `ry1 ) &&  add3 )  //ͼƬ��ʼ�� ��ַ��0
wan2_addra<= 15'd0;
else if( add3)  //ͼƬ����λ��
wan2_addra = wan2_addra + 1'b1;
end
always @ (posedge clk) 
begin
if( (Set_X == `rx4 - 10'd3) && (Set_Y == `ry1 ) &&  add4 )  //ͼƬ��ʼ�� ��ַ��0
cheng2_addra<= 15'd0;
else if( add4)  //ͼƬ����λ��
cheng2_addra = cheng2_addra + 1'b1;
end               
*/
//��������
 /*always @ (posedge clk) 
begin
if( (Set_X == `rx1 - 10'd3) && (Set_Y == `ry2 ) &&  add5 )  //ͼƬ��ʼ�� ��ַ��0
zuo_addra<= 15'd0;
else if( add5)  //ͼƬ����λ��
zuo_addra = zuo_addra + 1'b1;
end
always @ (posedge clk) 
begin
if( (Set_X == `rx2 - 10'd3) && (Set_Y == `ry2 ) &&  add6 )  //ͼƬ��ʼ�� ��ַ��0
yanl_addra<= 15'd0;
else if( add6)  //ͼƬ����λ��
yanl_addra = yanl_addra + 1'b1;
end
always @ (posedge clk) 
begin
if( (Set_X == `rx3 - 10'd3) && (Set_Y == `ry2 ) &&  add7 )  //ͼƬ��ʼ�� ��ַ��0
wei_addra<= 15'd0;
else if( add7)  //ͼƬ����λ��
wei_addra = wei_addra + 1'b1;
end*/
always @ (posedge clk) 
begin
if( (Set_X == `rx4 - 10'd3) && (Set_Y == `ry2 ) &&  add8 )  //ͼƬ��ʼ�� ��ַ��0
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
else if( add8)  //ͼƬ����λ��
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
//��������
/* always @ (posedge clk) 
begin
if( (Set_X == `rx1 - 10'd3) && (Set_Y == `ry3 ) &&  add9 )  //ͼƬ��ʼ�� ��ַ��0
you_addra<= 15'd0;
else if( add9)  //ͼƬ����λ��
you_addra = you_addra + 1'b1;
end
always @ (posedge clk) 
begin
if( (Set_X == `rx2 - 10'd3) && (Set_Y == `ry3 ) &&  add10 )  //ͼƬ��ʼ�� ��ַ��0
yanr_addra<= 15'd0;
else if( add10)  //ͼƬ����λ��
yanr_addra = yanr_addra + 1'b1;
end
always @ (posedge clk) 
begin
if( (Set_X == `rx3 - 10'd3) && (Set_Y == `ry3 ) &&  add11 )  //ͼƬ��ʼ�� ��ַ��0
wei2_addra<= 15'd0;
else if( add11)  //ͼƬ����λ��
wei2_addra = wei2_addra + 1'b1;
end*/
always @ (posedge clk) 
begin
if( (Set_X == `rx4 - 10'd3) && (Set_Y == `ry3 ) &&  add12 )  //ͼƬ��ʼ�� ��ַ��0
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
else if( add12)  //ͼƬ����λ��
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
always @ (posedge clk)  //ÿ��ʱ�������ظ�ֵ
begin   
  /* if(  en1 )
   begin
   if(ce2_douta==0)
   Shuang_data<= 24'hffffff;
   else
   Shuang_data<= 0;   //ͼƬRGB����
   end
   else if(en2)
             begin
             if(shi2_douta==0)
             Shuang_data<= 24'hffffff;
             else
             Shuang_data<= 0;   //ͼƬRGB����
             end
   else if(en3)
                       begin
                       if(wan2_douta==0)
                       Shuang_data<= 24'hffffff;
                       else
                       Shuang_data<= 0;   //ͼƬRGB����
                       end
   else if(en4)
                                 begin
                                 if(cheng2_douta==0)
                                 Shuang_data<= 24'hffffff;
                                 else
                                 Shuang_data<= 0;   //ͼƬRGB����
                                 end                                                            
*/

 /*  if( en5 )
  begin
  if(zuo_douta==0)
  Shuang_data<= 24'hffffff;
  else
  Shuang_data<= 0;   //ͼƬRGB����
  end
  else if(en6)
            begin
            if(yanl_douta==0)
            Shuang_data<= 24'hffffff;
            else
            Shuang_data<= 0;   //ͼƬRGB����
            end
  else if(en7)
                      begin
                      if(wei_douta==0)
                      Shuang_data<= 24'hffffff;
                      else
                      Shuang_data<= 0;   //ͼƬRGB����
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
                Shuang_data<= 0;   //ͼƬRGB����              
               end  
           8'h45:  begin     
               if(l45_douta==0)
                 Shuang_data<= 24'hffffff;
                else                             
                Shuang_data<= 0;   //ͼƬRGB����              
                end  
          8'h46:  begin     
                     if(l46_douta==0)
                       Shuang_data<= 24'hffffff;
                      else                             
                      Shuang_data<= 0;   //ͼƬRGB����              
                      end  
           8'h47:  begin     
                           if(l47_douta==0)
                             Shuang_data<= 24'hffffff;
                            else                             
                            Shuang_data<= 0;   //ͼƬRGB����              
                            end    
           8'h48:  begin     
                                            if(l48_douta==0)
                                              Shuang_data<= 24'hffffff;
                                             else                             
                                             Shuang_data<= 0;   //ͼƬRGB����              
                                             end   
         8'h49:  begin     
             if(l49_douta==0)
               Shuang_data<= 24'hffffff;
             else                             
           Shuang_data<= 0;   //ͼƬRGB����              
            end   
             8'h50:  begin     
                 if(l50_douta==0)
                Shuang_data<= 24'hffffff;
                 else                             
                 Shuang_data<= 0;   //ͼƬRGB����              
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
  Shuang_data<= 0;   //ͼƬRGB����
  end
  else if(en10)
            begin
            if(yanr_douta==0)
            Shuang_data<= 24'hffffff;
            else
            Shuang_data<= 0;   //ͼƬRGB����
            end
  else if(en11)
                      begin
                      if(wei2_douta==0)
                      Shuang_data<= 24'hffffff;
                      else
                      Shuang_data<= 0;   //ͼƬRGB����
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
  Shuang_data<= 0;   //ͼƬRGB����              
 end  
8'h45:  begin     
 if(r45_douta==0)
   Shuang_data<= 24'hffffff;
  else                             
  Shuang_data<= 0;   //ͼƬRGB����              
  end  
8'h46:  begin     
       if(r46_douta==0)
         Shuang_data<= 24'hffffff;
        else                             
        Shuang_data<= 0;   //ͼƬRGB����              
        end  
8'h47:  begin     
             if(r47_douta==0)
               Shuang_data<= 24'hffffff;
              else                             
              Shuang_data<= 0;   //ͼƬRGB����              
              end    
8'h48:  begin     
                              if(r48_douta==0)
                                Shuang_data<= 24'hffffff;
                               else                             
                               Shuang_data<= 0;   //ͼƬRGB����              
                               end   
8'h49:  begin     
if(r49_douta==0)
 Shuang_data<= 24'hffffff;
else                             
Shuang_data<= 0;   //ͼƬRGB����              
end   
8'h50:  begin     
   if(r50_douta==0)
  Shuang_data<= 24'hffffff;
   else                             
   Shuang_data<= 0;   //ͼƬRGB����              
  end 
8'h51: Shuang_data<= 24'hffffff;
8'h52:  Shuang_data<= 24'hffffff;
8'h53:  Shuang_data<= 24'hffffff;                                                                                                                                                                                                                                                                                                                                                                                                                                                            
  endcase                                                             
  else
  Shuang_data<= 24'hffffff;
end
/****************************�ش���ȷ******************************/
 /*       always @ (posedge clk) 
begin
 if( (Set_X == `origin_x1 - 10'd3) && (Set_Y == `origin_y1 ) &&  one_add )  //ͼƬ��ʼ�� ��ַ��0
     zheng_addra<= 15'd0;
 else if( one_add)  //ͼƬ����λ��
 zheng_addra = zheng_addra + 1'b1;
end*/
always @ (posedge clk) 
begin
 if( (Set_X == `origin_x2 - 10'd3) && (Set_Y == `origin_y2 ) &&  two_add )  //ͼƬ��ʼ�� ��ַ��0
     xiao_addra<= 15'd0;
 else if( two_add)  //ͼƬ����λ��
 xiao_addra = xiao_addra + 1'b1;
end

always @ (posedge clk)  //ÿ��ʱ�������ظ�ֵ
begin   
   if(  one_en )
   begin
 
    if(two_en)
             begin
             if(xiao_douta==0)
             R_data<= 24'h00ff00;
             else
             R_data<= 24'h00ff00;   //ͼƬRGB����
             end                                     
   else
   
   R_data<= 24'hffffff;
end
end
/***************************************�ش����*******************************/

always @ (posedge clk) 
begin
if( (Set_X == `origin_x2 - 10'd3) && (Set_Y == `origin_y2 ) &&  two_add )  //ͼƬ��ʼ�� ��ַ��0
ku_addra<= 15'd0;
else if( two_add)  //ͼƬ����λ��
ku_addra = ku_addra + 1'b1;
end
always @ (posedge clk)  //ÿ��ʱ�������ظ�ֵ
begin   
 if(two_en)
     begin
     if(ku_douta==0)
     W_data<= 24'hffffff;
     else
     W_data<= 0;   //ͼƬRGB����
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
 
       
 
        always @(posedge clk)//�ӱ���ʾ����
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
        case(eye)//�ӱ��С
        4'd0:
        begin
                length<=10'd490;//�߳�7.26 3.7
                length2<=10'd245;
                length5<=10'd98;
                vvvbegin<=10'd173;
                hhhbegin<=10'd562;
               case(Direct)
               2'd0: RGB_Data <= n_data;//����
               2'd1: RGB_Data <= s_data; //����
               2'd2: RGB_Data <= w_data;//����
               2'd3: RGB_Data <= e_data;//����
               endcase
        end
        4'd1:
        begin
                length<=10'd390;//�߳�5.76  3.8
                length2<=10'd195;
                length5<=10'd78;
                vvvbegin<=10'd223;
                hhhbegin<=10'd632;
               case(Direct)
               2'd0: RGB_Data <= n_data;//����
               2'd1: RGB_Data <= s_data; //����
               2'd2: RGB_Data <= w_data;//����
               2'd3: RGB_Data <= e_data;//����
               endcase
        end
        4'd2:
        begin
                length<=10'd310;//�߳�4.58 3.9
                length2<=10'd155;
                length5<=10'd62;
                vvvbegin<=10'd263;
                hhhbegin<=10'd652;
               case(Direct)
               2'd0: RGB_Data <= n_data;//����
               2'd1: RGB_Data <= s_data; //����
               2'd2: RGB_Data <= w_data;//����
               2'd3: RGB_Data <= e_data;//����
               endcase
        end
        4'd3:
        begin
                length<=10'd250;//�߳�3.64  4.0
                length2<=10'd125;
                length5<=10'd50;
                vvvbegin<=10'd293;
                hhhbegin<=10'd682;
               case(Direct)
               2'd0: RGB_Data <= n_data;//����
               2'd1: RGB_Data <= s_data; //����
               2'd2: RGB_Data <= w_data;//����
               2'd3: RGB_Data <= e_data;//����
               endcase
        end
        4'd4:
        begin
                length<=10'd200;//�߳�2.89  4.1
                length2<=10'd100;
                length5<=10'd40;
                vvvbegin<=10'd318;
                hhhbegin<=10'd707;
               case(Direct)
               2'd0: RGB_Data <= n_data;//����
               2'd1: RGB_Data <= s_data; //����
               2'd2: RGB_Data <= w_data;//����
               2'd3: RGB_Data <= e_data;//����
               endcase
        end
        4'd5:
        begin
                length<=10'd160;//�߳�2.30  4.2
                length2<=10'd80;
                length5<=10'd32;
                vvvbegin<=10'd338;
                hhhbegin<=10'd727;
               case(Direct)
               2'd0: RGB_Data <= n_data;//����
               2'd1: RGB_Data <= s_data; //����
               2'd2: RGB_Data <= w_data;//����
               2'd3: RGB_Data <= e_data;//����
               endcase
        end
        4'd6:
        begin
                length<=10'd120;//�߳�1.82   4.3
                length2<=10'd60;
                length5<=10'd24;
                vvvbegin<=10'd358;
                hhhbegin<=10'd747;
               case(Direct)
               2'd0: RGB_Data <= n_data;//����
               2'd1: RGB_Data <= s_data; //����
               2'd2: RGB_Data <= w_data;//����
               2'd3: RGB_Data <= e_data;//����
               endcase
        end
        4'd7:
        begin
                length<=10'd100;//�߳�1.45 4.4
                length2<=10'd50;
                length5<=10'd20;
                vvvbegin<=10'd368;
                hhhbegin<=10'd757;
               case(Direct)
               2'd0: RGB_Data <= n_data;//����
               2'd1: RGB_Data <= s_data; //����
               2'd2: RGB_Data <= w_data;//����
               2'd3: RGB_Data <= e_data;//����
               endcase
        end
        4'd8:
        begin
                length<=10'd80;//�߳�1.15 4.5
                length2<=10'd40;
                length5<=10'd16;
                vvvbegin<=10'd378;
                hhhbegin<=10'd767;
               case(Direct)
               2'd0: RGB_Data <= n_data;//����
               2'd1: RGB_Data <= s_data; //����
               2'd2: RGB_Data <= w_data;//����
               2'd3: RGB_Data <= e_data;//����
               endcase
        end
        4'd9:
        begin
                length<=10'd60;//�߳�0.91  4.6
                length2<=10'd30;
                length5<=10'd12;
                vvvbegin<=10'd388;
                hhhbegin<=10'd777;
               case(Direct)
               2'd0: RGB_Data <= n_data;//����
               2'd1: RGB_Data <= s_data; //����
               2'd2: RGB_Data <= w_data;//����
               2'd3: RGB_Data <= e_data;//����
               endcase
        end
        4'd10:
        begin
                length<=10'd50;//�߳�0.73    4.7
                length2<=10'd25;
                length5<=10'd10;
                vvvbegin<=10'd393;
                hhhbegin<=10'd782;
               case(Direct)
               2'd0: RGB_Data <= n_data;//����
               2'd1: RGB_Data <= s_data; //����
               2'd2: RGB_Data <= w_data;//����
               2'd3: RGB_Data <= e_data;//����
               endcase
        end
        4'd11:
        begin
                length<=10'd40;//�߳�0.58  4.8
                length2<=10'd20;
                length5<=10'd8;
                vvvbegin<=10'd398;
                hhhbegin<=10'd787;
               case(Direct)
               2'd0: RGB_Data <= n_data;//����
               2'd1: RGB_Data <= s_data; //����
               2'd2: RGB_Data <= w_data;//����
               2'd3: RGB_Data <= e_data;//����
               endcase
        end
        4'd12:
        begin
                length<=10'd30;//�߳�0.46   4.9
                length2<=10'd15;
                length5<=10'd6;
                vvvbegin<=10'd403;
                hhhbegin<=10'd792;
               case(Direct)
               2'd0: RGB_Data <= n_data;//����
               2'd1: RGB_Data <= s_data; //����
               2'd2: RGB_Data <= w_data;//����
               2'd3: RGB_Data <= e_data;//����
               endcase
        end
        4'd13:
        begin
                length<=10'd25;//�߳�0.36   5.0
                length2<=10'd12;
                length5<=10'd5;
                vvvbegin<=10'd406;
                hhhbegin<=10'd795;
               case(Direct)
               2'd0: RGB_Data <= n_data;//����
               2'd1: RGB_Data <= s_data; //����
               2'd2: RGB_Data <= w_data;//����
               2'd3: RGB_Data <= e_data;//����
               endcase
        end
        endcase
        end
        end       
    
always @(posedge clk)//�����ӱ�
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
 always @(posedge clk)//�����ӱ�
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
        always @(posedge clk)//�����ӱ�
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
        always @(posedge clk)//�����ӱ�
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

