module alu4 (
    input  logic [3:0] a,
    input  logic [3:0] b,
    input  logic [2:0] op,
    output logic [3:0] y,
    output logic       zero,
    output logic       carry
);

    logic [4:0] tmp;

    always_comb begin
        tmp = 5'b0;

        case (op)
            3'b000:  tmp = {1'b0, a} + {1'b0, b};
            3'b001:  tmp = {1'b0, a} - {1'b0, b};
            3'b010:  tmp = {1'b0, a & b};
            3'b011:  tmp = {1'b0, a | b};
            3'b100:  tmp = {1'b0, a ^ b};
            3'b101:  tmp = {1'b0, a << 1};
            3'b110:  tmp = {1'b0, a >> 1};
            3'b111:  tmp = {1'b0, b};
            default: tmp = 5'b0;
        endcase
    end

    assign y     = tmp[3:0];
    assign carry = tmp[4];
    assign zero  = (y == 4'b0000);

endmodule
