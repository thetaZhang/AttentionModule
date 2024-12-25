// Softmax.v
// Softmax module with simplifiled function: softmax(A[i,j])=(A[i,j]-min([i,:]))^2

`include "Min.v"
`include "Quantization.v"

module Softmax#(
  parameter INPUT_DATA_WIDTH = 16,
  parameter OUTPUT_DATA_WIDTH = 16,
  parameter DATA_LENGTH = 4
)(
  // input is a vector, output is a vector which every position is the softmax of input
  // input format: MSB{{MSBn,LSBn},..., {MSB1,LSB1}, {MSB0,LSB0}}LSB
  
  input [INPUT_DATA_WIDTH * DATA_LENGTH - 1 : 0] in,
  output [OUTPUT_DATA_WIDTH * DATA_LENGTH - 1 : 0] out
);

  wire [INPUT_DATA_WIDTH - 1 : 0 ] in_min;

  Min#(
    .DATA_WIDTH(INPUT_DATA_WIDTH),
    .DATA_LENGTH(DATA_LENGTH)
  ) input_min(
    .in(in),
    .out(in_min)
  );

  genvar i;
  generate
    for (i = 0; i < DATA_LENGTH; i = i + 1) begin
      wire [INPUT_DATA_WIDTH - 1 : 0] in_element;
      wire [2 * INPUT_DATA_WIDTH - 1 : 0] in_qua;
      wire [OUTPUT_DATA_WIDTH - 1 : 0] out_qua;
      assign in_element = in[INPUT_DATA_WIDTH * (i + 1) - 1 : INPUT_DATA_WIDTH * i];
      assign in_qua = (in_element - in_min) * (in_element - in_min);
      Quantization #(
      .INPUT_INTEGER_WIDTH(2*INPUT_DATA_WIDTH/2),
      .INPUT_DECIMAL_WIDTH(2*INPUT_DATA_WIDTH/2),
      .OUTPUT_INTEGER_WIDTH(OUTPUT_DATA_WIDTH/2),
      .OUTPUT_DECIMAL_WIDTH(OUTPUT_DATA_WIDTH/2)
      ) quantization(
        .in(in_qua),
        .out(out_qua)
      );
      assign out[OUTPUT_DATA_WIDTH * (i + 1) - 1 : OUTPUT_DATA_WIDTH * i] = out_qua;
    end
  endgenerate

endmodule