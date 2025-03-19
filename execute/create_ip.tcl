# Define target HDL
set target_hdl "VHDL"

# Define project name
set project_name "execute"

# Set project directory
set create_project_dir [file normalize [file join [file dirname [info script]]  "../"]]

# Create Vivado project
source $create_project_dir/create_project.tcl

update_compile_order -fileset sources_1
set_property source_mgmt_mode None [current_project]
set_property top top_wrapper [current_fileset]
ipx::package_project -root_dir /home/henrik/lab/riscv/execute/ip -vendor xilinx.com -library user -taxonomy /UserIP -import_files -set_current false -version 1.3
ipx::unload_core /home/henrik/lab/riscv/execute/ip/component.xml
ipx::edit_ip_in_project -upgrade true -name tmp_edit_project -directory /home/henrik/lab/riscv/execute/ip /home/henrik/lab/riscv/execute/ip/component.xml
set_property top top_wrapper [current_fileset]
update_compile_order -fileset sources_1
set_property name execute [ipx::current_core]
set_property display_name execute_v1_0 [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
set_property description execute_v1_0 [ipx::current_core]
set_property previous_version_for_upgrade xilinx.com:user:execute:1.0 [ipx::current_core]
set_property core_revision 1 [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::check_integrity [ipx::current_core]
ipx::save_core [ipx::current_core]
ipx::move_temp_component_back -component [ipx::current_core]
close_project -delete
