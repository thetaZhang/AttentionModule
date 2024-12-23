// FPMac.v
// Fix Point multiply accumulate module

module FPMac#(
  parameter INPUT_DATA_WIDTH = 16, // half MSBs integer part, half LSBs decimal part
  parameter OUTPUT_DATA_WIDTH = 16, // half MSBs integer part, half LSBs decimal part
  parameter DATA_LENGTH = 4
  )(
  input [INPUT_DATA_WIDTH-1:0] in_1[0:DATA_LENGTH-1],
  input [INPUT_DATA_WIDTH-1:0] in_2[0:DATA_LENGTH-1],

  output [OUTPUT_DATA_WIDTH-1:0] out
);

// after multiplication, the data width will be doubled
// Fix8_8 * Fix8_8 = Fix16_16
wire [2*INPUT_DATA_WIDTH-1:0] mul_out[0:DATA_LENGTH-1];

// after accumulation, the data width will increase [log_2((DATA_LENGT)](times of add)
wire [($clog2(DATA_LENGTH)+2*INPUT_DATA_WIDTH)-1:0] acc_scan[0:DATA_LENGTH-1];

//  multiplication
genvar i;
generate
  for (i = 0; i < DATA_LENGTH; i = i + 1) 
    assign mul_out[i] = in_1[i] * in_2[i];
endgenerate

// accumulation
genvar j;
generate
  for (j = 0; j < DATA_LENGTH; j = j + 1) 
    assign acc_scan[j] = (j == 0) ? mul_out[j] : acc_scan[j-1] + mul_out[j];
endgenerate


// accumulation result is quantized then get the output
Quantization #(
  .INPUT_INTEGER_WIDTH(2*INPUT_DATA_WIDTH/2),
  .INPUT_DECIMAL_WIDTH(2*INPUT_DATA_WIDTH/2 + $clog2(DATA_LENGTH)),
  .OUTPUT_INTEGER_WIDTH(OUTPUT_DATA_WIDTH/2),
  .OUTPUT_DECIMAL_WIDTH(OUTPUT_DATA_WIDTH/2)
) quantization(
  .in(acc_scan[DATA_LENGTH - 1]),
  .out(out)
);

endmodule