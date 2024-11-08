// 进位生成器
module CarryGenerator #(
    parameter LEN = 4
) (
    input CI, // 输入进位
    input [LEN - 1 : 0] GI, // 输入生成位
    input [LEN - 1 : 0] PI, // 输入传播位
    output [LEN - 1 : 0] CO, // 输出进位
    output GO, // 合成组生成位
    output PO // 合成组传播位
);
wire [LEN - 1 : 0] G;
wire [LEN - 1 : 0] P;

assign G[0] = GI[0];
assign P[0] = PI[0];


genvar i;
generate
    for(i = 1;i < LEN; i++) begin
        assign G[i] = GI[i] | G[i - 1] & PI[i];
        assign P[i] = PI[i] & P[i - 1];

        assign CO[i] = G[i - 1] | CI & P[i - 1];
    end
endgenerate

assign CO[0] = CI;

assign GO = G[LEN - 1];
assign PO = P[LEN - 1];

endmodule

module CarryGeneratorX16 (
    input CI,
    input [16 - 1 : 0] GI,
    input [16 - 1 : 0] PI,
    output [16 - 1 : 0] CO,
    output GO,
    output PO
);

wire [3 : 0] G;
wire [3 : 0] P;
wire [3 : 0] C;

genvar i;
generate
    for(i = 0;i < 4; i++) begin
        CarryGenerator #(
            .LEN(4)
        ) carryGenerator (
            .CI(C[i]),
            .GI(GI[i*4+3 : i*4]),
            .PI(PI[i*4+3 : i*4]),
            .CO(CO[i*4+3 : i*4]),
            .GO(G[i]),
            .PO(P[i])
        );
    end
endgenerate

CarryGenerator #(
    .LEN(4)
) carryGeneratorGroup (
    .CI(CI),
    .GI(G),
    .PI(P),
    .CO(C),
    .GO(GO),
    .PO(PO)
);
endmodule

module CarryGeneratorX64 (
    input CI,
    input [64 - 1 : 0] GI,
    input [64 - 1 : 0] PI,
    output [64 - 1 : 0] CO,
    output GO,
    output PO
);

wire [3 : 0] G;
wire [3 : 0] P;
wire [3 : 0] C;

genvar i;
generate
    for(i = 0;i < 4; i++) begin
        CarryGeneratorX16 carryGeneratorX16 (
            .CI(C[i]),
            .GI(GI[i*16+15 : i*16]),
            .PI(PI[i*16+15 : i*16]),
            .CO(CO[i*16+15 : i*16]),
            .GO(G[i]),
            .PO(P[i])
        );
    end
endgenerate

CarryGenerator #(
    .LEN(4)
) carryGeneratorGroup (
    .CI(CI),
    .GI(G),
    .PI(P),
    .CO(C),
    .GO(GO),
    .PO(PO)
);
endmodule

// 64位超前进位加法器
module CarryLookaheadAdderX64 (
    input [64 - 1 : 0] A,
    input [64 - 1 : 0] B,
    output [64 - 1 : 0] S
);
wire [64 - 1 : 0] G;
wire [64 - 1 : 0] P;
wire [64 - 1 : 0] C;
assign G = A & B;
assign P = A ^ B;

CarryGeneratorX64 carryGeneratorX64 (
    .CI(0),
    .GI(G),
    .PI(P),
    .CO(C),
    .GO(),
    .PO()
);

assign S = A ^ B ^ C;
endmodule
