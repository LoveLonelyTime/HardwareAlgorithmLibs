module CarryFreeAdder (
    input [1:0] A,
    input [1:0] B,
    input [1:0] TI, // 输入传递
    input EI, // 输入 E
    output reg [1:0] S, // 本位和
    output reg [1:0] TO, // 输出传递
    output reg EO // 输出 E
);

reg [1:0] I;

always @(*) begin
    case ({A,B,EI})
        5'b00010, 5'b01000: begin
            I = 2'b10;
            TO = 2'b01;
            EO = 0;
        end
        5'b00011, 5'b01001: begin
            I = 2'b01;
            TO = 0;
            EO = 0;
        end
        5'b00100, 5'b10000: begin
            I = 2'b10;
            TO = 0;
            EO = 1;
        end
        5'b00101, 5'b10001: begin
            I = 2'b01;
            TO = 2'b10;
            EO = 1;
        end
        5'b01010, 5'b01011: begin
            I = 0;
            TO = 2'b01;
            EO = 0;
        end
        5'b10100, 5'b10101: begin
            I = 0;
            TO = 2'b10;
            EO = 1;
        end
        5'b10010, 5'b10011, 5'b01100, 5'b01101, 5'b00000, 5'b00001: begin
            I = 0;
            TO = 0;
            EO = 0;
        end
        default: begin // Unexpected
            I = 0;
            TO = 0;
            EO = 0;
        end
    endcase

    case({I, TI})
        4'b0001, 4'b0100: S = 2'b01;
        4'b0010, 4'b1000: S = 2'b10;
        4'b0110, 4'b1001, 4'b0000: S = 0;
        default: S = 0; // Unexpected
    endcase
end
endmodule

// GSD 加法器
module CarryFreeAdderChain #(
    parameter LEN = 8
) (
    input [1:0] A [LEN-1:0],
    input [1:0] B [LEN-1:0],
    output [1:0] S [LEN-1:0]
);

wire [1:0] T [LEN:0];
wire [LEN:0] E;
assign T[0] = 0;
assign E[0] = 0;

genvar i;
generate
    for(i = 0;i < LEN;i++) begin
        CarryFreeAdder carryFreeAdder(
            .A(A[i]),
            .B(B[i]),
            .TI(T[i]),
            .EI(E[i]),
            .S(S[i]),
            .TO(T[i+1]),
            .EO(E[i+1])
        );
    end
endgenerate
endmodule

// 二进制（补码）转GSD
module BinToCarryFree #(
    parameter LEN = 8
) (
    input [LEN-1:0] A,
    output [1:0] S [LEN-1:0]
);

wire [LEN-1:0] P;
assign P = A[LEN-1] ? ~A + 1'b1 : A;

genvar i;
generate
    for(i = 0;i < LEN;i++) begin
        assign S[i] = P[i] ? (A[LEN-1] ? 2'b10 : 2'b01) : 0;
    end
endgenerate
endmodule

module CarryFreeToBinUnit (
    input [1:0] A,
    input TI,
    output reg S,
    output reg TO
);
always @(*) begin
    case ({A,TI})
        3'b000, 3'b011: begin
            S = 0;
            TO = 0;
        end
        3'b001, 3'b100: begin
            S = 1'b1;
            TO = 1'b1;
        end
        3'b010: begin
            S = 1'b1;
            TO = 0;
        end
        3'b101: begin
            S = 0;
            TO = 1'b1;
        end
        default: begin // Unexpected
            S = 0;
            TO = 0;
        end
    endcase
end
endmodule

// GSD转二进制（补码）
module CarryFreeToBin #(
    parameter LEN = 8
) (
    input [1:0] A [LEN-1:0],
    output [LEN-1:0] S
);
wire [LEN:0] T;

assign T[0] = 0;

genvar i;
generate
    for(i = 0;i < LEN;i++) begin
        CarryFreeToBinUnit carryFreeToBinUnit(
            .A(A[i]),
            .TI(T[i]),
            .S(S[i]),
            .TO(T[i+1])
        );
    end
endgenerate
endmodule
