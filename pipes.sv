// Module that takes in a 3 bit random number from the LFSR and generates a predetermined pipe gap from the green LED arrays
module pipes (clk, reset, ongoing, gameOver, position, layout);
	input logic clk, reset;
	input logic ongoing, gameOver;
	input logic [2:0] position;
	output logic [7:0] layout;
	logic [8:0] count;
	logic [7:0] ps, ns;
	logic gap = 1'b0;

	// generate pipes from an assortment of 3 pixel wide gap positions based on random number generated
	always_comb
		if (gameOver)
			ns = layout;
		else
			if (gap == 0)
				case(position)
					3'b000:	ns = 8'b11000111;
					3'b001:	ns = 8'b10001111;
					3'b010:	ns = 8'b11100011;
					3'b011:	ns = 8'b11110001;
					3'b100:	ns = 8'b10001111;
					3'b101:	ns = 8'b11000111;
					3'b110:	ns = 8'b11000111;
					3'b111:	ns = 8'b10001111;
					default:	ns = 8'b00000000;
				endcase
			else
				ns = 8'b00000000;

	assign layout = ps;

	always @(posedge clk)
		if (reset | ~ongoing) begin
			ps <= 8'b00000000;
			count <= 0;
			gap <= 1'b0;
		end
		else begin
			if (count == 0) begin
				ps <= ns;
				gap <= gap + 1'b1;
			end
			count <= count + 1;
		end
endmodule

// test variety of numbers to check the pipe generation
module pipes_testbench();
	logic clk, reset;
	logic ongoing, gameOver;
	logic [2:0] position;
	logic [7:0] layout;

	pipes #(.WIDTH(3)) dut (.clk, .reset, .ongoing, .gameOver, .position, .layout);

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

		position <= 3'b100;
		@(posedge clk);
		@(posedge clk);

		position <= 3'b001;
		@(posedge clk);
		@(posedge clk);

		position <= 3'b001;
		@(posedge clk);
		@(posedge clk);

		position <= 3'b010;
		@(posedge clk);
		@(posedge clk);

		position <= 3'b011;
		@(posedge clk);
		@(posedge clk);

		position <= 3'b100;
		@(posedge clk);
		@(posedge clk);

		position <= 3'b101;
		@(posedge clk);
		@(posedge clk);

		position <= 3'b110;
		@(posedge clk);
		@(posedge clk);

		gameOver <= 1;
		position <= 3'b110;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);

		$stop;
	end
endmodule
