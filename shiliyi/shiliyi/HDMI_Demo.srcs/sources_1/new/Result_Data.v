`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/30 16:21:44
// Design Name: 
// Module Name: Result_Data
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


module Result_Data(clk_100MHz,LR,Result,Data,flag2);
//输入输出
input clk_100MHz;
input [1:0]LR;
input [3:0]Result;
output[15:0]Data;
input [3:0]flag2;
//赋初值
reg [1:0] flag=00;
reg [15:0] Data=16'hffff;

always @(posedge clk_100MHz)
begin
   case(LR)
   2'b00:Data[15:0]<=16'hffff;  
   2'b01:begin
			 flag<=2'b01;
			 case(Result)
				  4'b0000:Data[7:0]<=8'h40;
				  4'b0001:Data[7:0]<=8'h41;
				  4'b0010:Data[7:0]<=8'h42;
				  4'b0011:Data[7:0]<=8'h43;
				  4'b0100:Data[7:0]<=8'h44;
				  4'b0101:Data[7:0]<=8'h45;
				  4'b0110:Data[7:0]<=8'h46;
				  4'b0111:Data[7:0]<=8'h47;
				  4'b1000:Data[7:0]<=8'h48;
				  4'b1001:Data[7:0]<=8'h49;
				  4'b1010:Data[7:0]<=8'h50;
				  4'b1011:Data[7:0]<=8'h51;
				  4'b1100:Data[7:0]<=8'h52;
				  4'b1101:Data[7:0]<=8'h53;
				  4'b1111:Data[7:0]<=8'hff;//初始情况，什么都不显示
		      default: Data<=Data;
			  endcase
		 end
   2'b10:begin
			 flag<=2'b10;
			 case(Result)
			  4'b0000:Data[15:8]<=8'h40;
			  4'b0001:Data[15:8]<=8'h41;
			  4'b0010:Data[15:8]<=8'h42;
			  4'b0011:Data[15:8]<=8'h43;
			  4'b0100:Data[15:8]<=8'h44;
			  4'b0101:Data[15:8]<=8'h45;
			  4'b0110:Data[15:8]<=8'h46;
			  4'b0111:Data[15:8]<=8'h47;
			  4'b1000:Data[15:8]<=8'h48;
			  4'b1001:Data[15:8]<=8'h49;
			  4'b1010:Data[15:8]<=8'h50;
			  4'b1011:Data[15:8]<=8'h51;
			  4'b1100:Data[15:8]<=8'h52;
			  4'b1101:Data[15:8]<=8'h53;
			  4'b1111:Data[15:8]<=8'hff;//初始情况，什么都不显示
			  default: Data<=Data;
			 endcase
		 end
   2'b11:begin
   if(flag2>=2'b10)
   begin
       
			 case(flag)
				 2'b01:
				     begin
					 case(Result)
					  4'b0000:Data[15:8]<=8'h40;
					  4'b0001:Data[15:8]<=8'h41;
					  4'b0010:Data[15:8]<=8'h42;
					  4'b0011:Data[15:8]<=8'h43;
					  4'b0100:Data[15:8]<=8'h44;
					  4'b0101:Data[15:8]<=8'h45;
					  4'b0110:Data[15:8]<=8'h46;
					  4'b0111:Data[15:8]<=8'h47;
					  4'b1000:Data[15:8]<=8'h48;
					  4'b1001:Data[15:8]<=8'h49;
					  4'b1010:Data[15:8]<=8'h50;
					  4'b1011:Data[15:8]<=8'h51;
					  4'b1100:Data[15:8]<=8'h52;
					  4'b1101:Data[15:8]<=8'h53;
					  4'b1111:Data[15:0]<=16'hffff;//初始情况，什么都不显示
					  default: Data<=Data;
					 endcase
		             end
				 2'b10:
					 begin
					 case(Result)
						  4'b0000:Data[7:0]<=8'h40;
						  4'b0001:Data[7:0]<=8'h41;
						  4'b0010:Data[7:0]<=8'h42;
						  4'b0011:Data[7:0]<=8'h43;
						  4'b0100:Data[7:0]<=8'h44;
						  4'b0101:Data[7:0]<=8'h45;
						  4'b0110:Data[7:0]<=8'h46;
						  4'b0111:Data[7:0]<=8'h47;
						  4'b1000:Data[7:0]<=8'h48;
						  4'b1001:Data[7:0]<=8'h49;
						  4'b1010:Data[7:0]<=8'h50;
						  4'b1011:Data[7:0]<=8'h51;
						  4'b1100:Data[7:0]<=8'h52;
						  4'b1101:Data[7:0]<=8'h53;
						  4'b1111:Data[15:0]<=16'hffff;//初始情况，什么都不显示
						  default: Data<=Data;
					  endcase
					  end
			default: Data<=Data;
					  
		     endcase    	 
		 end 
		 else Data<=Data;
		 end
	  default: Data<=Data;
      endcase
   
   end
  endmodule
