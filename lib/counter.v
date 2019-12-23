`default_nettype none

module Counter #(parameter TIMING_SCALE=24, OUT_WIDTH=4, MAX=2**OUT_WIDTH, MIN=0, INCREMENT=1) (
	input wire clk_in,
	output wire[OUT_WIDTH-1:0] out
);
	reg [$clog2(TIMING_SCALE):0] timing_counter;
    reg [OUT_WIDTH-1:0] counter;
    assign out = counter;

	always @(posedge clk_in) begin
		timing_counter = timing_counter + 1;

        if (timing_counter == TIMING_SCALE) begin
            timing_counter = 0;

            if (counter > MAX) 
                counter = MIN;
            else
                counter = counter + INCREMENT;
        end
    end
endmodule
