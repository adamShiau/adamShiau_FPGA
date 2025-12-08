## Copyright (C) 2018  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"

## DATE    "Mon Jan 13 19:01:29 2025"

##
## DEVICE  "EP4CE30F23I7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {altera_reserved_tck} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]
create_clock -name {CLOCK_100M} -period 10.000 -waveform { 0.000 5.000 } [get_ports {CLOCK_100M}]




#**************************************************************
# Create Generated Clock
#**************************************************************
# 手動建立 PLL 輸出的 clock 約束
# create_generated_clock -name CLOCK_ADC \
#   -source [get_ports CLOCK_100M] \
#   -phase -45.0 \
#   [get_pins PLL0_inst|altpll_component|auto_generated|pll1|clk[0]]

  create_generated_clock -name CLOCK_ADC \
  -source [get_ports CLOCK_100M] \
  [get_pins PLL0_inst|altpll_component|auto_generated|pll1|clk[0]]

create_generated_clock -name CLOCK_DAC \
  -source [get_ports CLOCK_100M] \
  [get_pins PLL0_inst|altpll_component|auto_generated|pll1|clk[1]]

create_generated_clock -name CLOCK_SDRAM \
  -source [get_ports CLOCK_100M] \
  -phase -45.0 \
  [get_pins PLL0_inst|altpll_component|auto_generated|pll1|clk[2]]

# create_generated_clock -name CLOCK_SDRAM \
#   -source [get_ports CLOCK_100M] \
#   [get_pins PLL0_inst|altpll_component|auto_generated|pll1|clk[2]]
  

create_generated_clock -name CPU_CLK \
  -source [get_ports CLOCK_100M] \
  [get_pins PLL0_inst|altpll_component|auto_generated|pll1|clk[3]]


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty


#**************************************************************
# Set Input Delay
#************************************************************** 
# set_input_delay -clock { CLOCK_ADC_1 } -min -add_delay 0 [get_ports {ADC_3[0] ADC_3[1] ADC_3[2] ADC_3[3] ADC_3[4] ADC_3[5] ADC_3[6] ADC_3[7] ADC_3[8] ADC_3[9] ADC_3[10] ADC_3[11] ADC_3[12] ADC_3[13]}]
# set_input_delay -clock { CLOCK_ADC_1 } -max -add_delay 5.0 [get_ports {ADC_3[0] ADC_3[1] ADC_3[2] ADC_3[3] ADC_3[4] ADC_3[5] ADC_3[6] ADC_3[7] ADC_3[8] ADC_3[9] ADC_3[10] ADC_3[11] ADC_3[12] ADC_3[13]}]

# set_input_delay -clock { CLOCK_ADC_1 } -min -add_delay 0.003 [get_ports {ADC_3[0] ADC_3[1] ADC_3[2] ADC_3[3] ADC_3[4] ADC_3[5] ADC_3[6] ADC_3[7] ADC_3[8] ADC_3[9] ADC_3[10] ADC_3[11] ADC_3[12] ADC_3[13]}]
# set_input_delay -clock { CLOCK_ADC_1 } -max -add_delay 0.105 [get_ports {ADC_3[0] ADC_3[1] ADC_3[2] ADC_3[3] ADC_3[4] ADC_3[5] ADC_3[6] ADC_3[7] ADC_3[8] ADC_3[9] ADC_3[10] ADC_3[11] ADC_3[12] ADC_3[13]}]

#**************************************************************
# Set Output Delay
#**************************************************************
# For output delay max_setup slack: the more positive the delay value, the stricter the constraint. 
# For output delay min_hold slack: the more negative the delay value, the stricter the constraint. 
# set_output_delay -clock { CLOCK_DAC_1 } -max -add_delay -1.07 [get_ports {DAC_3[0] DAC_3[1] DAC_3[2] DAC_3[3] DAC_3[4] DAC_3[5] DAC_3[6] DAC_3[7] DAC_3[8] DAC_3[9] DAC_3[10] DAC_3[11] DAC_3[12] DAC_3[13] DAC_3[14] DAC_3[15]}]
# set_output_delay -clock { CLOCK_DAC_1 } -min -add_delay -2.83 [get_ports {DAC_3[0] DAC_3[1] DAC_3[2] DAC_3[3] DAC_3[4] DAC_3[5] DAC_3[6] DAC_3[7] DAC_3[8] DAC_3[9] DAC_3[10] DAC_3[11] DAC_3[12] DAC_3[13] DAC_3[14] DAC_3[15]}]


#**************************************************************
# Set Clock Groups
#**************************************************************

# set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 


#**************************************************************
# Set False Path
#**************************************************************

# set_false_path -from [get_registers {*|alt_jtag_atlantic:*|jupdate}] -to [get_registers {*|alt_jtag_atlantic:*|jupdate1*}]
# set_false_path -from [get_registers {*|alt_jtag_atlantic:*|rdata[*]}] -to [get_registers {*|alt_jtag_atlantic*|td_shift[*]}]
# set_false_path -from [get_registers {*|alt_jtag_atlantic:*|read}] -to [get_registers {*|alt_jtag_atlantic:*|read1*}]
# set_false_path -from [get_registers {*|alt_jtag_atlantic:*|read_req}] 
# set_false_path -from [get_registers {*|alt_jtag_atlantic:*|rvalid}] -to [get_registers {*|alt_jtag_atlantic*|td_shift[*]}]
# set_false_path -from [get_registers {*|t_dav}] -to [get_registers {*|alt_jtag_atlantic:*|tck_t_dav}]
# set_false_path -from [get_registers {*|alt_jtag_atlantic:*|user_saw_rvalid}] -to [get_registers {*|alt_jtag_atlantic:*|rvalid0*}]
# set_false_path -from [get_registers {*|alt_jtag_atlantic:*|wdata[*]}] -to [get_registers *]
# set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write}] -to [get_registers {*|alt_jtag_atlantic:*|write1*}]
# set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write_stalled}] -to [get_registers {*|alt_jtag_atlantic:*|t_ena*}]
# set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write_stalled}] -to [get_registers {*|alt_jtag_atlantic:*|t_pause*}]
# set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write_valid}] 
# set_false_path -to [get_keepers {*altera_std_synchronizer:*|din_s1}]
# set_false_path -from [get_keepers {*CPU_nios2_cpu:*|CPU_nios2_cpu_nios2_oci:the_CPU_nios2_cpu_nios2_oci|CPU_nios2_cpu_nios2_oci_break:the_CPU_nios2_cpu_nios2_oci_break|break_readreg*}] -to [get_keepers {*CPU_nios2_cpu:*|CPU_nios2_cpu_nios2_oci:the_CPU_nios2_cpu_nios2_oci|CPU_nios2_cpu_debug_slave_wrapper:the_CPU_nios2_cpu_debug_slave_wrapper|CPU_nios2_cpu_debug_slave_tck:the_CPU_nios2_cpu_debug_slave_tck|*sr*}]
# set_false_path -from [get_keepers {*CPU_nios2_cpu:*|CPU_nios2_cpu_nios2_oci:the_CPU_nios2_cpu_nios2_oci|CPU_nios2_cpu_nios2_oci_debug:the_CPU_nios2_cpu_nios2_oci_debug|*resetlatch}] -to [get_keepers {*CPU_nios2_cpu:*|CPU_nios2_cpu_nios2_oci:the_CPU_nios2_cpu_nios2_oci|CPU_nios2_cpu_debug_slave_wrapper:the_CPU_nios2_cpu_debug_slave_wrapper|CPU_nios2_cpu_debug_slave_tck:the_CPU_nios2_cpu_debug_slave_tck|*sr[33]}]
# set_false_path -from [get_keepers {*CPU_nios2_cpu:*|CPU_nios2_cpu_nios2_oci:the_CPU_nios2_cpu_nios2_oci|CPU_nios2_cpu_nios2_oci_debug:the_CPU_nios2_cpu_nios2_oci_debug|monitor_ready}] -to [get_keepers {*CPU_nios2_cpu:*|CPU_nios2_cpu_nios2_oci:the_CPU_nios2_cpu_nios2_oci|CPU_nios2_cpu_debug_slave_wrapper:the_CPU_nios2_cpu_debug_slave_wrapper|CPU_nios2_cpu_debug_slave_tck:the_CPU_nios2_cpu_debug_slave_tck|*sr[0]}]
# set_false_path -from [get_keepers {*CPU_nios2_cpu:*|CPU_nios2_cpu_nios2_oci:the_CPU_nios2_cpu_nios2_oci|CPU_nios2_cpu_nios2_oci_debug:the_CPU_nios2_cpu_nios2_oci_debug|monitor_error}] -to [get_keepers {*CPU_nios2_cpu:*|CPU_nios2_cpu_nios2_oci:the_CPU_nios2_cpu_nios2_oci|CPU_nios2_cpu_debug_slave_wrapper:the_CPU_nios2_cpu_debug_slave_wrapper|CPU_nios2_cpu_debug_slave_tck:the_CPU_nios2_cpu_debug_slave_tck|*sr[34]}]
# set_false_path -from [get_keepers {*CPU_nios2_cpu:*|CPU_nios2_cpu_nios2_oci:the_CPU_nios2_cpu_nios2_oci|CPU_nios2_cpu_nios2_ocimem:the_CPU_nios2_cpu_nios2_ocimem|*MonDReg*}] -to [get_keepers {*CPU_nios2_cpu:*|CPU_nios2_cpu_nios2_oci:the_CPU_nios2_cpu_nios2_oci|CPU_nios2_cpu_debug_slave_wrapper:the_CPU_nios2_cpu_debug_slave_wrapper|CPU_nios2_cpu_debug_slave_tck:the_CPU_nios2_cpu_debug_slave_tck|*sr*}]
# set_false_path -from [get_keepers {*CPU_nios2_cpu:*|CPU_nios2_cpu_nios2_oci:the_CPU_nios2_cpu_nios2_oci|CPU_nios2_cpu_debug_slave_wrapper:the_CPU_nios2_cpu_debug_slave_wrapper|CPU_nios2_cpu_debug_slave_tck:the_CPU_nios2_cpu_debug_slave_tck|*sr*}] -to [get_keepers {*CPU_nios2_cpu:*|CPU_nios2_cpu_nios2_oci:the_CPU_nios2_cpu_nios2_oci|CPU_nios2_cpu_debug_slave_wrapper:the_CPU_nios2_cpu_debug_slave_wrapper|CPU_nios2_cpu_debug_slave_sysclk:the_CPU_nios2_cpu_debug_slave_sysclk|*jdo*}]
# set_false_path -from [get_keepers {sld_hub:*|irf_reg*}] -to [get_keepers {*CPU_nios2_cpu:*|CPU_nios2_cpu_nios2_oci:the_CPU_nios2_cpu_nios2_oci|CPU_nios2_cpu_debug_slave_wrapper:the_CPU_nios2_cpu_debug_slave_wrapper|CPU_nios2_cpu_debug_slave_sysclk:the_CPU_nios2_cpu_debug_slave_sysclk|ir*}]
# set_false_path -from [get_keepers {sld_hub:*|sld_shadow_jsm:shadow_jsm|state[1]}] -to [get_keepers {*CPU_nios2_cpu:*|CPU_nios2_cpu_nios2_oci:the_CPU_nios2_cpu_nios2_oci|CPU_nios2_cpu_nios2_oci_debug:the_CPU_nios2_cpu_nios2_oci_debug|monitor_go}]
# set_false_path -to [get_pins -nocase -compatibility_mode {*|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain*|clrn}]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

