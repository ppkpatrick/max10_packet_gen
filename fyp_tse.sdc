#Create PLL reference clock
create_clock -name {clk_50_max10} -period "50 MHz" [get_ports {clk_50_max10}]
#Virtual clock for input constraints
create_clock -name virtual_clk_125 -period 8
#Define RX clocks from PHY
create_clock -period 8 -waveform { 2 6 } -name  {rx_clk_125} [get_ports eneta_rx_clk]
#PLL clocks for triple speed Ethernet
create_generated_clock -name clk_125 -source [get_pins {fyp_eth_pll1|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 5 -divide_by 2 -master_clock {clk_50_max10} [get_pins {fyp_eth_pll1|altpll_component|auto_generated|pll1|clk[0]}] 
##Shifted 125MHz clock for timing closure in MAX10 device
create_generated_clock -name clk_125_shift -source [get_pins {fyp_eth_pll1|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 5 -divide_by 2 -phase 11.25 -master_clock {clk_50_max10} [get_pins {fyp_eth_pll1|altpll_component|auto_generated|pll1|clk[1]}] 
#GTX clocks to PHY
create_generated_clock -name gtx_125_clk -source [get_pins {fyp_clkctrl1|altclkctrl_0|fyp_clkctrl_altclkctrl_0_sub_component|clkctrl1|outclk}] -master_clock {clk_125_shift} [get_ports {eneta_gtx_clk}]


derive_clock_uncertainty

# RGMII TX channel
# Output Delay Constraints (Edge Aligned, Same Edge Capture)
# +---------------------------------------------------

set output_max_delay -0.9
set output_min_delay -2.7

post_message -type info "Output Max Delay = $output_max_delay"
post_message -type info "Output Min Delay = $output_min_delay"

set_output_delay -clock gtx_125_clk -max $output_max_delay [get_ports "eneta_tx_d* eneta_tx_en"]
set_output_delay -clock gtx_125_clk -max $output_max_delay [get_ports "eneta_tx_d* eneta_tx_en"] -clock_fall -add_delay
set_output_delay -clock gtx_125_clk -min $output_min_delay [get_ports "eneta_tx_d* eneta_tx_en"] -add_delay
set_output_delay -clock gtx_125_clk -min $output_min_delay [get_ports "eneta_tx_d* eneta_tx_en"] -clock_fall -add_delay



# Set false paths to remove irrelevant setup and hold analysis
set_false_path -fall_from [get_clocks clk_125] -rise_to [get_clocks gtx_125_clk] -setup
set_false_path -rise_from [get_clocks clk_125] -fall_to [get_clocks gtx_125_clk] -setup
set_false_path -fall_from [get_clocks clk_125] -fall_to [get_clocks gtx_125_clk] -hold
set_false_path -rise_from [get_clocks clk_125] -rise_to [get_clocks gtx_125_clk] -hold



# RGMII RX channel
# Input Delay Constraints (Center aligned, Same Edge Analysis)
# 125MHz input constraints
set input_max_delay_125 0.8
set input_min_delay_125 -0.8

post_message -type info "Input Max Delay for 125MHz domain= $input_max_delay_125"
post_message -type info "Input Min Delay for 125MHz domain= $input_min_delay_125"

set_input_delay -max [expr $input_max_delay_125 ] -clock [get_clocks virtual_clk_125] [get_ports "eneta_rx_d* eneta_rx_dv"]
set_input_delay -max [expr $input_max_delay_125 ] -clock [get_clocks virtual_clk_125] [get_ports "eneta_rx_d* eneta_rx_dv"] -clock_fall -add_delay
set_input_delay -min [expr $input_min_delay_125 ] -clock [get_clocks virtual_clk_125] [get_ports "eneta_rx_d* eneta_rx_dv"] -add_delay
set_input_delay -min [expr $input_min_delay_125 ] -clock [get_clocks virtual_clk_125] [get_ports "eneta_rx_d* eneta_rx_dv"] -clock_fall -add_delay

# Set false paths to remove irrelevant setup and hold analysis
set_false_path -fall_from [get_clocks virtual_clk_125] -rise_to [get_clocks {rx_clk_125}] -setup
set_false_path -rise_from [get_clocks virtual_clk_125] -fall_to [get_clocks {rx_clk_125}] -setup
set_false_path -fall_from [get_clocks virtual_clk_125] -fall_to [get_clocks {rx_clk_125}] -hold
set_false_path -rise_from [get_clocks virtual_clk_125] -rise_to [get_clocks {rx_clk_125}] -hold


#Remove irrelevant clock domain crossing analysis
set_clock_groups -exclusive -group {clk_125 gtx_125_clk virtual_clk_125 rx_clk_125} 

set_false_path -to [get_registers *sld_signaltap*]
