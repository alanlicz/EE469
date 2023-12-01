// Test bench for SSCPU file
// simulate runing a CPU
`timescale 1ns/10ps

module SSAPUstim(); 		

	parameter ClockDelay = 50;

	logic clk, reset;

	SSCPU dut (.clk, .reset);

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);

	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end

	initial begin
		reset <=1; repeat(1)  @(posedge clk);
		reset <=0; repeat(200) @(posedge clk);

		$stop;
	end
endmodule
