module button_led (
    input  logic       key1,  // ボタン S1 (押すと0, 離すと1)
    input  logic       key2,  // ボタン S2 (押すと0, 離すと1)
    output logic [5:0] led    // LED 6個 (0で点灯, 1で消灯)
);

    // key1 (S1) が押されたら (0になったら) led[0] を点灯 (0に) する
    assign led[0]   = key1;

    // key2 (S2) が押されたら (0になったら) led[1] を点灯 (0に) する
    assign led[1]   = key2;

    // 残りのLED (led[5:2]) は消灯 (1) にしておく
    assign led[5:2] = 4'b1111;

endmodule
