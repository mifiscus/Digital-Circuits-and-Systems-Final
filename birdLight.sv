// Module that handles the current position of the red "bird" LED, taking in user button inputs and the game state
module birdLight (clk, reset, ongoing, gameOver, press, ceiling, startPosition, lightBelow, lightAbove, light);
	input logic clk, reset;
	input logic ongoing, gameOver;
	input logic press, ceiling, startPosition, lightBelow, lightAbove;
	output logic light;
	logic [6:0] count;
	logic ps, ns;

	// determine whether this pixel should light up based on if the bird is moving towards it from either below or above
	always_comb
		if (gameOver)
			ns = ps;
		else
			case(ps)
				1'b0: ns = (~press & lightAbove) | (press & lightBelow);
				1'b1: ns = press & ceiling;
			endcase

	assign light = ps;

	always @(posedge clk)
		if (reset | ~ongoing) begin
			ps <= startPosition;
			count <= 0;
		end
		else begin
			if (count == 0) ps <= ns;
			count <= count + 1;
		end
endmodule

module birdLight_testbench();
	logic clk, reset;
	logic ongoing, gameOver;
	logic press, startPosition, lightAbove, lightBelow, ceiling;
	wire lightOn;

	birdLight dut (clk, reset, ongoing, gameOver, press, ceiling, startPosition, lightBelow, lightAbove, lightOn);

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
		ongoing <= 1;
		@(posedge clk);
		@(posedge clk);

		ceiling <= 0;
		lightAbove <= 1;
		press <= 0;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);

		ceiling <= 1;
		lightAbove <= 0;
		press <= 1;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);

		ceiling <= 0;
		lightBelow <= 1;
		press <= 1;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);

		$stop;
	end
endmodule
