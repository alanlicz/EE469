// this part is the control signal for CPU
`timescale 1ps/1ps
module controller (read_enable, Reg2Loc, AdI, ALUSrc, ALUOp, FWen, Sctr, MemToReg, 
						 RegWrite, MemWrite, Bcond, UncondBr, BrTaken, Opcode, flagOut, LT, zero);

	output logic read_enable, Reg2Loc, AdI, ALUSrc, FWen, Sctr, MemToReg, RegWrite, MemWrite;	// register side
	output logic [2:0] ALUOp;
	output logic Bcond,UncondBr, BrTaken;		// instruction side	
	input logic [10:0] Opcode;
	input logic [3:0] flagOut;  // new input
	input logic LT, zero;
	logic [14:0] outCtr;
	logic CBZ, condi, BrTak1, BrTak3;

	assign read_enable = outCtr[14];
	assign Reg2Loc  = outCtr[13];
	assign AdI 		 = outCtr[12];
	assign ALUSrc 	 = outCtr[11];
	assign ALUOp [2:0] = outCtr[10:8];
	assign FWen 	 = outCtr[ 7];
	assign Sctr 	 = outCtr[ 6];
	assign MemToReg = outCtr[ 5];
	assign RegWrite = outCtr[ 4];
	assign MemWrite = outCtr[ 3];
	assign Bcond 	 = outCtr[ 2];
	assign UncondBr = outCtr[ 1];
	assign CBZ 		 = outCtr[ 0];

	always_comb begin
		casex (Opcode)
			//                                ALU76543210
			11'b1001000100x: outCtr = 15'b0x1101000010000;	//ADDI
			11'b10101011000: outCtr = 15'b01x001010010000;	//ADDS
			11'b11111000010: outCtr = 15'b1x0101000110000;	//LDUR
			11'b11111000000: outCtr = 15'b000101000x01000;	//STUR
			11'b000101xxxxx: outCtr = 15'b0xxxxxx0xx00010;	//B
			11'b10110100xxx: outCtr = 15'b00x00000xx00001;	//CBZ
			11'b01010100xxx: outCtr = 15'b0xxxxxx0xx00100;	//B.condb 
			11'b11101011000: outCtr = 15'b01x001110010000;	//SUBS
			default: outCtr = 'x
			;
		endcase
	end
	
	xor a1 (condi, flagOut[3], flagOut[1]);
	and a2 (BrTak1, LT, condi);
	and c1 (BrTak3, CBZ, zero);
	
	or brtaken (BrTaken, BrTak1, UncondBr, BrTak3);
	
	// assign BrTaken = LT&(flagOut[3]^flagOut[1])|UncondBr|CBZ&zero;
	
endmodule

