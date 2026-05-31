`default_nettype none
module dmem (
    input  logic       clk,
    input  logic       we,
    input  logic [3:0] addr,
    input  logic [3:0] wdata,
    output logic [3:0] rdata
);
    logic [3:0] ram[15:0];
    always_ff @(posedge clk) begin
        if (we) begin
            ram[addr] <= wdata;
        end
    end
    assign rdata = ram[addr];
endmodule
