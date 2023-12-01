`timescale 1ps/1ps
module Decoder8_3 (out, en, s);
	output logic [7:0] out;
	input  logic       en;
	input  logic [2:0] s;
	logic        [2:0] o;		// invert s
	
	parameter delay = 50;
	
	not #delay inver2 (o[2], s[2]);
	not #delay inver1 (o[1], s[1]);
	not #delay inver0 (o[0], s[0]);
	
	and #delay g000 (out[0], o[2], o[1], o[0], en);
	and #delay g001 (out[1], o[2], o[1], s[0], en);
	and #delay g010 (out[2], o[2], s[1], o[0], en);
	and #delay g011 (out[3], o[2], s[1], s[0], en);
	and #delay g100 (out[4], s[2], o[1], o[0], en);
	and #delay g101 (out[5], s[2], o[1], s[0], en);
	and #delay g110 (out[6], s[2], s[1], o[0], en);
	and #delay g111 (out[7], s[2], s[1], s[0], en);
endmodule


module Decoder8_3_testbench();
	logic [7:0] out;
	logic       en;
	logic [2:0] s;
	Decoder8_3 dut (.out, .en, .s);
	// Try all combinations of inputs.
	integer i;
	initial begin
		en = 1'b0;
		for(i = 0; i <8; i++) begin
			s[2:0] = i; #1000;
		end
		en = 1'b1;
		for(i = 0; i <8; i++) begin
			s[2:0] = i; #1000;
		end
	end
endmodule
