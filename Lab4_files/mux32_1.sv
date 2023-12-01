`timescale 1ps/1ps
module mux32_1 (out, in, s);
	output logic out;
	input logic [31:0] in;
	input logic [4:0] s;
	logic [1:0] muxout;
	
	logic [31:0] in_reorder;
	
	
	mux16_1 mux1 (.out(muxout[1]), .in(in[31:16]), .s(s[3:0]));
	mux16_1 mux0 (.out(muxout[0]), .in(in[15:0] ), .s(s[3:0]));
	mux2_1 muxF (.out, .in1(muxout[0]), .in2(muxout[1]), .s(s[4]));
endmodule

module mux32_1_testbench();
	logic out;
	logic [31:0] in;
	logic [4:0] s;
	
	// Try all combinations of inputs.
	// varified
	// 
	initial begin
		s = 5'b10010; in[18] = 0; in[24] = 0; in[25] = 1; in[31] = 1; #5000;
		s = 5'b10010; in[18] = 0; in[24] = 1; in[25] = 1; in[31] = 0; #5000;
		s = 5'b10010; in[18] = 0; in[24] = 0; in[25] = 1; in[31] = 1; #5000;	
	end
	
	mux32_1 dut (.out, .in, .s);
endmodule

