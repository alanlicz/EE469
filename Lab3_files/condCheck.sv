// the only action here is LT
module condCheck (action, CondCode); 
	input logic [4:0] CondCode;
	output logic action;
	logic wire1, wire2;
	
	nor a (wire1, CondCode[4], CondCode[2]);
	and b (wire2, CondCode[3], CondCode[1], CondCode[0]);
	and c (action, wire1, wire2);

endmodule 

