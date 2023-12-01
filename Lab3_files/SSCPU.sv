// the main module of APU
// input: Clk and reset, 1bit signal
// SSCPU mean single cycle CPU
`timescale 1ps/1ps
module SSCPU (clk, reset);
	parameter delay = 50;
	
	input logic clk, reset;
	
	logic [31:0] instruction;
	logic [63:0] mout1, shOut, UncondResult;
	logic [63:0] newPC, IM_addr, plus4out;
	logic [18:0] imm19;
	logic [25:0] imm26;
	logic [63:0] Extend1, Extend2, Extend3, Extend4;
	logic [3:0]  flagOut; // 3NE 2ZERO 1OF 0Cout
	logic [2:0]  ALUOp;
	logic read_enable, UncondBr, BrTaken, Bcond, Reg2Loc, RegWrite, AdI, ALUSrc, FWen, Sctr, MemWrite, MemToReg;  //controls
	logic LT, negative, zero, overflow, carry_out;
	logic [10:0] Opcode;
	
	// PC part
	reg_p #(64) PcReg (.DataOut(IM_addr), .DataIn(newPC), .WriteEn(1'b1), .clk, .reset);
	instructmem IM (.address(IM_addr), .instruction, .clk);	// Memory is combinational, but used for error-checking
	
	Adder32 #(64) p4 (.S(plus4out), .A(IM_addr), .B(64'd4));	//pc = pc+4
	
	assign imm19 = instruction[23:5];
	assign imm26 = instruction[25:0];
	
	SE9_64 #(19, 64) se1 (.SEout(Extend1), .SEin(imm19));
	SE9_64 #(26, 64) se2 (.SEout(Extend2), .SEin(imm26));
	
	mux2_1p #(64) uncond (.out(mout1), .port0(Extend1), .port1(Extend2), .s(UncondBr)); // chose imm19 or imm26 mux2_1_32 (out, port0, port1, s)
	shifterP #(64) s1 (.value(mout1), .direction(1'b0), .distance(6'd2), .result(shOut)); // 0: left, 1: right
	Adder32 #(64) unCondAdd (.S(UncondResult), .A(shOut), .B(IM_addr));	//add imm+PC
	
	mux2_1p #(64) resultMux (.out(newPC), .port0(plus4out), .port1(UncondResult), .s(BrTaken));
	
	//control
	assign Opcode = instruction[31:21];
	controller ctr (.read_enable, .Reg2Loc, .AdI, .ALUSrc, .ALUOp, .FWen, .Sctr, .MemToReg, 
						 .RegWrite, .MemWrite, .Bcond, .UncondBr, .BrTaken, .Opcode, .flagOut, .LT, .zero);
	
	//RegFile part
	logic [4:0] Rd, Rn, Rm, CCIn, Ab;
	logic [63:0] Da, Db, Dw;	// on register
	logic [63:0] ExNum, ALUinB, shifted, ALUout, result0, result1;
	logic [8:0] imm9;
	logic [11:0] imm12;
	logic [5:0] SHAMT;
	
	assign Rd = instruction[4:0];
	assign Rn = instruction[9:5];
	assign Rm = instruction[20:16];
	assign imm9 = instruction[20:12];
	assign imm12 = instruction[21:10];
	assign SHAMT = instruction[15:10];
	
	//B.LT check
	mux2_1p #(5) BcondMux (.out(CCIn), .port0(5'b10000), .port1(Rd), .s(Bcond)); 
	condCheck cCh (.action(LT), .CondCode(CCIn));
	
	//Register
	mux2_1p #(5) RdRm (.out(Ab), .port0(Rd), .port1(Rm), .s(Reg2Loc));
	regfile RF (.ReadData1(Da), .ReadData2(Db), .WriteData(Dw),	 					// Da Db Dw
					.ReadRegister1(Rn), .ReadRegister2(Ab), .WriteRegister(Rd), 	// Aa Ab Aw
					.RegWrite, .clk); 
	
	// extend imm part and make choice to ALU
	SE9_64  se3 (.SEout(Extend3), .SEin(imm9));
	ZE12_64 ze4 (.ZEout(Extend4), .ZEin(imm12));				
	mux2_1p #(64) immC (.out(ExNum), .port0(Extend3), .port1(Extend4), .s(AdI));	
	mux2_1p #(64) ALUB (.out(ALUinB), .port0(Db), .port1(ExNum), .s(ALUSrc));
	
	// shifter
	shifterP #(64) s2 (.value(Da), .direction(1'b1), .distance(SHAMT), .result(shifted));
	
	// ALU with the flag register
	alu a (.A(Da), .B(ALUinB), .cntrl(ALUOp), .result(ALUout), .negative, .zero, .overflow, .carry_out);
	reg_p #(4) flagReg (.DataOut(flagOut), .DataIn({negative, zero, overflow, carry_out}), .WriteEn(FWen), .clk, .reset);
	
	// this mux dicide to use shifter or ALU
	mux2_1p #(64) SOA (.out(result0), .port0(ALUout), .port1(shifted), .s(Sctr));
	
	// memory
	datamem mem (.address(result0), .write_enable(MemWrite), .read_enable, .write_data(Db), .clk, .xfer_size(4'd8), .read_data(result1));
	
	mux2_1p #(64) mFinal (.out(Dw), .port0(result0), .port1(result1), .s(MemToReg));
	
endmodule 


