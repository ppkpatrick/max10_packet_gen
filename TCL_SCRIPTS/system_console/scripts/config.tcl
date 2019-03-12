	#FPGA-implemented Network Packet Generator
	#Student: Patrick Corley
	
	#Student ID: 15181383
	#Supervisor: Dr. Richard Conway
	
	#Current file: MAC and PHY config TCL script
	
	#Description: 
	#This script is used to configure the Intel Triple Speed Ethernet MAC and Marvel 88E1111 PHY.
	#It sources and executes two scripts created by Intel which are provided as part of the 
	#Intel MAX 10 FPGA Ethernet Reference Design

if {[file isdirectory "C:/Users/Patrick Corley/system_console/scripts"]} {
	set dir "C:/Users/Patrick Corley/system_console/scripts"
	puts "Scripts found in C:/Users/Patrick Corley/system_console/scripts"
} elseif {[file isdirectory "C:/Users/Patrick/system_console/scripts"]} {
	set dir "C:/Users/Patrick/system_console/scripts"
	puts "Scripts found in C:/Users/Patrick Corley/system_console/scripts"
}
puts "Initializing MAC and PHY hardware..."
source $dir/tse_mac_config.tcl
source $dir/tse_marvel_phy.tcl
mac_config 1 0 0
after 3000
marvel_phy_config 1000 1 0