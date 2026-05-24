`default_nettype none

module adder4 (
    input  logic [3:0] a,
    input  logic [3:0] b,
    input  logic       cin,
    output logic [3:0] sum,
    output logic [4:0] sum5,
    output logic       cout
);
    assign {cout, sum} = a + b + cin;
    //assign sum5[4:0] = a + b + cin;
    //assign cout      = sum5[4];
    //assign sum       = sum5[3:0];

endmodule
