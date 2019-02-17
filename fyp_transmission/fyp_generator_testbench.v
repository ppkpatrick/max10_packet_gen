/*

	Patrick Corley - University of Limerick Final Year Project
	FPGA-implemented Ethernet packet generator 

	Student I.D: 15181383
	Supervisor: Richard Conway
	
	Current file: Packet generator testbench - Used for logical verification of packet generator submodule
	
*/

`timescale 1ns/1ns

module fyp_generator_testbench;

reg clk;
reg gen_start;
reg tx_rdy;




fyp_generator fyp_generator1(

	.clk(clk),
	.gen_start(gen_start),      
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
		clk <= 1'b0;
		gen_start <= 1'b0;
		tx_rdy <= 1'b0;
		
		#10;
		
		tx_rdy <= 1'b1;
		
		#10;
		
		gen_start <= 1'b1;
		
		#100;
	
	end
	
	
always
	begin
		#5; 
		clk = ~clk;
	end



endmodule