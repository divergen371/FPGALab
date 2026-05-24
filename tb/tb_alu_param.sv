`timescale 1ns / 1ps
`default_nettype none

module tb_alu_param;

    // 今回は 8ビット でテスト！
    localparam int TEST_WIDTH = 8;

    // --- 信号の定義 ---
    logic [TEST_WIDTH-1:0] a;
    logic [TEST_WIDTH-1:0] b;
    logic [2:0]            op;
    logic [TEST_WIDTH-1:0] y;
    logic                  zero;
    logic                  carry;

    // --- テスト対象モジュール (DUT) のインスタンス化 ---
    // ここで #(8) のようにしてWIDTHパラメータを渡す
    alu_param #(
        .WIDTH(TEST_WIDTH)
    ) uut (
        .a     (a),
        .b     (b),
        .op    (op),
        .y     (y),
        .zero  (zero),
        .carry (carry)
    );

    // --- テストシナリオ ---
    initial begin
        $dumpfile("sim/alu_param.vcd");
        $dumpvars(0, tb_alu_param);

        $monitor("Time=%3t | op=%3b | a=%8b(%3d), b=%8b(%3d) | y=%8b(%3d) | zero=%b, carry=%b", 
                 $time, op, a, a, b, b, y, y, zero, carry);

        $display("--- Start 8-bit Parameterized ALU Test ---");

        // 基本テスト: a = 150, b = 100
        a = 8'd150; b = 8'd100;

        $display("\n--- ADD (op=000) ---");
        op = 3'b000; #10; // 150 + 100 = 250
        
        $display("\n--- SUB (op=001) ---");
        op = 3'b001; #10; // 150 - 100 = 50
        
        $display("\n--- Flag Test ---");
        // 8ビットの最大値は 255
        a = 8'd255; b = 8'd1; op = 3'b000; #10;   // 255 + 1 = 256 (桁あふれで y=0, carry=1, zero=1 になるはず)
        a = 8'd128; b = 8'd128; op = 3'b001; #10; // 128 - 128 = 0 (y=0, zero=1 になるはず)

        $display("\n--- Simulation Finished ---");
        $finish;
    end

endmodule
`default_nettype wire
