// FPMac_tb.v
`timescale 1ns/1ps
`include "../../FPMac.v"

module FPMac_tb();

reg [15 : 0] data_1 [0 : 3];
reg [15 : 0] data_2 [0 : 3];

reg [16*4 - 1 : 0] in_data_1;
reg [16*4 - 1 : 0] in_data_2;
 

always @( *) begin
  in_data_1 = {data_1[3], data_1[2], data_1[1], data_1[0]};
  in_data_2 = {data_2[3], data_2[2], data_2[1], data_2[0]};
end

wire [15 : 0] out_data;

real tmp = (1<<8);

FPMac#(
  .INPUT_DATA_WIDTH(16),
  .OUTPUT_DATA_WIDTH(16),
  .DATA_LENGTH(4)
) DUT(
  .in_1(in_data_1),
  .in_2(in_data_2),
  .out(out_data)
);

initial begin
  $readmemb("test_data1.txt", data_1);
  $readmemb("test_data2.txt", data_2);
  #10 
  /*
  $display("in1:%b %b %b %b ",data_1[0], data_1[1], data_1[2], data_1[3]);
  $display("in2:%b %b %b %b ",data_2[0], data_2[1], data_2[2], data_2[3]);
  
  $display("in1_module:%b %b %b %b ",DUT.in_vec_1[0], DUT.in_vec_1[1], DUT.in_vec_1[2], DUT.in_vec_1[3]);
  $display("in2_module:%b %b %b %b ",DUT.in_vec_2[0], DUT.in_vec_2[1], DUT.in_vec_2[2], DUT.in_vec_2[3]);
  
  $display("mul_out:%b %b %b %b ",DUT.mul_out[0], DUT.mul_out[1], DUT.mul_out[2], DUT.mul_out[3]);
  
  for (integer i = 0; i < 4; i = i + 1) begin
    if (DUT.mul_out[i] != data_1[i] * data_2[i]) 
      $display("mul_out[%0d] is wrong", i);
    else 
      $display("mul_out[%0d] is correct", i);
  end

  $display("acc_scan:%b %b %b %b ",DUT.acc_scan[0], DUT.acc_scan[1], DUT.acc_scan[2], DUT.acc_scan[3]);

  if (DUT.acc_scan[3] != data_1[0] * data_2[0] + data_1[1] * data_2[1] + data_1[2] * data_2[2] + data_1[3] * data_2[3]) 
    $display("acc_scan[3] is wrong");
  else 
    $display("acc_scan[3] is correct");
  */
  $display("out:%b %f", out_data, out_data[15 : 8] + out_data[7 : 0] / tmp);
  #10 $finish;
end


endmodule