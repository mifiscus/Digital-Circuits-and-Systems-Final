// Module that moves generated pipes along the x-axis towards the user controlled bird, taking in logic from the last pixel column
// to determine the state of the next column
module shift (clk, reset, ongoing, gameOver, next, pipeOut);
	input logic clk, reset;
	input logic ongoing, gameOver;
	input logic [7:0] next;
	output reg [7:0] pipeOut;
	logic [7:0] count;
	logic [7:0] ps, ns;

	always_comb
		if(gameOver)
			ns = ps;
		else
			ns = next;

	assign pipeOut = ps;

	always @(posedge clk)
		if (reset | ~ongoing) begin
			ps[7:0] <= 8'b00000000;
			count <= 0;
		end
		else begin
			if (count == 0) ps[7:0] <= ns;
			count <= count + 1;
		end
endmodule

// test whether the pixels will act accordingly given random pixels are sent in the last column
module shift_testbench();
	logic clk, reset;
	logic ongoing, gameOver;
	logic [7:0] next;
	logic [7:0] pipeOut;

	shift dut (clk, reset, ongoing, gameOver, next, pipeOut);

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

		next <= 8'b11010101;
		@(posedge clk);
		@(posedge clk);

		next <= 8'b10100110;
		@(posedge clk);
		@(posedge clk);

		next <= 8'b11010111;
		@(posedge clk);
		@(posedge clk);

		gameOver <= 1;
		@(posedge clk);
		@(posedge clk);

		next <= 8'b11010101;
		@(posedge clk);
		@(posedge clk);

		$stop;
	end
endmodule
