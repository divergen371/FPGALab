`default_nettype none

module decoder38 (
    input  logic [2:0] a,
    input  logic       en,
    output logic [7:0] y
);

    assign y = en ? (8'b0000_0001 << a) : 8'b0000_0000;

endmodule
