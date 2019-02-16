set_global_assignment -entity "fyp_gpio" -library "lib_fyp_gpio" -name IP_TOOL_NAME "altera_gpio_lite"
set_global_assignment -entity "fyp_gpio" -library "lib_fyp_gpio" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "fyp_gpio" -library "lib_fyp_gpio" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_fyp_gpio" -name SPD_FILE [file join $::quartus(sip_path) "fyp_gpio.spd"]

set_global_assignment -library "lib_fyp_gpio" -name MISC_FILE [file join $::quartus(sip_path) "fyp_gpio_sim/fyp_gpio.v"]
set_global_assignment -library "lib_fyp_gpio" -name MISC_FILE [file join $::quartus(sip_path) "fyp_gpio_sim/altera_gpio_lite/altera_gpio_lite.sv"]
