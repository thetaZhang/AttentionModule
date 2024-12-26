// FPMatMul.v
// Fix Point matrix multiplication module
`include "FPMac.v"
module FPMatMul#(
  parameter INPUT_DATA_WIDTH = 16, // half MSBs integer part, half LSBs decimal part
  parameter OUTPUT_DATA_WIDTH = 16, // half MSBs integer part, half LSBs decimal part
  parameter ROW_1 = 8,
  parameter COL_1 = 4,
  parameter ROW_2 = 4,
  parameter COL_2 = 8
)(
  // input format: MSB{{MSB(n-1,m-1),LSB(n-1,m-1)},..., {MSB(0,1),LSB(0,1}, {MSB(0,0),LSB(0,0)}}LSB
  // (i,j) means the i-th row and j-th column data
  input [INPUT_DATA_WIDTH * ROW_1 * COL_1 - 1 : 0] in_1,
  input [INPUT_DATA_WIDTH * ROW_2 * COL_2 - 1 : 0] in_2,

  output [OUTPUT_DATA_WIDTH * ROW_1 * COL_2 -1:0] out
);

// input reshape to row vector and column vector
wire [INPUT_DATA_WIDTH * COL_1 - 1 : 0] in_row_1[0 : ROW_1 - 1];
wire [INPUT_DATA_WIDTH * ROW_2 - 1 : 0] in_col_2[0 : COL_2 - 1];

genvar row1_index;
generate
  for (row1_index = 0; row1_index < ROW_1; row1_index = row1_index + 1) 
    assign in_row_1[row1_index] = 
    in_1[INPUT_DATA_WIDTH * COL_1 * (row1_index + 1) - 1 : INPUT_DATA_WIDTH * COL_1 * row1_index];
endgenerate

genvar row2_index,col2_index;
generate
  for (col2_index = 0; col2_index < COL_2; col2_index = col2_index + 1) 
    for (row2_index = 0; row2_index < ROW_2; row2_index = row2_index + 1) 
      assign in_col_2[col2_index][INPUT_DATA_WIDTH * (row2_index + 1) - 1 : INPUT_DATA_WIDTH * row2_index] = 
      in_2[INPUT_DATA_WIDTH *(row2_index * COL_2 + col2_index + 1) -1 : INPUT_DATA_WIDTH * (row2_index * COL_2 + col2_index)];
endgenerate

// output reshape to matrix
wire [OUTPUT_DATA_WIDTH-1:0] out_mat[0:ROW_1-1][0:COL_2-1];

generate
  for (row1_index = 0; row1_index < ROW_1; row1_index = row1_index + 1) 
    for (col2_index = 0; col2_index < COL_2; col2_index = col2_index + 1) 
      assign out[OUTPUT_DATA_WIDTH * (row1_index * COL_2 + col2_index + 1) - 1: OUTPUT_DATA_WIDTH * (row1_index * COL_2 + col2_index)] = 
      out_mat[row1_index][col2_index];
endgenerate


genvar i,j;
generate
  for (i = 0; i < ROW_1; i = i + 1) 
    for (j = 0; j < COL_2; j = j + 1) begin
      FPMac #(
        .INPUT_DATA_WIDTH(INPUT_DATA_WIDTH),
        .OUTPUT_DATA_WIDTH(OUTPUT_DATA_WIDTH),
        .DATA_LENGTH(COL_1)
      ) MacUnit(
        .in_1(in_row_1[i]),
        .in_2(in_col_2[j]),
        .out(out_mat[i][j])
      );
    end
endgenerate



endmodule