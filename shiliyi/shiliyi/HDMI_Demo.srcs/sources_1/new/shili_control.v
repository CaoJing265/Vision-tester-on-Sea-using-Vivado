module shili_control(LR,
Direct,Direct_Ran,
key_up,key_down,key_left,key_right,key_unknown,
Go,
clk_100MHz,
eye,
Single_Result,Result,
start_Sig,
Stage,
flag2,
eye1);
//测第二只眼要两个按键都拨上去
input [1:0]LR;
input key_left;
input key_down;
input key_right;
input key_up;
input key_unknown;
input Direct_Ran;
input Go;//开始测量
input clk_100MHz; //时钟100MHz

output[3:0] eye;//视标大小
output[3:0] eye1;//视标大小
output[1:0] Direct;   //视标方向
output[3:0] Result;  //测量结果
output[2:0] Single_Result; //单次测量结果  00不显示，01显示勾，10显示×
output start_Sig;//随机数产生开始

output flag2; //第二次结果输出
output Stage;    

reg[3:0]flag2=0;
reg[24:0]disp=25'b0011010100111000101011001;
reg[3:0]Stage=4'b0000;  
reg [1:0]a=0;  //正确的计数器
reg [1:0]b=0;  //错误的计数器
//reg Go;
reg[7:0]data=8'h00;
reg[3:0] eye=4'h8; //初值
reg[3:0] eye1=4'h8; //初值
reg [1:0]Direct;
reg[3:0] Result=4'hf;
reg [3:0] AA=4'ha;
reg [3:0] BB=4'hb;
reg [2:0]Single_Result=3'b101;
reg [7:0]i=0;
//reg [1:0]Direct_Ran; //随机
reg start_Sig=0;
reg [1:0]Direct_Anjian;
reg flag_unknown;
reg flag_youjian=0;//有键按下
//分频 10Hz
reg clk_10Hz;
integer clk_10Hz_cnt; //10Hz

always @(posedge clk_100MHz)
	begin
	if(clk_10Hz_cnt==32'd2500000-1)
		begin 
			clk_10Hz_cnt <= 1'b0; 
			clk_10Hz <= ~clk_10Hz;
		end
	else
		clk_10Hz_cnt <= clk_10Hz_cnt + 1'b1;
	end

//中心控制
always@(posedge clk_10Hz)
begin	
	//状态机模块
	if(Go==0)
	  begin
	      Stage<=4'b0000;
		  Result<=4'hf;
		  flag2<=0;
		  eye<=4'h8;
		  data<=8'h00;
		  a<=0;
		  b<=0;
		  Single_Result<=3'b101;
		  i<=0;
		  flag_youjian<=0;
	  end
    eye1<=eye;       
	case(Stage)
	4'b0000:
        begin
            i<=0;
           if(Go==1)
              begin
                 a<=0;
                 b<=0;
				 data=8'h00;
                 Stage<=4'b0001; 
              end
           else 
               Stage<=4'b0000;    //@1
        end
    4'b0001:
        begin
            i<=0;
            Single_Result<=2'b00;
            eye<=4'h8;
            if(LR!=0) Stage<=4'b0010; //有一个拨码开关打开，才会进入测试视力
            
        end
    4'b0010:
        begin
             
              start_Sig<=1'b1;
              Single_Result<=2'b00;
              Direct<=disp[1:0];//随机显示方向，随机数模块
                  //判断用户按键
                if(key_up==1)   //上
                    begin
                    Direct_Anjian<=2'b00;
                    flag_unknown<=0;
                    flag_youjian<=1;
					Stage<=4'b1000;
                    end
                if(key_down==1)  //下
                    begin
                    Direct_Anjian=2'b01;
                    flag_unknown<=0;
                    flag_youjian<=1;
					Stage<=4'b1000;
                    end
                if(key_left==1) //左
                    begin
                    Direct_Anjian=2'b10;
                    flag_unknown<=0;
                    flag_youjian<=1;
					Stage<=4'b1000;
                    end
                if(key_right==1)//右
                    begin
                    Direct_Anjian=2'b11;
                    flag_unknown<=0;
                    flag_youjian<=1;
					Stage<=4'b1000;
                    end
                if(key_unknown==1)
                    begin
                    flag_unknown<=1;
                    flag_youjian<=1;
					Stage<=4'b1000;
                    end
                                    
              //防止长时间不按键
              i<=i+1;
              if(i>=55)
              begin          
                  if(flag_youjian!=1)
                     begin
                     Stage<=4'b0100;
                     i<=0;
                     start_Sig<=1'b0;
                     flag_youjian<=0;
                     end
              end
        end
	4'b0011:
		begin
	
		Single_Result<=2'b01; //显示勾
		//等0.5秒
	   i<=i+1;
	   disp <= {disp[23:0],disp[24]}; 
	   if(i>=5)
	   begin
	   	a<=a+1;
				case(a)
					2'b00:Stage<=4'b0010;
					2'b01:Stage<=4'b0010;
					2'b10:Stage<=4'b0010;
					default:   //对三次以上
						begin
						if(eye==8'hD)  
							begin
							Result<=eye;  //输出结果
						    flag2<=flag2+1; //flag2=2标志第二次检测实力
						//    Single_Result<=3;
                             Stage<=4'b0111;
							end
						else   
						    Stage<=4'b0101;
						end
				endcase	
				end	
		end
	4'b0100:
		begin

		Single_Result<=2'b10; //显示×
		//等0.4秒
		i<=i+1;
		disp <= {disp[23:0],disp[24]}; 
	   if(i>=4)
	   begin
	   		b<=b+1;
				case(b)
					2'b00:Stage<=4'b0010;
					2'b01:Stage<=4'b0010;
					default:   //错两次以上
						begin
						if(eye==8'h0)  
							begin
							Result<=eye;  //输出结果
						    flag2<=flag2+1; //flag2=2标志第二次检测实力
                            Stage<=4'b0111;
							end
						else   Stage<=4'b0110;
						end
				endcase
			end
		end
	4'b0101:
		begin
			data<={data[3:0],AA};
			if(data==8'hba) 
				begin
				    Result<=eye;//输出当前视标
				   flag2<=flag2+1; //flag2=2标志第二次检测实力
                    Stage<=4'b0111;
			    end
			else  
				begin 
				eye<=eye+1; //视标小一号
				Stage=4'b0010;
				a<=0;
				b<=0;
				end
	end
	4'b0110:
		begin
			data<={data[3:0],BB};
			if(data==8'hab) 
				begin
				Result<=eye-1;//输出比当前大一号的视标
				Stage<=4'b0111;
			    flag2<=flag2+1; //flag2=2标志第二次检测实力
			    end
			else  
			begin
			eye<=eye-1; //视标大一号
			Stage<=4'b0010;
			b<=0;
			a<=0;
			end
		end
	default:
		begin
		Stage<=4'b0000;
		end
	4'b0111:
	    begin
		    if(flag2<=1) 
            begin 
                  Single_Result<=3'b011; //单眼测试完毕
                  if(LR==2'b11) Stage <=4'b0000;      
		    end
		    if(flag2>1) Single_Result<=3'b100; //双眼测试完毕
		end
	4'b1000:
	     begin
		     //按键正确
              if(flag_youjian==1)
              begin
                  if(Direct==Direct_Anjian)
                         begin
                         Stage<=4'b0011;
                         i<=0;
                         start_Sig<=1'b0;
                         flag_youjian<=0;
                         end
                  //按键错误或按看不清
                  if((Direct!=Direct_Anjian)||(flag_unknown==1))
                         begin
                         Stage<=4'b0100;
                         i<=0;
                         start_Sig<=1'b0;
                         flag_youjian<=0;
                         end
             end
		 end
	endcase
end
endmodule
	
