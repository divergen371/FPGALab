module alu_param #(
    parameter int WIDTH = 4
) (

    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic [      2:0] op,
    output logic [WIDTH-1:0] y,
    output logic             zero,
    output logic             carry
);

    logic [WIDTH:0] tmp;

    always_comb begin
        tmp = '0;

        case (op)
            3'b000:  tmp = {1'b0, a} + {1'b0, b};
            3'b001:  tmp = {1'b0, a} - {1'b0, b};
            3'b010:  tmp = {1'b0, a & b};
            3'b011:  tmp = {1'b0, a | b};
            3'b100:  tmp = {1'b0, a ^ b};
            3'b101:  tmp = {1'b0, a << 1};
            3'b110:  tmp = {1'b0, a >> 1};
            3'b111:  tmp = {1'b0, b};
            default: tmp = '0;
        endcase
    end

    assign y     = tmp[WIDTH-1:0];
    assign carry = tmp[WIDTH];
    assign zero  = (y == '0);

endmodule
