// Hardware program to allow user to play flappy bird displayed on an LED array for Altera DE1-SoC
module DE1_SoC(CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, GPIO_0);
	// Initialization
	input logic CLOCK_50;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	output logic [35:0] GPIO_0;
	logic reset, gameOver, press, ongoing, addPoint, c0, c1, c2;
	logic [2:0] r;
	logic [7:0][7:0] redArray, greenArray;

	// Blank HEX displays
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;

	// Red LEDs are only used in leftmost column [0], set the rest to off
	assign redArray[1][7:0] = 8'b00000000;
	assign redArray[2][7:0] = 8'b00000000;
	assign redArray[3][7:0] = 8'b00000000;
	assign redArray[4][7:0] = 8'b00000000;
	assign redArray[5][7:0] = 8'b00000000;
	assign redArray[6][7:0] = 8'b00000000;
	assign redArray[7][7:0] = 8'b00000000;

	// Reset button
	assign reset = ~KEY[3];

	// 25 MHz clock initialization
	wire [31:0] clk;
	parameter whichClock = 15;
	clock_divider cdiv (CLOCK_50, clk);
	wire clk0;
	assign clk0 = clk[whichClock];

	// User input module
	userInput2 user (.clk(clk0), .reset, .button(~KEY[0]), .out(press));

	// Game state module
	gameOn gOn (.clk(clk0), .reset, .press(press), .out(ongoing));

	// Point system module
	pointOrFail point (.clk(clk0), .reset, .ongoing, .bird(redArray[0]), .pipe(greenArray[0]), .fail(gameOver), .addPoint);

	// LED driver module
	ledDriver ledd (.clk(clk0), .redArray, .greenArray, .redDriver(GPIO_0[27:20]), .greenDriver(GPIO_0[35:28]), .rowSink(GPIO_0[19:12]));

	// Random number generator
	LFSR r3 (.clk(clk0), .reset, .out(r));

	// Hex display modules
	hexDisplay d0 (.clk(clk0), .reset, .ongoing, .plusOne(addPoint), .HEX(HEX0), .carryOver(c0));
	hexDisplay d1 (.clk(clk0), .reset, .ongoing, .plusOne(c0), .HEX(HEX1), .carryOver(c1));
	hexDisplay d2 (.clk(clk0), .reset, .ongoing, .plusOne(c1), .HEX(HEX2), .carryOver(c2));

	// Red "bird" LED modules
	birdLight b0 (.clk(clk0), .reset, .ongoing, .gameOver, .press, .ceiling(1'b0), .startPosition(1'b0), .lightBelow(1'b0), .lightAbove(redArray[0][1]), .light(redArray[0][0]));
	birdLight b1 (.clk(clk0), .reset, .ongoing, .gameOver, .press, .ceiling(1'b0), .startPosition(1'b0), .lightBelow(redArray[0][0]), .lightAbove(redArray[0][2]), .light(redArray[0][1]));
	birdLight b2 (.clk(clk0), .reset, .ongoing, .gameOver, .press, .ceiling(1'b0), .startPosition(1'b0), .lightBelow(redArray[0][1]), .lightAbove(redArray[0][3]), .light(redArray[0][2]));
	birdLight b3 (.clk(clk0), .reset, .ongoing, .gameOver, .press, .ceiling(1'b0), .startPosition(1'b0), .lightBelow(redArray[0][2]), .lightAbove(redArray[0][4]), .light(redArray[0][3]));
	birdLight b4 (.clk(clk0), .reset, .ongoing, .gameOver, .press, .ceiling(1'b0), .startPosition(1'b1), .lightBelow(redArray[0][3]), .lightAbove(redArray[0][5]), .light(redArray[0][4]));
	birdLight b5 (.clk(clk0), .reset, .ongoing, .gameOver, .press, .ceiling(1'b0), .startPosition(1'b0), .lightBelow(redArray[0][4]), .lightAbove(redArray[0][6]), .light(redArray[0][5]));
	birdLight b6 (.clk(clk0), .reset, .ongoing, .gameOver, .press, .ceiling(1'b0), .startPosition(1'b0), .lightBelow(redArray[0][5]), .lightAbove(redArray[0][7]), .light(redArray[0][6]));
	birdLight b7 (.clk(clk0), .reset, .ongoing, .gameOver, .press, .ceiling(1'b1), .startPosition(1'b0), .lightBelow(redArray[0][6]), .lightAbove(1'b0), .light(redArray[0][7]));

	// Green "pipe" generator module
	pipes pipeGen (.clk(clk0), .reset, .ongoing, .gameOver, .position(r), .layout(greenArray[7][7:0]));

	// Pipe shifting modules
	shift pipe0 (.clk(clk0), .reset, .ongoing, .gameOver, .next(greenArray[1][7:0]), .pipeOut(greenArray[0][7:0]));
	shift pipe1 (.clk(clk0), .reset, .ongoing, .gameOver, .next(greenArray[2][7:0]), .pipeOut(greenArray[1][7:0]));
	shift pipe2 (.clk(clk0), .reset, .ongoing, .gameOver, .next(greenArray[3][7:0]), .pipeOut(greenArray[2][7:0]));
	shift pipe3 (.clk(clk0), .reset, .ongoing, .gameOver, .next(greenArray[4][7:0]), .pipeOut(greenArray[3][7:0]));
	shift pipe4 (.clk(clk0), .reset, .ongoing, .gameOver, .next(greenArray[5][7:0]), .pipeOut(greenArray[4][7:0]));
	shift pipe5 (.clk(clk0), .reset, .ongoing, .gameOver, .next(greenArray[6][7:0]), .pipeOut(greenArray[5][7:0]));
	shift pipe6 (.clk(clk0), .reset, .ongoing, .gameOver, .next(greenArray[7][7:0]), .pipeOut(greenArray[6][7:0]));


endmodule

// actual gameplay is not testable here, just check if fail conditions result in correct output
module DE1_SoC_testbench();
	reg	clk;
	wire  [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	wire  [9:0] LEDR;
	reg   [3:0] KEY;
	reg   [9:0] SW;
	wire	[35:0] GPIO_0;

	DE1_SoC dut (clk, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, GPIO_0);

	parameter CLOCK_PERIOD=100;
	initial clk=1;
	always begin
		#(CLOCK_PERIOD/2);
		clk = ~clk;
	end

	initial begin
		// Start game
		KEY[3] <= 1;
		@(posedge clk);
		@(posedge clk);

		KEY[3] <= 0;
		@(posedge clk);
		@(posedge clk);

		// Flap
		KEY[0] <= 1;
		@(posedge clk);

		KEY[0] <= 0;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);

		// Flap
		KEY[0] <= 1;
		@(posedge clk);

		KEY[0] <= 0;
		@(posedge clk);
		@(posedge clk);

		// Flap
		KEY[0] <= 1;
		@(posedge clk);

		// Wait long enough for a fail
		KEY[0] <= 0;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);

		$stop;
	end
endmodule

// Clock divider module
// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...
module clock_divider (clock, divided_clocks);
	input clock;
	output [31:0] divided_clocks;
	reg [31:0] divided_clocks;

	initial
		divided_clocks = 0;

	always @(posedge clock)
		divided_clocks = divided_clocks + 1;
endmodule
