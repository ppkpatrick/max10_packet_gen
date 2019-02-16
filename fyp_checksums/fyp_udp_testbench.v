
`timescale 1ns/1ns

module fyp_udp_testbench;

reg reset;
reg clk;

initial
	begin
		reset = 1'b0;
		clk = 1'b0;
	end


always
	begin
		#5; 
		clk = ~clk;
	end

fyp_udp fyp_udp1(

	.clk(clk),
	.reset(reset)
);

endmodule