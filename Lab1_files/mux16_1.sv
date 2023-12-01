`timescale 1ps/1ps
module mux16_1 (out, in, s);
	output logic out;
	input logic [15:0] in;
	input logic [3:0] s;
	logic [3:0] muxout;
	
	mux4_1 mux3 (.out(muxout[3]), .in(in[15:12]), .s(s[1:0]));
	mux4_1 mux2 (.out(muxout[2]), .in(in[11:8] ), .s(s[1:0]));
	mux4_1 mux1 (.out(muxout[1]), .in(in[7:4]  ), .s(s[1:0]));
	mux4_1 mux0 (.out(muxout[0]), .in(in[3:0]  ), .s(s[1:0]));
	mux4_1 muxF (.out, .in(muxout[3:0]), .s(s[3:2]));
endmodule


module mux16_1_testbench();
	logic out;
	logic [15:0] in;
	logic [3:0] s;
	
	// Try all combinations of inputs.
	// varified: 
	// 
	initial begin
		s = 5'b010; in[3] = 1; in[2] = 0; in[1] = 1; in[0] = 1; #5000;
		s = 5'b010; in[3] = 0; in[2] = 1; in[1] = 1; in[0] = 0; #5000;
		s = 5'b010; in[3] = 0; in[2] = 0; in[1] = 1; in[0] = 1; #5000;	
	end
	
	mux16_1 dut (.out, .in, .s);
	
endmodule

