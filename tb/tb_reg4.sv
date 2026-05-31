`timescale 1ns / 1ps `default_nettype none

module tb_reg4;

    // --- 信号の定義 ---
    logic       clk;
    logic       rst_n;
    logic [3:0] d;
    logic [3:0] q;

    // --- テスト対象モジュール (DUT) のインスタンス化 ---
    reg4 uut (
        .clk  (clk),
        .rst_n(rst_n),
        .d    (d),
        .q    (q)
    );

    // --- クロック生成 ---
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // --- テストシナリオ ---
    initial begin
        // 波形出力の準備
        $dumpfile("sim/reg4.vcd");
        $dumpvars(0, tb_reg4);

        $monitor("Time=%3t | rst_n=%b, clk=%b, d=%4b | q=%4b", $time, rst_n, clk, d, q);

        $display("--- Start 4-bit Register Test ---");

        d     = 4'b0000;
        rst_n = 0;
        #25;
        rst_n = 1;

        // クロックの立ち上がりに合わせて d を変化させる
        @(posedge clk);
        #1 d = 4'b1010;  // 次の立ち上がりで取り込まれる
        @(posedge clk);
        #1 d = 4'b0101;  // 次の立ち上がりで取り込まれる
        @(posedge clk);
        #1 d = 4'b1111;  // 次の立ち上がりで取り込まれる

        #5;
        rst_n = 0;  // 非同期リセット
        #15;
        rst_n = 1;

        #20;
        $display("--- Simulation Finished ---");
        $finish;
    end

endmodule
`default_nettype wire
