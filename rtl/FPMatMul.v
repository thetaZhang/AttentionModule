// FPMatMul.v
// Fix Point matrix multiplication module

module FPMatMul#(
  parameter INPUT_DATA_WIDTH = 16, // half MSBs integer part, half LSBs decimal part
  parameter OUTPUT_DATA_WIDTH = 16, // half MSBs integer part, half LSBs decimal part
  parameter ROW_1 = 8,
  parameter COL_1 = 4,
  parameter ROW_2 = 4,
  parameter COL_2 = 8
)(
  input [INPUT_DATA_WIDTH-1:0] mat_in1[0:ROW_1-1][0:COL_1-1],
  input [INPUT_DATA_WIDTH-1:0] mat_in2[0:ROW_2-1][0:COL_2-1],

  output [OUTPUT_DATA_WIDTH-1:0] mat_out[0:ROW_1-1][0:COL_2-1]
);

genvar i, j;
generate
  for (i = 0; i<ROW_1; i=i+1) 
    for (j = 0; j<COL_1; j=j+1) 
      FPMAC#(

      ) Mac(
        
      )
endgenerate

endmodule