// this module is a mux that take two input, and control signal to select the output
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


//module mux2_1_32 (out, port0, port1, s);
//	output logic [31:0] out;
//	input logic [31:0] port0, port1;
//	input logic s;
//	
//	genvar j;
//	generate
//		for (j = 0; j < 32; j++) begin : MUX
//			mux2_1 mux1 (.out(out[j]), .in1(port0[j]), .in2(port1[j]), .s);
//		end
//	endgenerate
//endmodule
//
//
//module mux2_1_64 (out, port0, port1, s);
//	output logic [63:0] out;
//	input logic [63:0] port0, port1;
//	input logic s;
//	
//	genvar j;
//	generate
//		for (j = 0; j < 64; j++) begin : MUX
//			mux2_1 mux1 (.out(out[j]), .in1(port0[j]), .in2(port1[j]), .s);
//		end
//	endgenerate
//endmodule
//
//
//module mux2_1_5 (out, port0, port1, s);
//	output logic [4:0] out;
//	input logic [4:0] port0, port1;
//	input logic s;
//	
//	genvar j;
//	generate
//		for (j = 0; j < 5; j++) begin : MUX
//			mux2_1 mux1 (.out(out[j]), .in1(port0[j]), .in2(port1[j]), .s);
//		end
//	endgenerate
//endmodule



