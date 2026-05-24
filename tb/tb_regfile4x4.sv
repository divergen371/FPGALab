`timescale 1ns / 1ps
`default_nettype none

module tb_regfile4x4;

    // --- 信号の定義 ---
    logic clk;
    logic rst_n;
    logic we;
    logic [1:0] waddr;
    logic [3:0] wdata;
    logic [1:0] raddr1;
    logic [1:0] raddr2;
    logic [3:0] rdata1;
    logic [3:0] rdata2;

    // --- テスト対象モジュール (DUT) のインスタンス化 ---
    regfile4x4 uut (
        .clk   (clk),
        .rst_n (rst_n),
        .we    (we),
        .waddr (waddr),
        .wdata (wdata),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    // --- クロック生成 ---
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // --- テストシナリオ ---
    initial begin
        $dumpfile("sim/regfile4x4.vcd");
        $dumpvars(0, tb_regfile4x4);

        // Icarus Verilog で内部配列の波形も取るための呪文
        $dumpvars(0, uut.regs[0], uut.regs[1], uut.regs[2], uut.regs[3]);

        $monitor("Time=%3t | we=%b waddr=%0d wdata=%2d | raddr1=%0d rdata1=%2d | raddr2=%0d rdata2=%2d | r[0]=%2d, r[1]=%2d", 
                 $time, we, waddr, wdata, raddr1, rdata1, raddr2, rdata2, uut.regs[0], uut.regs[1]);

        $display("--- Start 4x4 Register File Test ---");

        // 初期化
        we = 0; waddr = 0; wdata = 0; raddr1 = 0; raddr2 = 1;
        rst_n = 0; #25; rst_n = 1;

        // [1] レジスタ0 に 5 を書き込む
        @(posedge clk); #1; we = 1; waddr = 0; wdata = 4'd5;
        
        // [2] レジスタ1 に 10 を書き込む
        @(posedge clk); #1; we = 1; waddr = 1; wdata = 4'd10;
        
        // [3] 書き込み禁止(we=0)のテスト: レジスタ0 に 15 を書き込もうとする (無視されるはず)
        @(posedge clk); #1; we = 0; waddr = 0; wdata = 4'd15;
        
        // [4] 読み出しテスト: レジスタ1 と レジスタ0 を同時に読み出す (rdata1=10, rdata2=5 になるはず)
        @(posedge clk); #1; we = 0; raddr1 = 1; raddr2 = 0;

        #30;
        $display("--- Simulation Finished ---");
        $finish;
    end

endmodule
`default_nettype wire
