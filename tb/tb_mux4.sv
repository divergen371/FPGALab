`timescale 1ns / 1ps `default_nettype none

module tb_mux4;

    // --- 信号の定義 ---
    logic d0, d1, d2, d3;
    logic [1:0] sel;  // 2ビットの選択信号
    logic       y;

    // --- テスト対象モジュール (DUT) のインスタンス化 ---
    mux4 uut (
        .d0 (d0),
        .d1 (d1),
        .d2 (d2),
        .d3 (d3),
        .sel(sel),
        .y  (y)
    );

    // --- テストシナリオ ---
    initial begin
        // 波形出力の準備
        $dumpfile("sim/mux4.vcd");
        $dumpvars(0, tb_mux4);

        // モニタ出力: 信号の変化をコンソールに出力
        $monitor("Time=%3t | sel=%b | d3=%b d2=%b d1=%b d0=%b | y=%b", $time, sel, d3, d2, d1, d0, y);

        $display("--- Start 4:1 MUX Test ---");

        // 入力データパターン1: d3=1, d2=0, d1=1, d0=0
        d0 = 0;
        d1 = 1;
        d2 = 0;
        d3 = 1;
        $display("\n--- Pattern 1: {d3, d2, d1, d0} = 1010 ---");
        sel = 2'b00;
        #10;  // y = d0(0) になるはず
        sel = 2'b01;
        #10;  // y = d1(1) になるはず
        sel = 2'b10;
        #10;  // y = d2(0) になるはず
        sel = 2'b11;
        #10;  // y = d3(1) になるはず

        // 入力データパターン2: d3=0, d2=1, d1=0, d0=1
        d0 = 1;
        d1 = 0;
        d2 = 1;
        d3 = 0;
        $display("\n--- Pattern 2: {d3, d2, d1, d0} = 0101 ---");
        sel = 2'b00;
        #10;  // y = d0(1) になるはず
        sel = 2'b01;
        #10;  // y = d1(0) になるはず
        sel = 2'b10;
        #10;  // y = d2(1) になるはず
        sel = 2'b11;
        #10;  // y = d3(0) になるはず

        $display("\n--- Simulation Finished ---");
        $finish;
    end

endmodule
`default_nettype wire
