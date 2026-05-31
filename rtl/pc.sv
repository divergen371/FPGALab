`default_nettype none

module pc (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       load_en,
    input  logic [3:0] load_addr,
    output logic [3:0] addr
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            addr <= 4'b0;
        end else if (load_en) begin
            addr <= load_addr;
        end else begin
            addr <= addr + 1;
        end
    end
endmodule
