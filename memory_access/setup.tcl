# Define target HDL
set target_hdl "Verilog"

# Define project name
set project_name "memory_access"

# Set project directory
set create_project_dir [file normalize [file join [file dirname [info script]]  "../"]]

# Create Vivado project
source $create_project_dir/create_project.tcl

start_gui
