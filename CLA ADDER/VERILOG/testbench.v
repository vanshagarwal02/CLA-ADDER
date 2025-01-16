`include "verilog_vlsi_project.v"

module testbench;
    reg [3:0] A, B;  // Test inputs
    reg C0;          // Initial carry
    reg clk;         // Clock signal
    wire [3:0] S;    // Sum output
    wire C4;         // Final carry output

    // Instantiate the carry lookahead adder
    finalcircuit cla (
        .A(A),
        .B(B),
        .C0(C0),
        .clk(clk),
        .S(S),
        .C4(C4)
    );

    // Generate clock signal
    always #5 clk = ~clk;

    // Test input signals
    initial begin
        $dumpfile("testbench.vcd");
        $dumpvars(0, testbench);
        clk = 1'b0; // Initialize clock
        A = 4'b1001; // Initial values
        B = 4'b1101;
        C0 = 1'b0;
        
        $monitor("Time=%0t A=%b B=%b C0=%b S=%b C4=%b", $time, A, B, C0, S, C4);

        #20 A = 4'b1010; // Change inputs
        #20 B = 4'b0101;
        #20 $finish; // Stop the simulation
    end
endmodule
