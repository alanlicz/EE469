// this module is a full adder
// input is carry in value, adding Ci A B together
// output is carry out and the sum
`timescale 1ps/1ps
module full_Adder (Sum, Co, A, B, Ci);
	output logic Sum, Co;
	input logic A, B, Ci;
	logic D, E, F, G;
	parameter delay = 50;
	
	// Sum = (AxorB)xorCi
	xor #delay xorgate0 (D, A, B);
	xor #delay xorgate1 (Sum, D, Ci);

	// Co = AB+ACi+BCi 
	and #delay gate0 (E, A ,B);
	and #delay gate1 (F, A ,Ci);
	and #delay gate2 (G, B ,Ci);
	or  #delay outputgate (Co, E, F, G);
	
endmodule

