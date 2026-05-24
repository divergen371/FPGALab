`default_nettype none

module shifter4 (
    input  logic [3:0] a,
    input  logic [1:0] shift_val,
    input  logic       dir,
    output logic [3:0] y
);
    assign y = (dir == 0) ? (a << shift_val) : (a >> shift_val);
endmodule
