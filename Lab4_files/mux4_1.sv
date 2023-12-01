// this module is a mux that take four inputs, and control signal to select one to the output
`timescale 1ps/1ps
module mux4_1 (out, in, s);
	output logic out;
	input logic [3:0] in;
	input logic [1:0] s;
	logic mux1out, mux2out;
	
	mux2_1 mux1 (.out(mux1out), .in1(in[0]), .in2(in[1]), .s(s[0]));
	mux2_1 mux2 (.out(mux2out), .in1(in[2]), .in2(in[3]), .s(s[0]));
	mux2_1 muxF (.out, .in1(mux1out), .in2(mux2out), .s(s[1]));
endmodule


module mux4_1_testbench();
	logic out;
	logic [3:0] in;
	logic [1:0] s;
	
	// Try all combinations of inputs.
	// varified: 
	// 
	initial begin
		s = 2'b10; in[3] = 1; in[2] = 0; in[1] = 1; in[0] = 1; #5000;
		s = 2'b10; in[3] = 0; in[2] = 1; in[1] = 1; in[0] = 0; #5000;
		s = 2'b10; in[3] = 0; in[2] = 0; in[1] = 1; in[0] = 1; #5000;	
	end
	
	mux4_1 dut (.out, .in, .s);
endmodule

