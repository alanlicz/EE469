module mux4_1p #(parameter WIDTH = 64) (out, in, s);
	output logic [WIDTH-1:0] out;
	input logic [1:0] s;
	input logic [3:0] [WIDTH-1:0] in;
	logic [WIDTH-1:0] [3:0] MuxIn;
	
	genvar x,y;
	generate
		for (x = 0; x < 4; x++) begin : row		// reorder the xy, since mux is 32:1
			for (y = 0; y < WIDTH; y++) begin : col
				assign MuxIn[y][x] = in[x][y];
			end
		end
	endgenerate
	
	genvar j;
	generate
		for (j = 0; j < WIDTH; j++) begin : MUX
			mux4_1 m41 (.out(out[j]), .in(MuxIn[j]), .s);
		end
	endgenerate
endmodule 