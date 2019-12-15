`default_nettype none
`include "lib/led_counter.v"

module Main(
	input CLK, 
	output GLED, 
	output TR3, 
	output TR4, 
	output TR5,
	output TR6,
	output BR3, 
	output BR4, 
	output BR5,
	output BR6,
	output BR7,
	output BR8,
	output BR9,
	output BR10
);
	LEDCounter led_counter(
		.clk_in (CLK),
		.digit_select ({ TR3, TR4, TR5, TR6 }),
		.led_segments ({ BR3, BR4, BR5, BR6, BR7, BR8, BR9, BR10 })
	);
endmodule
