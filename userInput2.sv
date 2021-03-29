// Module that utilizes a state machine to handle user inputs for flapping
module userInput2 (clk, reset, button, out);
	input logic clk, reset;
	input logic button;
	output logic out;
	logic ps, ns;

	always_comb
		ns = button;

	assign out = ps;

	always @(posedge clk)
		if (reset)
			ps <= 1'b0;
		else
			ps <= ns;

endmodule

// simple button testing
module userInput2_testbench();
	logic clk, reset;
	logic button;
	logic out;

	userInput2 dut (.clk, .reset, .button, .out);

	parameter clk_PERIOD=100;
	initial clk=1;
	always begin
		#(clk_PERIOD/2);
		clk = ~clk;
	end


	initial begin
		reset <= 1;
		@(posedge clk);
		@(posedge clk);

		reset <= 0;
		@(posedge clk);
		@(posedge clk);

		button <= 1;
		@(posedge clk);
		@(posedge clk);

		button <= 0;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);

		button <= 1;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);

		button <= 0;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);

		button <= 1;
		@(posedge clk);
		@(posedge clk);

		button <= 0;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);

		$stop;
	end
endmodule
