transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/github/adamShiau_FPGA/intel_IP/fog/PIG {D:/github/adamShiau_FPGA/intel_IP/fog/PIG/SMA_v1.v}

vlog -vlog01compat -work work +incdir+D:/github/adamShiau_FPGA/Intel\ Project/mySMA/../../intel_IP/fog/PIG/testbench {D:/github/adamShiau_FPGA/Intel Project/mySMA/../../intel_IP/fog/PIG/testbench/mySMA_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  mySMA_tb

add wave *
view structure
view signals
run -all
