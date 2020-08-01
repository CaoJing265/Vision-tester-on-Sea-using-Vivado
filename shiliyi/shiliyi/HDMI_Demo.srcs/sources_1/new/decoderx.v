module decoderx(
blue_key_up,blue_key_down,blue_key_left,blue_key_right,blue_key_unknown,blue_Go,blue_LR,
dout,dout_vld,blue_wendu
);



//input clk_100MHz; //时钟100MHz
input dout_vld;  //rx结束标志  =rx_down
input [7:0]dout;  //蓝牙收到的数据  =data_8bit


output [1:0]blue_LR;
output blue_key_left;
output blue_key_down;
output blue_key_right;
output blue_key_up;
output blue_key_unknown;
output blue_wendu;
output blue_Go;//开始测量


reg [1:0]blue_LR=2'b00;
reg blue_key_left=0;
reg blue_key_down=0;
reg blue_key_right=0;
reg blue_key_up=0;
reg blue_wendu=0;
reg blue_key_unknown=0;
reg blue_Go=0;//开始测量


always@(posedge dout_vld)
      begin	  
			case (dout)
			8'h01:
				begin
				blue_Go<=1;  //Go_on
				end
			8'h02: 
			begin 
			    blue_Go<=0; //G0_off
			end
			8'h03: 
			begin 
			   blue_LR[0]<=1;  //开始检测右眼
			end
			8'h04: 
			begin 
			   blue_LR[0]<=0;   //右眼的OFF
			end
			8'h05: 
			begin 
			    blue_LR[1]<=1;  //开始检测左眼
			end
			8'h06: 
			  begin blue_LR[1]<=0;  //左眼的off
			
			end
			8'h12:       //12是左
				begin
				blue_key_left<=1;
				blue_key_right<=0;
				blue_key_down<=0;
				blue_key_up<=0;
				blue_key_unknown<=0;
				end
			8'h13:      //13是右
				begin
				blue_key_left<=0;
				blue_key_right<=1;
				blue_key_down<=0;
				blue_key_up<=0;
				blue_key_unknown<=0;
				end
			8'h14:       //14是下
				begin
				blue_key_left<=0;
				blue_key_right<=0;
				blue_key_down<=1;
				blue_key_up<=0;
				blue_key_unknown<=0;
				end
			8'h15:     //15是上
				begin
				blue_key_left<=0;
				blue_key_right<=0;
				blue_key_down<=0;
				blue_key_up<=1;
				blue_key_unknown<=0;
				end
			8'h16:    //16是不知道
				begin
				blue_key_left<=0;
				blue_key_right<=0;
				blue_key_down<=0;
				blue_key_up<=0;
				blue_key_unknown<=1;
				end
			8'h17:
				begin
				blue_key_left<=0;
				blue_key_right<=0;
				blue_key_down<=0;
				blue_key_up<=0;
				blue_key_unknown<=0;
				end
			8'h31:
			    begin
				blue_wendu<=1;
				end
			8'h33:
			    blue_wendu<=0;
			default:
			   begin 
			    blue_key_left<=blue_key_left;
                blue_key_right<=blue_key_right;
                blue_key_down<=blue_key_down;
                blue_key_up<=blue_key_up;
                blue_key_unknown<=blue_key_unknown;
                blue_LR<=blue_LR;
				blue_wendu<=blue_wendu;
			   end
			endcase
	  end
endmodule