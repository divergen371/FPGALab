module oneshot (
    input  logic clk,
    input  logic reset,
    input  logic in_btn,    // デバウンス済みのボタン入力 (アクティブLow: 押すと0)
    output logic out_pulse  // 押された瞬間に1クロックだけ1になるパルス (アクティブHigh)
);

    logic in_btn_reg;

    // ボタン入力を1クロック遅延させるレジスタ
    always_ff @(posedge clk) begin
        if (reset) begin
            in_btn_reg <= 1'b1;  // 初期値はボタンを離している状態 (1)
        end else begin
            in_btn_reg <= in_btn;
        end
    end

    // 立ち下がりエッジ（ボタンが押された瞬間）を検出する
    // 「1クロック前が 1 (離されていた) 且つ 現在が 0 (押された)」の時に 1 を出力
    assign out_pulse = (~in_btn) & in_btn_reg;

endmodule
