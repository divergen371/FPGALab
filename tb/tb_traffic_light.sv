`timescale 1ns / 1ps

module tb_traffic_light;

    // 信号の定義
    logic       clk;
    logic       key2;
    logic [2:0] led;

    // クロック生成 (100MHz: 周期10ns, 半周期5ns)
    initial clk = 0;
    always #5 clk = ~clk;

    // テスト対象モジュール (DUT) のインスタンス化
    // シミュレーションをサクサク進めるために各状態の時間を 10 クロックにパラメータ上書き
    traffic_light #(
        .STATE_TIME(10)
    ) u_traffic (
        .clk (clk),
        .key2(key2),
        .led (led)
    );

    initial begin
        // 波形出力の設定
        $dumpfile("sim/traffic_light.vcd");
        $dumpvars(0, tb_traffic_light);

        // 信号の監視表示 (iverilogで100%動く最も安全な整数とバイナリ表示に修正)
        $monitor("Time=%0d ns | key2(RST_N)=%b | StateVal=%0d | timer=%0d | led=%b", $time, key2,
                 u_traffic.current_state, u_traffic.timer, led);

        // 初期化 (キーは離した状態 = 1)
        key2 = 1'b1;
        #20;

        // リセットをかける (key2 = 0)
        $display("\n--- Apply Reset (S2 press) ---");
        key2 = 1'b0;
        #30;
        key2 = 1'b1;  // リセット解除
        #20;

        // 4つの状態が自動遷移して一周する様子（4状態×10クロック＝400ns）を観察するため、多めに待つ
        $display("\n--- Observing Auto State Transitions ---");
        #500;

        $display("\nSimulation finished.");
        $finish;
    end

endmodule
