`include "lib/counter.v"
`include "lib/mux_counter.v"
`include "lib/digit_decoder.v"
`include "lib/decade_counter.v"

module DisplayDigits(
	input wire[3:0] digit_select,
	input wire[3:0] bcd_digit_1,
	input wire[3:0] bcd_digit_2,
	input wire[3:0] bcd_digit_3,
	input wire[3:0] bcd_digit_4,
	output reg[7:0] out
);
	reg [3:0] digit_value;

	DigitDecoder digit (
		.in (digit_value),
		.out (out)
	);

	always @(digit_select) begin
		case(digit_select)
			4'b1000 : digit_value <= bcd_digit_1;
			4'b0100 : digit_value <= bcd_digit_2;
			4'b0010 : digit_value <= bcd_digit_3;
			4'b0001 : digit_value <= bcd_digit_4;
			default : digit_value <= 0;
		endcase
	end
endmodule

module LEDCounter #(localparam NUM_DIGITS=4) (
	input wire clk_in,
	output wire[3:0] digit_select,
	output wire[7:0] led_segments
);
	// The display is common annode, so ground the selected digit
	wire [NUM_DIGITS-1:0] pos_digit_select;
	genvar i;
	for(i = 0; i < NUM_DIGITS; i++)
		assign digit_select[i] = ~pos_digit_select[i];
	
	MuxCounter #(
		.TIMING_SCALE (16), 
		.OUT_WIDTH (NUM_DIGITS),
		.MAX (NUM_DIGITS), 
		.MIN (1)
	) refresh_counter(
		.clk_in (clk_in),
		.out (pos_digit_select)
	);

	// Create a series of decimal counters
	wire [3:0]bcd_digits[3:0];
	wire carry[4:0];
	Counter #(
		.TIMING_SCALE (4_194_304),
		.OUT_WIDTH (1),
		.MAX (1),
		.MIN (0)
	) timing_clock (
		.clk_in (clk_in),
		.out (carry[0])
	);

	genvar j;
	for(j = 0; j < NUM_DIGITS; j = j + 1) begin
		DecadeCounter digit (
			.clk_in (carry[j]),
			.out (bcd_digits[j]),
			.carry (carry[j+1])
		);
	end

	// Output them
	DisplayDigits lookup(
		.digit_select (pos_digit_select),
		.bcd_digit_1 (bcd_digits[3]),
		.bcd_digit_2 (bcd_digits[2]),
		.bcd_digit_3 (bcd_digits[1]),
		.bcd_digit_4 (bcd_digits[0]),
		.out (led_segments)
	);
endmodule