// QKMatMul.v
// First stage of pipeline: Q*K^T
/*
`include "FPMatMul.v"
`include "Dff.v"
`include "Transpose.v"
*/
module QKMatMul#(
  parameter DATA_WIDTH = 16,
  parameter TOKEN_DIM = 4,
  parameter TOKEN_NUM = 8
)(
  input clk,
  input rst_n,

  input [DATA_WIDTH * TOKEN_DIM * TOKEN_NUM - 1 : 0] Q_in,
  input [DATA_WIDTH * TOKEN_DIM * TOKEN_NUM - 1 : 0] K_in,
  input [DATA_WIDTH * TOKEN_DIM * TOKEN_NUM - 1 : 0] V_in,

  output [DATA_WIDTH * TOKEN_NUM * TOKEN_NUM - 1 : 0] A_out,
  output [DATA_WIDTH * TOKEN_DIM * TOKEN_NUM - 1 : 0] V_out
);

wire [DATA_WIDTH * TOKEN_DIM * TOKEN_NUM - 1 : 0] K_transpose;
wire [DATA_WIDTH * TOKEN_NUM * TOKEN_NUM - 1 : 0] A;

 
Transpose#(
  .DATA_WIDTH(DATA_WIDTH),
  .ROW_IN(TOKEN_NUM),
  .COL_IN(TOKEN_DIM)
) TransposeUnit(
  .in(K_in),
  .out(K_transpose)
);

FPMatMul#(
  .INPUT_DATA_WIDTH(DATA_WIDTH),
  .OUTPUT_DATA_WIDTH(DATA_WIDTH),
  .ROW_1(TOKEN_NUM),
  .COL_1(TOKEN_DIM),
  .ROW_2(TOKEN_DIM),
  .COL_2(TOKEN_NUM)
) MatmulUnit(
  .in_1(Q_in),
  .in_2(K_transpose),
  .out(A)
);

Dff#(
  .DATA_WIDTH(DATA_WIDTH * TOKEN_NUM * TOKEN_NUM)
) AttnReg(
  .clk(clk),
  .rst_n(rst_n),

  .d(A),
  .q(A_out)
);

Dff#(
  .DATA_WIDTH(DATA_WIDTH * TOKEN_DIM * TOKEN_NUM)
) ValueReg(
  .clk(clk),
  .rst_n(rst_n),

  .d(V_in),
  .q(V_out)
);





endmodule