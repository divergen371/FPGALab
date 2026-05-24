`timescale 1ns / 1ps
`default_nettype none

module tb_full_adder;

    // --- 信号の定義 ---
    logic a;
    logic b;
    logic cin;
    logic sum;
    logic cout;

    // --- テスト対象モジュール (DUT) のインスタンス化 ---
    full_adder uut (
        .a    (a),
        .b    (b),
        .cin  (cin),
        .sum  (sum),
        .cout (cout)
    );

    // --- テストシナリオ ---
    initial begin
        // 波形出力の準備
        $dumpfile("sim/full_adder.vcd");
        $dumpvars(0, tb_full_adder);

        // モニタ出力: 信号の変化をコンソールに出力
        $monitor("Time=%3t | cin=%b, a=%b, b=%b | cout=%b, sum=%b", $time, cin, a, b, cout, sum);

        $display("--- Start Full Adder Test ---");

        // 全8パターンのテスト
        // cin, a, b の順で 000 〜 111 まで変化させます
        cin = 0; a = 0; b = 0; #10; // 0+0+0 = 0 (cout=0, sum=0)
        cin = 0; a = 0; b = 1; #10; // 0+0+1 = 1 (cout=0, sum=1)
        cin = 0; a = 1; b = 0; #10; // 0+1+0 = 1 (cout=0, sum=1)
        cin = 0; a = 1; b = 1; #10; // 0+1+1 = 2 (cout=1, sum=0)
        
        cin = 1; a = 0; b = 0; #10; // 1+0+0 = 1 (cout=0, sum=1)
        cin = 1; a = 0; b = 1; #10; // 1+0+1 = 2 (cout=1, sum=0)
        cin = 1; a = 1; b = 0; #10; // 1+1+0 = 2 (cout=1, sum=0)
        cin = 1; a = 1; b = 1; #10; // 1+1+1 = 3 (cout=1, sum=1)

        $display("--- Simulation Finished ---");
        $finish;
    end

endmodule
`default_nettype wire
