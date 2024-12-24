// Quantization_tb.v
`include "../../Quantization.v"
`timescale 1ns/1ps
module Quantization_tb();

reg [33:0] in_data;
wire [15:0] out_data;


Quantization #(
  .INPUT_INTEGER_WIDTH(18),
  .INPUT_DECIMAL_WIDTH(16),
  .OUTPUT_INTEGER_WIDTH(8),
  .OUTPUT_DECIMAL_WIDTH(8)
) DUT(
  .in(in_data),
  .out(out_data)
);

real tmp =  (1 << 8);

initial begin
  in_data = 34'b0;

  #10  generate_test_data(in_data);
  #5 $display("output: %b,%0f",out_data,out_data[15:8] + out_data[7:0] /tmp);

  #10 $finish;
  
end

task generate_test_data;
  output [33:0] data; 
  reg [17:0] integer_part;
  reg [15:0] decimal_part;
  real data_real;
  real tmp;
  begin
    integer_part = 18'b000000000010110100;
    decimal_part = 16'b1011001110000000;
    tmp = (1 << 16);
    data_real = integer_part + decimal_part / tmp;

    $display("input:%b, %b, %0f",integer_part,decimal_part,data_real);

    data = {integer_part, decimal_part};
  end
endtask

initial
begin            
    $dumpfile("wave.vcd");        //生成的vcd文件名称
    $dumpvars(0, Quantization_tb);    //tb模块名称
end

endmodule