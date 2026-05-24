`default_nettype none

module comparator4 (
    input  logic [3:0] a,
    input  logic [3:0] b,
    output logic       eq,
    output logic       gt,
    output logic       lt
);

    assign eq = (a == b);
    assign gt = (a > b);
    assign lt = (a < b);

endmodule
