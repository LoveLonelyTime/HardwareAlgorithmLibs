// 全加器
module FullAdder (
    input A,
    input B,
    input C,
    output S,
    output Q
);

assign S = A ^ B ^ C;
assign Q = A & B | A & C | B & C;

endmodule