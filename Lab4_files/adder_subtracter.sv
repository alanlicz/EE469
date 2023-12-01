// this is the add_sub module
// can do adding and subtracting
// input A B and output Sum is 64bit
// also output has the flag overflow and last carryout in 1bit

`timescale 1ps/1ps
module adder_subtracter (Sum, last_Co, OF, A, B, s0);	// 64_bit adder_subtracter
	output logic [63:0] Sum;
	output logic last_Co, OF;	// OF stand for overflow
	input  logic [63:0] A, B;
	input  logic s0;
	logic [63:0] Bn, muxOut, Co;
	parameter delay = 50;
	
	genvar i, j;
	generate
		for(i = 0; i < 64; i++) begin : each_invert
			not #delay invertgate (Bn[i], B[i]);
		end
	endgenerate
	
	// edge case, adder/subtracter at position 0
	mux2_1 m1 (.out(muxOut[0]), .in1(B[0]), .in2(Bn[0]), .s(s0));
	full_Adder f1 (.Sum(Sum[0]), .Co(Co[0]), .A(A[0]), .B(muxOut[0]), .Ci(s0));
	
	//from 1 to 63
	generate
		for(j = 1; j < 64; j++) begin : each_adder
			mux2_1 m1 (.out(muxOut[j]), .in1(B[j]), .in2(Bn[j]), .s(s0));
			full_Adder f1 (.Sum(Sum[j]), .Co(Co[j]), .A(A[j]), .B(muxOut[j]), .Ci(Co[j-1]));
		end
	endgenerate
	
	xor #delay check_OF (OF, Co[63], Co[62]);	//check overflow
	assign last_Co = Co[63];	// output last carry out
	
endmodule




module adder_subtracter_testbench();
	logic [63:0] Sum;
	logic last_Co, OF;	// OF stand for overflow
	logic [63:0] A, B;
	logic s0;
	
	// Try adge case inputs.
	initial begin
		A = 64'b1111111111111111111111111111111111111111111111111111111111111111; B = 64'b1111111111111111111111111111111111111111111111111111111111111111; s0 = 0; #5000;	// not OF, Co 1
		A = 64'b1111111111111111111111111111111111111111111111111111111111111111; B = 64'b0111111111111111111111111111111111111111111111111111111111111111; s0 = 0; #5000;	// no OF
		A = 64'b1111111111111111111111111111111111111111111111111111111111111111; B = 64'b0011111111111111111111111111111111111111111111111111111111111111; s0 = 0; #5000;	// no OF
		A = 64'b0000000000000000000000000000000000000000000000000000000000000111; B = 64'b0000000000000000000000000000000000000000000000000000000000000111; s0 = 1; #5000;	// 0, Cout 1
		A = 64'b1111111111111111111111111111111111111111111111111111111111111111; B = 64'b0000000000000000000000000000000000000000000000000000000000000000; s0 = 1; #5000;	// 1111111
		A = 64'b0000000000000000000000000000000000000000000000000000000000000000; B = 64'b1111111111111111111111111111111111111111111111111111111111111111; s0 = 1; #5000;	// sum = 1
		A = 64'b1000000000000000000000000000000000000000000000000000000000000000; B = 64'b1000000000000000000000000000000000000000000000000000000000000000; s0 = 0; #5000;	// OF

	end
	
	adder_subtracter dut (.Sum, .last_Co, .OF, .A, .B, .s0);
	
endmodule
