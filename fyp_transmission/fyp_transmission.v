
/*

	Patrick Corley - University of Limerick Final Year Project
	FPGA-implemented Ethernet packet generator 

	Student I.D: 15181383
	Supervisor: Dr. Richard Conway
	
	Current file: Packet transmitter module
	
	Description: This module contains the logic for the transmission of generated packet data 
	into the MAC block.
	
*/


module fyp_transmission(

	// Module inputs 
	
	// Avalon-ST receive interface <- MAc (Probably not necessary)
	
	input wire			clk,
	input wire			reset,
	
	input wire 			gen_start,
	input wire 			gen_stop,
	input wire [31:0] eth_ast_rx_data,                   
	input	wire			eth_ast_rx_eop,               
	input wire [5:0] 	eth_ast_rx_err,                     
	input wire [1:0] 	eth_ast_rx_empty,                    
	output wire			eth_ast_rx_rdy,                     
	input wire			eth_ast_rx_sop,             
	input wire			eth_ast_rx_valid,

	// Module outputs
	
	// Avalon ST transmit interface -> MAC

	output wire [31:0]eth_ast_tx_data,
	output wire			eth_ast_tx_eop,
	output wire			eth_ast_tx_err,
	output wire [1:0]	eth_ast_tx_empty,
	input wire			eth_ast_tx_rdy,
	output wire			eth_ast_tx_sop,
	output wire			eth_ast_tx_valid
	

);

// Data wires driven by UDP module

wire [15:0] udp_src;
wire [15:0] udp_dst;
wire [15:0] udp_length;
wire [15:0] udp_checksum;

//	UDP data field wires
wire [31:0] udp_tdata;

//	IP Header wires (V4)
wire [3:0] ip_version;
wire [3:0] ip_ihl;
wire [5:0] ip_dscp;
wire [1:0] ip_ecn;
wire [15:0] ip_length;
wire [15:0] ip_id;
wire [2:0] ip_flags;
wire [12:0] ip_frag_offset;
wire [7:0] ip_ttl;
wire [7:0] ip_protocol;
wire [15:0] ip_head_checksum;
wire [31:0] ip_src;
wire [31:0] ip_dst;

// MAC Header wires

wire [47:0] mac_dst;
wire [47:0] mac_src;
wire [15:0] mac_type;
wire [31:0] mac_crc;

// Control signals

wire udp_head_valid;
reg udp_head_ready;

wire udp_data_tvalid;
reg udp_data_tready;
wire udp_data_tuser;
wire udp_data_tlast;

wire busy;

// Flag registers 
reg run_flag;
reg pkt_ready;
reg payload_sampled;
reg header_sampled;

// Stat Registers

reg [15:0] tx_count;
reg [2:0] data_index;

// Registers to drive output wires

reg [31:0] tx_d;
reg tx_valid;
reg tx_sop;
reg tx_eop;
reg [1:0] tx_empty;
reg tx_error;

reg [335:0] header;
reg [143:0] payload; 

assign eth_ast_tx_data = tx_d;
assign eth_ast_tx_sop = tx_sop;
assign eth_ast_tx_eop = tx_eop;
assign eth_ast_tx_valid = tx_valid;
assign eth_ast_tx_empty = tx_empty;
assign eth_ast_tx_err = tx_error;

initial
	begin
		
		run_flag = 1'b0;
		tx_count = 16'h0000;
		
		tx_d = 32'h00000000;
		tx_valid = 1'b0;
		tx_sop = 1'b0;
		tx_eop = 1'b0;
		tx_empty = 2'b0;
		tx_error = 1'b0;
		
		udp_data_tready <= 1'b0;
		udp_head_ready <= 1'b0;
 		
		data_index <= 3'b0;
		
		header <= 335'b0;
		payload <= 144'b0;
		pkt_ready <= 1'b0;
		payload_sampled <= 1'b0;
		header_sampled <= 1'b0;
	
	end


	
always @(posedge clk)
	begin
		
		// Eth frame size = 64 bytes:
	
		// Dest MAC		Source MAC		Eth Type			DATA			CRC
	
		// 6 Bytes		6 Bytes			2 Bytes		46 Bytes		4 Bytes
		
		if(reset)
			begin
				run_flag <= 1'b0;
				tx_count <= 16'h0000;
				
				tx_d <= 32'h00000000;
				tx_valid <= 1'b0;
				tx_sop <= 1'b0;
				tx_eop <= 1'b0;
				tx_empty = 2'b0;
				tx_error = 1'b0;
				
				udp_data_tready <= 1'b0;
				udp_head_ready <= 1'b0;
				
				data_index <= 3'b0;
				
				header <= 335'b0;
				payload <= 144'b0;
				pkt_ready <= 1'b0;
				payload_sampled <= 1'b0;
				header_sampled <= 1'b0;
		
			end
		
		else
			begin
				if(gen_start)
					begin
						// Set transmission flag to start transmission
						run_flag <= 1'b1;
						udp_data_tready <= 1'b1;
						udp_head_ready <= 1'b1;
					end
					
				if(gen_stop)
					begin
						// Set transmission flag to stop transmission
						run_flag <= 1'b0;
					end
					
				if (run_flag)
					begin
						if ((udp_head_valid) && (payload_sampled))
							begin
								header <= {
								
								mac_dst, 			//48b
								mac_src,				//48b
								mac_type,			//16b
								ip_version,			//4b
								ip_ihl,				//4b
								ip_dscp,				//6b
								ip_ecn,				//2b
								ip_length,			//16b
								ip_id,				//16b
								ip_flags,			//3b
								ip_frag_offset,	//13b
								ip_ttl,				//8b
								ip_protocol,		//8b
								ip_head_checksum,	//16b
								ip_src,				//32b
								ip_dst,				//32b
								udp_src,				//16b
								udp_dst,				//16b
								udp_length,			//16b
								udp_checksum		//16b
								//mac_crc				//32b
													
								};
								payload_sampled <= 1'b0;
								header_sampled <= 1'b1;
								pkt_ready <= 1'b1;
								
							end
						else if(udp_data_tvalid)
							begin
								case (data_index)
									0:begin
										payload[143:112] <= udp_tdata;
										data_index <= data_index + 3'b1;
									end
									1:begin
										payload[111:80] <= udp_tdata;
										data_index <= data_index + 3'b1;
									end
									2:begin
										payload[79:48] <= udp_tdata;
										data_index <= data_index + 3'b1;
									end
									3:begin
										payload[47:16] <= udp_tdata;
										data_index <= data_index + 3'b1;
									end
									4:begin
										payload[15:0] <= udp_tdata[15:0];
										payload_sampled <= 1'b1;
										data_index <= 3'b0;
									end
								endcase
							end

						if(pkt_ready)
							begin
								if(eth_ast_tx_rdy)
									begin
										case (tx_count)
											0:begin
												tx_d <= header[335:304];
												tx_valid <= 1'b1;
												tx_sop <= 1'b1;
												tx_eop <= 1'b0;
												tx_count <= tx_count + 16'b1;
											end
											1:begin
												tx_d <= header[303:272];
												tx_valid <= 1'b1;
												tx_sop <= 1'b0;
												tx_eop <= 1'b0;
												tx_count <= tx_count + 16'b1;
											end
											2:begin
												tx_d <= header[271:240];
												tx_valid <= 1'b1;
												tx_sop <= 1'b0;
												tx_eop <= 1'b0;
												tx_count <= tx_count + 16'b1;
											end
											3:begin
												tx_d <= header[239:208];
												tx_valid <= 1'b1;
												tx_sop <= 1'b0;
												tx_eop <= 1'b0;
												tx_count <= tx_count + 16'b1;
											end
											4:begin
												tx_d <= header[207:176];
												tx_valid <= 1'b1;
												tx_sop <= 1'b0;
												tx_eop <= 1'b0;
												tx_count <= tx_count + 16'b1;
											end
											5:begin
												tx_d <= header[175:144];
												tx_valid <= 1'b1;
												tx_sop <= 1'b0;
												tx_eop <= 1'b0;
												tx_count <= tx_count + 16'b1;
											end
											6:begin
												tx_d <= header[143:112];
												tx_valid <= 1'b1;
												tx_sop <= 1'b0;
												tx_eop <= 1'b0;
												tx_count <= tx_count + 16'b1;
											end
											7:begin
												tx_d <= header[111:80];
												tx_valid <= 1'b1;
												tx_sop <= 1'b0;
												tx_eop <= 1'b0;
												tx_count <= tx_count + 16'b1;
											end
											8:begin
												tx_d <= header[79:48];
												tx_valid <= 1'b1;
												tx_sop <= 1'b0;
												tx_eop <= 1'b0;
												tx_count <= tx_count + 16'b1;
											end
											9:begin
												tx_d <= header[47:16];
												tx_valid <= 1'b1;
												tx_sop <= 1'b0;
												tx_eop <= 1'b0;
												tx_count <= tx_count + 16'b1;
											end
											10:begin
												tx_d <= {header[15:0], payload[143:128]};
												tx_valid <= 1'b1;
												tx_sop <= 1'b0;
												tx_eop <= 1'b0;
												tx_count <= tx_count + 16'b1;
											end
											11:begin
												tx_d <= payload[127:96];
												tx_valid <= 1'b1;
												tx_sop <= 1'b0;
												tx_eop <= 1'b0;
												tx_count <= tx_count + 16'b1;
											end
											12:begin
												tx_d <= payload[95:64];
												tx_valid <= 1'b1;
												tx_sop <= 1'b0;
												tx_eop <= 1'b0;
												tx_count <= tx_count + 16'b1;
											end
											13:begin
												tx_d <= payload[63:32];
												tx_valid <= 1'b1;
												tx_sop <= 1'b0;
												tx_eop <= 1'b0;
												tx_count <= tx_count + 16'b1;
											end
											14:begin
												tx_d <= payload[31:0];
												tx_valid <= 1'b1;
												tx_sop <= 1'b0;
												tx_eop <= 1'b1;
												tx_count <= tx_count + 16'b1;
											end
											15:begin
												tx_valid <= 1'b0;
												tx_sop <= 1'b0;
												tx_eop <= 1'b0;
												tx_empty <= 2'd0;
												
												tx_count <= 16'b0;
												pkt_ready <= 1'b0;
											end
										endcase
									end
							end
					end
			end
	end	
	
fyp_udp_ip fyp_udp_ip1(

	.clk(clk) ,													// input  clk_sig
	.reset(reset) ,											// input  reset_sig
	.udp_src_out(udp_src) ,									// output [15:0] udp_src_out_sig
	.udp_dst_out(udp_dst) ,									// output [15:0] udp_dst_out_sig
	.udp_length_out(udp_length) ,							// output [15:0] udp_length_out_sig
	.udp_checksum_out(udp_checksum) ,					// output [15:0] udp_checksum_out_sig
	.udp_tdata_out(udp_tdata) ,							// output [7:0] udp_tdata_out_sig
	.ip_version_out(ip_version) ,							// output [3:0] ip_version_out_sig
	.ip_ihl_out(ip_ihl) ,									// output [3:0] ip_ihl_out_sig
	.ip_dscp_out(ip_dscp) ,									// output [5:0] ip_dscp_out_sig
	.ip_ecn_out(ip_ecn) ,									// output [1:0] ip_ecn_out_sig
	.ip_length_out(ip_length) ,							// output [15:0] ip_length_out_sig
	.ip_id_out(ip_id) ,										// output [15:0] ip_id_out_sig
	.ip_flags_out(ip_flags) ,								// output [2:0] ip_flags_out_sig
	.ip_frag_offset_out(ip_frag_offset) ,				// output [12:0] ip_frag_offset_out_sig
	.ip_ttl_out(ip_ttl) ,									// output [7:0] ip_ttl_out_sig
	.ip_protocol_out(ip_protocol) ,						// output [7:0] ip_protocol_out_sig
	.ip_head_checksum_out(ip_head_checksum) ,			// output [15:0] ip_head_checksum_out_sig
	.ip_src_out(ip_src) ,									// output [31:0] ip_src_out_sig
	.ip_dst_out(ip_dst) ,									// output [31:0] ip_dst_out_sig
	.mac_dst_out(mac_dst) ,									// output [47:0] mac_dst_out_sig
	.mac_src_out(mac_src) ,									// output [47:0] mac_src_out_sig
	.mac_type_out(mac_type) ,								// output [15:0] mac_type_out_sig
	.mac_crc_out(mac_crc) ,									// output [31:0] mac_crc_out_sig
	.udp_head_valid_out(udp_head_valid) ,				// output  udp_head_valid_out_sig
	.udp_head_ready_out(udp_head_ready) ,				// input  udp_head_ready_out_sig
	.udp_data_tvalid_out(udp_data_tvalid) ,			// output  udp_data_tvalid_out_sig
	.udp_data_tready_out(udp_data_tready) ,			// input  udp_data_tready_out_sig
	.udp_data_tuser_out(udp_data_tuser) ,				// output  udp_data_tuser_out_sig
	.udp_data_tlast_out(udp_data_tlast) ,				// output  udp_data_tlast_out_sig
	.busy(busy) 												// output  busy_sig
);


endmodule