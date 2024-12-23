// Attention_top.v
// attention top module

`define DATA_WIDTH 16 // 8 MSBs integer part, 8 LSBs decimal part
`define TOKEN_DIM 4
`define TOKEN_NUM 8

module Attention_top(
  input clk,
  input rst_n,

  input [DATA_WIDTH-1:0] Q [][],
  input [DATA_WIDTH-1:0] K [][],
  input [DATA_WIDTH-1:0] V [][],

  output reg [DATA_WIDTH-1:0] O[][],
  output flag
);





endmodule