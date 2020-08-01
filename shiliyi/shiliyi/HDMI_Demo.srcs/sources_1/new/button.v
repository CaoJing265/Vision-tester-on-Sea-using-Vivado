/*
 * @Discription: buttons scan function
 * @Author: Qin Boyu
 * @Date: 2019-05-07 23:17:17
 * @LastEditTime: 2019-05-19 10:20:23
 */

	module button
(	input clk,
	input key1,
	input key2,
	input key3,
	
	output reg left_key_press,     //key2单次
	output reg right_key_press,    //key2长按
	output reg up_key_press,      //key1单次
	output reg down_key_press,    //key1长按
	output reg Go,                //key3长按
	output reg [1:0]LR             //左眼默认为1，右眼按下key3单次变为1
);

wire clk_1kHz;
reg [30:0]Clk_Divide_1kHz=100000/2; 

parameter s01=4'b0000; //初始    各个量为0
parameter s11=4'b0001; //有按键
parameter s21=4'b0010;//短按
parameter s31=4'b0100; //长按

reg [3:0]state1=s01;
reg [11:0]count1=0;
reg [9:0]count_led1=0;


always@(posedge clk_1kHz)
begin
    case(state1)
    s01:
    begin
        up_key_press<=0;
        down_key_press<=0;
        count_led1<=0;
        if(key1==1)
        state1<=s01;
        else if (key1==0)
        state1<=s11;
    end
    s11:
    begin
        up_key_press<=0;
        down_key_press<=0;
        if(key1==0)
        begin
            state1<=s11;
            count1<=count1+1;
        end
       else if(key1==1&&count1>10'b1111111111)
       begin 
            state1<=s31;
            count1<=0;
       end
       else 
       begin
            state1<=s21;
            count1<=0;
       end
   end
   s21:
   begin
        up_key_press<=1;
        count_led1<=count_led1+1;
        if(count_led1==10'b1111111111)
        state1<=s01;
   end
   s31:
   begin
         down_key_press<=1;
         count_led1<=count_led1+1;
         if(count_led1==10'b1111111111)
          state1<=s01;
   end
   endcase
end

parameter s02=4'b0000; //初始    各个量为0
parameter s12=4'b0001; //有按键
parameter s22=4'b0010;//短按
parameter s32=4'b0100; //长按

reg [3:0]state2=s02;
reg [11:0]count2=0;
reg [9:0]count_led2=0;


always@(posedge clk_1kHz)
begin
    case(state2)
    s02:
    begin
        left_key_press<=0;
        right_key_press<=0;
        count_led2<=0;
        if(key2==1)
        state2<=s02;
        else if (key2==0)
        state2<=s12;
    end
    s12:
    begin
        left_key_press<=0;
        right_key_press<=0;
        if(key2==0)
        begin
            state2<=s12;
            count2<=count2+1;
        end
       else if(key2==1&&count2>10'b1111111111)
       begin 
            state2<=s32;
            count2<=0;
       end
       else 
       begin
            state2<=s22;
            count2<=0;
       end
   end
   s22:
   begin
        left_key_press<=1;
        count_led2<=count_led2+1;
        if(count_led2==10'b1111111111)
        state2<=s02;
   end
   s32:
   begin
         right_key_press<=1;
         count_led2<=count_led2+1;
         if(count_led2==10'b1111111111)
          state2<=s02;
   end
   endcase
end 

reg flag=0;
always@(posedge clk_1kHz)
begin
  Go<=1;
  if(flag==0)
  LR=2'b10;
  if(key3==0)
   begin LR=2'b11;flag=1;end
end


 /*  parameter s03=4'b0000; //初始    各个量为0
   parameter s13=4'b0001; //有按键
   parameter s23=4'b0010;//短按
   parameter s33=4'b0100; //长按
  
   reg [3:0]state3=s03;
   reg [11:0]count3=0;
   reg [9:0]count_led3=0;
   reg flag=0;
   always@(posedge clk_1kHz)
   begin
       case(state3)
       s03:
       begin
       if(flag==0)
       begin
           Go<=0;
           LR<=2'b01;
       end  
           count_led3<=0;
           if(key3==1)
           state3<=s03;
           else if (key3==0)
           state3<=s13;
       end
       s13:
       begin
           Go<=0;
           LR<=2'b01;
           if(key3==0)
           begin
               state3<=s13;
               count3<=count3+1;
           end
          else if(key3==1&&count3>10'b1111111111)
          begin 
               state3<=s33;
               count3<=0;
          end
          else 
          begin
               state3<=s23;
               count3<=0;
          end
      end
      s23:
      begin
           LR<=2'b11;
           flag=1;
           count_led3<=count_led3+1;
           if(count_led3==10'b1111111111)
           state3<=s03;
      end
      s33:
      begin
            Go<=1;
            flag=1;
           count_led3<=count_led3+1;
            if(count_led3==10'b1111111111)
             state3<=s03;
      end
      endcase
end
*/
Clk_Division_0(.clk_100MHz(clk),.clk_mode(Clk_Divide_1kHz),.clk_out(clk_1kHz)); 

//******************************************************************
endmodule