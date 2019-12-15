`include "lib/binary2bcd.v"
`include "lib/counter.v"
`include "lib/mux_counter.v"
`include "lib/digit_decoder.v"

module Lookup(
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

	always @ (digit_select) begin
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
		.TIMING_SCALE (4), 
		.OUT_WIDTH (NUM_DIGITS),
		.MAX (NUM_DIGITS), 
		.MIN (1)
	) counter(
		.clk_in (clk_in),
		.out (pos_digit_select)
	);

	// Start a counter
	reg [13:0]binary_counter;
	Counter #(
		.TIMING_SCALE (20), 
		.WIRES (14),
		.MAX (999)
	) digit_counter (
		.clk_in (clk_in),
		.out (binary_counter)
	);

	// Convert to individual digits
	wire [3:0]bcd_digits[3:0];
	Binary2BCD binary2bcd(
		.binary (binary_counter),
		.ones (bcd_digits[3]),
		.tens (bcd_digits[2]),
		.hundreds (bcd_digits[1]),
		.thousands (bcd_digits[0])
	);

	// Output them
	Lookup lookup(
		.digit_select (pos_digit_select),
		.bcd_digit_1 (bcd_digits[0]),
		.bcd_digit_2 (bcd_digits[1]),
		.bcd_digit_3 (bcd_digits[2]),
		.bcd_digit_4 (bcd_digits[3]),
		.out (led_segments)
	);
endmodule