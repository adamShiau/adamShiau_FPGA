#include "adxl357.h"
#define VARSET_BASE VARSET_1_BASE

/******** I2C device address*********/
#define I2C_DEV_ADDR	0x1D

/******** I2C lock rate definition*********/
#define CLK_390K 	 7
#define CLK_781K 	 6
#define CLK_1562K 	 5
#define CLK_3125K 	 4


/******** VAR Register*********/
#define	O_VAR_DEV_ADDR		var_i2c_357_dev_addr
#define O_VAR_W_DATA		var_i2c_357_w_data
#define O_VAR_I2C_CTRL		var_i2c_357_ctrl
// #define O_VAR_SYNC_PER		3
#define O_VAR_REG_ADDR		var_i2c_357_reg_addr
#define O_VAR_I2C_STATUS	var_i2c_357_status
#define O_VAR_I2C_RDATA_1	var_i2c_357_rdata_1
#define O_VAR_I2C_RDATA_2	var_i2c_357_rdata_2
#define O_VAR_I2C_RDATA_3	var_i2c_357_rdata_3
#define O_VAR_I2C_RDATA_4	var_i2c_357_rdata_4
// #define O_VAR_I2C_RDATA_5	var_i2c_357_rdata_5
// #define O_VAR_I2C_RDATA_6	var_i2c_357_rdata_6
// #define O_VAR_I2C_RDATA_7	var_i2c_357_rdata_7
// #define O_VAR_I2C_RDATA_8	var_i2c_357_rdata_8
// #define O_VAR_I2C_RDATA_9	var_i2c_357_rdata_9
// #define O_VAR_I2C_RDATA_10	var_i2c_357_rdata_10
// #define O_VAR_I2C_RDATA_11	var_i2c_357_rdata_11

#define I2C_READ			0x1
#define I2C_WRITE			0x0

/**** CTRL ******/
#define ctrl_en_pos			0
#define ctrl_rw_reg_pos		1
#define ctrl_op_mode_pos 	1
#define ctrl_clk_rate_pos	4

/**** STATUS ******/
#define status_ready_pos	0
#define status_finish_pos	1
#define status_state_pos	9

/*** register address***/
#define DEVID_AD_ADDR	0x00
#define STATUS_ADDR 	0x04
#define FIFO_ADDR 		0x05
#define TEMP2_ADDR 		0x06
#define TEMP1_ADDR  	0x07
#define XDATA3_ADDR  	0x08
#define XDATA2_ADDR  	0x09
#define XDATA1_ADDR  	0x0A
#define YDATA3_ADDR  	0x0B
#define YDATA2_ADDR  	0x0C
#define YDATA1_ADDR  	0x0D
#define ZDATA3_ADDR  	0x0E
#define ZDATA2_ADDR  	0x0F
#define ZDATA1_ADDR  	0x10
#define FILTER_ADDR  	0x28
#define INTERRUPT_ADDR 	0x2A
#define SYNC_ADDR  		0x2B
#define RANGE_ADDR  	0x2C
#define POWER_CTL_ADDR 	0x2D
#define RST_ADDR  		0x2F

/*** range reg parameter***/
#define H_MODE		0x80
#define F_MODE		0x00
#define INT_POL_H	0x40
#define RANGE_10G 	0x01
#define RANGE_20G 	0x02
#define RANGE_40G 	0x03



/*** reset parameter ***/
#define POR 		0x52
/*** ODR parameter ***/
#define ODR_4000	0b0000
#define ODR_2000 	0b0001
#define ODR_1000 	0b0010
#define ODR_500 	0b0011
#define ODR_250 	0b0100
#define ODR_125 	0b0101

/*** sync parameter ***/
#define INT_SYNC	0x00
#define EXT_SYNC	0x02

/*** status reg mask***/
#define DATA_RDY_MSK 	0x01
#define FIFO_FULL_MSK 	0x02
#define FIFO_OVR_MSK 	0x04

/*** power control parameter***/
#define MEASURE_MODE	0x00
#define TEMP_OFF_MSK	0x02

/*** OP mode***/
#define CPU_RREG	0
#define CPU_WREG	1
#define CPU_RD_TEMP	2
#define CPU_RD_ACCL	3
#define HW_ALL		4


#define True 1
#define False 0

#define DLY_NUM_357 1000
static alt_u32 dly_cnt = 0, number = 5000;


/***********test funciton */
void test_CPU_ADXL357_ACCL()
{
	DEBUG_PRINT("testing_CPU_ADXL357_ACCL\n");
	while(number-- != 0 ) {
		dly_cnt = 0;
		while(dly_cnt++ < DLY_NUM_357) {} // delay control
		read_357_accl_CPU();
		// DEBUG_PRINT("test 357 :%ld\n", number);
	}
}

void test_HW_ADXL357()
{
	DEBUG_PRINT("testing_HW_ADXL357\n");
	while(number-- != 0 ) {
		read_357_all();
	}
}

/***********high level definition */
void init_ADXL357()
{
	/*** configure the ADXL355/357 ***/
	I2C_clock_rate_sel_ADXL357(CLK_390K);
	/*** set adxl357 parameters ***/
	// DEBUG_PRINT("0");
	I2C_write_357_register(RST_ADDR, POR);
	// DEBUG_PRINT("1");
	I2C_write_357_register(RANGE_ADDR, F_MODE | INT_POL_H | RANGE_20G);
	// DEBUG_PRINT("2");
	 I2C_read_357_register(RANGE_ADDR, 1);
	// DEBUG_PRINT("3");
//	I2C_write_357_register(FILTER_ADDR, ODR_500);
//	I2C_read_357_register(FILTER_ADDR);

	I2C_write_357_register(INTERRUPT_ADDR, 0x00); // see datasheet Table 14. Multiplexing of INT2 and DRDY, set INT2(pin 13) to drdy; DRDY pin to SYNC
	I2C_read_357_register(INTERRUPT_ADDR, 1);
	I2C_write_357_register(SYNC_ADDR, EXT_SYNC);
	I2C_read_357_register(SYNC_ADDR, 1);
	I2C_write_357_register(POWER_CTL_ADDR, MEASURE_MODE);
	I2C_read_357_register(POWER_CTL_ADDR, 1);
	
//	test_CPU_ADXL357_ACCL();
	// I2C_read_357_register(POWER_CTL_ADDR, 1); 
	// dly_cnt = 0;
	// while(dly_cnt++ < 100) {} // delay control

	// I2C_read_357_register(INTERRUPT_ADDR, 1);
//	 I2C_read_357_register(SYNC_ADDR, 1);
	// I2C_read_357_register(POWER_CTL_ADDR, 1); 




	
	I2C_op_mode_sel_ADXL357(HW_ALL);
	//  test_HW_ADXL357();

	// Set I2C operation mode to read 11 bytes (HW mode 11)
	//  I2C_op_mode_sel_ADXL357(HW_11);
}

void read_357_temp_CPU()
{
	float temp;

	// setting mode to r/w 1 byte
	I2C_op_mode_sel_ADXL357(CPU_RD_TEMP);

	I2C_sm_start_ADXL357();
	// Wait for the I2C SM to complete the operation
	while( !I2C_sm_read_finish_ADXL357()){}

	temp = 233.2873 - 0.1105*(float)IORD(VARSET_BASE, var_i2c_357_rdata_4);

//	printf("temp: %f\n", temp);
	UART_PRINT("temp: %f\n", temp);

}

void read_357_accl_CPU()
{
	float ax, ay, az;

	// setting mode to r/w 1 byte
	I2C_op_mode_sel_ADXL357(CPU_RD_ACCL);

	I2C_sm_start_ADXL357();
	// Wait for the I2C SM to complete the operation
	while( !I2C_sm_read_finish_ADXL357()){}


	ax = (float)IORD(VARSET_BASE, var_i2c_357_rdata_1)*SENS_ADXL357_20G;
	ay = (float)IORD(VARSET_BASE, var_i2c_357_rdata_2)*SENS_ADXL357_20G;
	az = (float)IORD(VARSET_BASE, var_i2c_357_rdata_3)*SENS_ADXL357_20G;

	DEBUG_PRINT("%f, %f, %f\n", ax, ay, az);
	// UART_PRINT("%f, %f, %f\n", ax, ay, az);

}

void read_357_all()
{
	float temp, ax, ay, az;

	// setting mode to r/w 1 byte
	// I2C_op_mode_sel_ADXL357(HW_ALL);

//	I2C_sm_start_ADXL357();
	// Wait for the I2C SM to complete the operation
	while( !I2C_sm_read_finish_ADXL357()){}

	ax = (float)IORD(VARSET_BASE, var_i2c_357_rdata_1)*SENS_ADXL357_20G;
	ay = (float)IORD(VARSET_BASE, var_i2c_357_rdata_2)*SENS_ADXL357_20G;
	az = (float)IORD(VARSET_BASE, var_i2c_357_rdata_3)*SENS_ADXL357_20G;
	temp = 233.2873 - 0.1105*(float)IORD(VARSET_BASE, var_i2c_357_rdata_4);

//	printf("%f, %f, %f\n", ax, ay, az);
	DEBUG_PRINT("%f, %f, %f, %f\n", ax, ay, az, temp);

}

// void print_11_reg()
// {
// 	alt_u8 H, L;
// 	alt_u8 XH, XM, XL;
// 	alt_u8 YH, YM, YL;
// 	alt_u8 ZH, ZM, ZL;
// 	float temp, accl_x, accl_y, accl_z;

// 	while( !I2C_sm_read_finish_ADXL357()){}
// 	H = IORD(VARSET_BASE, O_VAR_I2C_RDATA_1);
// 	L = IORD(VARSET_BASE, O_VAR_I2C_RDATA_2);
// 	XH = IORD(VARSET_BASE, O_VAR_I2C_RDATA_3);
// 	XM = IORD(VARSET_BASE, O_VAR_I2C_RDATA_4);
// 	XL = IORD(VARSET_BASE, O_VAR_I2C_RDATA_5);
// 	YH = IORD(VARSET_BASE, O_VAR_I2C_RDATA_6);
// 	YM = IORD(VARSET_BASE, O_VAR_I2C_RDATA_7);
// 	YL = IORD(VARSET_BASE, O_VAR_I2C_RDATA_8);
// 	ZH = IORD(VARSET_BASE, O_VAR_I2C_RDATA_9);
// 	ZM = IORD(VARSET_BASE, O_VAR_I2C_RDATA_10);
// 	ZL = IORD(VARSET_BASE, O_VAR_I2C_RDATA_11);

// 	temp = ((float)((H<<8)|L)-1885.0)/(-9.05)+25.0;
// 	accl_x = (XH>>7)? ((float)(XH<<12|XM<<4|XL>>4)-1048576.0)*SENS_ADXL357_40G : (float)(XH<<12|XM<<4|XL>>4)*SENS_ADXL357_40G;
// 	accl_y = (YH>>7)? ((float)(YH<<12|YM<<4|YL>>4)-1048576.0)*SENS_ADXL357_40G : (float)(YH<<12|YM<<4|YL>>4)*SENS_ADXL357_40G;
// 	accl_z = (ZH>>7)? ((float)(ZH<<12|ZM<<4|ZL>>4)-1048576.0)*SENS_ADXL357_40G : (float)(ZH<<12|ZM<<4|ZL>>4)*SENS_ADXL357_40G;

// 	INFO_PRINT("%.3f, %.4f, %.4f, %.4f\n", temp, accl_x, accl_y, accl_z);

// }

// void print_9_reg()
// {
// 	alt_u8 XH, XM, XL;
// 	alt_u8 YH, YM, YL;
// 	alt_u8 ZH, ZM, ZL;
// 	float accl_x, accl_y, accl_z;

// 	while( !I2C_sm_read_finish_ADXL357()){}
// 	XH = IORD(VARSET_BASE, O_VAR_I2C_RDATA_1);
// 	XM = IORD(VARSET_BASE, O_VAR_I2C_RDATA_2);
// 	XL = IORD(VARSET_BASE, O_VAR_I2C_RDATA_3);
// 	YH = IORD(VARSET_BASE, O_VAR_I2C_RDATA_4);
// 	YM = IORD(VARSET_BASE, O_VAR_I2C_RDATA_5);
// 	YL = IORD(VARSET_BASE, O_VAR_I2C_RDATA_6);
// 	ZH = IORD(VARSET_BASE, O_VAR_I2C_RDATA_7);
// 	ZM = IORD(VARSET_BASE, O_VAR_I2C_RDATA_8);
// 	ZL = IORD(VARSET_BASE, O_VAR_I2C_RDATA_9);

// 	accl_x = (XH>>7)? ((float)(XH<<12|XM<<4|XL>>4)-1048576.0)*SENS_ADXL357_40G : (float)(XH<<12|XM<<4|XL>>4)*SENS_ADXL357_40G;
// 	accl_y = (YH>>7)? ((float)(YH<<12|YM<<4|YL>>4)-1048576.0)*SENS_ADXL357_40G : (float)(YH<<12|YM<<4|YL>>4)*SENS_ADXL357_40G;
// 	accl_z = (ZH>>7)? ((float)(ZH<<12|ZM<<4|ZL>>4)-1048576.0)*SENS_ADXL357_40G : (float)(ZH<<12|ZM<<4|ZL>>4)*SENS_ADXL357_40G;

// 	// INFO_PRINT("%.4f, %.4f, %.4f\n", accl_x, accl_y, accl_z);

// }




/***********mid level definition */

void I2C_sm_start_ADXL357()
{
	alt_u8 dly = 50;

	I2C_sm_set_enable_ADXL357();
	while(dly--){}
	I2C_sm_set_disable_ADXL357();
}

void I2C_op_mode_sel_ADXL357(alt_u8 mode)
{
	alt_32 old = IORD(VARSET_BASE, O_VAR_I2C_CTRL);

	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, (old & 0xFFFFFFF1) | (mode<<ctrl_op_mode_pos));
}

void I2C_clock_rate_sel_ADXL357(alt_u8 rate)
{
	alt_32 old = IORD(VARSET_BASE, O_VAR_I2C_CTRL);

	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, (old & 0xFFFFFF8F) | (rate<<ctrl_clk_rate_pos));
}

void I2C_write_357_register(alt_u8 reg_addr, alt_u8 data)
{
	// setting mode to r/w 1 byte
	I2C_op_mode_sel_ADXL357(CPU_WREG);
	// Set I2C device address for ADXL355/357 (0x1D)
	IOWR(VARSET_BASE, O_VAR_DEV_ADDR, I2C_DEV_ADDR);
	// Set the target register address for read or write operations
	IOWR(VARSET_BASE, O_VAR_REG_ADDR, reg_addr);

	// set I2C SM to write mode
	// I2C_set_write_mode_ADXL357();

	// Set the data value to be written to the target register
	IOWR(VARSET_BASE, O_VAR_W_DATA, data);
	// start the I2C SM 
	I2C_sm_start_ADXL357();
	// Wait for the I2C SM to complete the operation
	 while( !I2C_sm_read_finish_ADXL357()){} // time duration from sm_enable to finish too short
//	 dly_cnt = 0;
//	 while(dly_cnt++ < 100) {} // delay control

}

alt_u8 I2C_read_357_register(alt_u8 reg_addr, alt_u8 print)
{
	alt_u8 rt;

	// setting mode to r/w 1 byte
	I2C_op_mode_sel_ADXL357(CPU_RREG);
	// Set I2C device address for ADXL355/357 (0x1D)
	IOWR(VARSET_BASE, O_VAR_DEV_ADDR, I2C_DEV_ADDR);
	// Set the target register address for read or write operations
	IOWR(VARSET_BASE, O_VAR_REG_ADDR, reg_addr);

	// Set the I2C SM to read mode
	// I2C_set_read_mode_ADXL357();

	// start the I2C SM 
	I2C_sm_start_ADXL357();
	// Wait for the I2C SM to complete the operation
	while( !I2C_sm_read_finish_ADXL357()){}
	// Retrieve the data read from the specified register
	rt = IORD(VARSET_BASE, O_VAR_I2C_RDATA_1);
	// Print the register address and its read value if 'print' is enabled
	if(print) 	INFO_PRINT("reg:%x, value:%x\n", reg_addr, rt);

	return rt;
}

/***********low level definition */

/*** Set the bit value at the spcified position without altering the values at other positions. */
 alt_u32 set_bit_safe_ADXL357(alt_u32 old_addr,  alt_u8 pos)
{
	// First, read the register value.
	alt_u32 old = IORD(VARSET_BASE, old_addr);

	// Returns the register value with the bit set at the specified position.
	return (old | (alt_32)(1<<pos)); 
}

/*** Clear the bit value at the spcified position without altering the values at other positions. */
 alt_u32 clear_bit_safe_ADXL357(alt_u32 old_addr,  alt_u8 pos)
{
	// First, read the register value.
	alt_u32 old = IORD(VARSET_BASE, old_addr);

	// Returns the register value with the bit cleared at the specified position.
	return (old & ~((alt_32)(1<<pos))); 
}

/*** Starts the state machine when it is in the IDLE state. */
 void I2C_sm_set_enable_ADXL357()
{
	IOWR(VARSET_BASE, O_VAR_I2C_CTRL,  set_bit_safe_ADXL357(O_VAR_I2C_CTRL, ctrl_en_pos));
}

 void I2C_sm_set_disable_ADXL357()
{
	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, clear_bit_safe_ADXL357(O_VAR_I2C_CTRL, ctrl_en_pos) );
}

 void I2C_set_read_mode_ADXL357()
{
	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, set_bit_safe_ADXL357(O_VAR_I2C_CTRL, ctrl_rw_reg_pos));
}

 void I2C_set_write_mode_ADXL357()
{
	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, clear_bit_safe_ADXL357(O_VAR_I2C_CTRL, ctrl_rw_reg_pos));
}


/*** Returns High when the state machine has finished. */
 alt_u8 I2C_sm_read_finish_ADXL357()
{
	alt_u8 finish=0;

	finish = (alt_u8)(IORD(VARSET_BASE, O_VAR_I2C_STATUS)>>status_finish_pos) & 0x01;
	// DEBUG_PRINT("%d\n", finish);

	return finish;
}
