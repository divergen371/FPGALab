`timescale 1ns / 1ps `default_nettype none

module tb_imem;

    // --- 信号の定義 ---
    logic [3:0] addr;
    logic [7:0] inst;

    // --- テスト対象モジュール (DUT) のインスタンス化 ---
    imem uut (
        .addr(addr),
        .inst(inst)
    );

    // --- テストシナリオ ---
    initial begin
        $dumpfile("sim/imem.vcd");
        $dumpvars(0, tb_imem);

        $monitor("Time=%3t | PC addr=%2d | Instruction=%8b", $time, addr, inst);

        $display("--- Start Instruction Memory (ROM) Test ---");

        // アドレスを0から順番に変化させて、どんな命令が出てくるか確認
        addr = 4'd0;
        #10;
        addr = 4'd1;
        #10;
        addr = 4'd2;
        #10;
        addr = 4'd3;
        #10;
        addr = 4'd4;
        #10;

        // 範囲外や指定していないアドレスのテスト
        addr = 4'd15;
        #10;

        $display("--- Simulation Finished ---");
        $finish;
    end

endmodule
`default_nettype wire
