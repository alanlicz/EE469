// Ethan Jiang, Zhiyu Ju
// the main module of ALU
// input A, B are 64bit
// cntrl set the oporation ro process
// output result in 64bit
// Flags: 1bit
// negative: whether the result output is negative if interpreted as 2's comp.
// zero: whether the result output was a 64-bit zero.
// overflow: on an add or subtract, whether the computation overflowed if the inputs are interpreted as 2's comp.
// carry_out: on an add or subtract, whether the computation produced a carry-out.
//
// cntrl			Operation						Notes:
// 000:			result = B						value of overflow and carry_out unimportant
// 010:			result = A + B
// 011:			result = A - B
// 100:			result = bitwise A & B		value of overflow and carry_out unimportant
// 101:			result = bitwise A | B		value of overflow and carry_out unimportant
// 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant
`timescale 1ps/1ps
module alu (A, B, cntrl, result, negative, zero, overflow, carry_out);
	input logic [63:0] A, B;
	input logic [2:0]  cntrl;
	output logic [63:0] result;
	output logic negative, zero, overflow, carry_out;
	logic [63:0] AandB, AorB, AxrB, add_sub;
	logic [7:0] [63:0] in;
	logic [63:0] [7:0] rOd;	//re-order mux
	
	// using for a big or_gate
	logic [31:0] lv0;
	logic [15:0] lv1;
	logic [7:0] lv2;
	logic [3:0] lv3;
	logic [1:0] lv4;
	
	parameter delay = 50;
	
	
	// generate inputs of mux
	genvar i, j;
	generate
		for(i = 0; i < 64; i++) begin : and_or_xor
			and #delay andgate (AandB[i], A[i], B[i]);
			or  #delay orgate  (AorB[i], A[i], B[i]);
			xor #delay xorgate (AxrB[i], A[i], B[i]);		
		end
	endgenerate
	
	// also set flags in computation
	adder_subtracter cal (.Sum(add_sub), .last_Co(carry_out), .OF(overflow), .A, .B, .s0(cntrl[0]));
	
	// assign inputs of the big mux
	assign in[0] = B;
	assign in[2] = add_sub;
	assign in[3] = add_sub;
	assign in[4] = AandB;
	assign in[5] = AorB;
	assign in[6] = AxrB;

	genvar x,y;
	generate
		for (x = 0; x < 8; x++) begin : row		// reorder the xy, since mux is 8:1
			for (y = 0; y < 64; y++) begin : col
				assign rOd[y][x] = in[x][y];
			end
		end
	endgenerate
	
	// create 64 mux, each process one bit
	generate
		for(j = 0; j < 64; j++) begin : muxs
			mux8_1 m (.out(result[j]), .in(rOd[j][7:0]), .s(cntrl));	// in is 8 bit
		end
	endgenerate
	
	// negative flag
	assign negative = result[63];
	
	// zero flag
	genvar a, b, c, d, e;
	generate		//create a big or gate;
		for(a = 0; a < 32; a++) begin : layer0
			or #delay l0 (lv0[a], result[a], result[a+32]);
		end
		for(b = 0; b < 16; b++) begin : layer1
			or #delay l1 (lv1[b], lv0[b], lv0[b+16]);
		end
		for(c = 0; c < 8; c++) begin : layer2
			or #delay l2 (lv2[c], lv1[c], lv1[c+8]);
		end
		for(d = 0; d < 4; d++) begin : layer3
			or #delay l3 (lv3[d], lv2[d], lv2[d+4]);
		end
		for(e = 0; e < 2; e++) begin : layer4
			or #delay l4 (lv4[e], lv3[e], lv3[e+2]);
		end
	endgenerate
	
	nor #delay l5 (zero, lv4[0], lv4[1]);
	
endmodule


