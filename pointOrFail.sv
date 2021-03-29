// Module that handles determination of whether a point is added to the counter, or the user has failed and ends the game
module pointOrFail (clk, reset, ongoing, bird, pipe, fail, addPoint);
	input logic clk, reset;
	input logic ongoing;
	input logic [7:0] bird, pipe;
	output logic fail, addPoint;

	logic [7:0] pspipe, nspipe;
	logic psfail, nsfail;

	// Any collision between the bird and the pipe or the bird and the ground results in a fail
	always_comb begin
		nspipe = pipe;
		nsfail = bird[0] | bird[1] & pipe[1] | bird[2] & pipe[2] | bird[3] & pipe[3] | bird[4] & pipe[4] | bird[5] & pipe[5] | bird[6] & pipe[6] | bird[7] & pipe[7];
	end

	// Add a point when a pipe crosses the left side of the screen (crosses the bird)
	assign addPoint = ~(pspipe == 8'b00000000) & (pipe == 8'b00000000);
	assign fail = psfail;

	always @(posedge clk)
		if(reset | ~ongoing) begin
			pspipe <= 8'b00000000;
			psfail <= 1'b0;
		end
		else begin
			pspipe <= nspipe;
			psfail <= nsfail;
		end
endmodule

// Testbench that simulates the bird falling and the bird passing a pipe (fail and add point testing)
module pointOrFail_testbench();
	logic clk, reset;
	logic ongoing;
	logic [7:0] bird, pipe;
	logic fail, addPoint;

	pointOrFail dut(clk, reset, ongoing, bird, pipe, fail, addPoint);

	parameter CLOCK_PERIOD=100;
	initial clk=1;
	always begin
		#(CLOCK_PERIOD/2);
		clk = ~clk;
	end

	initial begin
		reset <= 1;
		ongoing <= 0;
		@(posedge clk);
		@(posedge clk);

		reset <= 0;
		@(posedge clk);
		@(posedge clk);

		bird <= 8'b00010000;
		pipe <= 8'b1111111;
		@(posedge clk);
		@(posedge clk);

		ongoing <= 1;
		@(posedge clk);
		@(posedge clk);
		
		bird <= 8'b00000001;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);

		reset <= 0;
		@(posedge clk);
		@(posedge clk);

		reset <= 1;
		@(posedge clk);
		@(posedge clk);

		bird <= 8'b00010000;
		@(posedge clk);
		pipe <= 8'b00010000;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);

		$stop;
	end
endmodule
