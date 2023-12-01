module Adder32 #(parameter WIDTH = 32) (S, A, B);
	output logic [WIDTH-1:0] S;
	input logic [WIDTH-1:0] A, B;
	logic [WIDTH:0] Ci;
	
	assign Ci[0] = 1'b0;
	
	genvar i;
	generate
		for(i = 0; i < WIDTH; i++) begin : ADDER
			full_Adder position (.Sum(S[i]), .Co(Ci[i+1]), .A(A[i]), .B(B[i]), .Ci(Ci[i]));
		end
	endgenerate
	
endmodule

