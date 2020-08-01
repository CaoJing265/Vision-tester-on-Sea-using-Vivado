module seg_display
//---------------------<端口声明>---------------------------------------
(
input                   clk                 , //时钟，50Mhz
input                   rst_n               , //复位，低电平有效
input                   en                  , //数码管显示使能
input      [31:0]       data                , //输入数据
output     [ 7:0]       seg_sel             , //数码管位选
output reg [ 7:0]       seg_data              //数码管段选，即内容显示
);
//---------------------<信号定义>---------------------------------------
reg  [14:0]             cnt                 ;
wire                    add_cnt             ;
wire                    end_cnt             ;
reg                     clk_1k              ;
reg  [ 7:0]             seg_sel_r           ;
reg  [ 3:0]             data_tmp            ;
reg [7:0]duan0;
reg [7:0]duan1;
reg [7:0]duan2;
reg [7:0]duan3;
//----------------------------------------------------------------------
//-----------------  1k分频，扫描一个数目管时间为1ms
//----------------------------------------------------------------------

//计数
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        cnt <= 0;
    else if(add_cnt)begin
        if(end_cnt)
            cnt <= 0;
        else
            cnt <= cnt + 1;
    end
    else
        cnt <= cnt;
end

assign add_cnt = en;    //en为1才允许计数
assign end_cnt = add_cnt && cnt==25000-1;

//分频
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        clk_1k <= 0;
    else if(end_cnt)
        clk_1k <= ~clk_1k;
    else
        clk_1k <= clk_1k;
end

//----------------------------------------------------------------------
//--   数码管扫描，8位循环扫描，频率为1k
//----------------------------------------------------------------------
always @(posedge clk_1k or negedge rst_n)begin
    if(!rst_n)
        seg_sel_r <= 8'b0000_0001;
    else if(seg_sel==8'b1000_0000)
        seg_sel_r <= 8'b0000_0001;
    else
        seg_sel_r <= seg_sel << 1;
end

//----------------------------------------------------------------------
//--   位选，不同计数对应不同位选编码，也对应分割的不同数据
//----------------------------------------------------------------------
always @(*)begin
    case(seg_sel_r)
        8'b0000_0001: data_tmp = data[ 3: 0] ; // 位1
        8'b0000_0010: data_tmp = data[ 7: 4] ; // 位2
        8'b0000_0100: data_tmp = data[11: 8] ; // 位3
        8'b0000_1000: data_tmp = data[15:12] ; // 位4
        8'b0001_0000: data_tmp = data[19:16] ; // 位5
        8'b0010_0000: data_tmp = data[23:20] ; // 位6
        8'b0100_0000: data_tmp = data[27:24] ; // 位7
        8'b1000_0000: data_tmp = data[31:28] ; // 位8
        default:       data_tmp = 4'b0000     ;
    endcase
end

assign seg_sel = en ? seg_sel_r : 8'b0000_0000; // 位选使能

//----------------------------------------------------------------------
//--   段选，将不同分割数据进行段选编码
//----------------------------------------------------------------------
always @(*)
begin
/*begin
    case(data_tmp)
        4'h0:   seg_data = 8'b1100_0000;
        4'h1:   seg_data = 8'b1111_1001;
        4'h2:   seg_data = 8'b1010_0100;
        4'h3:   seg_data = 8'b1011_0000;
        4'h4:   seg_data = 8'b1001_1001;
        4'h5:   seg_data = 8'b1001_0010;
        4'h6:   seg_data = 8'b1000_0010;
        4'h7:   seg_data = 8'b1111_1000;
        4'h8:   seg_data = 8'b1000_0000;
        4'h9:   seg_data = 8'b1001_0000;
        4'ha:   seg_data = 8'b1000_1000;
        4'hb:   seg_data = 8'b1000_0011;
        4'hc:   seg_data = 8'b1100_0110;
        4'hd:   seg_data = 8'b1010_0001;
        4'he:   seg_data = 8'b1000_0110;
        4'hf:   seg_data = 8'b1111_1111;
        default:seg_data = 8'b1111_1111;
    endcase
end
*/
if(seg_sel_r==8'b00000001)
	begin
	   seg_data = duan0;
		case(data_tmp)
		4'h0:duan0=8'b1100_0000;//0
		4'h1:duan0=8'b1111_1001;//0.0625 1
		4'h2:duan0=8'b1111_1001;//0.125  1
		4'h3:duan0=8'b1010_0100;//0.1875 2
		4'h4:duan0=8'b1011_0000;//0.25   3
		4'h5:duan0=8'b1011_0000;//0.3125 3
		4'h6:duan0=8'b1001_1001;//0.375  4
		4'h7:duan0=8'b1001_1001;//0.4375 4
		4'h8:duan0=8'b1001_0010;//0.5	 5
		4'h9:duan0=8'b1000_0010;//0.5625 6
		4'ha:duan0=8'b1000_0010;//0.625  6
		4'hb:duan0=8'b1111_1000;//0.6875 7
		4'hc:duan0=8'b1000_0000;//0.75   8
		4'hd:duan0=8'b1000_0000;//0.8125 8
		4'he:duan0=8'b1001_0000;//0.875  9
		4'hf:duan0=8'b1001_0000;//0.9375 9
		//	4'hf:duan=8'b1111_1111;//不显礿
		default : duan0 = 8'b1100_0000;//0
		endcase
	end
	else if(seg_sel_r==8'b00000010)
	begin
        seg_data = duan1;
		case(data_tmp)
		4'h0:duan1=8'b0100_0000;//0
		4'h1:duan1=8'b0111_1001;//1
		4'h2:duan1=8'b0010_0100;//2
		4'h3:duan1=8'b0011_0000;//3
		4'h4:duan1=8'b0001_1001;//4
		4'h5:duan1=8'b0001_0010;//5
		4'h6:duan1=8'b0000_0010;//6
		4'h7:duan1=8'b0111_1000;//7
		4'h8:duan1=8'b0000_0000;//8
		4'h9:duan1=8'b0001_0000;//9
		4'ha:duan1=8'b0000_1000;//a
		4'hb:duan1=8'b0000_0011;//b
		4'hc:duan1=8'b0100_0110;//c
		4'hd:duan1=8'b0010_0001;//d
		4'he:duan1=8'b0000_0111;//e
		4'hf:duan1=8'b0000_1110;//f
		//	4'hf:duan=8'b1111_1111;//不显礿
		default : duan1 = 8'b1100_0000;//0
		endcase
	end
	else if(seg_sel_r==8'b0000_0100)	
	begin
       seg_data = duan2;
		case(data_tmp)
		4'h0:duan2=8'b1100_0000;//0
		4'h1:duan2=8'b1111_1001;//1
		4'h2:duan2=8'b1010_0100;//2
		4'h3:duan2=8'b1011_0000;//3
		4'h4:duan2=8'b1001_1001;//4
		4'h5:duan2=8'b1001_0010;//5
		4'h6:duan2=8'b1000_0010;//6
		4'h7:duan2=8'b1111_1000;//7
		4'h8:duan2=8'b1000_0000;//8
		4'h9:duan2=8'b1001_0000;//9
		4'ha:duan2=8'b1000_1000;//a
		4'hb:duan2=8'b1000_0011;//b
		4'hc:duan2=8'b1100_0110;//c
		4'hd:duan2=8'b1010_0001;//d
		4'he:duan2=8'b1000_0111;//e
		4'hf:duan2=8'b1000_1110;//f
		//	4'hf:duan=8'b1111_1111;//不显礿
		default : duan2 = 8'b1100_0000;//0
		endcase
	end
	else if(seg_sel_r==8'b00001000)
	begin
        seg_data = duan3;
		case(data_tmp)
		4'h0:duan3=8'b1100_0000;//0
		4'h1:duan3=8'b1111_1001;//1
		4'h2:duan3=8'b1010_0100;//2
		4'h3:duan3=8'b1011_0000;//3
		4'h4:duan3=8'b1001_1001;//4
		4'h5:duan3=8'b1001_0010;//5
		4'h6:duan3=8'b1000_0010;//6
		4'h7:duan3=8'b1111_1000;//7
		4'h8:duan3=8'b1000_0000;//8
		4'h9:duan3=8'b1001_0000;//9
		4'ha:duan3=8'b1000_1000;//a
		4'hb:duan3=8'b1000_0011;//b
		4'hc:duan3=8'b1100_0110;//c
		4'hd:duan3=8'b1010_0001;//d
		4'he:duan3=8'b1000_0111;//e
		4'hf:duan3=8'b1000_1110;//f
		//	4'hf:duan=8'b1111_1111;//不显礿
		default : duan3 = 8'b1100_0000;//0
		endcase
	end
	else
	begin
        case(data_tmp)
            4'h0:   seg_data = 8'b1100_0000;
            4'h1:   seg_data = 8'b1111_1001;
            4'h2:   seg_data = 8'b1010_0100;
            4'h3:   seg_data = 8'b1011_0000;
            4'h4:   seg_data = 8'b1001_1001;
            4'h5:   seg_data = 8'b1001_0010;
            4'h6:   seg_data = 8'b1000_0010;
            4'h7:   seg_data = 8'b1111_1000;
            4'h8:   seg_data = 8'b1000_0000;
            4'h9:   seg_data = 8'b1001_0000;
            4'ha:   seg_data = 8'b1000_1000;
            4'hb:   seg_data = 8'b1000_0011;
            4'hc:   seg_data = 8'b1100_0110;
            4'hd:   seg_data = 8'b1010_0001;
            4'he:   seg_data = 8'b1000_0110;
            4'hf:   seg_data = 8'b1111_1111;
            default:seg_data = 8'b1111_1111;
        endcase
    end
end
 endmodule    