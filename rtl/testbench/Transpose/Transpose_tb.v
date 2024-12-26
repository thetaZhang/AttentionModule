// Transpose_tb.v
`timescale 1ns/1ps
`include "../../Transpose.v"

module Transpose_tb();

reg [3 : 0] data_1 [0 : 31];


reg [4*32 - 1 : 0] in_data_1;


wire [4*32 - 1 : 0] out_data;

wire [3 : 0] out_data_mat [0 : 7][0 : 3];

genvar i,j;
generate
  for(i = 0; i < 32; i = i + 1 )
    always @( *) begin
      in_data_1[4 * (i+1) - 1 : 4 * i]=data_1[i];
    end
endgenerate

generate
  for (i = 0; i < 8; i = i + 1) 
    for (j = 0; j < 4; j = j + 1) 
     assign out_data_mat[i][j] = out_data[4 * (i * 4 + j + 1) - 1 : 4 * (i * 4 + j)];
endgenerate

real tmp = (1<<8);

Transpose#(
  .DATA_WIDTH(4),
  .ROW_IN(4),
  .COL_IN(8)
) DUT(
  .in(in_data_1),
  .out(out_data)
);

initial begin
  $readmemb("test_data1.txt", data_1);
  #10 
  for (integer index = 0; index < 8; index = index + 1) 
      $display("%b %b %b %b",out_data_mat[index][0],out_data_mat[index][1],out_data_mat[index][2],out_data_mat[index][3]);
      //$display("%f %f %f %f", out_data_mat[index][0][15 : 8] + out_data_mat[index][0][7 : 0] / tmp, out_data_mat[index][1][15 : 8] + out_data_mat[index][1][7 : 0] / tmp, out_data_mat[index][2][15 : 8] + out_data_mat[index][2][7 : 0] / tmp, out_data_mat[index][3][15 : 8] + out_data_mat[index][3][7 : 0] / tmp);
  #10 $finish;
end


endmodule