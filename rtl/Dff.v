// Dff.v
// D-FlipFlop with parameter, asynchronous reset, low active reset

module Dff #(
  parameter DATA_WIDTH = 1
)(
  input clk,
  input rst_n,

  input [DATA_WIDTH - 1 : 0] d,
  output [DATA_WIDTH - 1 : 0] q
);

  reg [DATA_WIDTH - 1 : 0] q_reg;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) 
      q_reg <= {DATA_WIDTH{1'b0}};
    else 
      q_reg <= d;
  end

  assign q = q_reg;

endmodule