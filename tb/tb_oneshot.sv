`timescale 1ns / 1ps

module tb_oneshot;

    // 信号の定義
    logic clk;
    logic reset;
    logic in_btn;
    logic out_pulse;

    // クロック生成 (100MHz: 周期10ns, 半周期5ns)
    initial clk = 0;
    always #5 clk = ~clk;

    // テスト対象モジュール (DUT) のインスタンス化
    oneshot u_oneshot (
        .clk      (clk),
        .reset    (reset),
        .in_btn   (in_btn),
        .out_pulse(out_pulse)
    );

    initial begin
        // 波形出力の設定
        $dumpfile("sim/oneshot.vcd");
        $dumpvars(0, tb_oneshot);

        // 信号の監視表示
        $monitor("Time=%0d ns | reset=%b | in_btn=%b | out_pulse=%b", $time, reset, in_btn, out_pulse);

        // 初期化
        reset  = 1'b1;
        in_btn = 1'b1;  // 離している状態 (1)
        #20;

        reset = 1'b0;
        #30;

        // 🚀 テスト1: ボタンを短く押す (30ns = 3クロック幅)
        $display("\n--- Test 1: Short Button Press (30ns) ---");
        in_btn = 1'b0;  // 押す (0)
        #30;
        in_btn = 1'b1;  // 離す (1)
        #50;

        // 🚀 テスト2: ボタンを長く押す (100ns = 10クロック幅)
        // 押し続けていても、パルスは最初の一瞬（1クロック）しか出ないことを検証
        $display("\n--- Test 2: Long Button Press (100ns) ---");
        in_btn = 1'b0;  // 押す (0)
        #100;
        in_btn = 1'b1;  // 離す (1)
        #50;

        $display("\nSimulation finished.");
        $finish;
    end

endmodule
