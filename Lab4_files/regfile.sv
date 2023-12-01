// this part is the register file it has one port to input data, and two ports to send out data.
`timescale 1ps/1ps
module regfile (ReadData1, ReadData2, WriteData,	 				// Da Db Dw
					 ReadRegister1, ReadRegister2, WriteRegister, 	// Aa Ab Aw
					 RegWrite, clk);  										// WrEn clk
					 
	output logic [63:0] ReadData1, ReadData2;
	input logic         clk;
	input logic [4:0]   ReadRegister1, ReadRegister2, WriteRegister; 
	input logic [63:0]  WriteData;  
	input logic RegWrite;
	
	
	logic reset, clk_inver;
	logic [31:0] WriteEn;
	logic [31:0][63:0] RegOut;
	logic [63:0][31:0] MuxIn;
	
	parameter delay = 50;

	assign reset = 1'b0;
	not #delay inverse_clk (clk_inver, clk);	// inverse the clock
	Decoder32_5 deco (.WriteEn, .RegWrite, .WriteRegister);
	

	genvar i;
	generate
		for(i = 0; i < 31; i++) begin : each64bRegister
			oneRegister Reg64 (.DataOut(RegOut[i][63:0]), .DataIn(WriteData), .WriteEn(WriteEn[i]), .clk(clk_inver), .reset);
		end

	
		for(i = 0; i < 64; i++) begin : zeros
			assign RegOut[31][i] = 1'b0;
		end
	endgenerate
	
	genvar x,y;
	generate
		for (x = 0; x < 32; x++) begin : row		// reorder the xy, since mux is 32:1
			for (y = 0; y < 64; y++) begin : col
				assign MuxIn[y][x] = RegOut[x][y];
			end
		end
	endgenerate
			
	genvar j;
	generate
		for (j = 0; j < 64; j++) begin : MUX
			mux32_1 mux1 (.out(ReadData1[j]), .in(MuxIn[j][31:0]), .s(ReadRegister1));
			mux32_1 mux2 (.out(ReadData2[j]), .in(MuxIn[j][31:0]), .s(ReadRegister2));
		end
	endgenerate
	
endmodule

