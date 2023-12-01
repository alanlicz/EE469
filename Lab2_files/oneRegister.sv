module oneRegister (DataOut, DataIn, WriteEn, clk, reset);	//takein 64, take out 64 bit
	output logic [63:0] DataOut;
	input  logic        clk, WriteEn, reset;
	input  logic [63:0] DataIn;
	logic        [63:0] muxOut;
	
	genvar i;
	generate
		for(i = 0; i < 64; i++) begin : each1bRegister
			mux2_1 mx (.out(muxOut[i]), .in1(DataOut[i]), .in2(DataIn[i]), .s(WriteEn));
			D_FF regis (.q(DataOut[i]), .d(muxOut[i]), .reset, .clk);
		end
	endgenerate

endmodule

