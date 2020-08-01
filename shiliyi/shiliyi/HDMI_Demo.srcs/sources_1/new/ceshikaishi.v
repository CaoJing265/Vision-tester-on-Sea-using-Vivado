`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/26 18:35:43
// Design Name: 
// Module Name: ceshikaishi
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


module ceshikaishi(
  input clk,
  input RGB_VDE,
  input [11:0]Set_X,
  input [11:0]Set_Y,
  output reg[23:0]RGB_Data=24'hffff00    //RBG
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
        wire  three_add;    //ͼƬλ���ź�
        wire  three_en;    //ͼƬʹ���ź�
        wire  four_add;    //ͼƬλ���ź�
        wire  four_en;    //ͼƬʹ���ź�
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
        //��ϵ�·,��������ͼƬλ���ź�
        assign  one_add = (Set_X >= `origin_x1 - 10'd3 ) && (Set_X < `origin_x1 + `shi_x - 10'd3 ) && (Set_Y >= `origin_y1) && (Set_Y < `origin_y1 + `shi_y); 
        //��ϵ�·,��������ͼƬʹ���ź�
        assign      one_en = (Set_X >= `origin_x1) && (Set_X < `origin_x1 + `shi_x) && (Set_Y >= `origin_y1) && (Set_Y < `origin_y1 + `shi_y);     
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
        always @ (posedge clk) 
        begin
                 if( (Set_X == `origin_x3 - 10'd3) && (Set_Y == `origin_y3 ) &&  three_add )  //ͼƬ��ʼ�� ��ַ��0
                     kai_addra<= 15'd0;
                 else if( three_add)  //ͼƬ����λ��
                 kai_addra = kai_addra + 1'b1;
        end
        always @ (posedge clk) 
        begin
                 if( (Set_X == `origin_x4 - 10'd3) && (Set_Y == `origin_y4 ) &&  four_add )  //ͼƬ��ʼ�� ��ַ��0
                     si_addra<= 15'd0;
                 else if( four_add)  //ͼƬ����λ��
                 si_addra = si_addra + 1'b1;
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
                   else if(three_en)
                                       begin
                                       if(kai_douta==0)
                                       RGB_Data<= 24'hffffff;
                                       else
                                       RGB_Data<= 0;   //ͼƬRGB����
                                       end
                   else if(four_en)
                                                 begin
                                                 if(si_douta==0)
                                                 RGB_Data<= 24'hffffff;
                                                 else
                                                 RGB_Data<= 0;   //ͼƬRGB����
                                                 end                                                            
                   else
                   RGB_Data<= 24'hffffff;
        end

endmodule
