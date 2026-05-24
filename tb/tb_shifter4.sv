`timescale 1ns / 1ps
`default_nettype none

module tb_shifter4;

    // --- 信号の定義 ---
    logic [3:0] a;
    logic [1:0] shift_val;
    logic       dir;
    logic [3:0] y;

    // --- テスト対象モジュール (DUT) のインスタンス化 ---
    shifter4 uut (
        .a         (a),
        .shift_val (shift_val),
        .dir       (dir),
        .y         (y)
    );

    // --- テストシナリオ ---
    initial begin
        // 波形出力の準備
        $dumpfile("sim/shifter4.vcd");
        $dumpvars(0, tb_shifter4);

        // モニタ出力: 2進数(%4b)で出力してビットの動きを確認
        $monitor("Time=%3t | dir=%b, a=%4b, shift_val=%0d | y=%4b", 
                 $time, dir, a, shift_val, y);

        $display("--- Start 4-bit Shifter Test ---");

        // テストケース
        a = 4'b0011; // 初期値 3
        
        $display("\n--- Left Shift (dir=0) ---");
        dir = 0;
        shift_val = 0; #10; // 0ビットシフト (y = 0011)
        shift_val = 1; #10; // 1ビット左シフト (y = 0110)
        shift_val = 2; #10; // 2ビット左シフト (y = 1100)
        shift_val = 3; #10; // 3ビット左シフト (y = 1000) <- 溢れた1は消える

        a = 4'b1100; // 初期値 12
        
        $display("\n--- Right Shift (dir=1) ---");
        dir = 1;
        shift_val = 0; #10; // 0ビットシフト (y = 1100)
        shift_val = 1; #10; // 1ビット右シフト (y = 0110)
        shift_val = 2; #10; // 2ビット右シフト (y = 0011)
        shift_val = 3; #10; // 3ビット右シフト (y = 0001) <- 溢れた0は消える
        
        $display("\n--- Simulation Finished ---");
        $finish;
    end

endmodule
`default_nettype wire
