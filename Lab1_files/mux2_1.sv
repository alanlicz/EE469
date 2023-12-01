`timescale 1ps/1ps
module mux2_1 (out, in1, in2, s);	// out = s' in1 + s in2
	output logic out;
	input logic in1, in2, s;
	logic A, B, os;
	
	parameter delay = 50;
	
	not #delay invertgate (os, s);
	and #delay gate1 (A,os,in1);
	and #delay gate2 (B,s ,in2);
	or  #delay outputgate (out, A, B);
	
endmodule

module mux2_1_testbench();
	logic out;
	logic in1, in2, s;
	
	// Try all combinations of inputs.
	initial begin
		s = 0; in1 = 0; in2 = 1; #5000;
		s = 0; in1 = 1; in2 = 0; #5000;
		s = 1; in1 = 0; in2 = 1; #5000;
		s = 1; in1 = 1; in2 = 0; #5000;
	end
	
	mux2_1 dut (.out, .in1, .in2, .s);
	
endmodule


