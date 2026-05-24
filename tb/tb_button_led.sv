`timescale 1ns / 1ps

module tb_button_led;

    // テスト対象モジュールの入出力用信号
    logic       key1;
    logic       key2;
    logic [5:0] led;

    // テスト対象モジュール (DUT) のインスタンス化
    button_led u_button_led (
        .key1(key1),
        .key2(key2),
        .led (led)
    );

    initial begin
        // 波形出力の設定
        $dumpfile("sim/button_led.vcd");
        $dumpvars(0, tb_button_led);

        // 信号の監視表示 (これで変数 'led' が使用され、警告が解消されます)
        $monitor("Time=%0d ns | key1=%b key2=%b | led=%b", $time, key1, key2, led);

        // 初期状態 (両方のボタンを離している状態 = 1)
        key1 = 1'b1;
        key2 = 1'b1;
        #100;

        // S2 (key1) を押す (0にする)
        $display("Press S2 (key1 = 0)");
        key1 = 1'b0;
        #100;

        // S2 (key1) を離す (1にする)
        $display("Release S2 (key1 = 1)");
        key1 = 1'b1;
        #100;

        // S1 (key2) を押す (0にする)
        $display("Press S1 (key2 = 0)");
        key2 = 1'b0;
        #100;

        // S1 (key2) を離す (1にする)
        $display("Release S1 (key2 = 1)");
        key2 = 1'b1;
        #100;

        // 両方押す
        $display("Press both S1 & S2");
        key1 = 1'b0;
        key2 = 1'b0;
        #100;

        // 両方離す
        key1 = 1'b1;
        key2 = 1'b1;
        #100;

        $display("Simulation finished.");
        $finish;
    end

endmodule
