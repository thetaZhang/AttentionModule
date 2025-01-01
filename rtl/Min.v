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

localparam DATA_LENGTH_A = DATA_LENGTH / 2;
localparam DATA_LENGTH_B = DATA_LENGTH - DATA_LENGTH_A;


generate
    if (DATA_LENGTH == 1)
        assign out = in;
    else begin
        wire [DATA_WIDTH - 1 : 0] out_a;
        wire [DATA_WIDTH - 1 : 0] out_b;

        wire [DATA_WIDTH * DATA_LENGTH_A - 1 : 0] in_a;
        wire [DATA_WIDTH * DATA_LENGTH_B - 1 : 0] in_b;

        assign in_a = in[DATA_WIDTH * DATA_LENGTH_A - 1 : 0];
        assign in_b = in[DATA_WIDTH * DATA_LENGTH - 1 : DATA_WIDTH * DATA_LENGTH_A];

        Min #(
            .DATA_WIDTH(DATA_WIDTH),
            .DATA_LENGTH(DATA_LENGTH_A)
        ) MinA(
            .in(in_a),
            .out(out_a)
        );

        Min #(
            .DATA_WIDTH(DATA_WIDTH),
            .DATA_LENGTH(DATA_LENGTH_B)
        ) MinB(
            .in(in_b),
            .out(out_b)
        );

        assign out = (out_a < out_b) ? out_a : out_b;

    end
endgenerate



endmodule