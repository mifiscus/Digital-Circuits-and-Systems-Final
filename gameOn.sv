// State machine that handles the current state of the game, waiting for user to press a buton before starting
module gameOn (clk, reset, press, out);
	input logic clk, reset;
	input logic press;
	output logic out;
	logic ps, ns;

	always_comb
		ns = ps | press;

	assign out = ps;

	always @(posedge clk)
		if (reset)
			ps <= 1'b0;
		else
			ps <= ns;

endmodule

module gameOn_testbench();
	logic clk, reset;
	logic press;
	logic out;

	gameOn dut (.clk, .reset, .press, .out);

	parameter CLOCK_PERIOD=100;
	initial clk=1;
	always begin
		#(CLOCK_PERIOD/2);
		clk = ~clk;
	end

	initial begin
		reset <= 1;
		@(posedge clk);
		@(posedge clk);

		reset <= 0;
		@(posedge clk);
		@(posedge clk);

		press <= 1;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);

		press <= 0;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);

		press <= 1;
		@(posedge clk);
		@(posedge clk);

		press <= 0;
		@(posedge clk);
		@(posedge clk);

		$stop;
	end
endmodule
