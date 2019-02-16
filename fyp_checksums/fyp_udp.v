/*

	Patrick Corley - University of Limerick Final Year Project
	FPGA-implemented Ethernet packet generator 

	Student I.D: 15181383
	Supervisor: Richard Conway
	
	Current file: UDP module
	
	Description: 
	This block provides registers for storage of UDP, IP and Ethernet fields.
	A UDP checksum module is instantiated to compute the UDP header checksum and length based on the header fields (in parallel) 
	and a stream of the Payload data (in series via an 8-bit wide AXI Bus).
	A 8-to-32 bit AXI bus width adaptor is instantiaed to convert the output stream from the checksum generator.
	
*/

module fyp_udp(

	input wire clk,
	input wire reset,

	output wire [15:0] udp_src_out,
	output wire [15:0] udp_dst_out,
	output wire [15:0] udp_length_out,
	output wire [15:0] udp_checksum_out,
	
	/* Define connections OUT OF UDP block for length and checksum calculation */
	
	//	UDP data field registers
	
	output wire [31:0] udp_tdata_out,
	
	//	IP Header registers (V4)
	
	output wire [3:0] ip_version_out,
	output wire [3:0] ip_ihl_out,
	output wire [5:0] ip_dscp_out,
	output wire [1:0] ip_ecn_out,
	output wire [15:0] ip_length_out,
	output wire [15:0] ip_id_out,
	output wire [2:0] ip_flags_out,
	output wire [12:0] ip_frag_offset_out,
	output wire [7:0] ip_ttl_out,
	output wire [7:0] ip_protocol_out,
	output wire [15:0] ip_head_checksum_out,
	output wire [31:0] ip_src_out,
	output wire [31:0] ip_dst_out,
	
	// MAC Header field register
	
	output wire [47:0] mac_dst_out,
	output wire [47:0] mac_src_out,
	output wire [15:0] mac_type_out,
	output wire [31:0] mac_crc_out,
	
	// Control registers
	
	output wire udp_head_valid_out,
	input wire udp_head_ready_out,
	
	output wire udp_data_tvalid_out,
	input wire udp_data_tready_out,
	output wire udp_data_tuser_out,
	output wire udp_data_tlast_out,
	
	output wire busy
);

/* Define connections INTO UDP block for length and checksum calculation */

//	UDP header Field registers

reg [15:0] udp_src_in;
reg [15:0] udp_dst_in;

//	UDP data field registers

reg [7:0] udp_tdata_in;
wire [7:0] udp_tdata_adap;

//	IP Header registers (V4) total length = 20 bytes

reg [3:0] ip_version_in;
reg [3:0] ip_ihl_in;
reg [5:0] ip_dscp_in;
reg [1:0] ip_ecn_in;
reg [15:0] ip_length_in;
reg [15:0] ip_id_in;
reg [2:0] ip_flags_in;
reg [12:0] ip_frag_offset_in;
reg [7:0] ip_ttl_in;
reg [7:0] ip_protocol_in;
reg [15:0] ip_head_checksum_in;
reg [31:0] ip_src_in;
reg [31:0] ip_dst_in;

// MAC Header field register

reg [47:0] mac_dst_in;
reg [47:0] mac_src_in;
reg [15:0] mac_type_in;
reg [31:0] mac_crc;

// Control registers

reg udp_head_valid_in;
wire udp_head_ready_in;

reg udp_data_tvalid_in;
wire udp_data_tready_in;
reg udp_data_tuser_in;
reg udp_data_tlast_in;

reg [31:0] data_counter;

assign mac_crc_out = mac_crc;

wire udp_data_tvalid_adap;
wire udp_data_tready_adap;
wire udp_data_tuser_adap;
wire udp_data_tlast_adap;

initial
	begin
		// Initialise fixed fields
			
		udp_src_in <= 16'h1111;
		udp_dst_in <= 16'h2222;
		
		//	UDP data field registers
		
		udp_tdata_in <= 8'h11;
		
		//	IP Header registers (V4)
		
		ip_version_in <= 4'h4;
		ip_ihl_in <= 4'h5;
		ip_dscp_in <= 6'h00;
		ip_ecn_in <= 3'h0;
		ip_length_in <= 8'h00; 						//calculated in checksum block, expected = 2e
		ip_id_in <= 16'h0000;
		ip_flags_in <= 3'h2;
		ip_frag_offset_in <= 13'h0000;
		ip_ttl_in <= 8'h00;
		ip_protocol_in <= 8'h11; 					// UDP identifier
		ip_head_checksum_in <= 16'hb912;
		ip_src_in <= 32'h00000000;
		ip_dst_in <= 32'hc0a80105;
		
		// MAC Header field register
		
		mac_dst_in <= 48'h00E04C68088F; // USB 3.0 Adaptor MAC: 00E04C68088F; Desktop NIC: ac220bd9f6a8
		mac_src_in <= 48'h999999999999;
		mac_type_in <= 16'h0800;
		mac_crc <= 32'h11221122;
		
		// Control registers
		
		udp_head_valid_in <= 1'b0;
		
		udp_data_tvalid_in <= 1'b0;
		udp_data_tuser_in <= 1'b0;
		udp_data_tlast_in <= 1'b0;

		data_counter <= 32'h00000000;
	
	end
	
always @ (posedge clk)
	begin
		
		if (reset)
			begin
				// Initialise fixed fields
			
				udp_src_in <= 16'h1111;
				udp_dst_in <= 16'h2222;
				
				//	UDP data field registers
				
				udp_tdata_in <= 8'h11;
				
				//	IP Header registers (V4)
				
				ip_version_in <= 4'h4;
				ip_ihl_in <= 4'h5;
				ip_dscp_in <= 6'h00;
				ip_ecn_in <= 3'h0;
				ip_length_in <= 8'h00; //2e
				ip_id_in <= 16'h0000;
				ip_flags_in <= 3'h2;
				ip_frag_offset_in <= 13'h0000;
				ip_ttl_in <= 8'h00;
				ip_protocol_in <= 8'h11; 				// UDP identifier
				ip_head_checksum_in <= 16'hb912; 	// *This must be provided, will have to write my own checksum logic*
				ip_src_in <= 32'h00000000;
				ip_dst_in <= 32'hc0a80105;
				
				// MAC Header field register
				
				mac_dst_in <= 48'h00E04C68088F;
				mac_src_in <= 48'h999999999999;
				mac_type_in <= 16'h0800;
				mac_crc <= 32'h11221122;
				
				// Control registers
				
				udp_head_valid_in <= 1'b0;
				udp_data_tvalid_in <= 1'b0;
				udp_data_tuser_in <= 1'b0;
				udp_data_tlast_in <= 1'b0;
		
				data_counter <= 32'h00000000;
			end
		else
			begin
				if(udp_head_ready_in)
					begin
						// Put header data on wire in parallel
						
						udp_head_valid_in <= 1'b1;
						udp_data_tvalid_in <= 1'b0;
					end
				if(udp_data_tready_in)
					begin
						// Put serial payload stream on wire 
						
						udp_head_valid_in <= 1'b0;
						case (data_counter)
							0:begin
								udp_data_tvalid_in <= 1'b1;
								data_counter <= data_counter + 1'b1;
							end
							1:begin
								udp_data_tvalid_in <= 1'b1;
								data_counter <= data_counter + 1'b1;
							end
							2:begin
								udp_data_tvalid_in <= 1'b1;
								data_counter <= data_counter + 1'b1;
							end
							3:begin
								udp_data_tvalid_in <= 1'b1;
								data_counter <= data_counter + 1'b1;
							end
							4:begin
								udp_data_tvalid_in <= 1'b1;
								data_counter <= data_counter + 1'b1;
							end
							5:begin
								udp_data_tvalid_in <= 1'b1;
								data_counter <= data_counter + 1'b1;
							end
							6:begin
								udp_data_tvalid_in <= 1'b1;
								data_counter <= data_counter + 1'b1;
							end
							7:begin
								udp_data_tvalid_in <= 1'b1;
								data_counter <= data_counter + 1'b1;
							end
							8:begin
								udp_data_tvalid_in <= 1'b1;
								data_counter <= data_counter + 1'b1;
							end
							9:begin
								udp_data_tvalid_in <= 1'b1;
								data_counter <= data_counter + 1'b1;
							end
							10:begin
								udp_data_tvalid_in <= 1'b1;
								data_counter <= data_counter + 1'b1;
							end
							11:begin
								udp_data_tvalid_in <= 1'b1;
								data_counter <= data_counter + 1'b1;
							end
							12:begin
								udp_data_tvalid_in <= 1'b1;
								data_counter <= data_counter + 1'b1;
							end
							13:begin
								udp_data_tvalid_in <= 1'b1;
								data_counter <= data_counter + 1'b1;
							end
							14:begin
								udp_data_tvalid_in <= 1'b1;
								data_counter <= data_counter + 1'b1;
							end
							15:begin
								udp_data_tvalid_in <= 1'b1;
								data_counter <= data_counter + 1'b1;
							end
							16:begin
								udp_data_tvalid_in <= 1'b1;
								data_counter <= data_counter + 1'b1;
							end
							17:begin
								udp_data_tvalid_in <= 1'b1;
								udp_data_tlast_in <= 1'b1;
								data_counter <= data_counter + 1;
							end
							18:begin
								udp_data_tvalid_in <= 1'b0;
								udp_data_tlast_in <= 1'b0;
								data_counter <= 32'b0;
							end
						endcase	
					end
			end
	end

defparam axis_adapter1.S_DATA_WIDTH = 8;
defparam axis_adapter1.M_DATA_WIDTH = 32;


axis_adapter axis_adapter1
(
	.clk(clk) ,											// input  clk_sig
	.rst(reset) ,										// input  rst_sig
	
	.s_axis_tdata(udp_tdata_adap) ,				// input [S_DATA_WIDTH-1:0] s_axis_tdata_sig
	.s_axis_tvalid(udp_data_tvalid_adap) ,		// input  s_axis_tvalid_sig
	.s_axis_tready(udp_data_tready_adap) ,		// output  s_axis_tready_sig
	.s_axis_tlast(udp_data_tlast_adap) ,		// input  s_axis_tlast_sig
	.s_axis_tuser(udp_data_tuser_adap) ,		// input [USER_WIDTH-1:0] s_axis_tuser_sig
	
	.m_axis_tdata(udp_tdata_out) ,				// output [M_DATA_WIDTH-1:0] m_axis_tdata_sig
	.m_axis_tvalid(udp_data_tvalid_out) ,		// output  m_axis_tvalid_sig
	.m_axis_tready(udp_data_tready_out) ,		// input  m_axis_tready_sig
	.m_axis_tlast(udp_data_tlast_out) , 		// output  m_axis_tlast_sig
	.m_axis_tuser(udp_data_tuser_out) 			// output [USER_WIDTH-1:0] m_axis_tuser_sig
);

	
defparam fyp_upd_checksum1.PAYLOAD_FIFO_ADDR_WIDTH = 11; 		// Default = 11
defparam fyp_upd_checksum1.HEADER_FIFO_ADDR_WIDTH = 3;			// Default = 3

udp_checksum_gen fyp_upd_checksum1
(
	.clk(clk) ,																	// input  clk_sig
	.rst(reset) ,																// input  rst_sig
	
	.s_udp_hdr_valid(udp_head_valid_in) ,								// input  s_udp_hdr_valid_sig
	.s_udp_hdr_ready(udp_head_ready_in) ,								// output  s_udp_hdr_ready_sig
	
	.s_eth_dest_mac(mac_dst_in) ,											// input [47:0] s_eth_dst_mac_sig
	.s_eth_src_mac(mac_src_in) ,											// input [47:0] s_eth_src_mac_sig
	.s_eth_type(mac_type_in) ,												// input [15:0] s_eth_type_sig
	
	.s_ip_version(ip_version_in) ,										// input [3:0] s_ip_version_sig
	.s_ip_ihl(ip_ihl_in) ,													// input [3:0] s_ip_ihl_sig
	.s_ip_dscp(ip_dscp_in) ,												// input [5:0] s_ip_dscp_sig
	.s_ip_ecn(ip_ecn_in) ,													// input [1:0] s_ip_ecn_sig
	.s_ip_identification(ip_id_in) ,										// input [15:0] s_ip_identification_sig
	.s_ip_flags(ip_flags_in) ,												// input [2:0] s_ip_flags_sig
	.s_ip_fragment_offset(ip_frag_offset_in) ,						// input [12:0] s_ip_fragment_offset_sig
	.s_ip_ttl(ip_ttl_in) ,													// input [7:0] s_ip_ttl_sig
	.s_ip_header_checksum(ip_head_checksum_in) ,						// input [15:0] s_ip_header_checksum_sig
	.s_ip_source_ip(ip_src_in) ,											// input [31:0] s_ip_source_ip_sig
	.s_ip_dest_ip(ip_dst_in) ,												// input [31:0] s_ip_dest_ip_sig
	.s_udp_source_port(udp_src_in) ,										// input [15:0] s_udp_source_port_sig
	.s_udp_dest_port(udp_dst_in) ,										// input [15:0] s_udp_dest_port_sig
	
	.s_udp_payload_axis_tdata(udp_tdata_in) ,							// input [7:0] s_udp_payload_axis_tdata_sig
	.s_udp_payload_axis_tvalid(udp_data_tvalid_in) ,				// input  s_udp_payload_axis_tvalid_sig
	.s_udp_payload_axis_tready(udp_data_tready_in) ,				// output  s_udp_payload_axis_tready_sig
	.s_udp_payload_axis_tlast(udp_data_tlast_in) ,					// input  s_udp_payload_axis_tlast_sig
	.s_udp_payload_axis_tuser(udp_data_tuser_in) ,					// input  s_udp_payload_axis_tuser_sig
	
	.m_udp_hdr_valid(udp_head_valid_out) ,								// output  m_udp_hdr_valid_sig
	.m_udp_hdr_ready(udp_head_ready_out) ,								// input  m_udp_hdr_ready_sig
	
	.m_eth_dest_mac(mac_dst_out) ,										// output [47:0] m_eth_dst_mac_sig
	.m_eth_src_mac(mac_src_out) ,											// output [47:0] m_eth_src_mac_sig
	.m_eth_type(mac_type_out) ,											// output [15:0] m_eth_type_sig
	
	.m_ip_version(ip_version_out) ,										// output [3:0] m_ip_version_sig
	.m_ip_ihl(ip_ihl_out) ,													// output [3:0] m_ip_ihl_sig
	.m_ip_dscp(ip_dscp_out) ,												// output [5:0] m_ip_dscp_sig
	.m_ip_ecn(ip_ecn_out) ,													// output [1:0] m_ip_ecn_sig
	.m_ip_length(ip_length_out) ,											// output [15:0] m_ip_length_sig
	.m_ip_identification(ip_id_out) ,									// output [15:0] m_ip_identification_sig
	.m_ip_flags(ip_flags_out) ,											// output [2:0] m_ip_flags_sig
	.m_ip_fragment_offset(ip_frag_offset_out) ,						// output [12:0] m_ip_fragment_offset_sig
	.m_ip_ttl(ip_ttl_out) ,													// output [7:0] m_ip_ttl_sig
	.m_ip_protocol(ip_protocol_out) ,									// output [7:0] m_ip_protocol_sig
	.m_ip_header_checksum(ip_head_checksum_out) ,					// output [15:0] m_ip_header_checksum_sig
	.m_ip_source_ip(ip_src_out) ,											// output [31:0] m_ip_source_ip_sig
	.m_ip_dest_ip(ip_dst_out) ,											// output [31:0] m_ip_dst_ip_sig
	
	.m_udp_source_port(udp_src_out) ,									// output [15:0] m_udp_source_port_sig
	.m_udp_dest_port(udp_dst_out) ,										// output [15:0] m_udp_dst_port_sig
	.m_udp_length(udp_length_out) ,										// output [15:0] m_udp_length_sig
	.m_udp_checksum(udp_checksum_out) ,									// output [15:0] m_udp_checksum_sig
	
	.m_udp_payload_axis_tdata(udp_tdata_adap) ,						// output [7:0] m_udp_payload_axis_tdata_sig
	.m_udp_payload_axis_tvalid(udp_data_tvalid_adap) ,				// output  m_udp_payload_axis_tvalid_sig
	.m_udp_payload_axis_tready(udp_data_tready_adap) ,				// input  m_udp_payload_axis_tready_sig
	.m_udp_payload_axis_tlast(udp_data_tlast_adap) ,				// output  m_udp_payload_axis_tlast_sig
	.m_udp_payload_axis_tuser(udp_data_tuser_adap) ,				// output  m_udp_payload_axis_tuser_sig
		
	.busy(busy) 																// output  busy_sig
);


endmodule
