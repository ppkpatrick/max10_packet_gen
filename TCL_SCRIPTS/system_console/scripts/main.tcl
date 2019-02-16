##==============================================================================
##		Main Reference Design Test
##==============================================================================  

source tse_mac_config.tcl
source tse_marvel_phy.tcl	
source eth_gen_mon.tcl
source tse_stat_read.tcl

proc TEST_MAC_LB {speed_test} {
	if  {$speed_test == "10M"} {

set ETH_SPEED 			0; # 10/100Mbps = 0 & 1000Mbps = 1
set ENA_10 				1; # 100Mbps = 0 & 10Mbps = 1
set LOOP_ENA			1;	#0;
set PHY_ETH_SPEED 		10;	# 10Mbps or 100Mbps or 1000Mbps
set PHY_ENABLE_AN 		0;		# Enable PHY Auto-Negotiation
set PHY_LOOPBACK		0;	# Enable PHY Loopback
set eth_gen 			1;				# Off = 0 & On = 1
mac_config $ETH_SPEED $ENA_10 $LOOP_ENA
marvel_phy_config $PHY_ETH_SPEED $PHY_ENABLE_AN $PHY_LOOPBACK
gen_mon_config $eth_gen
	} elseif {$speed_test == "100M"} {
set ETH_SPEED 			0; # 10/100Mbps = 0 & 1000Mbps = 1
set ENA_10 				0; # 100Mbps = 0 & 10Mbps = 1	
set LOOP_ENA			1;	#0;
set PHY_ETH_SPEED 		100;	# 10Mbps or 100Mbps or 1000Mbps
set PHY_ENABLE_AN 		0;		# Enable PHY Auto-Negotiation
set PHY_LOOPBACK		0;	# Enable PHY Loopback
set eth_gen 			1;				# Off = 0 & On = 1
mac_config $ETH_SPEED $ENA_10 $LOOP_ENA
marvel_phy_config $PHY_ETH_SPEED $PHY_ENABLE_AN $PHY_LOOPBACK
gen_mon_config $eth_gen
	} elseif {$speed_test == "1000M"} {
set ETH_SPEED 			1; # 10/100Mbps = 0 & 1000Mbps = 1
set ENA_10 				0; # 100Mbps = 0 & 10Mbps = 1	
set LOOP_ENA			1;	#0;
set PHY_ETH_SPEED 		1000;	# 10Mbps or 100Mbps or 1000Mbps
set PHY_ENABLE_AN 		0;		# Enable PHY Auto-Negotiation
set PHY_LOOPBACK		0;	# Enable PHY Loopback
set eth_gen 			1;				# Off = 0 & On = 1
mac_config $ETH_SPEED $ENA_10 $LOOP_ENA
marvel_phy_config $PHY_ETH_SPEED $PHY_ENABLE_AN $PHY_LOOPBACK
gen_mon_config $eth_gen
	} else {
	puts "\t      Wrong speed, enter 10M/100M/1000M "
	exit
	} 
}	

proc TEST_MAC_PHY_LB {speed_test} {
	if  {$speed_test == "10M"} {

set ETH_SPEED 			0; # 10/100Mbps = 0 & 1000Mbps = 1
set ENA_10 				1; # 100Mbps = 0 & 10Mbps = 1
set LOOP_ENA			0;	#0;
set PHY_ETH_SPEED 		10;	# 10Mbps or 100Mbps or 1000Mbps
set PHY_ENABLE_AN 		0;		# Enable PHY Auto-Negotiation
set PHY_LOOPBACK		1;	# Enable PHY Loopback
set eth_gen 			1;				# Off = 0 & On = 1
mac_config $ETH_SPEED $ENA_10 $LOOP_ENA
marvel_phy_config $PHY_ETH_SPEED $PHY_ENABLE_AN $PHY_LOOPBACK
gen_mon_config $eth_gen
	} elseif {$speed_test == "100M"} {
set ETH_SPEED 			0; # 10/100Mbps = 0 & 1000Mbps = 1
set ENA_10 				0; # 100Mbps = 0 & 10Mbps = 1	
set LOOP_ENA			0;	#0;
set PHY_ETH_SPEED 		100;	# 10Mbps or 100Mbps or 1000Mbps
set PHY_ENABLE_AN 		0;		# Enable PHY Auto-Negotiation
set PHY_LOOPBACK		1;	# Enable PHY Loopback
set eth_gen 			1;				# Off = 0 & On = 1
mac_config $ETH_SPEED $ENA_10 $LOOP_ENA
marvel_phy_config $PHY_ETH_SPEED $PHY_ENABLE_AN $PHY_LOOPBACK
gen_mon_config $eth_gen
	} elseif {$speed_test == "1000M"} {
set ETH_SPEED 			1; # 10/100Mbps = 0 & 1000Mbps = 1
set ENA_10 				0; # 100Mbps = 0 & 10Mbps = 1	
set LOOP_ENA			0;	#0;
set PHY_ETH_SPEED 		1000;	# 10Mbps or 100Mbps or 1000Mbps
set PHY_ENABLE_AN 		0;		# Enable PHY Auto-Negotiation
set PHY_LOOPBACK		1;	# Enable PHY Loopback
set eth_gen 			1;				# Off = 0 & On = 1
mac_config $ETH_SPEED $ENA_10 $LOOP_ENA
marvel_phy_config $PHY_ETH_SPEED $PHY_ENABLE_AN $PHY_LOOPBACK
gen_mon_config $eth_gen
	} else {
	puts "\t      Wrong speed, enter 10M/100M/1000M "
	exit
	} 
}	

proc TEST_ST_LB {speed_test} {
	if  {$speed_test == "10M"} {
set ETH_SPEED 			0; # 10/100Mbps = 0 & 1000Mbps = 1
set ENA_10 				1; # 100Mbps = 0 & 10Mbps = 1
set LOOP_ENA			0;	#0;
set PHY_ETH_SPEED 		10;	# 10Mbps or 100Mbps or 1000Mbps
set PHY_ENABLE_AN 		1;		# Enable PHY Auto-Negotiation
set PHY_LOOPBACK		0;	# Enable PHY Loopback
set eth_gen 			0;				# Off = 0 & On = 1
mac_config $ETH_SPEED $ENA_10 $LOOP_ENA
marvel_phy_config $PHY_ETH_SPEED $PHY_ENABLE_AN $PHY_LOOPBACK
gen_mon_config $eth_gen
stats_chk
	} elseif {$speed_test == "100M"} {
set ETH_SPEED 			0; # 10/100Mbps = 0 & 1000Mbps = 1
set ENA_10 				0; # 100Mbps = 0 & 10Mbps = 1	
set LOOP_ENA			0;	#0;
set PHY_ETH_SPEED 		100;	# 10Mbps or 100Mbps or 1000Mbps
set PHY_ENABLE_AN 		1;		# Enable PHY Auto-Negotiation
set PHY_LOOPBACK		0;	# Enable PHY Loopback
set eth_gen 			0;				# Off = 0 & On = 1
mac_config $ETH_SPEED $ENA_10 $LOOP_ENA
marvel_phy_config $PHY_ETH_SPEED $PHY_ENABLE_AN $PHY_LOOPBACK
gen_mon_config $eth_gen
stats_chk
	} elseif {$speed_test == "1000M"} {
set ETH_SPEED 			1; # 10/100Mbps = 0 & 1000Mbps = 1
set ENA_10 				0; # 100Mbps = 0 & 10Mbps = 1	
set LOOP_ENA			0;	#0;
set PHY_ETH_SPEED 		1000;	# 10Mbps or 100Mbps or 1000Mbps
set PHY_ENABLE_AN 		1;		# Enable PHY Auto-Negotiation
set PHY_LOOPBACK		0;	# Enable PHY Loopback
set eth_gen 			0;				# Off = 0 & On = 1
mac_config $ETH_SPEED $ENA_10 $LOOP_ENA
marvel_phy_config $PHY_ETH_SPEED $PHY_ENABLE_AN $PHY_LOOPBACK
gen_mon_config $eth_gen
stats_chk
	} else {
	puts "\t      Wrong speed, enter 10M/100M/1000M "
	exit
	} 
}	