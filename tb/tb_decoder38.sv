`timescale 1ns / 1ps
`default_nettype none

module tb_decoder38;

    // --- 信号の定義 ---
    logic [2:0] a;
    logic       en;
    logic [7:0] y;

    // --- テスト対象モジュール (DUT) のインスタンス化 ---
    decoder38 uut (
        .a  (a),
        .en (en),
        .y  (y)
    );

    // --- テストシナリオ ---
    initial begin
        // 波形出力の準備
        $dumpfile("sim/decoder38.vcd");
        $dumpvars(0, tb_decoder38);

        // モニタ出力: 信号の変化をコンソールに出力
        $monitor("Time=%3t | en=%b, a=%3b | y=%8b", $time, en, a, y);

        $display("--- Start 3-to-8 Decoder Test ---");

        // テスト1: en = 0 のテスト (a を変えても y は 0 のままのはず)
        $display("\n--- Test 1: en = 0 (Output should be all 0) ---");
        en = 0;
        a = 3'b000; #10;
        a = 3'b011; #10;
        a = 3'b111; #10;

        // テスト2: en = 1 のテスト (a に応じて y の該当ビットが 1 になるはず)
        $display("\n--- Test 2: en = 1 (Normal Operation) ---");
        en = 1;
        a = 3'b000; #10; // y = 00000001
        a = 3'b001; #10; // y = 00000010
        a = 3'b010; #10; // y = 00000100
        a = 3'b011; #10; // y = 00001000
        a = 3'b100; #10; // y = 00010000
        a = 3'b101; #10; // y = 00100000
        a = 3'b110; #10; // y = 01000000
        a = 3'b111; #10; // y = 10000000

        $display("\n--- Simulation Finished ---");
        $finish;
    end

endmodule
`default_nettype wire
