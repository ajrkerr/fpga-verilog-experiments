module Mux #(parameter IN_WIDTH=3, OUT_WIDTH=8)(
	input wire[2:0] in,
	output wire[6:0] out
);
	always @(in) 
	begin
		case(in)
			3'b001 : out <= 7'b0000001;
			3'b010 : out <= 7'b0000010;
			3'b011 : out <= 7'b0000100;
			3'b100 : out <= 7'b0001000;
			3'b101 : out <= 7'b0010000;
			3'b110 : out <= 7'b0100000;
			3'b111 : out <= 7'b1000000;
			default : out <= 7'b0000000;
		endcase
	end
endmodule