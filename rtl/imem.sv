`default_nettype none
module imem (
    input  logic [3:0] addr,
    output logic [7:0] inst
);
    always_comb begin
        case (addr)
            4'h0:    inst = 8'h00;  // NOP
            4'h1:    inst = 8'h11;  // LDI R1, 1
            4'h2:    inst = 8'h12;  // LDI R2, 2
            4'h3:    inst = 8'h31;  // ADD R1, R2
            default: inst = 8'hFF;
        endcase
    end
endmodule
