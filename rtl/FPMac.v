// FPMac.v
// Fix Point multiply accumulate module

/*
`include "Quantization.v"
`include "AdderTree.v"
*/
module FPMac#(
  parameter INPUT_DATA_WIDTH = 16, // half MSBs integer part, half LSBs decimal part
  parameter OUTPUT_DATA_WIDTH = 16, // half MSBs integer part, half LSBs decimal part
  parameter DATA_LENGTH = 4
  )(
  // input format: MSB{{MSBn,LSBn},..., {MSB1,LSB1}, {MSB0,LSB0}}LSB
  
  input [INPUT_DATA_WIDTH * DATA_LENGTH - 1 : 0] in_1,
  input [INPUT_DATA_WIDTH * DATA_LENGTH - 1 : 0] in_2,

  output [OUTPUT_DATA_WIDTH-1:0] out
);

// input reshape to vector
wire [INPUT_DATA_WIDTH - 1 : 0] in_vec_1 [0 : DATA_LENGTH - 1];
wire [INPUT_DATA_WIDTH - 1 : 0] in_vec_2 [0 : DATA_LENGTH - 1];

genvar k;
generate 
  for (k = 0; k < DATA_LENGTH; k = k + 1) begin
    assign in_vec_1[k] = in_1[INPUT_DATA_WIDTH * (k + 1) - 1 : INPUT_DATA_WIDTH * k];
    assign in_vec_2[k] = in_2[INPUT_DATA_WIDTH * (k + 1) - 1 : INPUT_DATA_WIDTH * k];
  end
endgenerate

// after multiplication, the data width will be doubled
// Fix8_8 * Fix8_8 = Fix16_16
wire [2*INPUT_DATA_WIDTH*DATA_LENGTH-1:0] mul_out;

// after accumulation, the data width will increase [log_2((DATA_LENGT)](times of add)
wire [($clog2(DATA_LENGTH)+2*INPUT_DATA_WIDTH)-1:0] acc_out;

//  multiplication and accumulation
genvar i;
generate
  for (i = 0; i < DATA_LENGTH; i = i + 1) 
    assign mul_out[2*INPUT_DATA_WIDTH*(i+1)-1:2*INPUT_DATA_WIDTH*i] = in_vec_1[i] * in_vec_2[i]; 
  
  AdderTree #(
    .INPUT_DATA_WIDTH(2*INPUT_DATA_WIDTH),
    .DATA_LENGTH(DATA_LENGTH)
  ) AdderTreeMul(
    .in(mul_out),
    .out(acc_out)
  );

endgenerate




// accumulation result is quantized then get the output
Quantization #(
  .INPUT_INTEGER_WIDTH(2*INPUT_DATA_WIDTH/2 + $clog2(DATA_LENGTH)),
  .INPUT_DECIMAL_WIDTH(2*INPUT_DATA_WIDTH/2),
  .OUTPUT_INTEGER_WIDTH(OUTPUT_DATA_WIDTH/2),
  .OUTPUT_DECIMAL_WIDTH(OUTPUT_DATA_WIDTH/2)
) QuantizationUnit(
  .in(acc_out),
  .out(out)
);

endmodule