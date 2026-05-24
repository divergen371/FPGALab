`default_nettype none

module mux4 (
    input  logic       d0,
    input  logic       d1,
    input  logic       d2,
    input  logic       d3,
    input  logic [1:0] sel,
    output logic       y
);

    always_comb begin
        case (sel)
            2'b11:   y = d3;
            2'b10:   y = d2;
            2'b01:   y = d1;
            2'b00:   y = d0;
            default: y = 1'bx;  // x = don't care (安全のため)
        endcase
    end
endmodule
