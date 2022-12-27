set_global_assignment -entity "Clock_100MHz" -library "lib_Clock_100MHz" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "Clock_100MHz" -library "lib_Clock_100MHz" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "Clock_100MHz" -library "lib_Clock_100MHz" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_Clock_100MHz" -name SPD_FILE [file join $::quartus(sip_path) "Clock_100MHz.spd"]

set_global_assignment -library "lib_Clock_100MHz" -name MISC_FILE [file join $::quartus(sip_path) "Clock_100MHz_sim/Clock_100MHz.vho"]
