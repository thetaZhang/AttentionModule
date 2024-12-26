// Attention_top.v
// attention top module

`include "Dff.v"
`include "QKMatMul.v"
`include "AttnSoftmax.v"
`include "SVMatMul.v"

module Attention_top#(
  parameter DATA_WIDTH = 16,// 8 MSBs integer part, 8 LSBs decimal part
  parameter TOKEN_DIM = 4,
  parameter TOKEN_NUM = 8
)(
  input clk,
  input rst_n,


  input [DATA_WIDTH * TOKEN_DIM * TOKEN_NUM - 1 : 0] Q,
  input [DATA_WIDTH * TOKEN_DIM * TOKEN_NUM - 1 : 0] K,
  input [DATA_WIDTH * TOKEN_DIM * TOKEN_NUM - 1 : 0] V,

  output [DATA_WIDTH * TOKEN_DIM * TOKEN_NUM - 1 : 0] token_out

);

wire [DATA_WIDTH * TOKEN_DIM * TOKEN_NUM - 1 : 0] V_stage_1_to_2;
wire [DATA_WIDTH * TOKEN_NUM * TOKEN_NUM - 1 : 0] A_stage_1_to_2;

wire [DATA_WIDTH * TOKEN_DIM * TOKEN_NUM - 1 : 0] V_stage_2_to_3;
wire [DATA_WIDTH * TOKEN_NUM * TOKEN_NUM - 1 : 0] S_stage_2_to_3;

wire [DATA_WIDTH * TOKEN_DIM * TOKEN_NUM - 1 : 0] Q_in;
wire [DATA_WIDTH * TOKEN_DIM * TOKEN_NUM - 1 : 0] K_in;
wire [DATA_WIDTH * TOKEN_DIM * TOKEN_NUM - 1 : 0] V_in;

Dff#(
  .DATA_WIDTH(DATA_WIDTH * TOKEN_DIM * TOKEN_NUM)
) QInputReg(
  .clk(clk),
  .rst_n(rst_n),

  .d(Q),
  .q(Q_in)
);

Dff#(
  .DATA_WIDTH(DATA_WIDTH * TOKEN_DIM * TOKEN_NUM)
) KInputReg(
  .clk(clk),
  .rst_n(rst_n),

  .d(K),
  .q(K_in)
);

Dff#(
  .DATA_WIDTH(DATA_WIDTH * TOKEN_DIM * TOKEN_NUM)
) VInputReg(
  .clk(clk),
  .rst_n(rst_n),

  .d(V),
  .q(V_in)
);

QKMatMul#(
  .DATA_WIDTH(DATA_WIDTH),
  .TOKEN_DIM(TOKEN_DIM),
  .TOKEN_NUM(TOKEN_NUM)
) QKMatMulPipeline(
  .clk(clk),
  .rst_n(rst_n),

  .Q_in(Q_in),
  .K_in(K_in),
  .V_in(V_in),

  .A_out(A_stage_1_to_2),
  .V_out(V_stage_1_to_2)
);

AttnSoftmax#(
  .DATA_WIDTH(DATA_WIDTH),
  .TOKEN_DIM(TOKEN_DIM),
  .TOKEN_NUM(TOKEN_NUM)
) AttnSoftmaxPipeline(
  .clk(clk),
  .rst_n(rst_n),

  .A_in(A_stage_1_to_2),
  .V_in(V_stage_1_to_2),

  .S_out(S_stage_2_to_3),
  .V_out(V_stage_2_to_3)
);

SVMatMul#(
  .DATA_WIDTH(DATA_WIDTH),
  .TOKEN_DIM(TOKEN_DIM),
  .TOKEN_NUM(TOKEN_NUM)
) SVMatMulUnit(
  .clk(clk),
  .rst_n(rst_n),

  .S_in(S_stage_2_to_3),
  .V_in(V_stage_2_to_3),

  .token_out(token_out)
);




endmodule