// Min.v
// find min of input vector

module Min#(
  parameter DATA_WIDTH = 16,
  parameter DATA_LENGTH = 8
)(
  // input format: MSB{{MSBn,LSBn},..., {MSB1,LSB1}, {MSB0,LSB0}}LSB

  input [DATA_WIDTH * DATA_LENGTH - 1 : 0] in,
  output [DATA_WIDTH - 1 : 0] out
);

wire [DATA_WIDTH - 1 : 0] in_vector [0 : DATA_LENGTH];

genvar i;
generate
  for (i = 0; i < DATA_LENGTH; i = i + 1)
    assign in_vector[i] = in[DATA_WIDTH * (i + 1) - 1 : DATA_WIDTH * i];
endgenerate

generate
  if (DATA_LENGTH == 1) 
    
  
endgenerate


endmodule