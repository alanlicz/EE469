// Zero extend module, by deflaut take 12 input width, output 64 output width
module ZE12_64 #(parameter IN_WIDTH = 12,
					parameter OUT_WIDTH = 64) (
	output logic [OUT_WIDTH-1:0] ZEout,
	input  logic [IN_WIDTH-1:0] ZEin
	);
	
	assign ZEout = {{(OUT_WIDTH-IN_WIDTH){1'b0}},ZEin};
endmodule 