`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/31 20:31:13
// Design Name: 
// Module Name: wendu
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


module wendu(Clk, xz, En, nRst,DQ,en,rst_n,RCLK,SRCLK,SER);

		input Clk; //ʱ�����Ŷ���
		input En;  //�¶�ʹ�ܶ����Ŷ���  T1
		input en; //�����ʹ��
		input rst_n;//�����rst
		input nRst; //��λ�����Ŷ��� U1
		input xz; //��������ʹ�� W2
		inout DQ; //�����������Ŷ���
		
		output RCLK;
		output SRCLK;
		output SER;
	//    output [3:0]sm_wei;
     //   output [7:0]sm_duan;
		wire [31:0]Data;
		wire [11:0]abc;//�¶ȼ��ת������
		wire [15:0]wendu;
		wire [31:0]d;//�¶ȼ��ת������
		
        DS18B20 U0(.Clk(Clk),.nRst(nRst),.En(En),.Data(wendu),.DQ(DQ));  
        reg [7:0]f;
		always@(Clk)
		begin
		    if(xz)
		    begin
		    f[7:0] = wendu[11:4]+3;
		    end
		    else
		    f[7:0] = wendu[11:4];
		end
        B_BCD U1(.HEX(f),.BCD(abc)); 
        assign d[3:0] = wendu[3:0];
        assign d[15:4] = abc[11:0]; 
        assign d[31:16]=16'hffff;
  smg_top U3(
       .clk_100MHz(Clk),
       .en(en),
       .rst_n(rst_n),
       .RCLK(RCLK),
       .SRCLK(SRCLK),
        .SER(SER),
        .data(d)
            ); 
     //   smg_ip_model U2(.clk(Clk),.data(d),.sm_wei(sm_wei),.sm_duan(sm_duan));
        endmodule