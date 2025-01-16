module dflipflop(
    output reg q,
    input d,
    input clk
);
    always @(posedge clk) begin
        q<=d;
    end
endmodule

module carry_lookahead_adder(
    input [3:0] A,   // 4-bit input A
    input [3:0] B,   // 4-bit input B
    input C0,        // Initial carry-in
    output [3:0] S,  // 4-bit sum
    output C4        // Final carry-out
);
    wire [3:0] P; // Propagate signals
    wire [3:0] G; // Generate signals
    wire C1, C2, C3; // Carry signals

    // Find P[i] (propagate) and G[i] (generate) for each bit
    xor u1(P[0], A[0], B[0]);
    xor u2(P[1], A[1], B[1]);
    xor u3(P[2], A[2], B[2]);
    xor u4(P[3], A[3], B[3]);

    and u5(G[0], A[0], B[0]);
    and u6(G[1], A[1], B[1]);
    and u7(G[2], A[2], B[2]);
    and u8(G[3], A[3], B[3]);

    // Find carry signals (C1, C2, C3, C4)
    wire a1, a2_1, a2_2, a3_1, a3_2, a3_3, a4_1, a4_2, a4_3, a4_4;

    // C1 = G[0] | (P[0] & C0)
    and u9(a1, P[0], C0);
    or u10(C1, G[0], a1);

    // C2 = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C0)
    and u11(a2_1, P[1], P[0], C0);
    and u12(a2_2, P[1], G[0]);
    or u13(C2, G[1], a2_1, a2_2);

    // C3 = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C0)
    and u14(a3_1, P[2], P[1], P[0], C0);
    and u15(a3_2, P[2], P[1], G[0]);
    and u16(a3_3, P[2], G[1]);
    or u17(C3, G[2], a3_1, a3_2, a3_3);

    // C4 = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C0)
    and u18(a4_1, P[3], P[2], P[1], P[0], C0);
    and u19(a4_2, P[3], P[2], P[1], G[0]);
    and u20(a4_3, P[3], P[2], G[1]);
    and u21(a4_4, P[3], G[2]);
    or u22(C4, G[3], a4_1, a4_2, a4_3, a4_4);

    // Find S[i] (Sum) for each bit
    xor u23(S[0], P[0], C0);
    xor u24(S[1], P[1], C1);
    xor u25(S[2], P[2], C2);
    xor u26(S[3], P[3], C3);
endmodule

module finalcircuit(    
    input [3:0] A,   // 4-bit input A
    input [3:0] B,   // 4-bit input B
    input C0,        // Initial carry-in
    input clk,
    output [3:0] S,  // 4-bit sum
    output C4        // Final carry-out);
);
    wire [3:0] A_ff,B_ff,S_ff;
    wire C4_ff;
    dflipflop dff1(A_ff[0],A[0],clk);
    dflipflop dff2(A_ff[1],A[1],clk);
    dflipflop dff3(A_ff[2],A[2],clk);
    dflipflop dff4(A_ff[3],A[3],clk);

    dflipflop dff5(B_ff[0],B[0],clk);
    dflipflop dff6(B_ff[1],B[1],clk);
    dflipflop dff7(B_ff[2],B[2],clk);
    dflipflop dff8(B_ff[3],B[3],clk);

    carry_lookahead_adder cla(.A(A_ff), .B(B_ff), .C0(C0), .S(S_ff), .C4(C4_ff));

    dflipflop dff9(S[0],S_ff[0],clk);
    dflipflop dff10(S[1],S_ff[1],clk);
    dflipflop dff11(S[2],S_ff[2],clk);
    dflipflop dff12(S[3],S_ff[3],clk);

    dflipflop dff13(C4,C4_ff,clk);
endmodule
