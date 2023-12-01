module reg64 (reset, clk, D, Q, write, enable);
	input reset, clk, write, enable;
	input [63:0] D;
	output [63:0] Q;
	reg [63:0] Q;
	
	D_FF df0(Q[0], D[0], reset, clk);
	D_FF df1(Q[1], D[1], reset, clk);
	D_FF df2(Q[2], D[2], reset, clk);
	D_FF df3(Q[3], D[3], reset, clk);
	