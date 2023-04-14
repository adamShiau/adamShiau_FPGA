## Generated SDC file "sparrow_v2.sdc"

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
## VERSION "Version 18.1.0 Build 625 09/12/2018 SJ Standard Edition"

## DATE    "Sat Apr 08 00:10:57 2023"

##
## DEVICE  "EP4CE15F17C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {altera_reserved_tck} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]
create_clock -name {clk_50M} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK_50}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -source {pll_inst|altpll_component|auto_generated|pll1|inclk[0]} -divide_by 50 -multiply_by 107 -duty_cycle 50.00 -name {pll_inst|altpll_component|auto_generated|pll1|clk[0]} {pll_inst|altpll_component|auto_generated|pll1|clk[0]}
create_generated_clock -source {pll_inst|altpll_component|auto_generated|pll1|inclk[0]} -divide_by 50 -multiply_by 107 -phase -90.00 -duty_cycle 50.00 -name {pll_inst|altpll_component|auto_generated|pll1|clk[1]} {pll_inst|altpll_component|auto_generated|pll1|clk[1]}
create_generated_clock -source {pll_inst|altpll_component|auto_generated|pll1|inclk[0]} -divide_by 50 -multiply_by 107 -duty_cycle 50.00 -name {pll_inst|altpll_component|auto_generated|pll1|clk[2]} {pll_inst|altpll_component|auto_generated|pll1|clk[2]}
create_generated_clock -source {pll_inst|altpll_component|auto_generated|pll1|inclk[0]} -divide_by 50 -multiply_by 107 -phase -90.00 -duty_cycle 50.00 -name {pll_inst|altpll_component|auto_generated|pll1|clk[3]} {pll_inst|altpll_component|auto_generated|pll1|clk[3]}
create_generated_clock -name {dac_clk} -source [get_pins {pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -master_clock {pll_inst|altpll_component|auto_generated|pll1|clk[0]} [get_ports {DAC_CLK}] 
create_generated_clock -name sdram_clk -source [get_pins {pll_inst|altpll_component|auto_generated|pll1|clk[1]}] [get_ports {SDRAM_CLK}]
create_generated_clock -name adc_clk -source [get_pins {pll_inst|altpll_component|auto_generated|pll1|clk[3]}] [get_ports {ADC_CLK}]

#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[2]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[2]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[2]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[2]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[2]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[2]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[2]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[2]}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************
set_input_delay -clock { adc_clk } -max -add_delay 5.2 [get_ports {ADC_D1[0] ADC_D1[1] ADC_D1[2] ADC_D1[3] ADC_D1[4] ADC_D1[5] ADC_D1[6] ADC_D1[7] ADC_D1[8] ADC_D1[9] ADC_D1[10] ADC_D1[11] ADC_D1[12] ADC_D1[13] ADC_OF1}]
set_input_delay -clock { adc_clk } -min -add_delay 3.2 [get_ports {ADC_D1[0] ADC_D1[1] ADC_D1[2] ADC_D1[3] ADC_D1[4] ADC_D1[5] ADC_D1[6] ADC_D1[7] ADC_D1[8] ADC_D1[9] ADC_D1[10] ADC_D1[11] ADC_D1[12] ADC_D1[13] ADC_OF1}]
set_input_delay -clock { sdram_clk } -max -add_delay 5.2 [get_ports {SDRAM_DQ[0] SDRAM_DQ[1] SDRAM_DQ[2] SDRAM_DQ[3] SDRAM_DQ[4] SDRAM_DQ[5] SDRAM_DQ[6] SDRAM_DQ[7] SDRAM_DQ[8] SDRAM_DQ[9] SDRAM_DQ[10] SDRAM_DQ[11] SDRAM_DQ[12] SDRAM_DQ[13] SDRAM_DQ[14] SDRAM_DQ[15]  }]
set_input_delay -clock { sdram_clk } -min -add_delay 3.2 [get_ports {SDRAM_DQ[0] SDRAM_DQ[1] SDRAM_DQ[2] SDRAM_DQ[3] SDRAM_DQ[4] SDRAM_DQ[5] SDRAM_DQ[6] SDRAM_DQ[7] SDRAM_DQ[8] SDRAM_DQ[9] SDRAM_DQ[10] SDRAM_DQ[11] SDRAM_DQ[12] SDRAM_DQ[13] SDRAM_DQ[14] SDRAM_DQ[15]  }]


#**************************************************************
# Set Output Delay
#**************************************************************
set_output_delay -clock { sdram_clk } -max -add_delay 1.5 [get_ports {SDRAM_ADDR[0] SDRAM_ADDR[1] SDRAM_ADDR[2] SDRAM_ADDR[3] SDRAM_ADDR[4] SDRAM_ADDR[5] SDRAM_ADDR[6] SDRAM_ADDR[7] SDRAM_ADDR[8] SDRAM_ADDR[9] SDRAM_ADDR[10] SDRAM_ADDR[11] SDRAM_ADDR[12] SDRAM_BA[0] SDRAM_BA[1] SDRAM_CAS_N SDRAM_CKE SDRAM_CS_N SDRAM_DQM[0] SDRAM_DQM[1] SDRAM_DQ[0] SDRAM_DQ[1] SDRAM_DQ[2] SDRAM_DQ[3] SDRAM_DQ[4] SDRAM_DQ[5] SDRAM_DQ[6] SDRAM_DQ[7] SDRAM_DQ[8] SDRAM_DQ[9] SDRAM_DQ[10] SDRAM_DQ[11] SDRAM_DQ[12] SDRAM_DQ[13] SDRAM_DQ[14] SDRAM_DQ[15] SDRAM_RAS_N SDRAM_WE_N}]
set_output_delay -clock { sdram_clk } -min -add_delay -1 [get_ports {SDRAM_ADDR[0] SDRAM_ADDR[1] SDRAM_ADDR[2] SDRAM_ADDR[3] SDRAM_ADDR[4] SDRAM_ADDR[5] SDRAM_ADDR[6] SDRAM_ADDR[7] SDRAM_ADDR[8] SDRAM_ADDR[9] SDRAM_ADDR[10] SDRAM_ADDR[11] SDRAM_ADDR[12] SDRAM_BA[0] SDRAM_BA[1] SDRAM_CAS_N SDRAM_CKE SDRAM_CS_N SDRAM_DQM[0] SDRAM_DQM[1] SDRAM_DQ[0] SDRAM_DQ[1] SDRAM_DQ[2] SDRAM_DQ[3] SDRAM_DQ[4] SDRAM_DQ[5] SDRAM_DQ[6] SDRAM_DQ[7] SDRAM_DQ[8] SDRAM_DQ[9] SDRAM_DQ[10] SDRAM_DQ[11] SDRAM_DQ[12] SDRAM_DQ[13] SDRAM_DQ[14] SDRAM_DQ[15] SDRAM_RAS_N SDRAM_WE_N}]
set_output_delay -clock { dac_clk } -max -add_delay 0 [get_ports {DAC1[0] DAC1[1] DAC1[2] DAC1[3] DAC1[4] DAC1[5] DAC1[6] DAC1[7] DAC1[8] DAC1[9] DAC1[10] DAC1[11] DAC1[12] DAC1[13] DAC1[14] DAC1[15] DAC2[0] DAC2[1] DAC2[2] DAC2[3] DAC2[4] DAC2[5] DAC2[6] DAC2[7] DAC2[8] DAC2[9] DAC2[10] DAC2[11] DAC2[12] DAC2[13] DAC2[14] DAC2[15] DAC_RST}]
set_output_delay -clock { dac_clk } -min -add_delay -2.9 [get_ports {DAC1[0] DAC1[1] DAC1[2] DAC1[3] DAC1[4] DAC1[5] DAC1[6] DAC1[7] DAC1[8] DAC1[9] DAC1[10] DAC1[11] DAC1[12] DAC1[13] DAC1[14] DAC1[15] DAC2[0] DAC2[1] DAC2[2] DAC2[3] DAC2[4] DAC2[5] DAC2[6] DAC2[7] DAC2[8] DAC2[9] DAC2[10] DAC2[11] DAC2[12] DAC2[13] DAC2[14] DAC2[15] DAC_RST}]

#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 


#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_registers {*|alt_jtag_atlantic:*|jupdate}] -to [get_registers {*|alt_jtag_atlantic:*|jupdate1*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|rdata[*]}] -to [get_registers {*|alt_jtag_atlantic*|td_shift[*]}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|read}] -to [get_registers {*|alt_jtag_atlantic:*|read1*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|read_req}] 
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|rvalid}] -to [get_registers {*|alt_jtag_atlantic*|td_shift[*]}]
set_false_path -from [get_registers {*|t_dav}] -to [get_registers {*|alt_jtag_atlantic:*|tck_t_dav}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|user_saw_rvalid}] -to [get_registers {*|alt_jtag_atlantic:*|rvalid0*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|wdata[*]}] -to [all_registers]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write}] -to [get_registers {*|alt_jtag_atlantic:*|write1*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write_stalled}] -to [get_registers {*|alt_jtag_atlantic:*|t_ena*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write_stalled}] -to [get_registers {*|alt_jtag_atlantic:*|t_pause*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write_valid}] 
set_false_path -to [get_keepers {*altera_std_synchronizer:*|din_s1}]
set_false_path -from [get_keepers {*CPU_nios2_cpu:*|CPU_nios2_cpu_nios2_oci:the_CPU_nios2_cpu_nios2_oci|CPU_nios2_cpu_nios2_oci_break:the_CPU_nios2_cpu_nios2_oci_break|break_readreg*}] -to [get_keepers {*CPU_nios2_cpu:*|CPU_nios2_cpu_nios2_oci:the_CPU_nios2_cpu_nios2_oci|CPU_nios2_cpu_debug_slave_wrapper:the_CPU_nios2_cpu_debug_slave_wrapper|CPU_nios2_cpu_debug_slave_tck:the_CPU_nios2_cpu_debug_slave_tck|*sr*}]
set_false_path -from [get_keepers {*CPU_nios2_cpu:*|CPU_nios2_cpu_nios2_oci:the_CPU_nios2_cpu_nios2_oci|CPU_nios2_cpu_nios2_oci_debug:the_CPU_nios2_cpu_nios2_oci_debug|*resetlatch}] -to [get_keepers {*CPU_nios2_cpu:*|CPU_nios2_cpu_nios2_oci:the_CPU_nios2_cpu_nios2_oci|CPU_nios2_cpu_debug_slave_wrapper:the_CPU_nios2_cpu_debug_slave_wrapper|CPU_nios2_cpu_debug_slave_tck:the_CPU_nios2_cpu_debug_slave_tck|*sr[33]}]
set_false_path -from [get_keepers {*CPU_nios2_cpu:*|CPU_nios2_cpu_nios2_oci:the_CPU_nios2_cpu_nios2_oci|CPU_nios2_cpu_nios2_oci_debug:the_CPU_nios2_cpu_nios2_oci_debug|monitor_ready}] -to [get_keepers {*CPU_nios2_cpu:*|CPU_nios2_cpu_nios2_oci:the_CPU_nios2_cpu_nios2_oci|CPU_nios2_cpu_debug_slave_wrapper:the_CPU_nios2_cpu_debug_slave_wrapper|CPU_nios2_cpu_debug_slave_tck:the_CPU_nios2_cpu_debug_slave_tck|*sr[0]}]
set_false_path -from [get_keepers {*CPU_nios2_cpu:*|CPU_nios2_cpu_nios2_oci:the_CPU_nios2_cpu_nios2_oci|CPU_nios2_cpu_nios2_oci_debug:the_CPU_nios2_cpu_nios2_oci_debug|monitor_error}] -to [get_keepers {*CPU_nios2_cpu:*|CPU_nios2_cpu_nios2_oci:the_CPU_nios2_cpu_nios2_oci|CPU_nios2_cpu_debug_slave_wrapper:the_CPU_nios2_cpu_debug_slave_wrapper|CPU_nios2_cpu_debug_slave_tck:the_CPU_nios2_cpu_debug_slave_tck|*sr[34]}]
set_false_path -from [get_keepers {*CPU_nios2_cpu:*|CPU_nios2_cpu_nios2_oci:the_CPU_nios2_cpu_nios2_oci|CPU_nios2_cpu_nios2_ocimem:the_CPU_nios2_cpu_nios2_ocimem|*MonDReg*}] -to [get_keepers {*CPU_nios2_cpu:*|CPU_nios2_cpu_nios2_oci:the_CPU_nios2_cpu_nios2_oci|CPU_nios2_cpu_debug_slave_wrapper:the_CPU_nios2_cpu_debug_slave_wrapper|CPU_nios2_cpu_debug_slave_tck:the_CPU_nios2_cpu_debug_slave_tck|*sr*}]
set_false_path -from [get_keepers {*CPU_nios2_cpu:*|CPU_nios2_cpu_nios2_oci:the_CPU_nios2_cpu_nios2_oci|CPU_nios2_cpu_debug_slave_wrapper:the_CPU_nios2_cpu_debug_slave_wrapper|CPU_nios2_cpu_debug_slave_tck:the_CPU_nios2_cpu_debug_slave_tck|*sr*}] -to [get_keepers {*CPU_nios2_cpu:*|CPU_nios2_cpu_nios2_oci:the_CPU_nios2_cpu_nios2_oci|CPU_nios2_cpu_debug_slave_wrapper:the_CPU_nios2_cpu_debug_slave_wrapper|CPU_nios2_cpu_debug_slave_sysclk:the_CPU_nios2_cpu_debug_slave_sysclk|*jdo*}]
set_false_path -from [get_keepers {sld_hub:*|irf_reg*}] -to [get_keepers {*CPU_nios2_cpu:*|CPU_nios2_cpu_nios2_oci:the_CPU_nios2_cpu_nios2_oci|CPU_nios2_cpu_debug_slave_wrapper:the_CPU_nios2_cpu_debug_slave_wrapper|CPU_nios2_cpu_debug_slave_sysclk:the_CPU_nios2_cpu_debug_slave_sysclk|ir*}]
set_false_path -from [get_keepers {sld_hub:*|sld_shadow_jsm:shadow_jsm|state[1]}] -to [get_keepers {*CPU_nios2_cpu:*|CPU_nios2_cpu_nios2_oci:the_CPU_nios2_cpu_nios2_oci|CPU_nios2_cpu_nios2_oci_debug:the_CPU_nios2_cpu_nios2_oci_debug|monitor_go}]
set_false_path -to [get_pins -nocase -compatibility_mode {*|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain*|clrn}]


#**************************************************************
# Set Multicycle Path
#**************************************************************
set_multicycle_path -from [get_clocks {adc_clk}] -to [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -setup -end 2
set_multicycle_path -from [get_clocks {sdram_clk}] -to [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -setup -end 2


#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

