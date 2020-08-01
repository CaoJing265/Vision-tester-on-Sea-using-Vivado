module DS18B20(Clk,nRst,En,Data,DQ);
        input Clk;  //输入时钟50MHz
        input nRst;  //输入复位
        input En;  // 启动温度转换
        output [15:0] Data;  //输出的温度数捿
        inout DQ;  //数据管脚
        /*                定义与声昿                */
        wire En;  //线网类型
        wire DQ;  //线网类型
        reg DqDir;  //方向选择 0：输兿 1：输凿
        reg DqOut;  //输出数据
        assign DQ = (DqDir == 1'b0) ?  1'bz : DqOut;  //双向端口，综合时霿要使用三态口，仿真时可采用force语句?
        //定义分频参数，输入时钟为50MHz
        parameter  ClkCnt   = 250,  //1/50 * 250 = 5us 
                   RstPulse = 100,  //100 * 5us = 500us
                   Samples  = 16;  //16 * 5us = 80us
        //状濁机使用的状态变釿
        reg [3:0] NS;
        parameter [3:0]  //时序中的状濿
                   RSTIDLE  = 4'b0000,  //复位空闲
                   RSTPUL   = 4'b0001,  //复位脉冲
                   RSTWAIT  = 4'b0010,  //等待，主机释放濻线
                   RSTPRE   = 4'b0011,  //存在脉冲
                   WIREIDLE = 4'b0100,  //写数据空闿
                   WIREPUL  = 4'b0101,  //写脉冿
                   WIREBIT  = 4'b0110,  //写位
                   WIRESFT  = 4'b0111,  //数据移位
                   READIDLE = 4'b1000,  //读数据空闿
                   READPUL  = 4'b1001,  //读脉冿
                   READBIT  = 4'b1010,  //读位
                   READSFT  = 4'b1011,  //数据移位
                   CMDIDLE  = 4'b1100,  //指令等待空闲
                   CMDFUN   = 4'b1101,  //功能函数
                   CMDDELY  = 4'b1110;  //指令延时
        /*                5μs时钟产生                */
        reg [7:0] DivCnt;  //时钟分频计数倿
        wire PulseClk;
        assign PulseClk = (DivCnt == ClkCnt);
        always@(posedge Clk or negedge nRst)
        begin
           if(~nRst) begin
                DivCnt = 1'b0;  //计数值归雿
           end
           else if(En) begin
               if(PulseClk & TimingEn)  //占空毿 ＿=50%
                   DivCnt = 8'd0;
               else 
                   DivCnt = DivCnt+1'b1;
           end
           else begin
               DivCnt = 1'b0;  //计数值归雿
           end
        end
        /*                ds18b20时序产生                */
        reg TimingEn; //时序使能标志
        reg [6:0] TimingCnt;  //时序计数
        always@(posedge Clk or negedge nRst)
        begin
           if(~nRst) begin
                TimingCnt = 7'b0;  //计数值归雿
           end
           else if(TimingEn) begin
               if(PulseClk)
                   TimingCnt = TimingCnt+1'b1;  //计数
               else
                   TimingCnt = TimingCnt;  //保持计数倿
           end
           else begin
               TimingCnt = 7'b0;  //计数值归雿
           end
        end
        /*                ds18b20复位定义类型                */
        reg DsRstEn;  //ds18b20复位使能
        /*                ds18b20写数据定义类垿                */
        reg WireEn;  //ds18b20写数据使胿
        reg [3:0] wSftCnt;  // 写bit次数  
        reg [7:0] WireCmd;  //写指仿
        reg [7:0] WireBus;  //写数捿
        /*                ds18b20读数据定义类垿                */
        reg ReadEn;  //ds18b20读数据使胿
        reg [3:0] rSftCnt;  // 写bit次数  
        reg [7:0] ReadData;  //读数捿
        /*                ds18b20指令功能定义类型                */
        reg [3:0] CmdCnt;  //指令计数
        reg [7:0] DataH;
        reg [7:0] DataL;
        wire [15:0] Data;  //输出数据
        assign Data = {DataH,DataL};
        /*                ds18b20状濁机                */
        always@(posedge Clk or negedge nRst)
        begin
            if(~nRst) begin
               wSftCnt <= 4'b0000;  //上电后，ds18b20写数据移位计数置雿
               rSftCnt <= 4'b0000;  //上电后，ds18b20读数据移位计数置雿
               DsRstEn <= 1'b0;  //上电后，ds18b20复位使能标志置零
               WireEn <= 1'b0;  //上电后，ds18b20写使能标志置雿
               ReadEn <= 1'b0;  //上电后，ds18b20读使能标志置雿
               WireCmd <= 1'b0;  //上电后，ds18b20写指令标志置雿
               CmdCnt <= 1'b0;;  //指令计数置零
               DqDir <= 1'b0;  //设置为输兿
               NS <= CMDIDLE;  //状濁空闿
           end
           else begin 
               case(NS)
        /*                ds18b20功能设置                */
                   CMDIDLE: begin  
                       if(En == 1'b1) begin //使能18b20
                           DsRstEn <= 1'b1;  //使能复位功能
                           NS <= RSTIDLE;  //启动复位时序
                       end
                       else begin
                           DsRstEn <= 1'b0;  //禁能复位功能
                           CmdCnt <= 1'b0;  //指令计数清零
                           DqDir <= 1'b0;  //设置为输兿
                           NS <= CMDIDLE;  //其它未知情况跳转至起始位罿
                       end
                   end
                   CMDFUN: begin
                       case(CmdCnt)
                           4'b0000: begin
                               NS <= WIREIDLE;  //启动写数捿
                               WireEn <= 1'b1;  //使能写数捿
                               WireCmd <= 8'hcc;  //发?0xcc
                           end
                           4'b0001: begin
                               NS <= WIREIDLE;  //启动写数捿
                               WireEn <= 1'b1;  //使能写数捿
                               WireCmd <= 8'h44;  //发?0x44
                           end
                           4'b0010: begin
                               NS <= CMDDELY;  //指令等待
                           end
                           4'b0011: begin
                               DsRstEn <= 1'b1;  //使能复位功能
                               NS <= RSTIDLE;  //启动复位时序
                           end
                           4'b0100: begin
                               NS <= WIREIDLE;  //启动写数捿
                               WireEn <= 1'b1;  //使能写数捿
                               WireCmd <= 8'hcc;  //发?0xcc
                           end
                           4'b0101: begin
                               NS <= WIREIDLE;  //启动写数捿
                               WireEn <= 1'b1;  //使能写数捿
                               WireCmd <= 8'hbe;  //发?0xbe
                           end
                           4'b0110: begin
                               NS <= READIDLE;  //启动读数据低使
                               ReadEn <= 1'b1;  //使能读数捿
                           end
                           4'b0111: begin
                               DataL <= ReadData;  //保存低位数据
                               NS <= READIDLE;  //启动读数据低使
                               ReadEn <= 1'b1;  //使能读数捿
                           end    
                           4'b1000: begin
                               DataH <= ReadData;  //保存高位数据
                               NS <= CMDIDLE;  //状濁空闿
                           end
                           default: NS <= CMDIDLE;  //其它未知情况跳转至起始位罿 
                       endcase
                       CmdCnt <= CmdCnt + 1'b1;  //计数
                   end
        /*                ds18b20指令延时                */
                   CMDDELY: begin
                       TimingEn <= 1'b1;  //使能时序
                       if(TimingCnt == RstPulse) begin
                           TimingEn <= 1'b0;  //禁能时序
                           NS <= CMDFUN;  //发?功能指仿
                       end
                       else begin
                           NS <= CMDDELY;  //继续等待执行
                       end
                   end
        /*                ds18b20复位时序                */
                   RSTIDLE: begin
                       if(DsRstEn) begin
                           DqDir <= 1'b1;  //设置为输凿
                           DqOut <= 1'b0;  //拉低数据线
                           TimingEn <= 1'b1;  //使能时序
                           NS <= RSTPUL;  //启动复位时序
                       end
                       else begin
                           NS <= RSTIDLE;  //继续等待执行
                       end
                   end
                   RSTPUL: begin
                       if(TimingCnt == RstPulse) begin
                           DqDir <= 1'b0;  //设置为输兿
                           DqOut <= 1'b1;  //拉高数据线
                           TimingEn <= 1'b0;  //禁能时序
                           NS <= RSTWAIT;  //主机拉高总线，等待从机应筿
                       end
                       else begin
                           NS <= RSTPUL;  //继续等待执行
                       end
                   end
                   RSTWAIT: begin
                       TimingEn <= 1'b1;  //使能时序
                       if(!DQ) begin
                           NS <= RSTPRE;  //复位成功状濿
                       end
                       else if(TimingCnt == RstPulse) begin
                           TimingEn <= 1'b0;  //禁能时序
                           NS <= RSTIDLE;  //返回空闲状濿
                       end
                   end
                   RSTPRE: begin
                       if(TimingCnt == RstPulse) begin
                           DsRstEn <= 1'b0;  //禁能复位功能
                           TimingEn <= 1'b0;  //禁能时序
                           DqDir <= 1'b0;  //设置为输兿
                           DqOut <= 1'b1;  //拉高数据线
                           NS <= CMDFUN;  //发?功能指仿
                       end
                   end
        /*                ds18b20写时庿                */
                   WIREIDLE: begin 
                       if(WireEn) begin
                           DqDir <= 1'b1;  //设置为输凿
                           DqOut <= 1'b0;  //拉低数据线
                           TimingEn <= 1'b1;  //使能时序
                           WireBus <= WireCmd;   //写指令传辿
                           NS <= WIREPUL;  //启动写时庿
                       end
                       else begin
                           WireBus <= 8'b0000_0000;  //数据清空
                           NS <= WIREIDLE;  //状濁空闿
                       end
                   end
                   WIREPUL: begin
                       TimingEn <= 1'b1;  //使能时序
                       if(PulseClk) begin  //等待5us
                           TimingEn <= 1'b0;  //禁能时序
                           NS <= WIREBIT;  //写bit
                       end
                       else begin
                           NS <= WIREPUL;  //继续等待执行
                       end
                   end
                   WIREBIT: begin
                       TimingEn <= 1'b1;  //使能时序
                       DqOut <= WireBus[0];  //写一使
                       if(TimingCnt == Samples) begin 
                           TimingEn <= 1'b0;  //禁能时序
                           DqOut <= 1'b1;  //拉高数据线
                           NS <= WIRESFT;  //数据移位
                       end
                       else begin
                           NS <= WIREBIT;  //继续等待执行
                       end
                   end
                   WIRESFT: begin
                       TimingEn <= 1'b1;  //使能时序
                       if(PulseClk) begin  //间隔丿5us
                           DqDir <= 1'b1;  //设置为输凿
                           DqOut <= 1'b0;  //拉低数据线
                           TimingEn <= 1'b0;  //禁能时序
                           WireBus <= WireBus >> 1'b1;  //移位
                           wSftCnt <= wSftCnt + 1'b1;  //记录次数
                           if(wSftCnt == 4'b0111) begin
                               wSftCnt <= 4'b0000;  //次数置零
                               DqDir <= 1'b0;  //设置为输兿
                               DqOut <= 1'b1;  //拉高数据线
                               NS <= CMDFUN;  //发?功能指仿
                           end
                           else begin
                               NS <= WIREPUL;  //启动写时庿
                           end
                       end
                       else begin
                           NS <= WIRESFT;  //继续等待执行
                       end
                   end
        /*                ds18b20读时庿                */
                   READIDLE: begin 
                       if(ReadEn) begin
                           DqDir <= 1'b1;  //设置为输凿
                           DqOut <= 1'b0;  //拉低数据线
                           TimingEn <= 1'b1;  //使能时序
                           NS <= READPUL;  //启动写时庿
                       end
                       else begin
                           ReadData <= 8'b0000_0000;  //数据清空 
                           NS <= READIDLE;  //状濁空闿
                       end
                   end
                   READPUL: begin
                       TimingEn <= 1'b1;  //使能时序
                       if(PulseClk) begin  //等待5us
                           TimingEn <= 1'b0;  //禁能时序
                           DqDir <= 1'b0;  //设置为输兿
                           DqOut <= 1'b1;  //拉高数据线
                           NS <= READBIT;  //读bit
                       end
                       else begin
                           NS <= READPUL;  //继续等待执行
                       end
                   end
                   READBIT: begin
                       TimingEn <= 1'b1;  //使能时序
                       if(PulseClk) begin  //等待5us
                           TimingEn <= 1'b0;  //禁能时序
                           ReadData[7] <= DQ;  //读一使
                           NS <= READSFT;  //数据移位
                       end
                       else begin
                           NS <= READBIT;  //继续等待执行
                       end
                   end
                   READSFT: begin
                       TimingEn <= 1'b1;  //使能时序
                       if(TimingCnt == Samples) begin  //间隔丿80us
                           TimingEn <= 1'b0;  //使能时序
                           DqDir <= 1'b1;  //设置为输凿
                           DqOut <= 1'b0;  //拉低数据线
                           rSftCnt <= rSftCnt + 1'b1;  //记录次数
                           if(rSftCnt == 4'b0111) begin
                               rSftCnt <= 4'b0000;  //次数置零
                               DqDir <= 1'b0;  //设置为输兿
                               DqOut <= 1'b1;  //拉高数据线
                               NS <= CMDFUN;  //发?功能指仿
                           end
                           else begin
                               ReadData <= ReadData >> 1'b1;  //移位
                               NS <= READPUL;  //启动写时庿
                           end
                       end
                       else begin
                           NS <= READSFT;  //继续等待执行
                       end
                   end
                   default: NS <= CMDIDLE;  //其它未知情况跳转至起始位罿
               endcase
           end
        end
  endmodule