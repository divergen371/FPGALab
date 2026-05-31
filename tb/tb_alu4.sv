`timescale 1ns / 1ps `default_nettype none

module tb_alu4;

    // --- 信号の定義 ---
    logic [3:0] a;
    logic [3:0] b;
    logic [2:0] op;
    logic [3:0] y;
    logic       zero;
    logic       carry;

    // --- テスト対象モジュール (DUT) のインスタンス化 ---
    alu4 uut (
        .a    (a),
        .b    (b),
        .op   (op),
        .y    (y),
        .zero (zero),
        .carry(carry)
    );

    // --- テストシナリオ ---
    initial begin
        // 波形出力の準備
        $dumpfile("sim/alu4.vcd");
        $dumpvars(0, tb_alu4);

        // モニタ出力: 2進数と10進数を併記して分かりやすく
        $monitor("Time=%3t | op=%3b | a=%4b(%2d), b=%4b(%2d) | y=%4b(%2d) | zero=%b, carry=%b", $time, op, a, a, b, b,
                 y, y, zero, carry);

        $display("--- Start 4-bit ALU Test ---");

        // 基本テスト: a = 5, b = 3
        a = 4'd5;
        b = 4'd3;

        $display("\n--- ADD (op=000) ---");
        op = 3'b000;
        #10;  // 5 + 3 = 8

        $display("\n--- SUB (op=001) ---");
        op = 3'b001;
        #10;  // 5 - 3 = 2

        $display("\n--- AND (op=010) ---");
        op = 3'b010;
        #10;  // 0101 & 0011 = 0001 (1)

        $display("\n--- OR  (op=011) ---");
        op = 3'b011;
        #10;  // 0101 | 0011 = 0111 (7)

        $display("\n--- XOR (op=100) ---");
        op = 3'b100;
        #10;  // 0101 ^ 0011 = 0110 (6)

        $display("\n--- SLL (op=101) ---");
        op = 3'b101;
        #10;  // 5 << 1 = 10

        $display("\n--- SRL (op=110) ---");
        op = 3'b110;
        #10;  // 5 >> 1 = 2

        $display("\n--- PASS_B (op=111) ---");
        op = 3'b111;
        #10;  // b(3) をそのまま出力

        $display("\n--- Flag Test (carry / zero) ---");
        a  = 4'd15;
        b  = 4'd1;
        op = 3'b000;
        #10;  // 15 + 1 = 16 (carry=1, zero=1, y=0)
        a  = 4'd7;
        b  = 4'd7;
        op = 3'b001;
        #10;  // 7 - 7 = 0  (zero=1, y=0)

        $display("\n--- Simulation Finished ---");
        $finish;
    end

endmodule
`default_nettype wire
