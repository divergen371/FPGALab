`timescale 1ns / 1ps

module tb_top_button_demo;

    // 信号の定義
    logic       clk;
    logic       key1;
    logic       key2;
    logic [5:0] led;

    // クロック生成 (100MHz: 周期10ns, 半周期5ns)
    initial clk = 0;
    always #5 clk = ~clk;

    // テスト対象モジュール (DUT) のインスタンス化
    top_button_demo u_top (
        .clk (clk),
        .key1(key1),
        .key2(key2),
        .led (led)
    );

    // シミュレーション高速化のため、内部のデバウンスおよび長押し判定のパラメータを書き換える
    defparam u_top.u_debounce.LIMIT = 8;
        defparam u_top.LONG_PRESS_LIMIT = 20;  // 20クロック（200ns相当）長押しで確定

    initial begin
        // 波形出力の設定
        $dumpfile("sim/top_button_demo.vcd");
        $dumpvars(0, tb_top_button_demo);

        // 信号の監視表示
        $monitor("Time=%0d ns | RST=%b | BTN=%b | deb=%b | pulse=%b | long_cnt=%d | pressed=%b | led=%b", $time, key2,
                 key1, u_top.key1_deb, u_top.key1_pulse, u_top.long_counter, u_top.long_pressed, led);

        // 初期化 (キーは両方離した状態 = 1)
        key1 = 1'b1;
        key2 = 1'b1;
        #20;

        // リセットをかける (key2 = 0)
        $display("\n--- Apply Reset (S1 press) ---");
        key2 = 1'b0;
        #30;
        key2 = 1'b1;  // リセット解除
        #20;

        // 🚀 テスト1: ボタン S2 を短く押す (カウントアップの検証)
        $display("\n--- Test 1: Short Button Press (count-up) ---");
        key1 = 1'b0;  // 押す (0)
        #100;  // 10クロック分待つ (デバウンス8クロックは超えるが、長押し20クロックには満たない)
        key1 = 1'b1;  // 離す (1)
        #100;

        // 🚀 テスト2: ボタン S2 を長押しする (3秒長押し模擬: 300ns = 30クロック押し続ける)
        $display("\n--- Test 2: Long Button Press (trigger all-on) ---");
        key1 = 1'b0;  // 押し始める (0)
        #300;  // 長押しLIMIT(20クロック=200ns)を超える時間押し続ける

        $display("--- Release Button ---");
        key1 = 1'b1;  // 離す
        #150;

        $display("\nSimulation finished.");
        $finish;
    end

endmodule
