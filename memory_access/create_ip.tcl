# Define target HDL
set target_hdl "Verilog"

# Define project name
set project_name "memory_access"

# Set project directory
set create_project_dir [file normalize [file join [file dirname [info script]]  "../"]]

# Create Vivado project
source $create_project_dir/create_project.tcl

update_compile_order -fileset sources_1
ipx::package_project -root_dir /home/henrik/lab/riscv/memory_access/ip -vendor xilinx.com -library user -taxonomy /UserIP -import_files -set_current false -version 1.57
ipx::unload_core /home/henrik/lab/riscv/memory_access/ip/component.xml
ipx::edit_ip_in_project -upgrade true -name tmp_edit_project -directory /home/henrik/lab/riscv/memory_access/ip /home/henrik/lab/riscv/memory_access/ip/component.xml
update_compile_order -fileset sources_1
set_property name memory_access [ipx::current_core]
set_property display_name memory_access_v1_0 [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
set_property description memory_access_v1_0 [ipx::current_core]
set_property previous_version_for_upgrade xilinx.com:user:top_wrapper:1.0 [ipx::current_core]
set_property core_revision 1 [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::check_integrity [ipx::current_core]
ipx::save_core [ipx::current_core]
ipx::move_temp_component_back -component [ipx::current_core]
close_project -delete
