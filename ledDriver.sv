module ledDriver (clk, redArray, greenArray, redDriver, greenDriver, rowSink);
	input logic clk;
	input logic [7:0][7:0] redArray, greenArray;
	output logic [7:0] redDriver, greenDriver, rowSink;
	
	reg [2:0] count = 3'b000;
	
	always @(*)
		case(count)
			3'b000:	rowSink = 8'b11111110;
			3'b001:	rowSink = 8'b11111101;
			3'b010:	rowSink = 8'b11111011;
			3'b011:	rowSink = 8'b11110111;
			3'b100:	rowSink = 8'b11101111;
			3'b101:	rowSink = 8'b11011111;
			3'b110:	rowSink = 8'b10111111;
			3'b111:	rowSink = 8'b01111111;
			default:	rowSink = 8'bX;
		endcase
	
	assign redDriver[7:0] = redArray[count];
	assign greenDriver[7:0] = greenArray[count];
	
	always @(posedge clk)
		count <= count + 3'b001;
endmodule

module ledDriver_testbench();
	reg clk;
	reg [7:0][7:0] redArray, greenArray;
	wire [7:0] redDriver, greenDriver, rowSink;
	
	parameter EIGHT_OFF = 8'b00000000;
	
	ledDriver dut (clk, redArray, greenArray, redDriver, greenDriver, rowSink);
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial clk=1;
	always begin
		#(CLOCK_PERIOD/2);
		clk = ~clk;
	end
	
	initial begin
		redArray[7][7:0] <= EIGHT_OFF;		greenArray[7][7:0] <= EIGHT_OFF;
		redArray[6][7:0] <= EIGHT_OFF;		greenArray[6][7:0] <= EIGHT_OFF;
		redArray[5][7:0] <= EIGHT_OFF;		greenArray[5][7:0] <= EIGHT_OFF;
		redArray[4][7:0] <= EIGHT_OFF;		greenArray[4][7:0] <= EIGHT_OFF;
		redArray[3][7:0] <= EIGHT_OFF;		greenArray[3][7:0] <= EIGHT_OFF;
		redArray[2][7:0] <= EIGHT_OFF;		greenArray[2][7:0] <= EIGHT_OFF;
		redArray[1][7:0] <= EIGHT_OFF;		greenArray[1][7:0] <= EIGHT_OFF;
		redArray[0][7:0] <= EIGHT_OFF;		greenArray[0][7:0] <= EIGHT_OFF;	@(posedge clk);
																										@(posedge clk);
																										@(posedge clk);
																										@(posedge clk);
																										@(posedge clk);
																										@(posedge clk);
																										@(posedge clk);
																										@(posedge clk);
																										@(posedge clk);
		
		redArray[7][7:0] <= EIGHT_OFF;		greenArray[7][7:0] <= EIGHT_OFF;
		redArray[6][7:0] <= 8'b11001111;	greenArray[6][7:0] <= EIGHT_OFF;
		redArray[5][7:0] <= EIGHT_OFF;		greenArray[5][7:0] <= EIGHT_OFF;
		redArray[4][7:0] <= 8'b11111001;	greenArray[4][7:0] <= EIGHT_OFF;
		redArray[3][7:0] <= 8'b11001111;	greenArray[3][7:0] <= EIGHT_OFF;
		redArray[2][7:0] <= 8'b11111001;	greenArray[2][7:0] <= EIGHT_OFF;
		redArray[1][7:0] <= EIGHT_OFF;		greenArray[1][7:0] <= EIGHT_OFF;
		redArray[0][7:0] <= EIGHT_OFF;		greenArray[0][7:0] <= EIGHT_OFF;	@(posedge clk);
																										@(posedge clk);
																										@(posedge clk);
																										@(posedge clk);
																										@(posedge clk);
																										@(posedge clk);
																										@(posedge clk);
																										@(posedge clk);
																										@(posedge clk);
		
		redArray[7][7:0] <= EIGHT_OFF;		greenArray[7][7:0] <= 8'b10111110;
		redArray[6][7:0] <= EIGHT_OFF;		greenArray[6][7:0] <= 8'b10111011;
		redArray[5][7:0] <= EIGHT_OFF;		greenArray[5][7:0] <= 8'b11101110;
		redArray[4][7:0] <= EIGHT_OFF;		greenArray[4][7:0] <= EIGHT_OFF;
		redArray[3][7:0] <= EIGHT_OFF;		greenArray[3][7:0] <= 8'b11111010;
		redArray[2][7:0] <= EIGHT_OFF;		greenArray[2][7:0] <= 8'b11011101;
		redArray[1][7:0] <= EIGHT_OFF;		greenArray[1][7:0] <= EIGHT_OFF;
		redArray[0][7:0] <= EIGHT_OFF;		greenArray[0][7:0] <= EIGHT_OFF;	@(posedge clk);
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