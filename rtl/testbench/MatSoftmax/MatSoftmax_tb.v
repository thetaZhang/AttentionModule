// MatSoftmax_tb.v
`timescale 1ns/1ps
`include "../../MatSoftmax.v"

module MatSoftmax_tb();

reg [15 : 0] data_1 [0 : 15];
reg [15 : 0] data_2 [0 : 15];

reg [16*16 - 1 : 0] in_data_1;
reg [16*16 - 1 : 0] in_data_2;
 

always @( *) begin
  in_data_1 = {data_1[15], data_1[14], data_1[13], data_1[12], data_1[11], data_1[10], data_1[9], data_1[8], data_1[7], data_1[6], data_1[5], data_1[4], data_1[3], data_1[2], data_1[1], data_1[0]};
  in_data_2 = {data_2[15], data_2[14], data_2[13], data_2[12], data_2[11], data_2[10], data_2[9], data_2[8], data_2[7], data_2[6], data_2[5], data_2[4], data_2[3], data_2[2], data_2[1], data_2[0]};
end

wire [16*16 - 1 : 0] out_data;

wire [15 : 0] out_data_mat [0 : 4][0 : 4];

genvar i,j;
generate
  for (i = 0; i < 4; i = i + 1) 
    for (j = 0; j < 4; j = j + 1) 
     assign out_data_mat[i][j] = out_data[16 * (i * 4 + j + 1) - 1 : 16 * (i * 4 + j)];
endgenerate

real tmp = (1<<8);

MatSoftmax#(
  .INPUT_DATA_WIDTH(16),
  .OUTPUT_DATA_WIDTH(16),
  .ROW_IN(8),
  .COL_IN(8)
) DUT(
  .in(in_data_1),
  .out(out_data)
);

initial begin
  $readmemb("test_data1.txt", data_1);
  $readmemb("test_data2.txt", data_2);
  #10 
  $display("out:");
  for (integer index = 0; index < 4; index = index + 1) 
      $display("%f %f %f %f", out_data_mat[index][0][15 : 8] + out_data_mat[index][0][7 : 0] / tmp, out_data_mat[index][1][15 : 8] + out_data_mat[index][1][7 : 0] / tmp, out_data_mat[index][2][15 : 8] + out_data_mat[index][2][7 : 0] / tmp, out_data_mat[index][3][15 : 8] + out_data_mat[index][3][7 : 0] / tmp);

  #10 $finish;
end


endmodule