//随即方向模块
module random_number(start_Sig,clk_100MHz,Done_Sig,Direct_Ran);
input start_Sig;    //随机数采集开始信号
input clk_100MHz;          //时钟信号
//input rst_n;        //复位信号
output Done_Sig;    //随机数完成信号
output[1:0] Direct_Ran;  //随机信号方向 00，01，10，11表示四个方向
//output[3:0]disp;
reg[4:0]disp=4'b0011;
reg Done_Sig=0;
reg [1:0]Direct_Ran;
reg [3:0]i=0;

always@(posedge clk_100MHz)
   begin
 //  if (start_Sig==1) 
 //  begin 
  //      Direct_Ran<=disp[1:0];
 //       Done_Sig<=1;
 //  end
 //  else
 //  begin
        disp <= {disp[2:0],disp[3]};  //四位循环的寄存器
        Done_Sig<=0;
 //  end
   end
always@(posedge start_Sig)
   begin
        Direct_Ran<=disp[1:0];
        Done_Sig<=1;
   end
endmodule