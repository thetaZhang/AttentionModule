//AdderTree.v
// adder tree

module AdderTree#(
    parameter INPUT_DATA_WIDTH = 16,
    parameter DATA_LENGTH = 4
)(
    input [INPUT_DATA_WIDTH*DATA_LENGTH - 1 : 0] in,
    output [INPUT_DATA_WIDTH + $clog2(DATA_LENGTH) - 1 : 0] out
);

    localparam OUTPUT_DATA_WIDTH = INPUT_DATA_WIDTH + $clog2(DATA_LENGTH);
    localparam DATA_LENGTH_A = DATA_LENGTH / 2;
    localparam DATA_LENGTH_B = DATA_LENGTH - DATA_LENGTH_A;
    localparam OUTPUT_DATA_WIDTH_A = INPUT_DATA_WIDTH + $clog2(DATA_LENGTH_A);
    localparam OUTPUT_DATA_WIDTH_B = INPUT_DATA_WIDTH + $clog2(DATA_LENGTH_B);

generate
    if (DATA_LENGTH == 1) 
        assign out = in;
    else begin 
        wire [OUTPUT_DATA_WIDTH_A - 1 : 0] out_a;
        wire [OUTPUT_DATA_WIDTH_B - 1 : 0] out_b;

        wire [INPUT_DATA_WIDTH * DATA_LENGTH_A - 1 : 0] in_a;
        wire [INPUT_DATA_WIDTH * DATA_LENGTH_B - 1 : 0] in_b;

        assign in_a = in[INPUT_DATA_WIDTH * DATA_LENGTH_A - 1 : 0];
        assign in_b = in[INPUT_DATA_WIDTH * DATA_LENGTH - 1 : INPUT_DATA_WIDTH * DATA_LENGTH_A];

        AdderTree #(
            .INPUT_DATA_WIDTH(INPUT_DATA_WIDTH),
            .DATA_LENGTH(DATA_LENGTH_A)
        ) AdderTreeA(
            .in(in_a),
            .out(out_a)
        );

        AdderTree #(
            .INPUT_DATA_WIDTH(INPUT_DATA_WIDTH),
            .DATA_LENGTH(DATA_LENGTH_B)
        ) AdderTreeB(
            .in(in_b),
            .out(out_b)
        );

        assign out = out_a + out_b;

    end
    
endgenerate

endmodule



