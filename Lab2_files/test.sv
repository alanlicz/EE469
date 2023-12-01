`timescale 1ps/1ps
module test (out, A);	
	output logic [2:0] out;
	input logic [2:0] A;
	
	parameter delay = 50;
	
	
	
endmodule




module test_testbench();
	logic [2:0] out;
	logic [2:0] A;
	
	// Try all combinations of inputs.
	initial begin
		A = 3'b111; #5000;
		A = 3'b000; #5000;
		A = 3'b010; #5000;

	end
	
	test dut (.out, .A);
	
endmodule
