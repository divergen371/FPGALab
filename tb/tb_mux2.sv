`timescale 1ns / 1ps `default_nettype none

module tb_mux2;

    // --- 信号の定義 ---
    logic d0;
    logic d1;
    logic sel;
    logic y;

    // --- テスト対象モジュール (DUT) のインスタンス化 ---
    mux2 uut (
        .d0 (d0),
        .d1 (d1),
        .sel(sel),
        .y  (y)
    );

    // --- テストシナリオ ---
    initial begin
        // 波形出力の準備
        $dumpfile("sim/mux2.vcd");
        $dumpvars(0, tb_mux2);

        // モニタ出力: 信号の変化をコンソールに出力
        $monitor("Time=%3t | sel=%b, d1=%b, d0=%b | y=%b", $time, sel, d1, d0, y);

        // テストケース開始
        $display("--- Start 2:1 MUX Test ---");

        // パターン1: 両方0
        sel = 0;
        d0  = 0;
        d1  = 0;
        #10;

        // パターン2: d0のみ1、sel=0 なので y=d0(1) が出力されるはず
        sel = 0;
        d0  = 1;
        d1  = 0;
        #10;

        // パターン3: そのまま sel=1 に切り替え、y=d1(0) になるはず
        sel = 1;
        #10;

        // パターン4: 両方1、sel=1 なので y=d1(1) が出力されるはず
        sel = 1;
        d0  = 1;
        d1  = 1;
        #10;

        // パターン5: d1のみ1、sel=0 なので y=d0(0) が出力されるはず
        sel = 0;
        d0  = 0;
        d1  = 1;
        #10;

        // パターン6: そのまま sel=1 に切り替え、y=d1(1) になるはず
        sel = 1;
        #10;

        $display("--- Simulation Finished ---");
        $finish;
    end

endmodule
`default_nettype wire
