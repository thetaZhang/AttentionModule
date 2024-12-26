// Min_tb.v
`timescale 1ns/1ps
`include "../../Min.v"

module Min_tb();

reg [15 : 0] data_1 [0 : 7];

reg [16*8 - 1 : 0] in_data_1;

wire [15 : 0] out_data;


genvar i;
generate
  for(i = 0; i < 8; i = i + 1 )
    always @( *) begin
      in_data_1[16 * (i+1) - 1 : 16 * i]=data_1[i];
    end
endgenerate


Min#(
  .DATA_WIDTH(16),
  .DATA_LENGTH(8)
) DUT(
  .in(in_data_1),
  .out(out_data)
);

initial begin
  $readmemb("test_data1.txt", data_1);
  #10 
  
  $display("%b",out_data);
  #10 $finish;
end



endmodule