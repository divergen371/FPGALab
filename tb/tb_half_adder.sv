`timescale 1ns / 1ps
`default_nettype none

module tb_half_adder;

    // --- 信号の定義 ---
    logic a;
    logic b;
    logic sum;
    logic carry;

    // --- テスト対象モジュール (DUT) のインスタンス化 ---
    half_adder uut (
        .a     (a),
        .b     (b),
        .sum   (sum),
        .carry (carry)
    );

    // --- テストシナリオ ---
    initial begin
        // 波形出力の準備
        $dumpfile("sim/half_adder.vcd");
        $dumpvars(0, tb_half_adder);

        // モニタ出力: 信号の変化をコンソールに出力
        $monitor("Time=%3t | a=%b, b=%b | carry=%b, sum=%b", $time, a, b, carry, sum);

        $display("--- Start Half Adder Test ---");

        // 全4パターンのテスト
        a = 0; b = 0; #10; // 0 + 0 = 0 (carry=0, sum=0)
        a = 0; b = 1; #10; // 0 + 1 = 1 (carry=0, sum=1)
        a = 1; b = 0; #10; // 1 + 0 = 1 (carry=0, sum=1)
        a = 1; b = 1; #10; // 1 + 1 = 2 (carry=1, sum=0)

        $display("--- Simulation Finished ---");
        $finish;
    end

endmodule
`default_nettype wire
