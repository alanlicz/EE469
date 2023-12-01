//// sign extend module, by deflaut take 9 input width, output 64 output width
module SE9_64 #(parameter IN_WIDTH = 9,
					parameter OUT_WIDTH = 64) (
	output logic [OUT_WIDTH-1:0] SEout,
	input  logic [IN_WIDTH-1:0] SEin
	);
	
	assign SEout = {{(OUT_WIDTH-IN_WIDTH){SEin[IN_WIDTH-1]}},SEin};
endmodule

//module SE9_64 (
//	output logic [63:0] SEout,
//	input  logic [8:0] SEin
//	);
//	
//	assign SEout = {{55{SEin[8]}},SEin};
//endmodule


//module SE19_32 (
//	output logic [31:0] SEout,
//	input  logic [18:0] SEin
//	);
//	
//	assign SEout = {{13{SEin[18]}},SEin};
//endmodule
//
//
//module SE26_32 (
//	output logic [31:0] SEout,
//	input  logic [25:0] SEin
//	);
//	
//	assign SEout = {{6{SEin[25]}},SEin};
//endmodule


