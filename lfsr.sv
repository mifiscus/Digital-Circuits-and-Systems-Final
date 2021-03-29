// Linear feedback shift register to act as a random number generator for pipe generation
module LFSR (clk, reset, out);
	input logic clk, reset;
	output reg [2:0] out;

		always @(posedge clk) begin
			if (reset) begin
				out = 3'b000;
			end

			else begin
				out <= out << 1;
				out[0] <= (out[1]^~out[2]);
			end
		end

endmodule

// Check numbers generated
module LFSR_testbench ();
	logic clk, reset;
	reg [2:0] out;

	LFSR random (.clk, .reset, .out);

	parameter clk_PERIOD = 100;
	initial clk = 1;
	always begin
		#(clk_PERIOD / 2);
		clk = ~clk;
	end

	initial begin

	reset <= 1;
	@(posedge clk);
	@(posedge clk);

	reset <= 0;
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
