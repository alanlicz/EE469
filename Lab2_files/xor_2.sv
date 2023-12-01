`timescale 1ps/1ps
module 	// out = A'B+AB'
	output logic out;
	input logic A, B;
	logic An, Bn, and0, and1;
	
	parameter delay = 50;
	
	not #delay invertgate0 (An, A);
	not #delay invertgate1 (Bn, B);
	
	and #delay gate0 (and0, An, B);
	and #delay gate1 (and1, A, Bn);
	
	or  #delay gate2 (out, and0, and1);
	
endmodule

