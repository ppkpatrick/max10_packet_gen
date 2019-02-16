# =======================================================================================
# ALTERA Confidential and Proprietary
# Copyright 2010 (c) Altera Corporation
# All rights reserved
#
# Project     : Triple Speed Ethernet Hardware Test By Using System Console
# 
# Description : Triple Speed Ethernet MAC Configuration Setting Script
#
# Revision Control Information
#
# Author      : IP Apps
# Revision    : #1
# Date        : 2010/11/11
# ======================================================================================

proc mac_config {ETH_SPEED ENA_10 LOOP_ENA} {

# TSE MAC Configuration Setting
# =============================
set MAC_SCRATCH		0xabcd0123;
# COMMAND_CONFIG
set ENA_TX 				1;
set ENA_RX 				1;
set XON_GEN 			0;


set PROMIS_EN			1;
set PAD_EN 				1;
set CRC_FWD 			0;
set PAUSE_FWD 			0;
set PAUSE_IGNORE		0;
set TX_ADDR_INS 		0;
set HD_ENA 				0;
set EXCESS_COL			0;
set LATE_COL			0;
set SW_RESET 			0;
set MHASH_SEL			0;

set TX_ADDR_SEL 		0x0;
set MAGIC_ENA			0;
set SLEEP	 			0;
set WAKEUP 				0;
set XOFF_GEN 			0;
set CTRL_FRM_ENA 		0;
set NO_LGTH_CHECK		0;
set RX_ERR_DISC 		0;
set DISABLE_RD_TIMEOUT	0;
set CNT_RESET			0;

set MAC_0 				0x99999999;
set MAC_1 				0x00009999;
set FRM_LENGTH  		64;	#9600. Default = 1518;
set PAUSE_QUANT  		8192;
set RX_SECTION_EMPTY 	8172;
set RX_SECTION_FULL  	16;
set TX_SECTION_EMPTY 	8172;
set TX_SECTION_FULL  	16;
set RX_ALMOST_EMPTY 	8;
set RX_ALMOST_FULL  	8;
set TX_ALMOST_EMPTY  	8;
set TX_ALMOST_FULL 		3;
set MDIO_ADDR0  		0;
set MDIO_ADDR1  		0;

set TX_IPG_LENGTH 		12;

set TX_OMIT_CRC 		0;

set TX_SHIFT16 			0;
set RX_SHIFT16 			0;

# Define Variable
set jtag_master [lindex [get_service_paths master] 0];

# Register Address Offset
# MAC
set REV_ADDRESS 				0x000;
set MAC_SCRATCH_ADDRESS 		0x004;
set COMMAND_CONFIG_ADDRESS		0x008;
set MAC_0_ADDRESS 				0x00C;
set MAC_1_ADDRESS 				0x010;
set FRM_LENGTH_ADDRESS 			0x014;
set PAUSE_QUANT_ADDRESS 		0x018;
set RX_SECTION_EMPTY_ADDRESS	0x01C;
set RX_SECTION_FULL_ADDRESS 	0x020;
set TX_SECTION_EMPTY_ADDRESS 	0x024;
set TX_SECTION_FULL_ADDRESS 	0x028;
set RX_ALMOST_EMPTY_ADDRESS 	0x02C;
set RX_ALMOST_FULL_ADDRESS 		0x030;
set TX_ALMOST_EMPTY_ADDRESS 	0x034;
set TX_ALMOST_FULL_ADDRESS 		0x038;
set MDIO_ADDR0_ADDRESS 			0x03C;
set MDIO_ADDR1_ADDRESS 			0x040;
set REG_STATUS_ADDRESS 			0x040;
set TX_IPG_LENGTH_ADDRESS 		0x05C;

set TX_CMD_STAT_ADDRESS 0x0E8;
set RX_CMD_STAT_ADDRESS 0x0EC;

# Combine Configuration Value
# MAC
set COMMAND_CONFIG_VALUE [expr (0 \
| $ENA_TX 				<< 0 \
| $ENA_RX 				<< 1 \
| $XON_GEN 				<< 2 \
| $ETH_SPEED 			<< 3 \
| $PROMIS_EN			<< 4 \
| $PAD_EN 				<< 5 \
| $CRC_FWD 				<< 6 \
| $PAUSE_FWD 			<< 7 \
| $PAUSE_IGNORE			<< 8 \
| $TX_ADDR_INS 			<< 9 \
| $HD_ENA 				<< 10 \
| $EXCESS_COL 			<< 11 \
| $LATE_COL				<< 12 \
| $SW_RESET 			<< 13 \
| $MHASH_SEL			<< 14 \
| $LOOP_ENA				<< 15 \
| $TX_ADDR_SEL 			<< 18 \
| $MAGIC_ENA			<< 19 \
| $SLEEP	 			<< 20 \
| $WAKEUP 				<< 21 \
| $XOFF_GEN 			<< 22 \
| $CTRL_FRM_ENA 		<< 23 \
| $NO_LGTH_CHECK		<< 24 \
| $ENA_10 				<< 25 \
| $RX_ERR_DISC 			<< 26 \
| $DISABLE_RD_TIMEOUT	<< 27 \
| $CNT_RESET			<< 31 \
| 0)];

set TX_CMD_STAT_VALUE [expr (0 \
| $TX_OMIT_CRC << 17 \
| $TX_SHIFT16 << 18 \
| 0)];

set RX_CMD_STAT_VALUE [expr (0 \
| $RX_SHIFT16 << 25 \
| 0)];



# Starting Marvell PHY Configuration System Console
# =================================================
puts "=============================================================================="
puts "	Starting TSE MAC Configuration System Console                   			"
puts "=============================================================================="

# Open JTAG Master Service
# ========================
open_service master $jtag_master;
master_write_32 $jtag_master 0x400 0x00000000;

puts "Info: Opened JTAG Master Service";
puts "Info: Configure TSE MAC\n";

# Configuration Command
# MAC
puts "TSE MAC Rev \t \t = [master_read_32 $jtag_master $REV_ADDRESS 1]";

master_write_32 $jtag_master $MAC_SCRATCH_ADDRESS $MAC_SCRATCH;
puts "TSE MAC write Scratch \t = $MAC_SCRATCH";
puts "TSE MAC read Scratch \t = [master_read_32 $jtag_master $MAC_SCRATCH_ADDRESS 1]";

master_write_32 $jtag_master $COMMAND_CONFIG_ADDRESS [expr ($COMMAND_CONFIG_VALUE | (1 << 13))];
puts "Command Config \t \t = [master_read_32 $jtag_master $COMMAND_CONFIG_ADDRESS 1]";

master_write_32 $jtag_master $COMMAND_CONFIG_ADDRESS $COMMAND_CONFIG_VALUE;
puts "Command Config \t \t = [master_read_32 $jtag_master $COMMAND_CONFIG_ADDRESS 1]";

master_write_32 $jtag_master $MAC_0_ADDRESS $MAC_0;
puts "MAC Address 0 \t \t = [master_read_32 $jtag_master $MAC_0_ADDRESS 1]";

master_write_32 $jtag_master $MAC_1_ADDRESS $MAC_1;
puts "MAC Address 1 \t \t = [master_read_32 $jtag_master $MAC_1_ADDRESS 1]";

master_write_32 $jtag_master $FRM_LENGTH_ADDRESS $FRM_LENGTH;
puts "Frame Length \t \t = [master_read_32 $jtag_master $FRM_LENGTH_ADDRESS 1]";

master_write_32 $jtag_master $PAUSE_QUANT_ADDRESS $PAUSE_QUANT;
puts "Pause Quanta \t \t = [master_read_32 $jtag_master $PAUSE_QUANT_ADDRESS 1]";

master_write_32 $jtag_master $RX_SECTION_EMPTY_ADDRESS $RX_SECTION_EMPTY;
puts "RX Section Empty \t \t = [master_read_32 $jtag_master $RX_SECTION_EMPTY_ADDRESS 1]";

master_write_32 $jtag_master $RX_SECTION_FULL_ADDRESS $RX_SECTION_FULL;
puts "RX Section Full \t \t = [master_read_32 $jtag_master $RX_SECTION_FULL_ADDRESS 1]";

master_write_32 $jtag_master $TX_SECTION_EMPTY_ADDRESS $TX_SECTION_EMPTY;
puts "TX Section Empty \t \t = [master_read_32 $jtag_master $TX_SECTION_EMPTY_ADDRESS 1]";

master_write_32 $jtag_master $TX_SECTION_FULL_ADDRESS $TX_SECTION_FULL;
puts "TX Section Full \t \t = [master_read_32 $jtag_master $TX_SECTION_FULL_ADDRESS 1]";

master_write_32 $jtag_master $RX_ALMOST_EMPTY_ADDRESS $RX_ALMOST_EMPTY;
puts "RX Almost Empty \t \t = [master_read_32 $jtag_master $RX_ALMOST_EMPTY_ADDRESS 1]";

master_write_32 $jtag_master $RX_ALMOST_FULL_ADDRESS $RX_ALMOST_FULL;
puts "RX Almost Full \t \t = [master_read_32 $jtag_master $RX_ALMOST_FULL_ADDRESS 1]";

master_write_32 $jtag_master $TX_ALMOST_EMPTY_ADDRESS $TX_ALMOST_EMPTY;
puts "TX Almost Empty \t \t = [master_read_32 $jtag_master $TX_ALMOST_EMPTY_ADDRESS 1]";

master_write_32 $jtag_master $TX_ALMOST_FULL_ADDRESS $TX_ALMOST_FULL;
puts "TX Almost Full \t \t = [master_read_32 $jtag_master $TX_ALMOST_FULL_ADDRESS 1]";

master_write_32 $jtag_master $MDIO_ADDR0_ADDRESS $MDIO_ADDR0;
puts "MDIO Address 0 \t \t = [master_read_32 $jtag_master $MDIO_ADDR0_ADDRESS 1]";

master_write_32 $jtag_master $MDIO_ADDR1_ADDRESS $MDIO_ADDR1;
puts "MDIO Address 1 \t \t = [master_read_32 $jtag_master $MDIO_ADDR1_ADDRESS 1]";

puts "Regiter Status \t \t = [master_read_32 $jtag_master $REG_STATUS_ADDRESS 1]";

master_write_32 $jtag_master $TX_IPG_LENGTH_ADDRESS $TX_IPG_LENGTH;
puts "TX IPG Length \t \t = [master_read_32 $jtag_master $TX_IPG_LENGTH_ADDRESS 1]";

master_write_32 $jtag_master $TX_CMD_STAT_ADDRESS $TX_CMD_STAT_VALUE;
puts "TX Command Status \t \t = [master_read_32 $jtag_master $TX_CMD_STAT_ADDRESS 1]";

master_write_32 $jtag_master $RX_CMD_STAT_ADDRESS $RX_CMD_STAT_VALUE;
puts "RX Command Status \t \t = [master_read_32 $jtag_master $RX_CMD_STAT_ADDRESS 1]";

close_service master $jtag_master;
puts "\nInfo: Closed JTAG Master Service";
}