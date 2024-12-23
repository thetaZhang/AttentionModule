// Quantization.v
// quantize the input data to the given bit width in the fixed point format

module Quantization#(
  parameter INPUT_INTEGER_WIDTH = 18,
  parameter INPUT_DECIMAL_WIDTH = 16, 
  parameter OUTPUT_INTEGER_WIDTH = 8,
  parameter OUTPUT_DECIMAL_WIDTH = 8
)(
  input [(INPUT_INTEGER_WIDTH + INPUT_DECIMAL_WIDTH)-1 : 0] in,
  output [(OUTPUT_INTEGER_WIDTH + OUTPUT_DECIMAL_WIDTH)-1 : 0] out
);

  localparam INPUT_WIDTH = INPUT_INTEGER_WIDTH + INPUT_DECIMAL_WIDTH;
  localparam OUTPUT_WIDTH = OUTPUT_INTEGER_WIDTH + OUTPUT_DECIMAL_WIDTH;

  wire [INPUT_INTEGER_WIDTH-1 : 0] input_integer;
  wire [INPUT_DECIMAL_WIDTH-1 : 0] input_decimal;

  wire is_overflow;
  wire [OUTPUT_WIDTH - 1 : 0] out_part;
  wire round_carry;

  assign input_integer = in[INPUT_WIDTH - 1 : INPUT_DECIMAL_WIDTH];
  assign input_decimal = in[INPUT_DECIMAL_WIDTH - 1 : 0];

  // if the MSBs out of the output width have 1, which means if overflow
  assign is_overflow = (|input_integer[INPUT_INTEGER_WIDTH - 1 : OUTPUT_INTEGER_WIDTH]);
  
  // directly cut the output bits in the input
  assign out_part = {input_integer[OUTPUT_INTEGER_WIDTH-1:0], input_decimal[INPUT_DECIMAL_WIDTH - 1 : INPUT_DECIMAL_WIDTH - OUTPUT_DECIMAL_WIDTH]};

  // if the decimal bit to be throw have carry in
  assign round_carry = input_decimal[(INPUT_DECIMAL_WIDTH - OUTPUT_DECIMAL_WIDTH) - 1];

  // Saturate and Round
  assign out = (is_overflow)  ? {OUTPUT_WIDTH{1'b1}} : 
               (~(&out_part) && round_carry) ? {out_part + 1'b1} :
               (out_part) ;

endmodule