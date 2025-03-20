# Define target HDL
set target_hdl "VHDL"

# Define project name
set project_name "instruction_decode"

# Set project directory
set create_project_dir [file normalize [file join [file dirname [info script]]  "../"]]

# Create Vivado project
source $create_project_dir/create_project.tcl

update_compile_order -fileset sources_1
set_property source_mgmt_mode None [current_project]
set_property top top_wrapper [current_fileset]
ipx::package_project -root_dir /home/henrik/lab/riscv/instruction_decode/ip -vendor xilinx.com -library user -taxonomy /UserIP -import_files -set_current false -version 2.63
ipx::unload_core /home/henrik/lab/riscv/instruction_decode/ip/component.xml
ipx::edit_ip_in_project -upgrade true -name tmp_edit_project -directory /home/henrik/lab/riscv/instruction_decode/ip /home/henrik/lab/riscv/instruction_decode/ip/component.xml
set_property top top_wrapper [current_fileset]
update_compile_order -fileset sources_1
set_property name instruction_decode [ipx::current_core]
set_property display_name instruction_decode_v1_0 [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
set_property description instruction_decode_v1_0 [ipx::current_core]
set_property previous_version_for_upgrade xilinx.com:user:instruction_decode:1.0 [ipx::current_core]
set_property core_revision 1 [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::check_integrity [ipx::current_core]
ipx::save_core [ipx::current_core]
ipx::move_temp_component_back -component [ipx::current_core]
close_project -delete
