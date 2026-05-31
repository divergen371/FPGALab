`timescale 1ns / 1ps `default_nettype none

module tb_adder4;

    // --- 信号の定義 ---
    logic [3:0] a;
    logic [3:0] b;
    logic       cin;
    logic [3:0] sum;
    logic       cout;

    // --- テスト対象モジュール (DUT) のインスタンス化 ---
    adder4 uut (
        .a   (a),
        .b   (b),
        .cin (cin),
        .sum (sum),
        .cout(cout)
    );

    // --- テストシナリオ ---
    initial begin
        // 波形出力の準備
        $dumpfile("sim/adder4.vcd");
        $dumpvars(0, tb_adder4);

        // モニタ出力: 計算が分かりやすいように10進数(%0d)で出力
        $monitor("Time=%3t | cin=%b, a=%2d, b=%2d | cout=%b, sum=%2d", $time, cin, a, b, cout, sum);

        $display("--- Start 4-bit Adder Test ---");

        // テストケース (4'd5 は 4ビットの10進数5 という意味)
        $display("\n--- cin = 0 ---");
        cin = 0;
        a   = 4'd5;
        b   = 4'd3;
        #10;  // 5 + 3 = 8 (cout=0, sum=8)
        cin = 0;
        a   = 4'd10;
        b   = 4'd5;
        #10;  // 10 + 5 = 15 (cout=0, sum=15)
        cin = 0;
        a   = 4'd10;
        b   = 4'd6;
        #10;  // 10 + 6 = 16 (cout=1, sum=0)  ※4ビットで表せる最大は15なので桁あふれ

        $display("\n--- cin = 1 ---");
        cin = 1;
        a   = 4'd5;
        b   = 4'd3;
        #10;  // 5 + 3 + 1 = 9 (cout=0, sum=9)
        cin = 1;
        a   = 4'd15;
        b   = 4'd0;
        #10;  // 15 + 0 + 1 = 16 (cout=1, sum=0)
        cin = 1;
        a   = 4'd15;
        b   = 4'd15;
        #10;  // 15 + 15 + 1 = 31 (cout=1, sum=15)

        $display("\n--- Simulation Finished ---");
        $finish;
    end

endmodule
`default_nettype wire
