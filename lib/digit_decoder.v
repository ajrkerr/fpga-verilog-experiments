`default_nettype none

module DigitDecoder(
	input wire[3:0] in,
	output reg[7:0] out
);
	always @ (in) begin
		case(in)
			1 : out <= 8'b01100000;
			2 : out <= 8'b11011010;
			3 : out <= 8'b11110010;
			4 : out <= 8'b01100110;
			5 : out <= 8'b10110110;
			6 : out <= 8'b10111110;
			7 : out <= 8'b11100000;
			8 : out <= 8'b11111110;
			9 : out <= 8'b11100110;
			0 : out <= 8'b11111100;
			default : out <= 8'b00000000;
		endcase
	end
endmodule
