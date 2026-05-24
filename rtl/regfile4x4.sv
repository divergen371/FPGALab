`default_nettype none

module regfile4x4 (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       we,
    input  logic [1:0] waddr,
    input  logic [3:0] wdata,
    input  logic [1:0] raddr1,
    input  logic [1:0] raddr2,
    output logic [3:0] rdata1,
    output logic [3:0] rdata2
);
    logic [3:0] regs[3:0];

    assign rdata1 = regs[raddr1];
    assign rdata2 = regs[raddr2];

    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            regs[0] <= 4'b0;
            regs[1] <= 4'b0;
            regs[2] <= 4'b0;
            regs[3] <= 4'b0;
        end else if (we == 1'b1) begin
            regs[waddr] <= wdata;
        end
    end
endmodule
