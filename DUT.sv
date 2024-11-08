module DUT (
    input [64 - 1 : 0] A,
    input [64 - 1 : 0] B,
    output [64 - 1 : 0] S
);

CarryLookaheadAdderX64 carryLookaheadAdderX64 (
    .A(A),
    .B(B),
    .S(S)
);

endmodule