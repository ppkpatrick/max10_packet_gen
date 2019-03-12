/* 
	FPGA-implemented Network Packet Generator
	Student: Patrick Corley
	
	Student ID: 15181383
	Supervisor: Dr. Richard Conway
	
	Current file: UDP/IP Testbench
	
	Description: 
	Testbench for simulation and testing of fyp_udp_ip verilog block.
	fyp_udp_ip generates traffic based on register values at compile-time, therefore the 
	only input stimuli are the clock and reset signals.
	We are able to probe the output signals of the fyp_udp_ip block in Modelsim
	without explicitly connecting them to this testbench.
*/
`timescale 1ns/1ns

module fyp_udp_ip_testbench;

reg reset;
reg clk;

initial
	begin
		// Initialize testbench registers
		reset = 1'b0;
		clk = 1'b0;
	end


always
	begin
		// Create a clock signal
		#5; 
		clk = ~clk;
	end

fyp_udp_ip fyp_udp_ip1(

	// Instantiate fyp_udp_ip module with clock and reset stimuli
	.clk(clk),
	.reset(reset)
);

endmodule