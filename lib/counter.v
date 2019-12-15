`default_nettype none

module Counter #(parameter TIMING_SCALE=24, WIRES=4, MAX=2**WIRES, MIN=0, INCREMENT=1) (
	input wire clk_in,
	output reg[WIRES-1:0] out
);
	reg [TIMING_SCALE-1:0] timing_counter;
    reg [WIRES-1:0] counter;
    assign out = counter;

	always @(posedge clk_in) begin
		timing_counter <= timing_counter + 1;

        if (timing_counter == 1) begin
            if (counter >= MAX) 
                counter <= MIN;
            else
                counter <= counter + INCREMENT;
        end
    end
endmodule
