    module smg_top(
    input clk_100MHz,
    input en,
    input rst_n,
    input[31:0]data,
    output RCLK,
    output SRCLK,
    output SER
    
        );
wire [7:0] sm_wei;
wire [7:0] sm_duan;
//reg  [31:0]data=32'h12345678;
reg clk;
always @(posedge clk_100MHz)
clk=~clk;
smg595 Usmg595
    (
.clk(clk_100MHz)                 , //时钟，50Mhz
.rst_n(rst_n)               , //复位，低电平有效
.en(en)                 , //数码管使能信号
.seg_sel(sm_wei)             , //数码管位选
.seg_data(sm_duan)            , //数码管段选
.ST_CP(RCLK)               , //存储寄存器时钟输出
.SH_CP(SRCLK)               , //移位寄存器时钟输出
.DS(SER)                    //串行数据输入
    );   
/*smg U1(
     .clk(clk_100MHz),
      .data(data),
      .sm_wei(sm_wei),
      .sm_duan(sm_duan)
        );
        */
seg_display Udisplay
        //---------------------<端口声明>---------------------------------------
        (
      .clk(clk_100MHz)                 , //时钟，50Mhz
      .rst_n (rst_n)              , //复位，低电平有效
      .en(en)                  , //数码管显示使能
      .data(data)                , //输入数据
     .seg_sel(sm_wei)             , //数码管位选
     .seg_data(sm_duan)              //数码管段选，即内容显示
        );
endmodule