## Generated SDC file "D:/github/adamShiau_FPGA/intel_IP/fog/PIG/sdc/sparrow_v2_117MHz.sdc"

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

## DATE    "Thu Jul 13 11:03:19 2023"

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

create_generated_clock -name {pll_inst|altpll_component|auto_generated|pll1|clk[0]} -source [get_pins {pll_inst|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 7 -divide_by 3 -master_clock {clk_50M} [get_pins {pll_inst|altpll_component|auto_generated|pll1|clk[0]}] 
create_generated_clock -name {pll_inst|altpll_component|auto_generated|pll1|clk[1]} -source [get_pins {pll_inst|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 2 -phase -90.000 -master_clock {clk_50M} [get_pins {pll_inst|altpll_component|auto_generated|pll1|clk[1]}] 
create_generated_clock -name {pll_inst|altpll_component|auto_generated|pll1|clk[3]} -source [get_pins {pll_inst|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 2 -phase -90.000 -master_clock {clk_50M} [get_pins {pll_inst|altpll_component|auto_generated|pll1|clk[3]}] 
create_generated_clock -name {dac_clk} -source [get_pins {pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -master_clock {pll_inst|altpll_component|auto_generated|pll1|clk[0]} [get_ports {DAC_CLK}] 
create_generated_clock -name {sdram_clk} -source [get_pins {pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -master_clock {pll_inst|altpll_component|auto_generated|pll1|clk[1]} [get_ports {SDRAM_CLK}] 
create_generated_clock -name {adc_clk} -source [get_pins {pll_inst|altpll_component|auto_generated|pll1|clk[3]}] -master_clock {pll_inst|altpll_component|auto_generated|pll1|clk[3]} [get_ports {ADC_CLK}] 


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
set_clock_uncertainty -fall_from [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay -max -clock [get_clocks {adc_clk}]  5.200 [get_ports {ADC_D1[0]}]
set_input_delay -add_delay -min -clock [get_clocks {adc_clk}]  3.200 [get_ports {ADC_D1[0]}]
set_input_delay -add_delay -max -clock [get_clocks {adc_clk}]  5.200 [get_ports {ADC_D1[1]}]
set_input_delay -add_delay -min -clock [get_clocks {adc_clk}]  3.200 [get_ports {ADC_D1[1]}]
set_input_delay -add_delay -max -clock [get_clocks {adc_clk}]  5.200 [get_ports {ADC_D1[2]}]
set_input_delay -add_delay -min -clock [get_clocks {adc_clk}]  3.200 [get_ports {ADC_D1[2]}]
set_input_delay -add_delay -max -clock [get_clocks {adc_clk}]  5.200 [get_ports {ADC_D1[3]}]
set_input_delay -add_delay -min -clock [get_clocks {adc_clk}]  3.200 [get_ports {ADC_D1[3]}]
set_input_delay -add_delay -max -clock [get_clocks {adc_clk}]  5.200 [get_ports {ADC_D1[4]}]
set_input_delay -add_delay -min -clock [get_clocks {adc_clk}]  3.200 [get_ports {ADC_D1[4]}]
set_input_delay -add_delay -max -clock [get_clocks {adc_clk}]  5.200 [get_ports {ADC_D1[5]}]
set_input_delay -add_delay -min -clock [get_clocks {adc_clk}]  3.200 [get_ports {ADC_D1[5]}]
set_input_delay -add_delay -max -clock [get_clocks {adc_clk}]  5.200 [get_ports {ADC_D1[6]}]
set_input_delay -add_delay -min -clock [get_clocks {adc_clk}]  3.200 [get_ports {ADC_D1[6]}]
set_input_delay -add_delay -max -clock [get_clocks {adc_clk}]  5.200 [get_ports {ADC_D1[7]}]
set_input_delay -add_delay -min -clock [get_clocks {adc_clk}]  3.200 [get_ports {ADC_D1[7]}]
set_input_delay -add_delay -max -clock [get_clocks {adc_clk}]  5.200 [get_ports {ADC_D1[8]}]
set_input_delay -add_delay -min -clock [get_clocks {adc_clk}]  3.200 [get_ports {ADC_D1[8]}]
set_input_delay -add_delay -max -clock [get_clocks {adc_clk}]  5.200 [get_ports {ADC_D1[9]}]
set_input_delay -add_delay -min -clock [get_clocks {adc_clk}]  3.200 [get_ports {ADC_D1[9]}]
set_input_delay -add_delay -max -clock [get_clocks {adc_clk}]  5.200 [get_ports {ADC_D1[10]}]
set_input_delay -add_delay -min -clock [get_clocks {adc_clk}]  3.200 [get_ports {ADC_D1[10]}]
set_input_delay -add_delay -max -clock [get_clocks {adc_clk}]  5.200 [get_ports {ADC_D1[11]}]
set_input_delay -add_delay -min -clock [get_clocks {adc_clk}]  3.200 [get_ports {ADC_D1[11]}]
set_input_delay -add_delay -max -clock [get_clocks {adc_clk}]  5.200 [get_ports {ADC_D1[12]}]
set_input_delay -add_delay -min -clock [get_clocks {adc_clk}]  3.200 [get_ports {ADC_D1[12]}]
set_input_delay -add_delay -max -clock [get_clocks {adc_clk}]  5.200 [get_ports {ADC_D1[13]}]
set_input_delay -add_delay -min -clock [get_clocks {adc_clk}]  3.200 [get_ports {ADC_D1[13]}]
set_input_delay -add_delay -max -clock [get_clocks {adc_clk}]  5.200 [get_ports {ADC_OF1}]
set_input_delay -add_delay -min -clock [get_clocks {adc_clk}]  3.200 [get_ports {ADC_OF1}]
set_input_delay -add_delay -max -clock [get_clocks {sdram_clk}]  5.200 [get_ports {SDRAM_DQ[0]}]
set_input_delay -add_delay -min -clock [get_clocks {sdram_clk}]  3.200 [get_ports {SDRAM_DQ[0]}]
set_input_delay -add_delay -max -clock [get_clocks {sdram_clk}]  5.200 [get_ports {SDRAM_DQ[1]}]
set_input_delay -add_delay -min -clock [get_clocks {sdram_clk}]  3.200 [get_ports {SDRAM_DQ[1]}]
set_input_delay -add_delay -max -clock [get_clocks {sdram_clk}]  5.200 [get_ports {SDRAM_DQ[2]}]
set_input_delay -add_delay -min -clock [get_clocks {sdram_clk}]  3.200 [get_ports {SDRAM_DQ[2]}]
set_input_delay -add_delay -max -clock [get_clocks {sdram_clk}]  5.200 [get_ports {SDRAM_DQ[3]}]
set_input_delay -add_delay -min -clock [get_clocks {sdram_clk}]  3.200 [get_ports {SDRAM_DQ[3]}]
set_input_delay -add_delay -max -clock [get_clocks {sdram_clk}]  5.200 [get_ports {SDRAM_DQ[4]}]
set_input_delay -add_delay -min -clock [get_clocks {sdram_clk}]  3.200 [get_ports {SDRAM_DQ[4]}]
set_input_delay -add_delay -max -clock [get_clocks {sdram_clk}]  5.200 [get_ports {SDRAM_DQ[5]}]
set_input_delay -add_delay -min -clock [get_clocks {sdram_clk}]  3.200 [get_ports {SDRAM_DQ[5]}]
set_input_delay -add_delay -max -clock [get_clocks {sdram_clk}]  5.200 [get_ports {SDRAM_DQ[6]}]
set_input_delay -add_delay -min -clock [get_clocks {sdram_clk}]  3.200 [get_ports {SDRAM_DQ[6]}]
set_input_delay -add_delay -max -clock [get_clocks {sdram_clk}]  5.200 [get_ports {SDRAM_DQ[7]}]
set_input_delay -add_delay -min -clock [get_clocks {sdram_clk}]  3.200 [get_ports {SDRAM_DQ[7]}]
set_input_delay -add_delay -max -clock [get_clocks {sdram_clk}]  5.200 [get_ports {SDRAM_DQ[8]}]
set_input_delay -add_delay -min -clock [get_clocks {sdram_clk}]  3.200 [get_ports {SDRAM_DQ[8]}]
set_input_delay -add_delay -max -clock [get_clocks {sdram_clk}]  5.200 [get_ports {SDRAM_DQ[9]}]
set_input_delay -add_delay -min -clock [get_clocks {sdram_clk}]  3.200 [get_ports {SDRAM_DQ[9]}]
set_input_delay -add_delay -max -clock [get_clocks {sdram_clk}]  5.200 [get_ports {SDRAM_DQ[10]}]
set_input_delay -add_delay -min -clock [get_clocks {sdram_clk}]  3.200 [get_ports {SDRAM_DQ[10]}]
set_input_delay -add_delay -max -clock [get_clocks {sdram_clk}]  5.200 [get_ports {SDRAM_DQ[11]}]
set_input_delay -add_delay -min -clock [get_clocks {sdram_clk}]  3.200 [get_ports {SDRAM_DQ[11]}]
set_input_delay -add_delay -max -clock [get_clocks {sdram_clk}]  5.200 [get_ports {SDRAM_DQ[12]}]
set_input_delay -add_delay -min -clock [get_clocks {sdram_clk}]  3.200 [get_ports {SDRAM_DQ[12]}]
set_input_delay -add_delay -max -clock [get_clocks {sdram_clk}]  5.200 [get_ports {SDRAM_DQ[13]}]
set_input_delay -add_delay -min -clock [get_clocks {sdram_clk}]  3.200 [get_ports {SDRAM_DQ[13]}]
set_input_delay -add_delay -max -clock [get_clocks {sdram_clk}]  5.200 [get_ports {SDRAM_DQ[14]}]
set_input_delay -add_delay -min -clock [get_clocks {sdram_clk}]  3.200 [get_ports {SDRAM_DQ[14]}]
set_input_delay -add_delay -max -clock [get_clocks {sdram_clk}]  5.200 [get_ports {SDRAM_DQ[15]}]
set_input_delay -add_delay -min -clock [get_clocks {sdram_clk}]  3.200 [get_ports {SDRAM_DQ[15]}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC1[0]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC1[0]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC1[1]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC1[1]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC1[2]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC1[2]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC1[3]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC1[3]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC1[4]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC1[4]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC1[5]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC1[5]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC1[6]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC1[6]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC1[7]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC1[7]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC1[8]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC1[8]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC1[9]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC1[9]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC1[10]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC1[10]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC1[11]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC1[11]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC1[12]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC1[12]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC1[13]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC1[13]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC1[14]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC1[14]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC1[15]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC1[15]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC2[0]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC2[0]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC2[1]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC2[1]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC2[2]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC2[2]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC2[3]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC2[3]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC2[4]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC2[4]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC2[5]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC2[5]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC2[6]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC2[6]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC2[7]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC2[7]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC2[8]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC2[8]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC2[9]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC2[9]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC2[10]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC2[10]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC2[11]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC2[11]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC2[12]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC2[12]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC2[13]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC2[13]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC2[14]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC2[14]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC2[15]}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC2[15]}]
set_output_delay -add_delay -max -clock [get_clocks {dac_clk}]  0.000 [get_ports {DAC_RST}]
set_output_delay -add_delay -min -clock [get_clocks {dac_clk}]  -2.900 [get_ports {DAC_RST}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_ADDR[0]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_ADDR[0]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_ADDR[1]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_ADDR[1]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_ADDR[2]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_ADDR[2]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_ADDR[3]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_ADDR[3]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_ADDR[4]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_ADDR[4]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_ADDR[5]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_ADDR[5]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_ADDR[6]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_ADDR[6]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_ADDR[7]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_ADDR[7]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_ADDR[8]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_ADDR[8]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_ADDR[9]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_ADDR[9]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_ADDR[10]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_ADDR[10]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_ADDR[11]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_ADDR[11]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_ADDR[12]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_ADDR[12]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_BA[0]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_BA[0]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_BA[1]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_BA[1]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_CAS_N}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_CAS_N}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_CKE}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_CKE}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_CS_N}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_CS_N}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_DQM[0]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_DQM[0]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_DQM[1]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_DQM[1]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_DQ[0]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_DQ[0]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_DQ[1]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_DQ[1]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_DQ[2]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_DQ[2]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_DQ[3]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_DQ[3]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_DQ[4]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_DQ[4]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_DQ[5]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_DQ[5]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_DQ[6]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_DQ[6]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_DQ[7]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_DQ[7]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_DQ[8]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_DQ[8]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_DQ[9]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_DQ[9]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_DQ[10]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_DQ[10]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_DQ[11]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_DQ[11]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_DQ[12]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_DQ[12]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_DQ[13]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_DQ[13]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_DQ[14]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_DQ[14]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_DQ[15]}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_DQ[15]}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_RAS_N}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_RAS_N}]
set_output_delay -add_delay -max -clock [get_clocks {sdram_clk}]  1.500 [get_ports {SDRAM_WE_N}]
set_output_delay -add_delay -min -clock [get_clocks {sdram_clk}]  -1.000 [get_ports {SDRAM_WE_N}]


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

set_multicycle_path -setup -end -from  [get_clocks {adc_clk}]  -to  [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}] 2


#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

