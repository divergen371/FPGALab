`timescale 1ns / 1ps
`default_nettype none

module tb_comparator4;

    // --- 信号の定義 ---
    logic [3:0] a;
    logic [3:0] b;
    logic       eq;
    logic       gt;
    logic       lt;

    // --- テスト対象モジュール (DUT) のインスタンス化 ---
    comparator4 uut (
        .a  (a),
        .b  (b),
        .eq (eq),
        .gt (gt),
        .lt (lt)
    );

    // --- テストシナリオ ---
    initial begin
        // 波形出力の準備
        $dumpfile("sim/comparator4.vcd");
        $dumpvars(0, tb_comparator4);

        // モニタ出力
        $monitor("Time=%3t | a=%2d, b=%2d | eq=%b, gt=%b, lt=%b", 
                 $time, a, b, eq, gt, lt);

        $display("--- Start 4-bit Comparator Test ---");

        // テストケース
        $display("\n--- Test 1: Equal ---");
        a = 4'd5;  b = 4'd5;  #10; // eq=1, gt=0, lt=0
        
        $display("\n--- Test 2: Greater Than (a > b) ---");
        a = 4'd10; b = 4'd5;  #10; // eq=0, gt=1, lt=0
        a = 4'd15; b = 4'd0;  #10; // eq=0, gt=1, lt=0
        
        $display("\n--- Test 3: Less Than (a < b) ---");
        a = 4'd3;  b = 4'd8;  #10; // eq=0, gt=0, lt=1
        a = 4'd0;  b = 4'd15; #10; // eq=0, gt=0, lt=1

        $display("\n--- Simulation Finished ---");
        $finish;
    end

endmodule
`default_nettype wire
