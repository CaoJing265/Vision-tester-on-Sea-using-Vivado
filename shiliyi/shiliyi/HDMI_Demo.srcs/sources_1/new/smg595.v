module smg595
//---------------------<��������>---------------------------------------
#(
parameter SEG_SEL       = 8                 , //8λ
parameter SEG_DATA      = 8                   //8��
)
//---------------------<�˿�����>---------------------------------------
(
input                   clk                 , //ʱ�ӣ�50Mhz
input                   rst_n               , //��λ���͵�ƽ��Ч
input                   en                  , //�����ʹ���ź�
input  [SEG_SEL -1:0]   seg_sel             , //�����λѡ
input  [SEG_DATA-1:0]   seg_data            , //����ܶ�ѡ
output reg              ST_CP               , //�洢�Ĵ���ʱ�����
output reg              SH_CP               , //��λ�Ĵ���ʱ�����
output reg              DS                    //������������
);
//---------------------<�źŶ���>---------------------------------------
reg  [ 1:0]             cnt0                ;
wire                    add_cnt0            ;
wire                    end_cnt0            ;
reg  [ 5:0]             cnt1                ;
wire                    add_cnt1            ;
wire                    end_cnt1            ;
wire                    sclk                ; //��Ƶʱ���ź�
wire [ 5:0]             sclk_cnt            ; //���л�������

//----------------------------------------------------------------------
//--   4��Ƶ������
//----------------------------------------------------------------------
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        cnt0 <= 0;
    else if(add_cnt0)begin
        if(end_cnt0)
            cnt0 <= 0;
        else
            cnt0 <= cnt0 + 1;
    end
    else
        cnt0 <= cnt0;
end

assign add_cnt0 = en;
assign end_cnt0 = add_cnt0 && cnt0==4-1;

assign sclk = end_cnt0;

//----------------------------------------------------------------------
//--   ���л�������
//----------------------------------------------------------------------
always @(posedge clk or negedge rst_n)begin 
    if(!rst_n)
        cnt1 <= 0;
    else if(add_cnt1)begin
        if(end_cnt1)
            cnt1 <= 0;
        else
            cnt1 <= cnt1 + 1;
    end
    else
        cnt1 <= cnt1;
end

assign add_cnt1 = sclk;
assign end_cnt1 = add_cnt1 && cnt1==35-1;

assign sclk_cnt = cnt1;

//-------------------------------------------------------------------------------
//--   SHCP����λ�Ĵ�����ʱ������,������ʱ��λ�Ĵ����е����������ƶ�һλ
//--   STCP���洢�Ĵ�����ʱ������,������ʱ��λ�Ĵ����е����ݽ���洢�Ĵ���
//--   ͨ��STCP��Ϊ�͵�ƽ����λ����������ST_CP�˲���һ�������������ʾ����
//-------------------------------------------------------------------------------
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        ST_CP <= 0;
        SH_CP <= 0;
        DS    <= 0;
    end 
    else begin
        case(sclk_cnt)
             0: begin             SH_CP <= 0;                    end 
             1: begin ST_CP <= 0; SH_CP <= 1;                    end 
             2: begin             SH_CP <= 0; DS <= seg_data[7]; end
             3: begin             SH_CP <= 1;                    end
             4: begin             SH_CP <= 0; DS <= seg_data[6]; end
             5: begin             SH_CP <= 1;                    end
             6: begin             SH_CP <= 0; DS <= seg_data[5]; end
             7: begin             SH_CP <= 1;                    end
             8: begin             SH_CP <= 0; DS <= seg_data[4]; end
             9: begin             SH_CP <= 1;                    end
            10: begin             SH_CP <= 0; DS <= seg_data[3]; end
            11: begin             SH_CP <= 1;                    end
            12: begin             SH_CP <= 0; DS <= seg_data[2]; end
            13: begin             SH_CP <= 1;                    end
            14: begin             SH_CP <= 0; DS <= seg_data[1]; end
            15: begin             SH_CP <= 1;                    end
            16: begin             SH_CP <= 0; DS <= seg_data[0]; end
            17: begin             SH_CP <= 1;                    end
            18: begin             SH_CP <= 0; DS <= seg_sel[7];  end
            19: begin             SH_CP <= 1;                    end
            20: begin             SH_CP <= 0; DS <= seg_sel[6];  end
            21: begin             SH_CP <= 1;                    end
            22: begin             SH_CP <= 0; DS <= seg_sel[5];  end
            23: begin             SH_CP <= 1;                    end
            24: begin             SH_CP <= 0; DS <= seg_sel[4];  end
            25: begin             SH_CP <= 1;                    end
            26: begin             SH_CP <= 0; DS <= seg_sel[3];  end
            27: begin             SH_CP <= 1;                    end
            28: begin             SH_CP <= 0; DS <= seg_sel[2];  end
            29: begin             SH_CP <= 1;                    end
            30: begin             SH_CP <= 0; DS <= seg_sel[1];  end
            31: begin             SH_CP <= 1;                    end
            32: begin             SH_CP <= 0; DS <= seg_sel[0];  end
            33: begin             SH_CP <= 1;                    end
            34: begin ST_CP <= 1;                                end
            default:
                begin ST_CP <= 0; SH_CP <= 0; DS <= 0          ; end
        endcase
    end
end

endmodule