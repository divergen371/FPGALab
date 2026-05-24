`default_nettype none

module half_adder (
    input  logic a,
    input  logic b,
    output logic sum,
    output logic carry
);
    // sum を a XOR b、carry を a AND b で求めるのが正攻法
    // 2つの信号を連結して算術演算を使うのもあり
    assign {carry, sum} = a + b;
endmodule
