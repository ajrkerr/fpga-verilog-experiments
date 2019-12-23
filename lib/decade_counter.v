`default_nettype none

module DecadeCounter (
	input wire clk_in,
	output wire[3:0] out,
	output reg carry
);
	always @(posedge clk_in) begin
		carry = 0;
		out = out + 1;

		if (out == 10) begin
			out = 0;
			carry = 1;
		end
	end
endmodule