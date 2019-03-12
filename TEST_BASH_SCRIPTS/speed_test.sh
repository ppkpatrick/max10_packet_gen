#!/bin/bash
 
	#FPGA-implemented Network Packet Generator
	#Student: Patrick Corley
	
	#Student ID: 15181383
	#Supervisor: Dr. Richard Conway
	
	#Current file: Speed Measurement Bash script
	
	#Description: This script is run on a Linux OS to determine the throughput of 
	#data on a specified Ethernet port.
	
INTERVAL="1"  # update interval in seconds
 
IF="enp2s0"
echo "Ethernet interface RX speed script"
while true 
do
        R1=`cat /sys/class/net/$IF/statistics/rx_bytes`
        sleep $INTERVAL
        R2=`cat /sys/class/net/$IF/statistics/rx_bytes`
	RBPS=$(($R2 - $R1))
	RMBPS=$(($RBPS / 1048576))
	RMBITPS=$(($RMBPS * 8))
	echo "Interface: \t$IF"
        echo "Megabit/sec: \tRX: $RMBITPS Mb/s"
	echo "Megabyte/sec: \tRX: $RMBPS MB/s"
	echo ""
done
