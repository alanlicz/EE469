// the main module of APU
// input: Clk and reset, 1bit signal
// Piplining CPU
`timescale 1ps/1ps
module SSCPU (clk, reset);
	parameter delay = 50;
	
	input logic clk, reset;
	
	logic [31:0] instruction0, instruction;	// ins0 is after memory, ins is input to RF
	logic [63:0] mout1, shOut, UncondResult;
	logic [63:0] newPC, IM_addr, IM_addr_delay, plus4out;
	logic [18:0] imm19;
	logic [25:0] imm26;
	logic [63:0] Extend1, Extend2, Extend3, Extend4;
	logic [3:0]  flagOut; // 3NE 2ZERO 1OF 0Cout
	logic [2:0]  ALUOp;
	logic read_enable, UncondBr, BrTaken, Bcond, Reg2Loc, RegWrite, AdI, ALUSrc, FWen, Sctr, MemWrite, MemToReg;  //controls
	logic LT, negative, zero, overflow, carry_out, isZero;
	logic [10:0] Opcode;
	
	//RegFile part
	logic [4:0] Rd, Rn, Rm, CCIn, Ab;	// CCin condition check input, check LT
	logic [63:0] Da0, Da, Db0, Db, Dw;	// on register
	logic [63:0] ExNum, ALUinB, shifted, ALUout_EX, result0, result1;
	logic [8:0] imm9;
	logic [11:0] imm12;
	logic [5:0] SHAMT;
	
	// ALU with the flag register
	logic [3:0] flagOut0;
	logic flagChose;
	
	// logics in MEM:
	logic MemToReg_MEM, MemWrite_MEM, read_enable_MEM, RegWrite_MEM; //control pass to MEM
	logic [63:0] result0_MEM, Db_MEM, Dw_MEM;
	logic [4:0] Rd_MEM;
	
	// logics in EX:
	logic [2:0]  ALUOp_EX;
	logic Sctr_EX, FWen_EX, MemToReg_EX, MemWrite_EX, read_enable_EX, RegWrite_EX;  //control pass to EX
	logic [63:0] Da_EX, ALUinB_EX, Db_EX;
	logic [4:0] Rd_EX;
	logic [5:0] SHAMT_EX;
	
	// logics in WB:
	logic RegWrite_WB; //control pass to WB
	logic [63:0] Dw_WB;
	logic [4:0] Rd_WB;
	
	// forward logics
	logic [3:0] [63:0] MuxAin;
	logic [3:0] [63:0] MuxBin;
	logic [1:0] cA, cB;	// output of control of forwarding, select mux
	

	
	
	// PC part
	reg_p #(64) PcReg (.DataOut(IM_addr), .DataIn(newPC), .WriteEn(1'b1), .clk, .reset);
	instructmem IM (.address(IM_addr), .instruction(instruction0), .clk);	// Memory is combinational, but used for error-checking
	reg_p #(64) PcReg_delay (.DataOut(IM_addr_delay), .DataIn(IM_addr), .WriteEn(1'b1), .clk, .reset);
	Adder64 #(64) p4 (.S(plus4out), .A(IM_addr), .B(64'd4));	//pc = pc+4
	
	reg_p #(32) IF_RF (.DataOut(instruction), .DataIn(instruction0), .WriteEn(1'b1), .clk, .reset);		// IF to RF
	
	// RF starts: 
	assign imm19 = instruction[23:5];
	assign imm26 = instruction[25:0];
	
	SE9_64 #(19, 64) se1 (.SEout(Extend1), .SEin(imm19));
	SE9_64 #(26, 64) se2 (.SEout(Extend2), .SEin(imm26));
	
	mux2_1p #(64) uncond (.out(mout1), .port0(Extend1), .port1(Extend2), .s(UncondBr)); // chose imm19 or imm26 mux2_1_32 (out, port0, port1, s)	//UncondBr stay in RF
	lshifter_2 Shifter1 (.offset(mout1), .addr(shOut));
	Adder64 #(64) unCondAdd (.S(UncondResult), .A(shOut), .B(IM_addr_delay));	//add imm+PC																				
	
	mux2_1p #(64) resultMux (.out(newPC), .port0(plus4out), .port1(UncondResult), .s(BrTaken));													//BrTaken, ALUSrc, AdI stay RF
	
	// control
	assign Opcode = instruction[31:21];
	controller ctr (.read_enable, .Reg2Loc, .AdI, .ALUSrc, .ALUOp, .FWen, .Sctr, .MemToReg, 
						 .RegWrite, .MemWrite, .Bcond, .UncondBr, .BrTaken, .Opcode, .flagOut, .LT, .isZero);
	// pass control to EX
	

	
	assign Rd = instruction[4:0];
	assign Rn = instruction[9:5];																						// Aa(Rn) to forward control unit
	assign Rm = instruction[20:16];
	assign imm9 = instruction[20:12];
	assign imm12 = instruction[21:10];
	assign SHAMT = instruction[15:10];																				// SHAMT need to go EX stage
	
	//B.LT check
	mux2_1p #(5) BcondMux (.out(CCIn), .port0(5'b10000), .port1(Rd), .s(Bcond)); 
	condCheck cCh (.action(LT), .CondCode(CCIn));
	
	//Register
	mux2_1p #(5) RdRm (.out(Ab), .port0(Rd), .port1(Rm), .s(Reg2Loc));									// Ab to forward control unit
	regfile RF (.ReadData1(Da0), .ReadData2(Db0), .WriteData(Dw_WB),	 				// Da Db Dw			
					.ReadRegister1(Rn), .ReadRegister2(Ab), .WriteRegister(Rd_WB), 	// Aa Ab Aw		
					.RegWrite(RegWrite_WB), .clk); 
	

					
	zero_test zt (.isZero, .data(Db));		// test condition for CBZ
	
	// extend imm part and make choice to ALU
	SE9_64  se3 (.SEout(Extend3), .SEin(imm9));
	ZE12_64 ze4 (.ZEout(Extend4), .ZEin(imm12));				
	mux2_1p #(64) immC (.out(ExNum), .port0(Extend3), .port1(Extend4), .s(AdI));	
	mux2_1p #(64) ALUB (.out(ALUinB), .port0(Db), .port1(ExNum), .s(ALUSrc));
	

	
	// control pass to EX:
	reg_p #(3) c_EX1 (.DataOut(ALUOp_EX), .DataIn(ALUOp), .WriteEn(1'b1), .clk, .reset);	// To EX
	D_FF c_EX2 (.q(Sctr_EX), 			.d(Sctr), 			.reset, .clk);								// To EX
	D_FF c_EX3 (.q(FWen_EX), 			.d(FWen), 			.reset, .clk);								// To EX
	D_FF c_EX4 (.q(MemToReg_EX), 		.d(MemToReg), 		.reset, .clk);								// To MEM
	D_FF c_EX5 (.q(MemWrite_EX), 		.d(MemWrite), 		.reset, .clk);								// To MEM
	D_FF c_EX6 (.q(read_enable_EX), 	.d(read_enable), 	.reset, .clk);								// To MEM
	D_FF c_EX7 (.q(RegWrite_EX), 		.d(RegWrite), 		.reset, .clk);								// To WB
	
	// data pass to EX:
	reg_p #(64) d_EX1 (.DataOut(Da_EX), 		.DataIn(Da), 		.WriteEn(1'b1), .clk, .reset);
	reg_p #(64) d_EX2 (.DataOut(ALUinB_EX), 	.DataIn(ALUinB), 	.WriteEn(1'b1), .clk, .reset);
	reg_p #(64) d_EX3 (.DataOut(Db_EX), 		.DataIn(Db), 		.WriteEn(1'b1), .clk, .reset);
	reg_p #(5)  d_EX4 (.DataOut(Rd_EX), 		.DataIn(Rd), 		.WriteEn(1'b1), .clk, .reset);
	reg_p #(6)  d_EX5 (.DataOut(SHAMT_EX), 	.DataIn(SHAMT), 	.WriteEn(1'b1), .clk, .reset);
	// RF end
 	
	
	// EX starts: 
	// shifter
	shifterP #(64) s2 (.value(Da_EX), .direction(1'b1), .distance(SHAMT_EX), .result(shifted));
	

	alu a (.A(Da_EX), .B(ALUinB_EX), .cntrl(ALUOp_EX), .result(ALUout_EX), .negative, .zero, .overflow, .carry_out);
	reg_p #(4) flagReg (.DataOut(flagOut0), .DataIn({negative, zero, overflow, carry_out}), .WriteEn(FWen_EX), .clk, .reset);
	
	mux2_1p #(4) flag (.out(flagOut), .port0(flagOut0), .port1({negative, zero, overflow, carry_out}), .s(flagChose));	// decide use current or past
	and #delay fcho (flagChose, FWen_EX, LT);
	
	// this mux dicide to use shifter or ALU
	mux2_1p #(64) SOA (.out(result0), .port0(ALUout_EX), .port1(shifted), .s(Sctr_EX));
	
	

	
	// control pass to MEM:
	D_FF c_M1 (.q(MemToReg_MEM), 		.d(MemToReg_EX), 		.reset, .clk);								// To MEM
	D_FF c_M2 (.q(MemWrite_MEM), 		.d(MemWrite_EX), 		.reset, .clk);								// To MEM
	D_FF c_M3 (.q(read_enable_MEM), 	.d(read_enable_EX), 	.reset, .clk);								// To MEM
	D_FF c_M4 (.q(RegWrite_MEM), 		.d(RegWrite_EX), 		.reset, .clk);								// To WB
	
	// data pass to MEM:
	reg_p #(64) d_M1 (.DataOut(result0_MEM), 	.DataIn(result0), 	.WriteEn(1'b1), .clk, .reset);
	reg_p #(64) d_M2 (.DataOut(Db_MEM), 		.DataIn(Db_EX), 		.WriteEn(1'b1), .clk, .reset);
	reg_p #(5)  d_M3 (.DataOut(Rd_MEM), 		.DataIn(Rd_EX), 		.WriteEn(1'b1), .clk, .reset);
	// EX end
	

	
	// MEM starts
	datamem mem (.address(result0_MEM), .write_enable(MemWrite_MEM), .read_enable(read_enable_MEM), .write_data(Db_MEM), .clk, .xfer_size(4'd8), .read_data(result1));
	
	mux2_1p #(64) mFinal (.out(Dw_MEM), .port0(result0_MEM), .port1(result1), .s(MemToReg_MEM));
	

	
	// control pass to WB:
	D_FF c_W1 (.q(RegWrite_WB), .d(RegWrite_MEM), .reset, .clk);								// To WB
	
	// data pass to WB:
	reg_p #(64) d_W1 (.DataOut(Dw_WB), 	.DataIn(Dw_MEM), 	.WriteEn(1'b1), .clk, .reset);
	reg_p #(5)  d_W2 (.DataOut(Rd_WB), 		.DataIn(Rd_MEM), 		.WriteEn(1'b1), .clk, .reset);
	// MEM end
	
	// forward control
	assign MuxAin [3] = 64'd0;
	assign MuxAin [2] = Dw_MEM;
	assign MuxAin [1] = result0;
	assign MuxAin [0] = Da0;
	
	assign MuxBin [3] = 64'd0;
	assign MuxBin [2] = Dw_MEM;
	assign MuxBin [1] = result0;
	assign MuxBin [0] = Db0;
	
	Forward_ctrl FCrtl (.cA, .cB, .Aa(Rn), .Ab, .Aw_EX(Rd_EX), .Aw_MEM(Rd_MEM), .RegWrite_EX, .RegWrite_MEM);
	mux4_1p FA (.out(Da), .in(MuxAin), .s(cA));		// DW_mem2 from mem, result0(1) from alu
	mux4_1p FB (.out(Db), .in(MuxBin), .s(cB));
	
	
endmodule 


