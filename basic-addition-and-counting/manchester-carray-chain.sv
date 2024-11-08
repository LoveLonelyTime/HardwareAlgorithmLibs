module CarryGenerator (
    input X,
    input Y,
    input CI,
    output CO
);

wire G,P;
assign G = X & Y;
assign P = X ^ Y;
assign CO = G | (CI & P);

endmodule

module ManchesterCarryChain #(
    parameter LEN = 8
) (
    input [LEN - 1 : 0] A,
    input [LEN - 1 : 0] B,
    output [LEN - 1 : 0] S
);

wire [LEN : 0] C;

genvar i;
generate
    for(i = 0;i < LEN; i++) begin
        CarryGenerator carryGenerator (
            .X(A[i]),
            .Y(B[i]),
            .CI(C[i]),
            .CO(C[i+1])
        );

        assign S[i] = A[i] ^ B[i] ^ C[i];
    end
endgenerate
endmodule
