module B_BCD(HEX,BCD);
input [7:0]HEX;
output [11:0]BCD;
reg [11:0]high;
reg [7:0]low;
reg [4:0] highlow30,highlow74;
reg [11:0]BCD_BUF;
//reg c30,c74;

always @(HEX)
	begin
	if(HEX[3:0] > 4'b1001) 
		begin
		low[7:4] = 4'h1;
		low[3:0] = HEX[3:0] + 4'b0110;			//Decimal adjust
		end
	else 
		begin
		low[3:0]= HEX[3:0];
		low[7:4] = 4'h0;
		end
	case(HEX[7:4])
	4'h0 : high[11:0] = 12'h000;
	4'h1 : high[11:0] = 12'h016;
	4'h2 : high[11:0] = 12'h032;
	4'h3 : high[11:0] = 12'h048;
	4'h4 : high[11:0] = 12'h064;
	4'h5 : high[11:0] = 12'h080;
	4'h6 : high[11:0] = 12'h096;
	4'h7 : high[11:0] = 12'h112;
	4'h8 : high[11:0] = 12'h128;
	4'h9 : high[11:0] = 12'h144;
	4'ha : high[11:0] = 12'h160;
	4'hb : high[11:0] = 12'h176;
	4'hc : high[11:0] = 12'h192;
	4'hd : high[11:0] = 12'h208;
	4'he : high[11:0] = 12'h224;
	4'hf : high[11:0] = 12'h240;
	//default : ;
	endcase
	
	highlow30 = high[3:0] + low[3:0] ;  		//keep carry in calculation
	
	//if(high[3:0] + low[3:0] > 4'b1001)  //Error occurs when the result is greater than 16
	  if(highlow30 > 4'b1001)
		begin
		low[7:4] = low[7:4] + 4'h1;			//Carry
		BCD_BUF[3:0] = high[3:0] + low[3:0] + 4'b0110 ;		//Decimal adjust
		end
	else BCD_BUF[3:0] = high[3:0] + low[3:0];
	
	highlow74 = high[7:4] + low[7:4] ;
	  if(highlow74 > 4'b1001)
	//if(high[7:4] + low[7:4] > 4'b1001)
		begin
		BCD_BUF[7:4] = high[7:4] + low[7:4] + 4'b0110;
		high[11:8] = high[11:8] + 4'b1;					//Carry
		end
	else BCD_BUF[7:4] = high[7:4] + low[7:4];
	BCD_BUF[11:8] = high[11:8];
	end

assign BCD = BCD_BUF;	
endmodule