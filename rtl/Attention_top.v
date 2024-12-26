// Attention_top.v
// attention top module

`define DATA_WIDTH 16 // 8 MSBs integer part, 8 LSBs decimal part
`define TOKEN_DIM 4
`define TOKEN_NUM 8

module Attention_top(
  input clk,
  input rst_n,

  input [`DATA_WIDTH * `TOKEN_DIM * `TOKEN_NUM - 1 : 0] Q,
  input [`DATA_WIDTH * `TOKEN_DIM * `TOKEN_NUM - 1 : 0] K,
  input [`DATA_WIDTH * `TOKEN_DIM * `TOKEN_NUM - 1 : 0] V,

  output [`DATA_WIDTH * `TOKEN_DIM * `TOKEN_NUM - 1 : 0] token_out

);

wire [`DATA_WIDTH * `TOKEN_DIM * `TOKEN_NUM - 1 : 0] V_stage_1_to_2;
wire [`DATA_WIDTH * `TOKEN_NUM * `TOKEN_NUM - 1 : 0] A_stage_1_to_2;

wire [`DATA_WIDTH * `TOKEN_DIM * `TOKEN_NUM - 1 : 0] V_stage_2_to_3;
wire [`DATA_WIDTH * `TOKEN_NUM * `TOKEN_NUM - 1 : 0] S_stage_2_to_3;

QKMatMul#(
  .DATA_WIDTH(`DATA_WIDTH),
  .TOKEN_DIM(`TOKEN_DIM),
  .TOKEN_NUM(`TOKEN_NUM)
) QKMatMulPipeline(
  .clk(clk),
  .rst_n(rst_n),

  .Q_in(Q),
  .K_in(K),
  .V_in(V),

  .A_out(A_stage_1_to_2),
  .V_out(V_stage_1_to_2)
);

AttnSoftmax#(
  .DATA_WIDTH(`DATA_WIDTH),
  .TOKEN_DIM(`TOKEN_DIM),
  .TOKEN_NUM(`TOKEN_NUM)
) AttnSoftmaxPipeline(
  .clk(clk),
  .rst_n(rst_n),

  .A_in(A_stage_1_to_2),
  .V_in(V_stage_1_to_2),

  .S_out(S_stage_2_to_3),
  .V_out(V_stage_2_to_3)
);

SVMatMul#(
  .DATA_WIDTH(`DATA_WIDTH),
  .TOKEN_DIM(`TOKEN_DIM),
  .TOKEN_NUM(`TOKEN_NUM)
) SVMatMulUnit(
  .clk(clk),
  .rst_n(rst_n),

  .S_in(S_stage_2_to_3),
  .V_in(V_stage_2_to_3),

  .token_out(token_out)
);




endmodule