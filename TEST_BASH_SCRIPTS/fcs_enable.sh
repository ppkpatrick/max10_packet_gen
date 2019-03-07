#!/bin/bash

# Patrick Corley - Final Year Project
# FPGA-implemented Network Packet generator
# Supervisor: Richard Conway
# This script makes the Frame Check Sequence (FCS) of a packet visible to user
# apps such as Wireshark.

# Receive all frames, regardless of whether the FCS is valid or not
sudo ethtool -K enp2s0 rx-all on

# Enable the FCS of the packet
sudo ethtool -K enp2s0 rx-fcs on
