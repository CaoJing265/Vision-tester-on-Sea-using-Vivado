(* X_CORE_INFO = "uart_top,Vivado 2018.2" *)
(* CHECK_LICENSE_TYPE = "BlueTooth_0,uart_top,{}" *)
(* CORE_GENERATION_INFO = "BlueTooth_0,uart_top,{x_ipProduct=Vivado 2018.2,x_ipVendor=xilinx.com,x_ipLibrary=xup,x_ipName=BlueTooth,x_ipVersion=1.0,x_ipCoreRevision=3,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,DVSR=651,DATA_WIDTH=8,SB_TICK=16}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module BlueTooth_0 (
  clk,
  reset,
  rx,
  tx_btn,
  data_in,
  data_out,
  rx_done,
  tx_done,
  tx
);

input wire clk;
input wire reset;
input wire rx;
input wire tx_btn;
input wire [7 : 0] data_in;
output wire [7 : 0] data_out;
output wire rx_done;
output wire tx_done;
output wire tx;

  uart_top #(
    .DVSR(651),
    .DATA_WIDTH(8),
    .SB_TICK(16)
  ) inst (
    .clk(clk),
    .reset(reset),
    .rx(rx),
    .tx_btn(tx_btn),
    .data_in(data_in),
    .data_out(data_out),
    .rx_done(rx_done),
    .tx_done(tx_done),
    .tx(tx)
  );
endmodule