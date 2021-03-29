// Hex display module to change corresponding hex display for score keeping
module hexDisplay(clk, reset, ongoing, plusOne, HEX, carryOver);
	input logic clk, reset;
	input logic ongoing, plusOne;
	output logic carryOver;
	output logic [6:0] HEX;
	logic [6:0] ps, ns;

	always_comb
		if(plusOne)
			case(ps)
				7'b1000000:	ns = 7'b1111001; // 0 -> 1
				7'b1111001:	ns = 7'b0100100; // 1 -> 2
				7'b0100100:	ns = 7'b0110000; // 2 -> 3
				7'b0110000:	ns = 7'b0011001; // 3 -> 4
				7'b0011001:	ns = 7'b0010010; // 4 -> 5
				7'b0010010: ns = 7'b0000010; // 5 -> 6
				7'b0000010: ns = 7'b1111000; // 6 -> 7
				7'b1111000: ns = 7'b0000000; // 7 -> 8
				7'b0000000: ns = 7'b0010000; // 8 -> 9
				7'b0010000: ns = 7'b1000000; // 9 -> 0
				default:	ns = 7'b1111111;
			endcase
		else
			ns = ps;

	// Output a signal to let the next hex display know to increment for carry over
	assign carryOver = plusOne & (ps[6:0] == 7'b0010000);
	assign HEX[6:0] = ps[6:0];

	always @(posedge clk)
		if(reset | ~ongoing)
			ps <= 7'b1000000;
		else
			ps <= ns;
endmodule

// Check that all numbers are displayed correctly with the carry over
module hexDisplay_testbench();
	logic clk, reset;
	logic ongoing, plusOne;
	logic [6:0] HEX;
	logic carryOver;

	hexDisplay dut (.clk, .reset, .ongoing, .plusOne, .HEX, .carryOver);

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

		ongoing <= 0;
		@(posedge clk);
		@(posedge clk);

		ongoing <= 1;
		@(posedge clk);
		@(posedge clk); //0

		plusOne <= 1; //1
		@(posedge clk);
		plusOne <= 0;
		@(posedge clk);
		plusOne <= 1; //2
		@(posedge clk);
		plusOne <= 0;
		@(posedge clk);
		plusOne <= 1; //3
		@(posedge clk);
		plusOne <= 0;
		@(posedge clk);
		plusOne <= 1; //4
		@(posedge clk);
		plusOne <= 0;
		@(posedge clk);
		plusOne <= 1; //5
		@(posedge clk);
		plusOne <= 0;
		@(posedge clk);
		plusOne <= 1; //6
		@(posedge clk);
		plusOne <= 0;
		@(posedge clk);
		plusOne <= 1; //7
		@(posedge clk);
		plusOne <= 0;
		@(posedge clk);
		plusOne <= 1; //8
		@(posedge clk);
		plusOne <= 0;
		@(posedge clk);
		plusOne <= 1; //9
		@(posedge clk);
		plusOne <= 0;
		@(posedge clk);

		$stop;
	end
endmodule
