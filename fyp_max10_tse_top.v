/*

	Patrick Corley - University of Limerick Final Year Project
	FPGA-implemented Ethernet packet generator 

	Student I.D: 15181383
	Supervisor: Richard Conway
	
	Current file: Top level module
	
	TODO: 
	
	1. Build state-machine or otherwise to generate traffic (instantiated module)
		- Start with simpled fixed-packet generator with static CRC appended to ethernet frame.
		- Build random payload generator logic.
		- Build or instantiate ethernet CRC generator logic.
	2. [Done] Clean-up resets and clocks.
	3. Implement NIOS2 soft processor to initialize hardware on power-up and set config registers
	4. Add support for 10Mb/100Mb operation if time permits (optional)
	
*/



module fyp_max10_tse_top(
		
	// Module inputs
		
	input wire clk_50_max10,
	input wire [3:0] user_pb,
	input wire fpga_resetn,
	input wire [3:0] eneta_rx_d,
	input wire eneta_rx_dv,
	input wire eneta_rx_clk,
	
	// Module outputs
		
	output wire [3:0] eneta_tx_d,
	output wire eneta_tx_en,
	output wire eneta_gtx_clk,
	output wire eneta_resetn,
	
	output wire [4:0] user_led,
	
	output wire enet_mdc,
	
	// Bidirectional MDIO port
	
	inout wire enet_mdio
	
	
);

// Indicator LEDs

reg [4:0] indicator_led;

// PLL clock output connections

wire clk_125;
wire clk_125_shift;

// ethernet mode status wires

wire eth_mode;
wire ena_10;

// Avalon-ST receive/transmit wires

wire [31:0] rx_data;
wire rx_eop;
wire [5:0] rx_err;
wire [1:0] rx_empty;
wire rx_rdy;
wire rx_valid;
wire rx_sop;

wire [31:0] tx_data;
wire tx_eop;
wire tx_err;
wire [1:0] tx_empty;
wire tx_rdy;
wire tx_valid;
wire tx_sop;

// Clock control output wires

// wire clkctrl_out;

// MDIO interface wires

wire mdio_oen;
wire mdio_out;

// Continuous assignment ops to drive outputs 

assign enet_mdio = (!mdio_oen) ? (mdio_out) : ( 1'bz );
assign user_led = indicator_led;
assign eneta_resetn = fpga_resetn;
assign eneta_gtx_clk = clk_125_shift;


initial
	begin
		// Turn LSB LED on to indicate active design
		indicator_led = 5'b11110;
		
	end
	
// Always logic block for indicator LEDs

always @(posedge clk_125)
	begin
		indicator_led[2] = ~eth_mode; // hard-wired HIGH
		indicator_led[3] = ~ena_10;
	end

	
	
fyp_eth_pll fyp_eth_pll1 (
	.areset (~fpga_resetn),
	.inclk0 (clk_50_max10),
	.c0 (clk_125),
	.c1 (clk_125_shift),
	.locked ()
);
	
//fyp_clkctrl fyp_clkctrl1 (
//	.inclk  (clk_125_shift),   //  altclkctrl_input.inclk
//	.outclk (clkctrl_out)  		// altclkctrl_output.outclk
//);
	
//fyp_gpio fyp_gpio1 (
//	.outclock (clkctrl_out),
//	.din(2'b01),
//	.pad_out(eneta_gtx_clk)
//);	
	


fyp_max10_tse_sys fyp_max10_tse_sys1 (
	
	.clk_sys_125_clk                     			(clk_125),     			//  clk_sys_125.clk
	.reset_sys_125_reset_n                       (fpga_resetn), 			//  reset_sys_125.reset_n
	
	.eth_tse_0_pcs_mac_tx_clock_connection_clk   (clk_125),   			  	//  eth_tse_0_pcs_mac_tx_clock_connection.clk
   .eth_tse_0_pcs_mac_rx_clock_connection_clk   (eneta_rx_clk),   		//  eth_tse_0_pcs_mac_rx_clock_connection.clk
	.eth_tse_0_mac_rgmii_connection_rgmii_in     (eneta_rx_d),    			//  eth_tse_0_mac_rgmii_connection.rgmii_in
	.eth_tse_0_mac_rgmii_connection_rgmii_out    (eneta_tx_d),    			//  .rgmii_out
	.eth_tse_0_mac_rgmii_connection_rx_control   (eneta_rx_dv),   			//  .rx_control
	.eth_tse_0_mac_rgmii_connection_tx_control   (eneta_tx_en),   			//  .tx_control

	.eth_tse_0_receive_clock_connection_clk      (clk_125),              //  eth_tse_0_receive_clock_connection.clk
	.eth_tse_0_receive_data                      (rx_data),             	//  eth_tse_0_receive.data
	.eth_tse_0_receive_endofpacket               (rx_eop),             	//  .endofpacket
	.eth_tse_0_receive_error                     (rx_err),              	//  .error
	.eth_tse_0_receive_empty                     (rx_empty),             //  .empty
	.eth_tse_0_receive_ready                     (rx_rdy),              	//  .ready
	.eth_tse_0_receive_startofpacket             (rx_sop),              	//  .startofpacket
	.eth_tse_0_receive_valid                     (rx_valid),             //  .valid
	
	.eth_tse_0_transmit_clock_connection_clk     (clk_125),              //  eth_tse_0_transmit_clock_connection.clk
	.eth_tse_0_transmit_data                     (tx_data),              //  eth_tse_0_transmit.data
	.eth_tse_0_transmit_endofpacket              (tx_eop),              	//  .endofpacket
	.eth_tse_0_transmit_error                    (tx_err),              	//  .error
	.eth_tse_0_transmit_empty                    (tx_empty),             //  .empty
	.eth_tse_0_transmit_ready                    (tx_rdy),              	//  .ready
	.eth_tse_0_transmit_startofpacket            (tx_sop),              	//  .startofpacket
	.eth_tse_0_transmit_valid                    (tx_valid),             //  .valid
	
	.eth_tse_0_mac_status_connection_set_10      (1'b0),              	//  eth_tse_0_mac_status_connection.set_10
	.eth_tse_0_mac_status_connection_set_1000    (1'b1),              	//  .set_1000
	.eth_tse_0_mac_status_connection_eth_mode    (eth_mode),             //  .eth_mode
	.eth_tse_0_mac_status_connection_ena_10      (ena_10),              	//  .ena_10

	.eth_tse_0_mac_misc_connection_xon_gen       (),              			//  eth_tse_0_mac_misc_connection.xon_gen
   .eth_tse_0_mac_misc_connection_xoff_gen      (),              			//  .xoff_gen
	.eth_tse_0_mac_misc_connection_magic_wakeup  (),              			//  eth_tse_0_mac_misc_connection.magic_wakeup
	.eth_tse_0_mac_misc_connection_magic_sleep_n (), 				  			//  .magic_sleep_n
	.eth_tse_0_mac_misc_connection_ff_tx_crc_fwd (1'b0),              	//  .ff_tx_crc_fwd
	.eth_tse_0_mac_misc_connection_ff_tx_septy   (),              			//  .ff_tx_septy
	.eth_tse_0_mac_misc_connection_tx_ff_uflow   (),              			//  .tx_ff_uflow
	.eth_tse_0_mac_misc_connection_ff_tx_a_full  (),              			//  .ff_tx_a_full
	.eth_tse_0_mac_misc_connection_ff_tx_a_empty (),              			//  .ff_tx_a_empty
	.eth_tse_0_mac_misc_connection_rx_err_stat   (),              			//  .rx_err_stat
	.eth_tse_0_mac_misc_connection_rx_frm_type   (),              			//  .rx_frm_type
	.eth_tse_0_mac_misc_connection_ff_rx_dsav    (),              			//  .ff_rx_dsav
	.eth_tse_0_mac_misc_connection_ff_rx_a_full  (),              			//  .ff_rx_a_full
	.eth_tse_0_mac_misc_connection_ff_rx_a_empty (),              			//  .ff_rx_a_empty

	.eth_tse_0_mac_mdio_connection_mdc           (enet_mdc),      			//  eth_tse_0_mac_mdio_connection.mdc
   .eth_tse_0_mac_mdio_connection_mdio_in       (enet_mdio),     			//  .mdio_in
   .eth_tse_0_mac_mdio_connection_mdio_out      (mdio_out),      			//  .mdio_out
   .eth_tse_0_mac_mdio_connection_mdio_oen      (mdio_oen),      			// 

);

fyp_generator fyp_generator1(

	/* As convention, any control inputs will be sampled on a rising edge.
		The user push buttons on the Max 10 dev board are active low, therefore 
		they're complement will be connected as inputs to this module.
	*/
	
	.clk(clk_125),
	.reset(~fpga_resetn),			  
	.gen_start(~user_pb[3]),      
	.gen_stop(~user_pb[2]),
	.eth_ast_tx_data(tx_data),
	.eth_ast_tx_eop(tx_eop),
	.eth_ast_tx_err(tx_err),
	.eth_ast_tx_empty(tx_empty),
	.eth_ast_tx_rdy(tx_rdy),
	.eth_ast_tx_sop(tx_sop),
	.eth_ast_tx_valid(tx_valid),
	
	.eth_ast_rx_data(),
	.eth_ast_rx_eop(),
	.eth_ast_rx_err(),
	.eth_ast_rx_empty(),
	.eth_ast_rx_rdy(),
	.eth_ast_rx_sop(),
	.eth_ast_rx_valid()

);


endmodule