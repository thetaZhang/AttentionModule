// MatSoftmax_tb.v
`timescale 1ns/1ps
`include "../../MatSoftmax.v"

module MatSoftmax_tb();

reg [15 : 0] data_1 [0 : 63];

reg [16*64 - 1 : 0] in_data_1;


genvar i,j;
generate
  for(i = 0; i < 64; i = i + 1 )
    always @( *) begin
      in_data_1[16 * (i+1) - 1 : 16 * i]=data_1[i];
    end
endgenerate

wire [16*64 - 1 : 0] out_data;

wire [15 : 0] out_data_mat [0 : 7][0 : 7];

generate
  for (i = 0; i < 8; i = i + 1) 
    for (j = 0; j < 8; j = j + 1) 
     assign out_data_mat[i][j] = out_data[16 * (i * 8 + j + 1) - 1 : 16 * (i * 8 + j)];
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
  
  #10 
  $display("out:");
  for (integer index = 0; index < 8; index = index + 1) begin
    for (integer iindex = 0; iindex < 8; iindex = iindex + 1)begin
      $write("%f ",out_data_mat[index][iindex][15 : 8] + out_data_mat[index][iindex][7 : 0] / tmp);
    end
    $write("\n");
    end
  #10 $finish;
end


endmodule