# Set Vivado's default project directory
set vivado_project_name "lab_riscv_${project_name}"
set vivado_project_dir [file normalize [file join "." "vivado" $vivado_project_name]]

set project_directory_base [file normalize "."]
set project_dir [file normalize [file join $project_directory_base $project_name]]

# Set the target device for your project
set device_part "xc7z007sclg400-1"

# Define absolute paths for sources and constraints using the directory of the Tcl file
# Normalize the path to make sure it is correct
set sources_dir [file normalize [file join $create_project_dir $project_name "src"]]
set sim_dir [file normalize [file join $create_project_dir $project_name "sim"]]
set constrs_dir [file normalize [file join $create_project_dir $project_name "constrs"]]

################################################################################

exec mkdir -p $project_directory_base

# Create the project in the default directory
create_project $vivado_project_name $vivado_project_dir -part $device_part

#set_property board_part avnet.com:zedboard:part0:1.4 [current_project] ;# ZedBoard Zynq Evaluation Kit
#set_property board_part digilentinc.com:zybo-z7-20:part0:1.2 [current_project] ;# Zybo Z7-20

# Set the target language to VHDL or Verilog
set_property target_language Verilog [current_project]

################################################################################

# Add design sources
if {[file exists $sources_dir]} {
    add_files -scan_for_includes $sources_dir
}

# Add simulation sources
if {[file exists $sim_dir]} {
    add_files -scan_for_includes -fileset sim_1 $sim_dir
}

# Add constraints
if {[file exists $constrs_dir]} {
    add_files -scan_for_includes -fileset constrs_1 $contrs_dir
}
