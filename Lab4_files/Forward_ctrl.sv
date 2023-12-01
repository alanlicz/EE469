module Forward_ctrl (cA, cB, Aa, Ab, Aw_EX, Aw_MEM, RegWrite_EX, RegWrite_MEM);
	output logic [1:0] cA, cB;			// 0 origin; 1 ALU; 2 MEM; 3 N/A
	input logic [4:0] Aa, Ab, Aw_EX, Aw_MEM;
	input logic RegWrite_EX, RegWrite_MEM;
	
	always_comb begin
		if (Aa == 5'd31) begin
			cA = 2'd0;
		end else if ((RegWrite_EX == 1)) begin
			if (Aa == Aw_EX) begin
				cA = 2'd1;
			end else if (RegWrite_MEM == 1 & Aa == Aw_MEM) begin
				cA = 2'd2;
			end else begin
				cA = 2'd0;
			end
		end else if (RegWrite_MEM == 1) begin
			if (Aa == Aw_MEM) begin
				cA = 2'd2;
			end else begin
				cA = 2'd0;
			end
		end else begin
			cA = 2'd0;
		end
	end
	
	always_comb begin
		if (Ab == 5'd31) begin
			cB = 2'd0;
		end else if ((RegWrite_EX == 1)) begin
			if (Ab == Aw_EX) begin
				cB = 2'd1;
			end else if (RegWrite_MEM == 1 & Ab == Aw_MEM) begin
				cB = 2'd2;
			end else begin
				cB = 2'd0;
			end 	
		end else if (RegWrite_MEM == 1) begin
			if (Ab == Aw_MEM) begin
				cB = 2'd2;
			end else begin
				cB = 2'd0;
			end
		end else begin
			cB = 2'd0;
		end
	end
endmodule 