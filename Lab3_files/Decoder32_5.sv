`timescale 1ps/1ps
module Decoder32_5 (WriteEn, RegWrite, WriteRegister);
	output logic [31:0] WriteEn;
	input logic RegWrite;	//enablelor
	input logic [4:0] WriteRegister;
	logic [3:0] enable;
	logic WriteOpp3, WriteOpp4;
	
	parameter delay = 50;
	
	// 4_2decoder
	not #delay inver4 (WriteOpp4, WriteRegister[4]);
	not #delay inver3 (WriteOpp3, WriteRegister[3]);

	and #delay e00 (enable[0], WriteOpp4, 			WriteOpp3, 			RegWrite);
	and #delay e01 (enable[1], WriteOpp4, 			WriteRegister[3],	RegWrite);
	and #delay e10 (enable[2], WriteRegister[4], WriteOpp3, 		RegWrite);
	and #delay e11 (enable[3], WriteRegister[4], WriteRegister[3], RegWrite);
	
	// 4_2decoder connect to 4 8_3decoders
	Decoder8_3 de31_24 (.out(WriteEn[31:24]), .en(enable[3]), .s(WriteRegister[2:0]));
	Decoder8_3 de23_16 (.out(WriteEn[23:16]), .en(enable[2]), .s(WriteRegister[2:0]));
	Decoder8_3 de15_8  (.out(WriteEn[15:8]) , .en(enable[1]), .s(WriteRegister[2:0]));
	Decoder8_3 de7_0   (.out(WriteEn[7:0])  , .en(enable[0]), .s(WriteRegister[2:0]));
endmodule



module Decoder32_5_testbench();
	logic [31:0] WriteEn;
	logic RegWrite;	//enablelor
	logic [4:0] WriteRegister;
	Decoder32_5 dut (.WriteEn, .RegWrite, .WriteRegister);
	// Try all combinations of inputs.
	integer i;
	initial begin
		RegWrite = 1'b0;
		for(i = 0; i <32; i++) begin
			WriteRegister[4:0] = i; #5000;
		end
		RegWrite = 1'b1;
		for(i = 0; i <32; i++) begin
			WriteRegister[4:0] = i; #5000;
		end
	end
endmodule

