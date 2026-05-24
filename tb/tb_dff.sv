`timescale 1ns / 1ps
`default_nettype none

module tb_dff;

    // --- 信号の定義 ---
    logic clk;
    logic rst_n;
    logic d;
    logic q;

    // --- テスト対象モジュール (DUT) のインスタンス化 ---
    dff uut (
        .clk   (clk),
        .rst_n (rst_n),
        .d     (d),
        .q     (q)
    );

    // --- クロック生成 ---
    // 10nsごとに反転 (周期20nsのクロック)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // --- テストシナリオ ---
    initial begin
        // 波形出力の準備
        $dumpfile("sim/dff.vcd");
        $dumpvars(0, tb_dff);

        $monitor("Time=%3t | rst_n=%b, clk=%b, d=%b | q=%b", $time, rst_n, clk, d, q);

        $display("--- Start D Flip-Flop Test ---");

        // 初期化とリセット
        d = 0;
        rst_n = 0; // リセットON
        #25;
        rst_n = 1; // リセット解除
        $display("\n--- Reset Released ---");

        // クロックに合わせたデータの取り込みテスト
        // クロックの立ち上がりの直後(#1)に d を変化させる
        @(posedge clk); #1 d = 1; // 次の立ち上がりで q=1 になるはず
        @(posedge clk); #1 d = 0; // 次の立ち上がりで q=0 になるはず
        @(posedge clk); #1 d = 1; // 次の立ち上がりで q=1 になるはず
        
        // 非同期リセットのテスト
        // クロックに関係ないタイミングでリセットをかける
        #5; 
        $display("\n--- Asynchronous Reset Test ---");
        rst_n = 0; // ここで瞬時に q=0 になるはず
        #15; 
        rst_n = 1;

        #20;
        $display("\n--- Simulation Finished ---");
        $finish;
    end

endmodule
`default_nettype wire
