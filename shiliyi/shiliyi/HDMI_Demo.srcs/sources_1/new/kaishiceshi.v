`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/26 16:34:01
// Design Name: 
// Module Name: kaishiceshi
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


module kaishiceshi(
   input clk,                          //ʱ��     
   input [2:0]Single_Result, 
   output reg [23:0]RGB_Data,              //�������
   input  [11:0]Set_X,          //ͼ������X
   input  [11:0]Set_Y           //ͼ������Y
    );
    
    `define shi_x 10'd100    //ͼƬ���
    `define shi_y 10'd100    //ͼƬ�߶�
    `define origin_x1  10'd270    //ͼƬ��ʾ��㣨x,y��
    `define origin_y1  10'd290
    `define origin_x2  10'd380    //ͼƬ��ʾ��㣨x,y��
    `define origin_y2  10'd290
    `define origin_x3  10'd490    //ͼƬ��ʾ��㣨x,y��
    `define origin_y3  10'd290
    `define origin_x4  10'd600    //ͼƬ��ʾ��㣨x,y��
    `define origin_y4  10'd290
    wire  one_add;    //ͼƬλ���ź�
    wire  one_en;    //ͼƬʹ���ź�
    wire  two_add;    //ͼƬλ���ź�
    wire  two_en;    //ͼƬʹ���ź�
    reg [13 : 0] shi_addra;
    wire [0 : 0] shi_douta;
    shi_rom shi (
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
    );
    //��ϵ�·,��������ͼƬλ���ź�
    assign  one_add = (Set_X >= `origin_x1 - 10'd3 ) && (Set_X < `origin_x1 + `shi_x - 10'd3 ) && (Set_Y >= `origin_y1) && (Set_Y < `origin_y1 + `shi_y); 
    //��ϵ�·,��������ͼƬʹ���ź�
    assign      one_en = (Set_X >= `origin_x1) && (Set_X < `origin_x1 + `shi_x) && (Set_Y >= `origin_y1) && (Set_Y < `origin_y1 + `shi_y);     
    //��ϵ�·,��������ͼƬλ���ź�
    assign  two_add = (Set_X >= `origin_x2 - 10'd3 ) && (Set_X < `origin_x2 + `shi_x - 10'd3 ) && (Set_Y >= `origin_y2) && (Set_Y < `origin_y1 + `shi_y); 
    //��ϵ�·,��������ͼƬʹ���ź�
    assign      two_en = (Set_X >= `origin_x2) && (Set_X < `origin_x2 + `shi_x) && (Set_Y >= `origin_y2) && (Set_Y < `origin_y2 + `shi_y);     
    //ʱ���·���������Ĵ�����ֵ
    always @ (posedge clk) 
    begin
             if( (Set_X == `origin_x1 - 10'd3) && (Set_Y == `origin_y1 ) &&  one_add )  //ͼƬ��ʼ�� ��ַ��0
                 ce_addra<= 15'd0;
             else if( one_add)  //ͼƬ����λ��
             ce_addra = ce_addra + 1'b1;
    end
    always @ (posedge clk) 
    begin
             if( (Set_X == `origin_x2 - 10'd3) && (Set_Y == `origin_y2 ) &&  two_add )  //ͼƬ��ʼ�� ��ַ��0
                 shi_addra<= 15'd0;
             else if( two_add)  //ͼƬ����λ��
             shi_addra = shi_addra + 1'b1;
    end
    always @ (posedge clk)  //ÿ��ʱ�������ظ�ֵ
    begin   
               if(  one_en )
               begin
               if(ce_douta==0)
               RGB_Data<= 24'hffffff;
               else
               RGB_Data<= 0;   //ͼƬRGB����
               end
               else if(two_en)
                         begin
                         if(shi_douta==0)
                         RGB_Data<= 24'hffffff;
                         else
                         RGB_Data<= 0;   //ͼƬRGB����
                         end
               else
               RGB_Data<= 24'hffffff;
    end

endmodule
