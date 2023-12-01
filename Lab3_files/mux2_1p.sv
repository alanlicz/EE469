module mux2_1p #(parameter WIDTH = 64) (out, port0, port1, s);
	output logic [WIDTH-1:0] out;
	input logic [WIDTH-1:0] port0, port1;
	input logic s;
	
	genvar j;
	generate
		for (j = 0; j < WIDTH; j++) begin : MUX
			mux2_1 m (.out(out[j]), .in1(port0[j]), .in2(port1[j]), .s);
		end
	endgenerate
endmodule 