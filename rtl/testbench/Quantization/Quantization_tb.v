// Quantization_tb.v
`include "../../Quantization.v"
module Quantization_tb();

reg 


Quantization #(
  .INPUT_INTEGER_WIDTH(18),
  .INPUT_DECIMAL_WIDTH(16),
  .OUTPUT_INTEGER_WIDTH(8),
  .OUTPUT_DECIMAL_WIDTH(8)
) DUT(
  .in(in_data),
  .out(out_data)
);


endmodule;