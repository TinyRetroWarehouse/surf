# Load RUCKUS environment and library
source -quiet $::env(RUCKUS_DIR)/vivado_proc.tcl

# Load the source code
loadSource -lib surf -dir "$::DIR_PATH/core"

# Get the family type
set family [getFpgaFamily]

if { ${family} eq {kintexu} ||
     ${family} eq {kintexuplus} ||
     ${family} eq {virtexuplus} ||
     ${family} eq {virtexuplusHBM} ||
     ${family} eq {zynquplus} ||
     ${family} eq {zynquplusRFSOC} ||
     ${family} eq {qzynquplusRFSOC} } {
   loadSource -lib surf -dir  "$::DIR_PATH/lvdsUltraScale"
}
