//�漴����ģ��
module random_number(start_Sig,clk_100MHz,Done_Sig,Direct_Ran);
input start_Sig;    //������ɼ���ʼ�ź�
input clk_100MHz;          //ʱ���ź�
//input rst_n;        //��λ�ź�
output Done_Sig;    //���������ź�
output[1:0] Direct_Ran;  //����źŷ��� 00��01��10��11��ʾ�ĸ�����
//output[3:0]disp;
reg[4:0]disp=4'b0011;
reg Done_Sig=0;
reg [1:0]Direct_Ran;
reg [3:0]i=0;

always@(posedge clk_100MHz)
   begin
 //  if (start_Sig==1) 
 //  begin 
  //      Direct_Ran<=disp[1:0];
 //       Done_Sig<=1;
 //  end
 //  else
 //  begin
        disp <= {disp[2:0],disp[3]};  //��λѭ���ļĴ���
        Done_Sig<=0;
 //  end
   end
always@(posedge start_Sig)
   begin
        Direct_Ran<=disp[1:0];
        Done_Sig<=1;
   end
endmodule