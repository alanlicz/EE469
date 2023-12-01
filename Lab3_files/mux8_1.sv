// this module is a mux that take eight inputs, and control signal to select one to the output
`timescale 1ps/1ps
module mux8_1 (out, in, s);
	output logic out;
	input logic [7:0] in;
	input logic [2:0] s;
	logic [1:0] muxout;
	
	mux4_1 mux0 (.out(muxout[0]), .in(in[3:0]  ), .s(s[1:0]));
	mux4_1 mux1 (.out(muxout[1]), .in(in[7:4]  ), .s(s[1:0]));
	mux2_1 muxF (.out, .in1(muxout[0]), .in2(muxout[1]), .s(s[2]));
endmodule


module mux8_1_testbench();
	logic out;
	logic [7:0] in;
	logic [2:0] s;
	
	// Try all combinations of inputs.
	// varified: 
	// 
	initial begin
		s = 3'b111; in[7] = 1; in[2] = 0; in[1] = 1; in[0] = 1; #5000;
		s = 3'b111; in[7] = 0; in[2] = 1; in[1] = 1; in[0] = 0; #5000;
		s = 3'b111; in[7] = 0; in[2] = 0; in[1] = 1; in[0] = 1; #5000;	
	end
	
	mux8_1 dut (.out, .in, .s);
	
endmodule

