

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "myAXI_2017P4_50reg" "NUM_INSTANCES" "DEVICE_ID"  "C_S00_AXI_BASEADDR" "C_S00_AXI_HIGHADDR"
}
