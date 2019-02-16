set_global_assignment -entity "fyp_clkctrl" -library "lib_fyp_clkctrl" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "fyp_clkctrl" -library "lib_fyp_clkctrl" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "fyp_clkctrl" -library "lib_fyp_clkctrl" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_fyp_clkctrl" -name SPD_FILE [file join $::quartus(sip_path) "../fyp_clkctrl.spd"]
set_global_assignment -library "lib_fyp_clkctrl" -name MISC_FILE [file join $::quartus(sip_path) "../../fyp_clkctrl.qsys"]

set_global_assignment -library "lib_fyp_clkctrl" -name MISC_FILE [file join $::quartus(sip_path) "fyp_clkctrl.v"]
set_global_assignment -library "lib_fyp_clkctrl" -name MISC_FILE [file join $::quartus(sip_path) "submodules/fyp_clkctrl_altclkctrl_0.v"]
