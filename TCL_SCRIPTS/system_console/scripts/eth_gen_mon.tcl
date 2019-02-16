# =======================================================================================
# ALTERA Confidential and Proprietary
# Copyright 2010 (c) Altera Corporation
# All rights reserved
#
# Project     : Triple Speed Ethernet Hardware Test By Using System Console
# 
# Description : Ethernet Generator/Monitor Configuration Setting Script
#
# Revision Control Information
#
# Author      : IP Apps
# Revision    : #1
# Date        : 2010/11/10
# ======================================================================================

# ===========================
proc gen_mon_config {eth_gen} {

# Ethernet Generator Configuration Setting
# =============================
set number_packet		100000;		# Number of packets

set length_sel 			1;				# Fixed = 0	& Random = 1	
set pkt_length 			1518;			# Ranges from 24 to 9600
set pattern_sel 		1;				# Incremental = 0 & Random = 1	
set rand_seed 			0x123456789ABC;	# random seed
set source_addr 		0xEE1122334450;	# MAC destination address
set destination_addr 	0xEE1122334450;	# MAC source address

set jtag_master [lindex [get_service_paths master] 0];

set register_read_value 	0x00000000;
set register_write_value 	0x00000000;

puts "=============================================================================="
puts "	Starting Ethernet Generator / Monitor System Console			"
puts "==============================================================================\n\n"

# Open JTAG Master Service
# =======================
open_service master $jtag_master;
puts "\nInfo: Opened JTAG Master Service\n\n";

# Turn ON Ethernet Generator
# =======================
if {$eth_gen == 0} {
	set register_write_value 0x00000000;
} else {
	set register_write_value 0x00000001;
};

set AddressOffset 0x400;
master_write_32 $jtag_master $AddressOffset $register_write_value;
set register_read_value [master_read_32 $jtag_master $AddressOffset 1];
if {$register_read_value == 0} {
	puts "ST Reverse Loopback";
} else {
	puts "Use Ethernet Generator";
};

# Configure Ethernet Generator
# =======================
for {set AddressOffset 0xc00} {$AddressOffset < 0xc20} {incr AddressOffset 0x4} {
	
	set AddressOffset_hex [format "%#x" $AddressOffset];
	
	switch -exact -- $AddressOffset_hex {
	0xc00 { 
		master_write_32 $jtag_master $AddressOffset $number_packet;
		set register_read_value [master_read_32 $jtag_master $AddressOffset 1];
		set register_read_value_unsigned [format "%#u" $register_read_value];
		puts "Number of packets \t = $register_read_value_unsigned"; 
	}
	0xc04 { 
		puts "Configuration setting:"; 
		if {$length_sel == 0} {
			set register_write_value 0x00000000;
			puts "- Length \t \t : Fixed"; 
		} else {
			set register_write_value 0x00000001;
			puts "- Length \t \t : Random"; 
		}
		puts "- Packets length \t : $pkt_length"; 
		set pkt_length [expr {$pkt_length << 1}];
		set register_write_value [expr {$register_write_value + $pkt_length}];
		if {$pattern_sel == 0} {
			set register_write_value [expr {$register_write_value | 0x0000}];
			puts "- Pattern \t \t : Incremental"; 
		} else {
			set register_write_value [expr {$register_write_value | 0x8000}];
			puts "- Pattern \t \t : Random"; 
		}
		master_write_32 $jtag_master $AddressOffset $register_write_value;
		#puts "Configuration setting = [master_read_32 $jtag_master $AddressOffset 1]"; 
	}
	0xc08 { 
		set rand_seed0 0x
		set rand_seed0 [append rand_seed0 [string range $rand_seed 6 14]]
		master_write_32 $jtag_master $AddressOffset $rand_seed0;
		puts "Random seed 0 \t \t = [master_read_32 $jtag_master $AddressOffset 1]"; 
	}
	0xc0c { 
		set rand_seed1 [string range $rand_seed 0 5]
		master_write_32 $jtag_master $AddressOffset $rand_seed1;
		puts "Random seed 1 \t \t = [master_read_32 $jtag_master $AddressOffset 1]"; 
	}
	0xc10 { 
		set source_addr0 0x
		set source_addr0 [append source_addr0 [string range $source_addr 6 14]]
		master_write_32 $jtag_master $AddressOffset $source_addr0;
		puts "Source address 0 \t \t = [master_read_32 $jtag_master $AddressOffset 1]"; 
	}
	0xc14 { 
		set source_addr1 [string range $source_addr 0 5]
		master_write_32 $jtag_master $AddressOffset $source_addr1;
		puts "Source address 1 \t \t = [master_read_32 $jtag_master $AddressOffset 1]"; 
	}
	0xc18 { 
		set destination_addr0 0x
		set destination_addr0 [append destination_addr0 [string range $destination_addr 6 14]]
		master_write_32 $jtag_master $AddressOffset $destination_addr0;
		puts "Destination address 0 \t = [master_read_32 $jtag_master $AddressOffset 1]"; 
	}
	0xc1c { 
		set destination_addr1 [string range $destination_addr 0 5]
		master_write_32 $jtag_master $AddressOffset $destination_addr1;
		puts "Destination address 1 \t = [master_read_32 $jtag_master $AddressOffset 1]"; 
	}
	default { }
	};

};

# Configure Ethernet Monitor
# =======================
set AddressOffset 0x800;
master_write_32 $jtag_master $AddressOffset $number_packet;

set AddressOffset 0x81c;
set receive_ctrl_status 0x00000001; # start Monitor
master_write_32 $jtag_master $AddressOffset $receive_ctrl_status;

# Start Ethernet Generator
# =======================
set AddressOffset 0xc20;
set operation 0x00000001; # start Generator
master_write_32 $jtag_master $AddressOffset $operation;
puts "Start Ethernet Generator";

#ksting # Check Ethernet Monitor Receive Status
#ksting # =======================
#ksting set AddressOffset 0x81c;
#ksting set receive_ctrl_status 0x00000000;
#ksting 
#ksting while {$receive_ctrl_status != 0x00000004} {
#ksting 	for {set COUNT_TEMP 0x0000} {$COUNT_TEMP < 0x0200} {incr COUNT_TEMP 0x0001} {	
#ksting 		set receive_ctrl_status [master_read_32 $jtag_master $AddressOffset 1];
#ksting 		set receive_ctrl_status [expr {$receive_ctrl_status & 0x00000004}];
#ksting 		if {$receive_ctrl_status == 0x00000004} {
#ksting 			break
#ksting 		} 
#ksting 		if {$COUNT_TEMP == 0x01ff} {
#ksting 			set register_read_value [master_read_32 $jtag_master 0x804 1];
#ksting 			set packets_received_OK [format "%#u" $register_read_value];
#ksting 			set register_read_value [master_read_32 $jtag_master 0x808 1];
#ksting 			set packets_received_error [format "%#u" $register_read_value];
#ksting 			puts "Running -> Number of packets received = [expr {$packets_received_OK + $packets_received_error}]"; 
#ksting 			set receive_ctrl_status [master_read_32 $jtag_master $AddressOffset 1];
#ksting 			set receive_ctrl_status [expr {$receive_ctrl_status & 0x00000004}];
#ksting 			break
#ksting 		} 		
#ksting 	}
#ksting }
#ksting 
#ksting puts "Monitor receive done";
#ksting 
#ksting for {set AddressOffset 0x804} {$AddressOffset < 0x820} {incr AddressOffset 0x4} {
#ksting 	
#ksting 	set AddressOffset_hex [format "%#x" $AddressOffset];
#ksting 	
#ksting 	switch -exact -- $AddressOffset_hex {
#ksting 	0x804 { 
#ksting 		set register_read_value [master_read_32 $jtag_master $AddressOffset 1];
#ksting 		set register_read_value_unsigned [format "%#u" $register_read_value];
#ksting 		puts "Number of packets received OK \t \t = $register_read_value_unsigned"; 
#ksting 	}
#ksting 	0x808 { 
#ksting 		set register_read_value [master_read_32 $jtag_master $AddressOffset 1];
#ksting 		set register_read_value_unsigned [format "%#u" $register_read_value];
#ksting 		puts "Number of packets received error \t = $register_read_value_unsigned"; 
#ksting 	}
#ksting 	0x81c { 
#ksting 		set register_read_value [master_read_32 $jtag_master $AddressOffset 1];
#ksting 		set receive_ctrl_status [expr {$register_read_value & 0x00000008}];
#ksting 		if {$receive_ctrl_status == 0x00000008} {
#ksting 			puts "Packets received with CRC errors"; 
#ksting 		}
#ksting 		set register_read_value [master_read_32 $jtag_master $AddressOffset 1];
#ksting 		set receive_ctrl_status [expr {$register_read_value & 0x00000010}];
#ksting 		if {$receive_ctrl_status == 0x00000010} {
#ksting 			puts "Packets received with frame errors"; 
#ksting 		}
#ksting 		set register_read_value [master_read_32 $jtag_master $AddressOffset 1];
#ksting 		set receive_ctrl_status [expr {$register_read_value & 0x00000020}];
#ksting 		if {$receive_ctrl_status == 0x00000020} {
#ksting 			puts "Packets received with invalid length errors"; 
#ksting 		}
#ksting 		set register_read_value [master_read_32 $jtag_master $AddressOffset 1];
#ksting 		set receive_ctrl_status [expr {$register_read_value & 0x00000040}];
#ksting 		if {$receive_ctrl_status == 0x00000040} {
#ksting 			puts "Packets received with CRC errors"; 
#ksting 		}
#ksting 		set register_read_value [master_read_32 $jtag_master $AddressOffset 1];
#ksting 		set receive_ctrl_status [expr {$register_read_value & 0x00000080}];
#ksting 		if {$receive_ctrl_status == 0x00000080} {
#ksting 			puts "Packets received with frame truncated"; 
#ksting 		}
#ksting 		set register_read_value [master_read_32 $jtag_master $AddressOffset 1];
#ksting 		set receive_ctrl_status [expr {$register_read_value & 0x00000100}];
#ksting 		if {$receive_ctrl_status == 0x00000100} {
#ksting 			puts "Corrupted frame received caused by a PHY error"; 
#ksting 		}
#ksting 		set register_read_value [master_read_32 $jtag_master $AddressOffset 1];
#ksting 		set receive_ctrl_status [expr {$register_read_value & 0x00000200}];
#ksting 		if {$receive_ctrl_status == 0x00000200} {
#ksting 			puts "Packets received with collision errors"; 
#ksting 		}
#ksting 	}
#ksting 	default { }
#ksting 	};
#ksting 
#ksting };

close_service master $jtag_master;
puts "\nInfo: Closed JTAG Master Service\n\n";
}