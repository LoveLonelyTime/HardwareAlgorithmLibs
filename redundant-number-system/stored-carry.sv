// 单个比特位加法单元
module CarrySaveAdder (
    input [1:0] A,
    input B,
    input T,
    output [1:0] S,
    output Q
);
wire fullAdderS, fullAdderQ;

// FullAdder 是一个全加器单元
FullAdder fullAdder(
    .A(A[0]),
    .B(A[1]),
    .C(B),
    .S(fullAdderS),
    .Q(fullAdderQ)
);

assign S = {fullAdderS, T};
assign Q = fullAdderQ;
endmodule

// Stored-Carry 加法器链
// A 输入的 Stored-Carry 数
// B 输入的一般二进制数
// C 结果 Stored-Carry 数
module CarrySaveAdderChain #(
    parameter LEN = 8
) (
    input [1:0] A [LEN - 1:0],
    input [LEN - 1:0] B,
    output [1:0] S [LEN - 1:0]
);

wire [LEN:0] T;
assign T[0] = 0;

genvar i;
generate
    for(i = 0;i < LEN; i++) begin
        CarrySaveAdder carrySaveAdder(
            .A(A[i]),
            .B(B[i]),
            .T(T[i]),
            .S(S[i]),
            .Q(T[i+1])
        );
    end
endgenerate
endmodule

// 将 Stored-Carry 数转换为普通二进制数
module CarrySaveToBin #(
    parameter LEN = 8
) (
    input [1:0] A [LEN - 1:0],
    output [LEN - 1:0] S
);

wire [LEN:0] T;
assign T[0] = 0;

genvar i;
generate
    for(i = 0;i < LEN; i++) begin
        FullAdder fullAdder(
            .A(A[i][0]),
            .B(A[i][1]),
            .C(T[i]),
            .S(S[i]),
            .Q(T[i+1])
        );
    end
endgenerate
endmodule