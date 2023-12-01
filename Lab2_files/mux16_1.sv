`timescale 1ps/1ps
module mux16_1 (out, in, s);
	output logic out;
	input logic [15:0] in;
	input logic [3:0] s;
	logic [3:0] muxout;
	
	mux4_1 mux0 (.out(muxout[0]), .in(in[3:0]  ), .s(s[1:0]));
	mux4_1 mux1 (.out(muxout[1]), .in(in[7:4]  ), .s(s[1:0]));
	mux4_1 mux2 (.out(muxout[2]), .in(in[11:8] ), .s(s[1:0]));
	mux4_1 mux3 (.out(muxout[3]), .in(in[15:12]), .s(s[1:0]));
	mux4_1 muxF (.out, .in(muxout[3:0]), .s(s[3:2]));
endmodule


module mux16_1_testbench();
	logic out;
	logic [15:0] in;
	logic [3:0] s;
	

