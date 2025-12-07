#include "asm330lhhx.h"
#define VARSET_BASE VARSET_1_BASE

/******** I2C device address*********/
#define I2C_DEV_ADDR	0x6A

/******** I2C lock rate definition*********/
#define CLK_390K 	 7
#define CLK_781K 	 6
#define CLK_1562K 	 5
#define CLK_3125K 	 4


/******** VAR Register*********/
#define	O_VAR_DEV_ADDR		var_i2c_IMU_dev_addr
#define O_VAR_W_DATA		var_i2c_IMU_w_data
#define O_VAR_I2C_CTRL		var_i2c_IMU_ctrl
#define O_VAR_REG_ADDR		var_i2c_IMU_reg_addr
#define O_VAR_I2C_STATUS	i_var_i2c_IMU_status
#define O_VAR_I2C_RDATA_1	i_var_i2c_IMU_rdata_1
#define O_VAR_I2C_RDATA_2	i_var_i2c_IMU_rdata_2
#define O_VAR_I2C_RDATA_3	i_var_i2c_IMU_rdata_3
#define O_VAR_I2C_RDATA_4	i_var_i2c_IMU_rdata_4
#define O_VAR_I2C_RDATA_5	i_var_i2c_IMU_rdata_5
#define O_VAR_I2C_RDATA_6	i_var_i2c_IMU_rdata_6
#define O_VAR_I2C_RDATA_7	i_var_i2c_IMU_rdata_7


#define I2C_READ			0x1
#define I2C_WRITE			0x0

/**** CTRL ******/
#define ctrl_en_pos			0
// #define ctrl_rw_reg_pos		1
#define ctrl_op_mode_pos 	1
#define ctrl_clk_rate_pos	4

/**** STATUS ******/
#define status_ready_pos	0
#define status_finish_pos	1
#define status_state_pos	9

/*** WREG definition    ***/
#define WREG_CONFIG_0  0x40
#define WREG_CONFIG_1  0x44
#define WREG_CONFIG_2  0x48
#define WREG_CONFIG_3  0x4C

/*** RREG definition    ***/
#define RREG_CONFIG_0  0x20
#define RREG_CONFIG_1  0x24
#define RREG_CONFIG_2  0x28
#define RREG_CONFIG_3  0x2C

/***-------Configuraiton register*/
/*** Control Register  */
#define CTRL1_XL	0x10
#define CTRL2_G		0x11
#define CTRL3_C		0x12
#define CTRL4_C		0x13
#define CTRL5_C		0x14
#define CTRL6_C		0x15
#define CTRL7_G		0x16
#define CTRL8_XL	0x17
#define CTRL9_XL	0x18
#define CTRL10_C	0x19

/*** Who am I Register  */
#define WHO_AM_I	0x0F

#define BDU 1<<6

/***-------End of configuraiton register 1 */


/*** OP mode***/
#define CPU_WREG	0
#define CPU_RREG	1
#define HW		    2

#define True 1
#define False 0

static alt_u32 dly_cnt = 0, number = 5000;

/***********high level definition */
void init_ASM330LHHX()
{
	/*** configure the ADXL355/357 ***/
	I2C_clock_rate_sel_ASM330LHHX(CLK_390K);
	/*** set ASM330LHHX parameters ***/
	I2C_read_ASM330LHHX_register(CTRL3_C, 1);
	I2C_write_ASM330LHHX_register(CTRL3_C, BDU);
	I2C_read_ASM330LHHX_register(WHO_AM_I, 1);
	// I2C_read_ASM330LHHX_register(RREG_CONFIG_0, 1);
	// I2C_write_ASM330LHHX_register(WREG_CONFIG_1, DR_20_40|MODE_NORMAL|CM_SINGLE_SHOT|VREF_INTERNAL|TS_DISABLE);
	// I2C_read_ASM330LHHX_register(RREG_CONFIG_1, 1);
	// I2C_read_ASM330LHHX_register(RREG_CONFIG_2, 1);
	// I2C_read_ASM330LHHX_register(RREG_CONFIG_3, 1);
	// setting mode 
	// I2C_op_mode_sel_ASM330LHHX(HW);
	// Set I2C device address
	// I2C_set_device_addr_ASM330LHHX(I2C_DEV_ADDR);
	// test_ADS122C04();
}



void read_ASM330LHHX()
{
	float gx, gy, gz, ax, ay, az, temp;

	// setting mode 
	I2C_op_mode_sel_ASM330LHHX(HW);
	// Set I2C device address
	I2C_set_device_addr_ASM330LHHX(I2C_DEV_ADDR);

	gx = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_1);
	gy = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_2);
	gz = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_3);
	ax = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_4);
	ay = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_5);
	az = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_6);
	temp = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_7);

//	printf("%f, %f, %f\n", ax, ay, az);
	// uart_printf("%f\n", ain0);
	// uart_printf("%f, %f\n", ain0, ain1);
	// uart_printf("%f, %f, %f\n", ain0, ain1, ain2);
	// DEBUG_PRINT("%f, %f, %f, %f\n", ain0, ain1, ain2, ain3);
	// uart_printf("%f, %f, %f, %f\n", ain0, ain1, ain2, ain3);
}

/***********mid level definition */

void I2C_sm_start_ASM330LHHX()
{
	alt_u8 dly = 50;

	I2C_sm_set_enable_ASM330LHHX();
	while(dly--){}
	I2C_sm_set_disable_ASM330LHHX();
}

void I2C_op_mode_sel_ASM330LHHX(alt_u8 mode)
{
	alt_32 old = IORD(VARSET_BASE, O_VAR_I2C_CTRL);

	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, (old & 0xFFFFFFF1) | (mode<<ctrl_op_mode_pos));
}

void I2C_clock_rate_sel_ASM330LHHX(alt_u8 rate)
{
	alt_32 old = IORD(VARSET_BASE, O_VAR_I2C_CTRL);

	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, (old & 0xFFFFFF8F) | (rate<<ctrl_clk_rate_pos));
}

void I2C_write_ASM330LHHX_register(alt_u8 reg_addr, alt_u8 data)
{
	// setting mode to cpu write register
	I2C_op_mode_sel_ASM330LHHX(CPU_WREG);
	// Set I2C device address
	I2C_set_device_addr_ASM330LHHX(I2C_DEV_ADDR);
	// Set the target register address for read or write operations
	IOWR(VARSET_BASE, O_VAR_REG_ADDR, reg_addr);

	// Set the data value to be written to the target register
	IOWR(VARSET_BASE, O_VAR_W_DATA, data);
	// start the I2C SM 
	I2C_sm_start_ASM330LHHX();
	// Wait for the I2C SM to complete the operation
	while( !I2C_sm_read_finish_ASM330LHHX()){}
}

alt_u8 I2C_read_ASM330LHHX_register(alt_u8 reg_addr, alt_u8 print)
{
	alt_u8 rt;

	// setting mode to cpu read register
	I2C_op_mode_sel_ASM330LHHX(CPU_RREG);
	// Set I2C device address
	I2C_set_device_addr_ASM330LHHX(I2C_DEV_ADDR);
	// Set the target register address for read or write operations
	IOWR(VARSET_BASE, O_VAR_REG_ADDR, reg_addr);

	// start the I2C SM 
	I2C_sm_start_ASM330LHHX();
	// Wait for the I2C SM to complete the operation
	while( !I2C_sm_read_finish_ASM330LHHX()){}
	// Retrieve the data read from the specified register
	rt = IORD(VARSET_BASE, O_VAR_I2C_RDATA_1);
	// Print the register address and its read value if 'print' is enabled
	if(print) 	DEBUG_PRINT("reg:%x, value:%x\n", reg_addr, rt);
	if(print) 	printf("reg:%x, value:%x\n", reg_addr, rt);

	return rt;
}

void I2C_set_device_addr_ASM330LHHX(alt_u8 dev)
{
	IOWR(VARSET_BASE, O_VAR_DEV_ADDR, dev);
}

/***********low level definition */

/*** Set the bit value at the spcified position without altering the values at other positions. */
 alt_u32 set_bit_safe_ASM330LHHX(alt_u32 old_addr,  alt_u8 pos)
{
	// First, read the register value.
	alt_u32 old = IORD(VARSET_BASE, old_addr);

	// Returns the register value with the bit set at the specified position.
	return (old | (alt_32)(1<<pos)); 
}

/*** Clear the bit value at the spcified position without altering the values at other positions. */
 alt_u32 clear_bit_safe_ASM330LHHX(alt_u32 old_addr,  alt_u8 pos)
{
	// First, read the register value.
	alt_u32 old = IORD(VARSET_BASE, old_addr);

	// Returns the register value with the bit cleared at the specified position.
	return (old & ~((alt_32)(1<<pos))); 
}

/*** Starts the state machine when it is in the IDLE state. */
 void I2C_sm_set_enable_ASM330LHHX()
{
	IOWR(VARSET_BASE, O_VAR_I2C_CTRL,  set_bit_safe_ASM330LHHX(O_VAR_I2C_CTRL, ctrl_en_pos));
}

 void I2C_sm_set_disable_ASM330LHHX()
{
	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, clear_bit_safe_ASM330LHHX(O_VAR_I2C_CTRL, ctrl_en_pos) );
}

//  void I2C_set_read_mode_ASM330LHHX()
// {
// 	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, set_bit_safe_ASM330LHHX(O_VAR_I2C_CTRL, ctrl_rw_reg_pos));
// }

//  void I2C_set_write_mode_ASM330LHHX()
// {
// 	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, clear_bit_safe_ASM330LHHX(O_VAR_I2C_CTRL, ctrl_rw_reg_pos));
// }


/*** Returns High when the state machine has finished. */
 alt_u8 I2C_sm_read_finish_ASM330LHHX()
{
	alt_u8 finish=0;

	finish = (alt_u8)(IORD(VARSET_BASE, O_VAR_I2C_STATUS)>>status_finish_pos) & 0x01;

	return finish;
}
