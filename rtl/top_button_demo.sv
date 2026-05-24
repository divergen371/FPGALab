module top_button_demo #(
    parameter int LONG_PRESS_LIMIT = 81000000  // 3秒 @ 27MHz
) (
    input  logic       clk,
    input  logic       key1,  // ボタン S1 (カウントアップ: 押すと0)
    input  logic       key2,  // ボタン S2 (リセット: 押すと0)
    output logic [5:0] led    // LED 6個 (0で点灯, 1で消灯)
);

    // リセット信号の作成 (ボタンS2は押すと0なので、反転してアクティブHighの同期リセットにする)
    logic reset;
    assign reset = ~key2;

    // デバウンス回路のインスタンス化 (S1ボタンのチャタリング除去)
    // 実機動作時はデフォルト値の LIMIT=270000 (10ms @ 27MHz) で動作
    logic key1_deb;
    debounce #(
        .LIMIT(270000)
    ) u_debounce (
        .clk    (clk),
        .reset  (reset),
        .in_btn (key1),
        .out_btn(key1_deb)
    );

    // ワンショットパルス生成回路のインスタンス化 (ボタンが押された一瞬だけ1にする)
    logic key1_pulse;
    oneshot u_oneshot (
        .clk      (clk),
        .reset    (reset),
        .in_btn   (key1_deb),
        .out_pulse(key1_pulse)
    );

    // 6ビットカウンタレジスタ
    logic [5:0] count_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            count_reg <= 6'b0;
        end else if (key1_pulse) begin
            count_reg <= count_reg + 6'b1;
        end
    end

    // 🚀 3秒長押しカウンターロジック
    // LIMITの値に応じて自動で最適なビット幅を計算
    localparam int LONG_WIDTH = $clog2(LONG_PRESS_LIMIT + 1);
    logic [LONG_WIDTH-1:0] long_counter;
    logic                  long_pressed;

    always_ff @(posedge clk) begin
        if (reset) begin
            long_counter <= '0;
            long_pressed <= 1'b0;
        end else begin
            if (key1_deb == 1'b0) begin
                // ボタンが押されている間 (key1_deb == 0) カウントアップ
                if (long_counter >= LONG_PRESS_LIMIT - 1) begin
                    long_pressed <= 1'b1;  // LIMITに達したら長押し確定フラグON
                end else begin
                    long_counter <= long_counter + 1'b1;
                end
            end else begin
                // ボタンを離したら即座にカウンタと長押しフラグをリセット
                long_counter <= '0;
                long_pressed <= 1'b0;
            end
        end
    end

    // LED出力のマルチプレクス (長押しフラグONの時は全点灯(000000)、通常時はカウンタ値を反転)
    assign led = long_pressed ? 6'b000000 : ~count_reg;

endmodule
