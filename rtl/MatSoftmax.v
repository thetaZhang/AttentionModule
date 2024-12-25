// MatSoftmax.v
// row-wise softmax of input matrix

`include "Softmax.v"
module MatSoftmax#(
  parameter INPUT_DATA_WIDTH = 16,
  parameter OUTPUT_DATA_WIDTH = 16,
  parameter ROW_IN = 8,
  parameter COL_IN = 8
)(
  // input format: MSB{{MSB(n-1,m-1),LSB(n-1,m-1)},..., {MSB(0,1),LSB(0,1}, {MSB(0,0),LSB(0,0)}}LSB
  // (i,j) means the i-th row and j-th column data
    input [INPUT_DATA_WIDTH * ROW_IN * COL_IN - 1 : 0] in,

    output [OUTPUT_DATA_WIDTH * ROW_IN * COL_IN - 1 : 0] out
);

genvar i;
generate
  for (i = 0; i < ROW_IN; i = i + 1) begin
    wire [INPUT_DATA_WIDTH * COL_IN - 1 : 0] in_row;
    wire [OUTPUT_DATA_WIDTH * COL_IN - 1 : 0] out_row;
    assign in_row = in[INPUT_DATA_WIDTH * (i + 1) * COL_IN - 1 : INPUT_DATA_WIDTH * i * COL_IN];
    Softmax#(
      .INPUT_DATA_WIDTH(INPUT_DATA_WIDTH),
      .OUTPUT_DATA_WIDTH(OUTPUT_DATA_WIDTH),
      .DATA_LENGTH(COL_IN)
    ) softmax_row(
      .in(in_row),
      .out(out_row)
    );
    assign out[OUTPUT_DATA_WIDTH * (i + 1) * COL_IN - 1 : OUTPUT_DATA_WIDTH * i * COL_IN]=out_row;
  end
endgenerate

endmodule