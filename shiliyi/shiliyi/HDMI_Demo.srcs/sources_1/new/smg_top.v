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
.clk(clk_100MHz)                 , //ʱ�ӣ�50Mhz
.rst_n(rst_n)               , //��λ���͵�ƽ��Ч
.en(en)                 , //�����ʹ���ź�
.seg_sel(sm_wei)             , //�����λѡ
.seg_data(sm_duan)            , //����ܶ�ѡ
.ST_CP(RCLK)               , //�洢�Ĵ���ʱ�����
.SH_CP(SRCLK)               , //��λ�Ĵ���ʱ�����
.DS(SER)                    //������������
    );   
/*smg U1(
     .clk(clk_100MHz),
      .data(data),
      .sm_wei(sm_wei),
      .sm_duan(sm_duan)
        );
        */
seg_display Udisplay
        //---------------------<�˿�����>---------------------------------------
        (
      .clk(clk_100MHz)                 , //ʱ�ӣ�50Mhz
      .rst_n (rst_n)              , //��λ���͵�ƽ��Ч
      .en(en)                  , //�������ʾʹ��
      .data(data)                , //��������
     .seg_sel(sm_wei)             , //�����λѡ
     .seg_data(sm_duan)              //����ܶ�ѡ����������ʾ
        );
endmodule