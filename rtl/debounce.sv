module debounce #(
    parameter int LIMIT = 270000  // 判定閾値 (デフォルト: 10ms @ 27MHz)
) (
    input  logic clk,
    input  logic reset,
    input  logic in_btn,
    output logic out_btn
);

    // メタステービリティ対策 (2段D-FFによる同期化)
    logic btn_sync_0;
    logic btn_sync;

    always_ff @(posedge clk) begin
        if (reset) begin
            btn_sync_0 <= 1'b1;
            btn_sync   <= 1'b1;
        end else begin
            btn_sync_0 <= in_btn;
            btn_sync   <= btn_sync_0;
        end
    end

    // 安定性を判定するためのカウンタ
    // LIMITの値に応じて自動で最適なビット幅を計算 ($clog2 は対数を計算するシステム関数)
    localparam int WIDTH = $clog2(LIMIT + 1);
    logic [WIDTH-1:0] counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= '0;
            out_btn <= 1'b1;  // 初期状態は離している状態 (1)
        end else begin
            if (btn_sync != out_btn) begin
                // 現在の確定出力と入力値が異なる場合、安定時間を計測開始
                if (counter >= LIMIT - 1) begin
                    out_btn <= btn_sync;  // LIMIT時間安定したら出力を更新
                    counter <= '0;
                end else begin
                    counter <= counter + 1'b1;
                end
            end else begin
                // 入力値が元の確定出力と同じに戻ったら、ノイズとみなしてカウンタをクリア
                counter <= '0;
            end
        end
    end

endmodule
