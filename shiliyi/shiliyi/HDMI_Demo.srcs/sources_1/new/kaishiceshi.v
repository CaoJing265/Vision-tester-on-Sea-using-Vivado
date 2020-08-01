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
   input clk,                          //时钟     
   input [2:0]Single_Result, 
   output reg [23:0]RGB_Data,              //输出数据
   input  [11:0]Set_X,          //图像坐标X
   input  [11:0]Set_Y           //图像坐标Y
    );
    
    `define shi_x 10'd100    //图片宽度
    `define shi_y 10'd100    //图片高度
    `define origin_x1  10'd270    //图片显示起点（x,y）
    `define origin_y1  10'd290
    `define origin_x2  10'd380    //图片显示起点（x,y）
    `define origin_y2  10'd290
    `define origin_x3  10'd490    //图片显示起点（x,y）
    `define origin_y3  10'd290
    `define origin_x4  10'd600    //图片显示起点（x,y）
    `define origin_y4  10'd290
    wire  one_add;    //图片位置信号
    wire  one_en;    //图片使能信号
    wire  two_add;    //图片位置信号
    wire  two_en;    //图片使能信号
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
    //组合电路,用于生成图片位置信号
    assign  one_add = (Set_X >= `origin_x1 - 10'd3 ) && (Set_X < `origin_x1 + `shi_x - 10'd3 ) && (Set_Y >= `origin_y1) && (Set_Y < `origin_y1 + `shi_y); 
    //组合电路,用于生成图片使能信号
    assign      one_en = (Set_X >= `origin_x1) && (Set_X < `origin_x1 + `shi_x) && (Set_Y >= `origin_y1) && (Set_Y < `origin_y1 + `shi_y);     
    //组合电路,用于生成图片位置信号
    assign  two_add = (Set_X >= `origin_x2 - 10'd3 ) && (Set_X < `origin_x2 + `shi_x - 10'd3 ) && (Set_Y >= `origin_y2) && (Set_Y < `origin_y1 + `shi_y); 
    //组合电路,用于生成图片使能信号
    assign      two_en = (Set_X >= `origin_x2) && (Set_X < `origin_x2 + `shi_x) && (Set_Y >= `origin_y2) && (Set_Y < `origin_y2 + `shi_y);     
    //时序电路，用来给寄存器赋值
    always @ (posedge clk) 
    begin
             if( (Set_X == `origin_x1 - 10'd3) && (Set_Y == `origin_y1 ) &&  one_add )  //图片起始点 地址清0
                 ce_addra<= 15'd0;
             else if( one_add)  //图片生成位置
             ce_addra = ce_addra + 1'b1;
    end
    always @ (posedge clk) 
    begin
             if( (Set_X == `origin_x2 - 10'd3) && (Set_Y == `origin_y2 ) &&  two_add )  //图片起始点 地址清0
                 shi_addra<= 15'd0;
             else if( two_add)  //图片生成位置
             shi_addra = shi_addra + 1'b1;
    end
    always @ (posedge clk)  //每个时钟上升沿赋值
    begin   
               if(  one_en )
               begin
               if(ce_douta==0)
               RGB_Data<= 24'hffffff;
               else
               RGB_Data<= 0;   //图片RGB数据
               end
               else if(two_en)
                         begin
                         if(shi_douta==0)
                         RGB_Data<= 24'hffffff;
                         else
                         RGB_Data<= 0;   //图片RGB数据
                         end
               else
               RGB_Data<= 24'hffffff;
    end

endmodule
