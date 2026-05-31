`timescale 1ns / 1ps `default_nettype none

module tb_pc;

    // --- 信号の定義 ---
    logic       clk;
    logic       rst_n;
    logic       load_en;
    logic [3:0] load_addr;
    logic [3:0] addr;

    // --- テスト対象モジュール (DUT) のインスタンス化 ---
    pc uut (
        .clk      (clk),
        .rst_n    (rst_n),
        .load_en  (load_en),
        .load_addr(load_addr),
        .addr     (addr)
    );

    // --- クロック生成 ---
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // --- テストシナリオ ---
    initial begin
        // 波形出力の準備
        $dumpfile("sim/pc.vcd");
        $dumpvars(0, tb_pc);

        $monitor("Time=%3t | rst_n=%b load_en=%b load_addr=%2d | PC addr=%2d", $time, rst_n, load_en, load_addr, addr);

        $display("--- Start Program Counter Test ---");

        // 初期化とリセット
        load_en   = 0;
        load_addr = 0;
        rst_n     = 0;
        #25;
        rst_n = 1;
        $display("\n--- Reset Released (Start counting up) ---");

        // 通常のカウントアップ (何サイクルか待つ)
        #100;

        // Jump (ロード) テスト
        $display("\n--- Jump to address 8 ---");
        @(posedge clk);
        #1;
        load_en   = 1;
        load_addr = 4'd8;  // 次の立ち上がりで8にジャンプ
        @(posedge clk);
        #1;
        load_en = 0;  // ジャンプ完了、再びカウントアップへ

        // その後またカウントアップ
        #60;

        $display("\n--- Simulation Finished ---");
        $finish;
    end

endmodule
`default_nettype wire
