//����ģ��
module smg(clk_100MHz , TMDS_Tx_Clk_N,
    TMDS_Tx_Clk_P,
    TMDS_Tx_Data_N,
    TMDS_Tx_Data_P,
    key1,
    key2,
    key3
       );
//inout DQ;
//input rx;
input key1;
input key2;
input key3;
input clk_100MHz;
//shili_controlģ��
   output TMDS_Tx_Clk_N;
   output TMDS_Tx_Clk_P;
   output [2:0]TMDS_Tx_Data_N;
   output [2:0]TMDS_Tx_Data_P;
 //  output RCLK;
  // output SRCLK;
   //output SER;
//random_number ģ��
wire Go,key_up,key_down,key_left,key_right,key_unknown;
//sm_wei,sm_duan,
//Single_Result,
//disp_RGB,hsync,vsync,

wire [1:0]LR;
//input [2:0]choose;  //100������010������001���ƴ�����

//output [2:0]disp_RGB; //VGA �������
//output hsync; //VGA ��ͬ���ź�
//output vsync; //VGA ��ͬ���ź�
wire [3:0]eye1;
//output [3:0]sm_wei;
//output [7:0]sm_duan;
//output[3:0] eye;//�ӱ��С
wire[1:0] Direct;   //�ӱ귽��
wire[2:0]Stage;  
wire[2:0] Single_Result; //���β������  00����ʾ��01��ʾ����10��ʾ��
//----------------------------------------------------------
wire [15:0]Data;
wire [3:0]Result;
//wire [3:0]sm_wei;
//wire [7:0]sm_duan;
wire [3:0]flag2;
wire start_Sig;
wire Done_Sig;    //���������ź�
wire[1:0] Direct_Ran;  //����źŷ��� 00��01��10��11��ʾ�ĸ�����
//wire vga_clk;
wire [3:0]eye;//�ӱ��С
//wire [1:0]Direct;//�ӱ귽��
wire[7:0]data_out;
wire rx_done;
wire clock_my;
clk_wiz_0 clk_10(.clk_out1(clock_my),.clk_in1(clk_100MHz));

 wire left_key_press;     //key2����
 wire right_key_press;    //key2����
 wire up_key_press;      //key1����
 wire down_key_press;    //key1����

 
wire [1:0]blue_LR;
wire blue_key_left;
wire blue_key_down;
wire blue_key_right;
wire blue_key_up;
wire blue_key_unknown;
wire blue_Go;//��ʼ����
wire blue_wendu;
//----------------------------------------------------------
   
    
 
 
Result_Data U0 (.flag2(flag2),.clk_100MHz(clk_100MHz),.LR(LR),.Result(Result),.Data(Data));
//smg_ip_model U1 (.clk_100MHz(clk_100MHz),.Data(Data),.sm_wei(sm_wei),.sm_duan(sm_duan));
random_number U2(.start_Sig(start_Sig),.clk_100MHz(clk_100MHz),.Done_Sig(Done_Sig),.Direct_Ran(Direct_Ran));
shili_control U3(.LR(LR),.eye1(eye1),.Direct(Direct),.Direct_Ran(Direct_Ran),.key_up(blue_key_up),.key_down(blue_key_down),.key_left(blue_key_left),.key_right(blue_key_right),.key_unknown(blue_key_unknown),.Go(Go),.clk_100MHz(clk_100MHz),.eye(eye),
.Single_Result(Single_Result),
.Result(Result),.start_Sig(start_Sig),.Stage(Stage),.flag2(flag2));
//BlueTooth_0 u_uart (
//              .clk(clk_100MHz),            // input wire clk
 //             .reset(1'b0),        // input wire reset
  //            .rx(rx),              // input wire rx
   //           .tx_btn(1'b0),      // input wire tx_btn
    //          .data_in(8'b00001111),    // input wire [7 : 0] data_in
 //             .data_out(data_out),  // output wire [7 : 0] data_out
   //           .rx_done(rx_done),    // output wire rx_done
     //         .tx_done(),    // output wire tx_done
       //       .tx()              // output wire tx
         //   );

 //decoderx U6(.blue_key_up(blue_key_up),.blue_key_down(blue_key_down),.blue_key_left(blue_key_left),.blue_key_right(blue_key_right),.blue_key_unknown(blue_key_unknown),
  //                                     .blue_Go(blue_Go),
    //                                   .blue_LR(blue_LR),
      //                                 .dout(data_out),
        //                               .dout_vld(rx_done),.blue_wendu(blue_wendu));
 HDMI_Demo U7(.clock_my(clock_my),.eye(eye),.Direct(Direct),
                 .Single_Result(Single_Result),.TMDS_Tx_Clk_N (TMDS_Tx_Clk_N),.TMDS_Tx_Clk_P( TMDS_Tx_Clk_P),
                 .TMDS_Tx_Data_N(TMDS_Tx_Data_N),.TMDS_Tx_Data_P(TMDS_Tx_Data_P),.Data(Data)) ;                   
   
// wendu(.Clk(clk_100MHz), .xz(0), .En(blue_wendu),. nRst(blue_wendu),.DQ(DQ),.en(blue_wendu),.rst_n(blue_wendu),.RCLK(RCLK),.SRCLK(SRCLK),.SER(SER));   
button U4(.clk(clk_100MHz),
          .key1(key1),
          .key2(key2),
          .key3(key3),
          .left_key_press(blue_key_left),
          .right_key_press(blue_key_right),
           .up_key_press(blue_key_up),
           .down_key_press(blue_key_down),
           .Go(Go),
           .LR(LR)
        );   
                                                   
endmodule
