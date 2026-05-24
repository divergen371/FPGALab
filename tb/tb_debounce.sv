`timescale 1ns / 1ps

module tb_debounce;

    // 信号の定義
    logic clk;
    logic reset;
    logic in_btn;
    logic out_btn;

    // クロック生成 (100MHz: 周期10ns, 半周期5ns)
    initial clk = 0;
    always #5 clk = ~clk;

    // テスト対象モジュール (DUT) のインスタンス化
    // シミュレーション高速化のため判定限界 LIMIT を 8 クロックに設定
    debounce #(
        .LIMIT(8)
    ) u_debounce (
        .clk    (clk),
        .reset  (reset),
        .in_btn (in_btn),
        .out_btn(out_btn)
    );

    initial begin
        // 波形出力の設定
        $dumpfile("sim/debounce.vcd");
        $dumpvars(0, tb_debounce);

        // 信号の監視表示
        $monitor("Time=%0d ns | reset=%b | in_btn=%b | out_btn=%b | counter=%d", $time, reset, in_btn, out_btn,
                 u_debounce.counter);

        // 初期化
        reset  = 1'b1;
        in_btn = 1'b1;  // 離している状態 (1)
        #20;

        reset = 1'b0;
        #30;

        // 🚀 テスト1: 押す瞬間のチャタリング（バウンド）の再現
        $display("\n--- Test 1: Button Press with Chattering ---");

        in_btn = 1'b0;
        #10;  // 1クロック分 0 になるが
        in_btn = 1'b1;
        #10;  // すぐ 1 に戻る (バウンド)
        in_btn = 1'b0;
        #20;  // 2クロック分 0 になるが
        in_btn = 1'b1;
        #10;  // また 1 に戻る (バウンド)

        $display("--- Button signal becomes stable at 0 ---");
        in_btn = 1'b0;  // ここから安定して 0 になる
        #150;  // 15クロック分待つ (LIMITの8クロックを超える)

        // 🚀 テスト2: 離す瞬間のチャタリング（バウンド）の再現
        $display("\n--- Test 2: Button Release with Chattering ---");

        in_btn = 1'b1;
        #10;  // 1クロック分 1 になるが
        in_btn = 1'b0;
        #10;  // すぐ 0 に戻る (バウンド)
        in_btn = 1'b1;
        #20;  // 2クロック分 1 になるが
        in_btn = 1'b0;
        #10;  // すぐ 0 に戻る (バウンド)

        $display("--- Button signal becomes stable at 1 ---");
        in_btn = 1'b1;  // ここから安定して 1 になる
        #150;  // 15クロック分待つ

        $display("\nSimulation finished.");
        $finish;
    end

endmodule
