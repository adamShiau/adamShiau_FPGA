#
# Vivado (TM) v2017.2 (64-bit)
#
# uart_axi.tcl: Tcl script for re-creating project 'uart_test'
#
# Generated by Vivado on Thu Oct 29 15:39:22 +0800 2020
# IP Build 1909766 on Thu Jun 15 19:58:00 MDT 2017
#
# This file contains the Vivado Tcl commands for re-creating the project to the state*
# when this script was generated. In order to re-create the project, please source this
# file in the Vivado Tcl Shell.
#
# * Note that the runs in the created project will be configured the same way as the
#   original project, however they will not be launched automatically. To regenerate the
#   run results please launch the synthesis/implementation runs as needed.
#
#*****************************************************************************************
# NOTE: In order to use this script for source control purposes, please make sure that the
#       following files are added to the source control system:-
#
# 1. This project restoration tcl script (uart_axi.tcl) that was generated.
#
# 2. The following source(s) files that were local or imported into the original project.
#    (Please see the '$orig_proj_dir' and '$origin_dir' variable setting below at the start of the script)
#
#    "C:/Users/adam/Desktop/axi_uart/uart_test/uart_test.srcs/sources_1/bd/sys1/sys1.bd"
#    "C:/Users/adam/Documents/GitHub/adamShiau_FPGA/uart/uart_rx.v"
#    "C:/Users/adam/Documents/GitHub/adamShiau_FPGA/uart/uart_tx.v"
#    "C:/Users/adam/Documents/GitHub/adamShiau_FPGA/uart/vivado/uart_axi_top.v"
#    "C:/Users/adam/Documents/GitHub/adamShiau_FPGA/uart/vivado/uart_test.xdc"
#    "C:/Users/adam/Documents/GitHub/adamShiau_FPGA/uart/vivado/vla.xdc"
#    "C:/Users/adam/Documents/GitHub/adamShiau_FPGA/uart/vivado/uart_tb.v"
#
# 3. The following remote source files that were added to the original project:-
#
#    "C:/Users/adam/Desktop/axi_uart/uart_test/uart_test.srcs/sources_1/imports/hdl/sys1_wrapper.v"
#
#*****************************************************************************************

# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir "C:/Users/adam/Documents/GitHub/adamShiau_FPGA"

# Use origin directory path location variable, if specified in the tcl shell
if { [info exists ::origin_dir_loc] } {
  set origin_dir $::origin_dir_loc
}

variable script_file
set script_file "uart_axi.tcl"

# Help information for this script
proc help {} {
  variable script_file
  puts "\nDescription:"
  puts "Recreate a Vivado project from this script. The created project will be"
  puts "functionally equivalent to the original project for which this script was"
  puts "generated. The script contains commands for creating a project, filesets,"
  puts "runs, adding/importing sources and setting properties on various objects.\n"
  puts "Syntax:"
  puts "$script_file"
  puts "$script_file -tclargs \[--origin_dir <path>\]"
  puts "$script_file -tclargs \[--help\]\n"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--origin_dir <path>\]  Determine source file paths wrt this path. Default"
  puts "                       origin_dir path value is \".\", otherwise, the value"
  puts "                       that was set with the \"-paths_relative_to\" switch"
  puts "                       when this script was generated.\n"
  puts "\[--help\]               Print help information for this script"
  puts "-------------------------------------------------------------------------\n"
  exit 0
}

if { $::argc > 0 } {
  for {set i 0} {$i < [llength $::argc]} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--origin_dir" { incr i; set origin_dir [lindex $::argv $i] }
      "--help"       { help }
      default {
        if { [regexp {^-} $option] } {
          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
          return 1
        }
      }
    }
  }
}

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/../../../../../Desktop/axi_uart/uart_test"]"

# Create project
create_project uart_test ./uart_test -part xc7z010clg400-1

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Reconstruct message rules
# None

# Set project properties
set obj [get_projects uart_test]
set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
set_property -name "ip_cache_permissions" -value "read write" -objects $obj
set_property -name "ip_output_repo" -value "C:/Users/adam/Documents/GitHub/adamShiau_FPGA/xilinx_IP/ip" -objects $obj
set_property -name "part" -value "xc7z010clg400-1" -objects $obj
set_property -name "sim.ip.auto_export_scripts" -value "1" -objects $obj
set_property -name "simulator_language" -value "Mixed" -objects $obj
set_property -name "xpm_libraries" -value "XPM_CDC XPM_MEMORY" -objects $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set IP repository paths
set obj [get_filesets sources_1]
set_property "ip_repo_paths" "[file normalize "$origin_dir/xilinx_IP"]" $obj

# Rebuild user ip_repo's index before adding any source files
update_ip_catalog -rebuild

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
# set files [list \
 # "[file normalize "$origin_dir/../../../../../Desktop/axi_uart/uart_test/uart_test.srcs/sources_1/bd/sys1/sys1.bd"]"\
 # "[file normalize "$origin_dir/../uart_rx.v"]"\
 # "[file normalize "$origin_dir/../uart_tx.v"]"\
 # "[file normalize "$origin_dir/uart_axi_top.v"]"\
 # "[file normalize "$origin_dir/../../../../../Desktop/axi_uart/uart_test/uart_test.srcs/sources_1/imports/hdl/sys1_wrapper.v"]"\
# ]

set files [list \
 "[file normalize "$origin_dir/uart/uart_rx.v"]"\
 "[file normalize "$origin_dir/uart/uart_tx.v"]"\
 "[file normalize "$origin_dir/uart/vivado/uart_axi_top.v"]"\
]
add_files -norecurse -fileset $obj $files

# Create block design
 source $origin_dir/uart/vivado/sys1.tcl

 # Generate the wrapper
 set design_name [get_bd_designs]
 make_wrapper -files [get_files $design_name.bd] -top -import

# Set 'sources_1' fileset file properties for remote files
# None

# Set 'sources_1' fileset file properties for local files
# None

# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property -name "top" -value "uart_test_top" -objects $obj

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/uart/vivado/uart_test.xdc"]"
set file_added [add_files -norecurse -fileset $obj $file]
set file "vivado/uart_test.xdc"
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property -name "file_type" -value "XDC" -objects $file_obj

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/uart/vivado/vla.xdc"]"
set file_added [add_files -norecurse -fileset $obj $file]
set file "vivado/vla.xdc"
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property -name "file_type" -value "XDC" -objects $file_obj
set_property -name "used_in" -value "implementation" -objects $file_obj
set_property -name "used_in_synthesis" -value "0" -objects $file_obj

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]
set_property -name "target_constrs_file" -value "[file normalize "$origin_dir/uart/vivado/vla.xdc"]" -objects $obj

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}

# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
set files [list \
 "[file normalize "$origin_dir/uart/vivado/uart_tb.v"]"\
]
add_files -norecurse -fileset $obj $files

# Set 'sim_1' fileset file properties for remote files
# None

# Set 'sim_1' fileset file properties for local files
# None

# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property -name "top" -value "uart_tb" -objects $obj

# Create 'synth_1' run (if not found)
if {[string equal [get_runs -quiet synth_1] ""]} {
  create_run -name synth_1 -part xc7z010clg400-1 -flow {Vivado Synthesis 2017} -strategy "Vivado Synthesis Defaults" -constrset constrs_1
} else {
  set_property strategy "Vivado Synthesis Defaults" [get_runs synth_1]
  set_property flow "Vivado Synthesis 2017" [get_runs synth_1]
}
set obj [get_runs synth_1]
set_property -name "part" -value "xc7z010clg400-1" -objects $obj

# set the current synth run
current_run -synthesis [get_runs synth_1]

# Create 'impl_1' run (if not found)
if {[string equal [get_runs -quiet impl_1] ""]} {
  create_run -name impl_1 -part xc7z010clg400-1 -flow {Vivado Implementation 2017} -strategy "Vivado Implementation Defaults" -constrset constrs_1 -parent_run synth_1
} else {
  set_property strategy "Vivado Implementation Defaults" [get_runs impl_1]
  set_property flow "Vivado Implementation 2017" [get_runs impl_1]
}
set obj [get_runs impl_1]
set_property -name "part" -value "xc7z010clg400-1" -objects $obj
set_property -name "steps.write_bitstream.args.readback_file" -value "0" -objects $obj
set_property -name "steps.write_bitstream.args.verbose" -value "0" -objects $obj

# set the current impl run
current_run -implementation [get_runs impl_1]

puts "INFO: Project created:uart_test"