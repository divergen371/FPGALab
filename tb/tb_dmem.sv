`timescale 1ns / 1ps `default_nettype none

module tb_dmem;

    // --- 信号の定義 ---
    logic       clk;
    logic       we;
    logic [3:0] addr;
    logic [3:0] wdata;
    logic [3:0] rdata;

    // --- テスト対象モジュール (DUT) のインスタンス化 ---
    dmem uut (
        .clk  (clk),
        .we   (we),
        .addr (addr),
        .wdata(wdata),
        .rdata(rdata)
    );

    // --- クロック生成 ---
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // --- テストシナリオ ---
    initial begin
        $dumpfile("sim/dmem.vcd");
        $dumpvars(0, tb_dmem);

        // Icarus Verilogで配列の中身を見るためにテストする場所だけダンプ
        $dumpvars(0, uut.ram[0], uut.ram[5], uut.ram[15]);

        $monitor("Time=%3t | we=%b addr=%2d wdata=%2d | rdata=%2d (ram[5]=%2d, ram[15]=%2d)", $time, we, addr, wdata,
                 rdata, uut.ram[5], uut.ram[15]);

        $display("--- Start Data Memory (RAM) Test ---");

        we    = 0;
        addr  = 0;
        wdata = 0;
        #25;

        // [1] アドレス5 に 8 を書き込む
        @(posedge clk);
        #1;
        we    = 1;
        addr  = 4'd5;
        wdata = 4'd8;

        // [2] アドレス15 に 12 を書き込む
        @(posedge clk);
        #1;
        we    = 1;
        addr  = 4'd15;
        wdata = 4'd12;

        // [3] 書き込みを停止し、アドレス5 を読み出す (rdata = 8になるはず)
        @(posedge clk);
        #1;
        we    = 0;
        addr  = 4'd5;
        wdata = 4'd0;

        // [4] アドレス15 を読み出す (rdata = 12になるはず)
        @(posedge clk);
        #1;
        we   = 0;
        addr = 4'd15;

        // [5] 何も書き込んでいない アドレス0 を読み出す
        // （初期化していないため、シミュレータ上は 'x' または不定値が出ます。それが正常です）
        @(posedge clk);
        #1;
        we   = 0;
        addr = 4'd0;

        #30;
        $display("--- Simulation Finished ---");
        $finish;
    end

endmodule
`default_nettype wire
