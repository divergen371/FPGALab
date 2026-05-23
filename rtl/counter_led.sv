module counter_led (
    input  logic       clk,
    output logic [5:0] led
);

    logic [31:0] counter = 32'd0;

    always_ff @(posedge clk) begin
        counter <= counter + 32'd1;
    end
    assign led = ~counter[28:23];
endmodule
