`default_nettype none

module MuxCounter #(parameter TIMING_SCALE=24, OUT_WIDTH=5, MAX=5, MIN=0)(
	input wire clk_in,
	output reg[OUT_WIDTH:0] out
);
	reg [TIMING_SCALE-1:0] counter;

	always @(posedge clk_in)
	begin
		counter = counter + 1;

		if(counter == 1) begin
			case (out)
				0 : out <= 1;
				2**(MAX-1): out <= MIN;
				default : out <= (out << 1);
			endcase
		end
	end
endmodule