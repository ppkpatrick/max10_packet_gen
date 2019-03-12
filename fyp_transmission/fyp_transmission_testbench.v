/* 
	FPGA-implemented Network Packet Generator
	Student: Patrick Corley
	
	Student ID: 15181383
	Supervisor: Dr. Richard Conway
	
	Current file: Transmission Testbench
	
	Description: 
	Testbench for simulation and testing of fyp_transmission verilog block.
	fyp_transmission receives packets generated within the fyp_udp_block and transmits them 
	to the MAC block over an Avalon-ST interface. 
	The only input stimuli required for this module are the clock, generator start and transmission 
	ready signals.
	We are able to probe the output signals of the fyp_transmission block in Modelsim
	without explicitly connecting them to this testbench.
*/

`timescale 1ns/1ns

module fyp_transmission_testbench;

reg clk;
reg gen_start;
reg gen_stop;
reg tx_rdy;




fyp_transmission fyp_transmission1(

	.clk(clk),
	.gen_start(gen_start),
	.gen_stop(gen_stop),
	.eth_ast_tx_data(),
	.eth_ast_tx_eop(),
	.eth_ast_tx_err(),
	.eth_ast_tx_empty(),
	.eth_ast_tx_rdy(tx_rdy),
	.eth_ast_tx_sop(),
	.eth_ast_tx_valid(),
	
	.eth_ast_rx_data(),
	.eth_ast_rx_eop(),
	.eth_ast_rx_err(),
	.eth_ast_rx_empty(),
	.eth_ast_rx_rdy(),
	.eth_ast_rx_sop(),
	.eth_ast_rx_valid()
	

);

initial
	begin
		// Initialize register values and allow settle time.
		clk <= 1'b0;
		gen_start <= 1'b0;
		gen_stop <= 1'b0;
		tx_rdy <= 1'b0;
		#10;
		tx_rdy <= 1'b1;
		#10;
		gen_start <= 1'b1;
		#100;
	
	end
	
	
always
	begin
		// Create clock signal
		#5; 
		clk = ~clk;
	end



endmodule