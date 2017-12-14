# Load RUCKUS library
source -quiet $::env(RUCKUS_DIR)/vivado_proc.tcl

# Load Source Code
loadSource -dir  "$::DIR_PATH/rtl"
loadSource -path "$::DIR_PATH/coregen/GigEthGth7Core.dcp"
