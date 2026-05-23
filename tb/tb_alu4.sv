`timescale 1ns / 1ps

module tb_alu4;

    logic [3:0] a;
    logic [3:0] b;
    logic [2:0] op;
    logic [3:0] y;
    logic       zero;
    logic       carry;

    alu4 dut (
        .a    (a),
        .b    (b),
        .op   (op),
        .y    (y),
        .zero (zero),
        .carry(carry)
    );

    initial begin
        $dumpfile("sim/alu4.vcd");
        $dumpvars(0, tb_alu4);

        a  = 4'd3;
        b  = 4'd5;
        op = 3'b000;
        #10;
        a  = 4'd8;
        b  = 4'd2;
        op = 3'b001;
        #10;
        a  = 4'b1010;
        b  = 4'b1100;
        op = 3'b010;
        #10;
        a  = 4'b1010;
        b  = 4'b1100;
        op = 3'b011;
        #10;
        a  = 4'b1010;
        b  = 4'b1100;
        op = 3'b100;
        #10;
        a  = 4'b0011;
        b  = 4'b0000;
        op = 3'b101;
        #10;
        a  = 4'b1000;
        b  = 4'b0000;
        op = 3'b110;
        #10;
        a  = 4'd0;
        b  = 4'd9;
        op = 3'b111;
        #10;

        $finish;
    end

endmodule
