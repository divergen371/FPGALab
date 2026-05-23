module blinky (
    input  logic clk,
    output logic led
);

    logic [23:0] counter = 24'd0;

    always_ff @(posedge clk) begin
        counter <= counter + 24'd1;
    end

    assign led = counter[23];

endmodule
