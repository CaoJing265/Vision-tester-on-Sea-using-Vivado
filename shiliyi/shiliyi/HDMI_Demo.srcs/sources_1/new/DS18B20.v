module DS18B20(Clk,nRst,En,Data,DQ);
        input Clk;  //����ʱ��50MHz
        input nRst;  //���븴λ
        input En;  // �����¶�ת��
        output [15:0] Data;  //������¶�����
        inout DQ;  //���ݹܽ�
        /*                ���������p                */
        wire En;  //��������
        wire DQ;  //��������
        reg DqDir;  //����ѡ�� 0����� 1������
        reg DqOut;  //�������
        assign DQ = (DqDir == 1'b0) ?  1'bz : DqOut;  //˫��˿ڣ��ۺ�ʱ�WҪʹ����̬�ڣ�����ʱ�ɲ���force���?
        //�����Ƶ����������ʱ��Ϊ50MHz
        parameter  ClkCnt   = 250,  //1/50 * 250 = 5us 
                   RstPulse = 100,  //100 * 5us = 500us
                   Samples  = 16;  //16 * 5us = 80us
        //״���ʹ�õ�״̬���Y
        reg [3:0] NS;
        parameter [3:0]  //ʱ���е�״�W
                   RSTIDLE  = 4'b0000,  //��λ����
                   RSTPUL   = 4'b0001,  //��λ����
                   RSTWAIT  = 4'b0010,  //�ȴ��������ͷŞS��
                   RSTPRE   = 4'b0011,  //��������
                   WIREIDLE = 4'b0100,  //д���ݿ��]
                   WIREPUL  = 4'b0101,  //д����
                   WIREBIT  = 4'b0110,  //дλ
                   WIRESFT  = 4'b0111,  //������λ
                   READIDLE = 4'b1000,  //�����ݿ��]
                   READPUL  = 4'b1001,  //������
                   READBIT  = 4'b1010,  //��λ
                   READSFT  = 4'b1011,  //������λ
                   CMDIDLE  = 4'b1100,  //ָ��ȴ�����
                   CMDFUN   = 4'b1101,  //���ܺ���
                   CMDDELY  = 4'b1110;  //ָ����ʱ
        /*                5��sʱ�Ӳ���                */
        reg [7:0] DivCnt;  //ʱ�ӷ�Ƶ������
        wire PulseClk;
        assign PulseClk = (DivCnt == ClkCnt);
        always@(posedge Clk or negedge nRst)
        begin
           if(~nRst) begin
                DivCnt = 1'b0;  //����ֵ���
           end
           else if(En) begin
               if(PulseClk & TimingEn)  //ռ�՚� ��=50%
                   DivCnt = 8'd0;
               else 
                   DivCnt = DivCnt+1'b1;
           end
           else begin
               DivCnt = 1'b0;  //����ֵ���
           end
        end
        /*                ds18b20ʱ�����                */
        reg TimingEn; //ʱ��ʹ�ܱ�־
        reg [6:0] TimingCnt;  //ʱ�����
        always@(posedge Clk or negedge nRst)
        begin
           if(~nRst) begin
                TimingCnt = 7'b0;  //����ֵ���
           end
           else if(TimingEn) begin
               if(PulseClk)
                   TimingCnt = TimingCnt+1'b1;  //����
               else
                   TimingCnt = TimingCnt;  //���ּ�����
           end
           else begin
               TimingCnt = 7'b0;  //����ֵ���
           end
        end
        /*                ds18b20��λ��������                */
        reg DsRstEn;  //ds18b20��λʹ��
        /*                ds18b20д���ݶ�������                */
        reg WireEn;  //ds18b20д����ʹ�v
        reg [3:0] wSftCnt;  // дbit����  
        reg [7:0] WireCmd;  //дָ��
        reg [7:0] WireBus;  //д����
        /*                ds18b20�����ݶ�������                */
        reg ReadEn;  //ds18b20������ʹ�v
        reg [3:0] rSftCnt;  // дbit����  
        reg [7:0] ReadData;  //������
        /*                ds18b20ָ��ܶ�������                */
        reg [3:0] CmdCnt;  //ָ�����
        reg [7:0] DataH;
        reg [7:0] DataL;
        wire [15:0] Data;  //�������
        assign Data = {DataH,DataL};
        /*                ds18b20״���                */
        always@(posedge Clk or negedge nRst)
        begin
            if(~nRst) begin
               wSftCnt <= 4'b0000;  //�ϵ��ds18b20д������λ�������
               rSftCnt <= 4'b0000;  //�ϵ��ds18b20��������λ�������
               DsRstEn <= 1'b0;  //�ϵ��ds18b20��λʹ�ܱ�־����
               WireEn <= 1'b0;  //�ϵ��ds18b20дʹ�ܱ�־���
               ReadEn <= 1'b0;  //�ϵ��ds18b20��ʹ�ܱ�־���
               WireCmd <= 1'b0;  //�ϵ��ds18b20дָ���־���
               CmdCnt <= 1'b0;;  //ָ���������
               DqDir <= 1'b0;  //����Ϊ���
               NS <= CMDIDLE;  //״����]
           end
           else begin 
               case(NS)
        /*                ds18b20��������                */
                   CMDIDLE: begin  
                       if(En == 1'b1) begin //ʹ��18b20
                           DsRstEn <= 1'b1;  //ʹ�ܸ�λ����
                           NS <= RSTIDLE;  //������λʱ��
                       end
                       else begin
                           DsRstEn <= 1'b0;  //���ܸ�λ����
                           CmdCnt <= 1'b0;  //ָ���������
                           DqDir <= 1'b0;  //����Ϊ���
                           NS <= CMDIDLE;  //����δ֪�����ת����ʼλ�Z
                       end
                   end
                   CMDFUN: begin
                       case(CmdCnt)
                           4'b0000: begin
                               NS <= WIREIDLE;  //����д����
                               WireEn <= 1'b1;  //ʹ��д����
                               WireCmd <= 8'hcc;  //��?0xcc
                           end
                           4'b0001: begin
                               NS <= WIREIDLE;  //����д����
                               WireEn <= 1'b1;  //ʹ��д����
                               WireCmd <= 8'h44;  //��?0x44
                           end
                           4'b0010: begin
                               NS <= CMDDELY;  //ָ��ȴ�
                           end
                           4'b0011: begin
                               DsRstEn <= 1'b1;  //ʹ�ܸ�λ����
                               NS <= RSTIDLE;  //������λʱ��
                           end
                           4'b0100: begin
                               NS <= WIREIDLE;  //����д����
                               WireEn <= 1'b1;  //ʹ��д����
                               WireCmd <= 8'hcc;  //��?0xcc
                           end
                           4'b0101: begin
                               NS <= WIREIDLE;  //����д����
                               WireEn <= 1'b1;  //ʹ��д����
                               WireCmd <= 8'hbe;  //��?0xbe
                           end
                           4'b0110: begin
                               NS <= READIDLE;  //���������ݵ�ʹ
                               ReadEn <= 1'b1;  //ʹ�ܶ�����
                           end
                           4'b0111: begin
                               DataL <= ReadData;  //�����λ����
                               NS <= READIDLE;  //���������ݵ�ʹ
                               ReadEn <= 1'b1;  //ʹ�ܶ�����
                           end    
                           4'b1000: begin
                               DataH <= ReadData;  //�����λ����
                               NS <= CMDIDLE;  //״����]
                           end
                           default: NS <= CMDIDLE;  //����δ֪�����ת����ʼλ�Z 
                       endcase
                       CmdCnt <= CmdCnt + 1'b1;  //����
                   end
        /*                ds18b20ָ����ʱ                */
                   CMDDELY: begin
                       TimingEn <= 1'b1;  //ʹ��ʱ��
                       if(TimingCnt == RstPulse) begin
                           TimingEn <= 1'b0;  //����ʱ��
                           NS <= CMDFUN;  //��?����ָ��
                       end
                       else begin
                           NS <= CMDDELY;  //�����ȴ�ִ��
                       end
                   end
        /*                ds18b20��λʱ��                */
                   RSTIDLE: begin
                       if(DsRstEn) begin
                           DqDir <= 1'b1;  //����Ϊ����
                           DqOut <= 1'b0;  //����������
                           TimingEn <= 1'b1;  //ʹ��ʱ��
                           NS <= RSTPUL;  //������λʱ��
                       end
                       else begin
                           NS <= RSTIDLE;  //�����ȴ�ִ��
                       end
                   end
                   RSTPUL: begin
                       if(TimingCnt == RstPulse) begin
                           DqDir <= 1'b0;  //����Ϊ���
                           DqOut <= 1'b1;  //����������
                           TimingEn <= 1'b0;  //����ʱ��
                           NS <= RSTWAIT;  //�����������ߣ��ȴ��ӻ�Ӧ�q
                       end
                       else begin
                           NS <= RSTPUL;  //�����ȴ�ִ��
                       end
                   end
                   RSTWAIT: begin
                       TimingEn <= 1'b1;  //ʹ��ʱ��
                       if(!DQ) begin
                           NS <= RSTPRE;  //��λ�ɹ�״�W
                       end
                       else if(TimingCnt == RstPulse) begin
                           TimingEn <= 1'b0;  //����ʱ��
                           NS <= RSTIDLE;  //���ؿ���״�W
                       end
                   end
                   RSTPRE: begin
                       if(TimingCnt == RstPulse) begin
                           DsRstEn <= 1'b0;  //���ܸ�λ����
                           TimingEn <= 1'b0;  //����ʱ��
                           DqDir <= 1'b0;  //����Ϊ���
                           DqOut <= 1'b1;  //����������
                           NS <= CMDFUN;  //��?����ָ��
                       end
                   end
        /*                ds18b20дʱ��                */
                   WIREIDLE: begin 
                       if(WireEn) begin
                           DqDir <= 1'b1;  //����Ϊ����
                           DqOut <= 1'b0;  //����������
                           TimingEn <= 1'b1;  //ʹ��ʱ��
                           WireBus <= WireCmd;   //дָ��{
                           NS <= WIREPUL;  //����дʱ��
                       end
                       else begin
                           WireBus <= 8'b0000_0000;  //�������
                           NS <= WIREIDLE;  //״����]
                       end
                   end
                   WIREPUL: begin
                       TimingEn <= 1'b1;  //ʹ��ʱ��
                       if(PulseClk) begin  //�ȴ�5us
                           TimingEn <= 1'b0;  //����ʱ��
                           NS <= WIREBIT;  //дbit
                       end
                       else begin
                           NS <= WIREPUL;  //�����ȴ�ִ��
                       end
                   end
                   WIREBIT: begin
                       TimingEn <= 1'b1;  //ʹ��ʱ��
                       DqOut <= WireBus[0];  //дһʹ
                       if(TimingCnt == Samples) begin 
                           TimingEn <= 1'b0;  //����ʱ��
                           DqOut <= 1'b1;  //����������
                           NS <= WIRESFT;  //������λ
                       end
                       else begin
                           NS <= WIREBIT;  //�����ȴ�ִ��
                       end
                   end
                   WIRESFT: begin
                       TimingEn <= 1'b1;  //ʹ��ʱ��
                       if(PulseClk) begin  //���د5us
                           DqDir <= 1'b1;  //����Ϊ����
                           DqOut <= 1'b0;  //����������
                           TimingEn <= 1'b0;  //����ʱ��
                           WireBus <= WireBus >> 1'b1;  //��λ
                           wSftCnt <= wSftCnt + 1'b1;  //��¼����
                           if(wSftCnt == 4'b0111) begin
                               wSftCnt <= 4'b0000;  //��������
                               DqDir <= 1'b0;  //����Ϊ���
                               DqOut <= 1'b1;  //����������
                               NS <= CMDFUN;  //��?����ָ��
                           end
                           else begin
                               NS <= WIREPUL;  //����дʱ��
                           end
                       end
                       else begin
                           NS <= WIRESFT;  //�����ȴ�ִ��
                       end
                   end
        /*                ds18b20��ʱ��                */
                   READIDLE: begin 
                       if(ReadEn) begin
                           DqDir <= 1'b1;  //����Ϊ����
                           DqOut <= 1'b0;  //����������
                           TimingEn <= 1'b1;  //ʹ��ʱ��
                           NS <= READPUL;  //����дʱ��
                       end
                       else begin
                           ReadData <= 8'b0000_0000;  //������� 
                           NS <= READIDLE;  //״����]
                       end
                   end
                   READPUL: begin
                       TimingEn <= 1'b1;  //ʹ��ʱ��
                       if(PulseClk) begin  //�ȴ�5us
                           TimingEn <= 1'b0;  //����ʱ��
                           DqDir <= 1'b0;  //����Ϊ���
                           DqOut <= 1'b1;  //����������
                           NS <= READBIT;  //��bit
                       end
                       else begin
                           NS <= READPUL;  //�����ȴ�ִ��
                       end
                   end
                   READBIT: begin
                       TimingEn <= 1'b1;  //ʹ��ʱ��
                       if(PulseClk) begin  //�ȴ�5us
                           TimingEn <= 1'b0;  //����ʱ��
                           ReadData[7] <= DQ;  //��һʹ
                           NS <= READSFT;  //������λ
                       end
                       else begin
                           NS <= READBIT;  //�����ȴ�ִ��
                       end
                   end
                   READSFT: begin
                       TimingEn <= 1'b1;  //ʹ��ʱ��
                       if(TimingCnt == Samples) begin  //���د80us
                           TimingEn <= 1'b0;  //ʹ��ʱ��
                           DqDir <= 1'b1;  //����Ϊ����
                           DqOut <= 1'b0;  //����������
                           rSftCnt <= rSftCnt + 1'b1;  //��¼����
                           if(rSftCnt == 4'b0111) begin
                               rSftCnt <= 4'b0000;  //��������
                               DqDir <= 1'b0;  //����Ϊ���
                               DqOut <= 1'b1;  //����������
                               NS <= CMDFUN;  //��?����ָ��
                           end
                           else begin
                               ReadData <= ReadData >> 1'b1;  //��λ
                               NS <= READPUL;  //����дʱ��
                           end
                       end
                       else begin
                           NS <= READSFT;  //�����ȴ�ִ��
                       end
                   end
                   default: NS <= CMDIDLE;  //����δ֪�����ת����ʼλ�Z
               endcase
           end
        end
  endmodule