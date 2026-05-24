`default_nettype none

module mux2 (
    input  logic d0,
    input  logic d1,
    input  logic sel,
    output logic y
);

    // 三項演算子を用いた実装
    assign y = sel ? d1 : d0;

    // --------------------------------------------------------
    // always_comb を用いる場合は以下のように記述します
    // --------------------------------------------------------
    // always_comb begin
    //     if (sel == 1'b1) begin
    //         y = d1;
    //     end else begin
    //         y = d0;
    //     end
    // end

endmodule
`default_nettype wire
