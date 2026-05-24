module traffic_light #(
    parameter int STATE_TIME = 27000000  // 各状態の継続時間 (デフォルト: 1秒 @ 27MHz)
) (
    input  logic       clk,
    input  logic       key2,  // ボタン S1 (RST / リセット: 押すと0)
    output logic [2:0] led    // LED 3個 (赤:led[2], 黄:led[1], 青:led[0]) (0で点灯)
);

    // 🚀 assign の使用: 単純接続と論理反転
    // オンボードボタンは押すと 0 なので、反転してアクティブHighの内部同期リセット信号を作る
    logic reset;
    assign reset = ~key2;

    // 🚀 enum の使用: 可読性の高い状態（ステート）の定義
    // 内部的には2ビット(00, 01, 10, 11)のバイナリ値が割り当てられる
    typedef enum logic [1:0] {
        GREEN,   // 青信号
        YELLOW,  // 黄信号
        RED,     // 赤信号
        ALL_ON   // 警報（全点灯）
    } state_t;

    // 🚀 logic の使用: 状態保持用と次状態用の変数宣言
    state_t current_state;
    state_t next_state;

    // タイマー用カウンタ (STATE_TIMEまで数える)
    // localparam を使って、必要なカウンタのビット幅を自動計算 ($clog2 は対数計算)
    localparam int TIMER_WIDTH = $clog2(STATE_TIME + 1);
    logic [TIMER_WIDTH-1:0] timer;

    // 🚀 always_ff の使用: クロック同期で動くレジスタ（順序回路）
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= GREEN;  // リセットされたら青信号から開始
            timer         <= '0;
        end else begin
            if (timer >= STATE_TIME - 1) begin
                current_state <= next_state;  // 設定時間が経過したら、次の状態へ切り替える
                timer         <= '0;
            end else begin
                timer <= timer + 1'b1;  // カウントアップ
            end
        end
    end

    // 🚀 always_comb の使用: 純粋な回路切り替えスイッチ（組み合わせ回路）
    // 🚀 case と if の使用: 状態遷移条件の記述
    always_comb begin
        // デフォルト代入 (意図しないラッチを防止するための絶対ルール)
        next_state = GREEN;

        case (current_state)
            GREEN: begin
                next_state = YELLOW;  // 青の次は黄
            end
            YELLOW: begin
                next_state = RED;  // 黄の次は赤
            end
            RED: begin
                next_state = ALL_ON;  // 赤の次は全点灯警報
            end
            ALL_ON: begin
                // if文の文法例 (あえて条件判定を入れています)
                if (reset == 1'b0) begin
                    next_state = GREEN;  // 警報の次は青に戻る
                end else begin
                    next_state = GREEN;
                end
            end
            default: begin
                next_state = GREEN;
            end
        endcase
    end

    // 🚀 always_comb の使用: 状態に応じたLEDデコーダ（組み合わせ回路）
    always_comb begin
        // デフォルトは消灯(1)にする (ラッチ防止)
        led = 3'b111;

        case (current_state)
            GREEN:   led = 3'b110;  // 青のみ点灯 (led[0]=0)
            YELLOW:  led = 3'b101;  // 黄のみ点灯 (led[1]=0)
            RED:     led = 3'b011;  // 赤のみ点灯 (led[2]=0)
            ALL_ON:  led = 3'b000;  // 全点灯 (led[2:0]=0)
            default: led = 3'b111;  // 全消灯
        endcase
    end

endmodule
