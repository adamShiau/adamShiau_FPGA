#include "ads122c04_se.h"
#define VARSET_BASE VARSET_1_BASE

/******** I2C device address*********/
#define I2C_DEV_ADDR	0x45 // 100_0101

/******** I2C lock rate definition*********/
#define CLK_390K 	 7
#define CLK_781K 	 6
#define CLK_1562K 	 5
#define CLK_3125K 	 4


/******** VAR Register*********/
#define	O_VAR_DEV_ADDR		var_i2c_ads122c04_temp_dev_addr
#define O_VAR_W_DATA		var_i2c_ads122c04_temp_w_data
#define O_VAR_I2C_CTRL		var_i2c_ads122c04_temp_ctrl
#define O_VAR_REG_ADDR		var_i2c_ads122c04_temp_reg_addr
#define O_VAR_I2C_STATUS	var_i2c_ads122c04_temp_status
#define O_VAR_I2C_RDATA_1	var_i2c_ads122c04_temp_rdata_1
#define O_VAR_I2C_RDATA_2	var_i2c_ads122c04_temp_rdata_2
#define O_VAR_I2C_RDATA_3	var_i2c_ads122c04_temp_rdata_3
#define O_VAR_I2C_RDATA_4	var_i2c_ads122c04_temp_rdata_4

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

/***-------Configuraiton register 1 */
/*** Data Rate  */
#define DR_20_40		0x00
#define DR_45_90		0x20
#define DR_90_180		0x40
#define DR_175_350		0x60
#define DR_330_660		0x80
#define DR_600_1200		0xA0
#define DR_1000_2000	0xC0

/*** Operating mode  */
#define MODE_NORMAL		0x00 
#define MODE_TURBO		0x10 

/*** Conversion mode  */
#define CM_SINGLE_SHOT		0x00 
#define CM_CONTINUOUS		0x08 

/*** Voltage reference selection  */
#define VREF_INTERNAL		0x00
#define VREF_EXTERNAL		0x02
#define VREF_ANALOG_SUPPLY  0x04

/*** Temperature sensor mode  */
#define TS_DISABLE		0x00
#define TS_ENABLE		0x01
/***-------End of configuraiton register 1 */


/*** OP mode***/
#define CPU_WREG	0
#define CPU_RREG	1
#define HW		    2

#define True 1
#define False 0

/***********high level definition */
void init_ADS122C04_TEMP()
{
	/*** configure the ADXL355/357 ***/
	I2C_clock_rate_sel_ADS122C04_TEMP(CLK_390K);
	/*** set adxl357 parameters ***/
	// I2C_write_ADS122C04_TEMP_register(RST_ADDR, POR);
	I2C_read_ADS122C04_TEMP_register(RREG_CONFIG_0, 1);
	I2C_write_ADS122C04_TEMP_register(WREG_CONFIG_1, DR_330_660|MODE_NORMAL|CM_SINGLE_SHOT|VREF_INTERNAL|TS_DISABLE);
	I2C_read_ADS122C04_TEMP_register(RREG_CONFIG_1, 1);
	I2C_read_ADS122C04_TEMP_register(RREG_CONFIG_2, 1);
	I2C_read_ADS122C04_TEMP_register(RREG_CONFIG_3, 1);
}

void read_ADS122C04_TEMP()
{
	float ain0, ain1, ain2, ain3;

	// setting mode 
	I2C_op_mode_sel_ADS122C04_TEMP(HW);
	// Set I2C device address
	I2C_set_device_addr_ADS122C04_TEMP(I2C_DEV_ADDR);

	ain0 = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_1)*2.048/8388608.0;
	ain1 = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_2)*2.048/8388608.0;
	ain2 = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_3)*2.048/8388608.0;
	ain3 = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_4)*2.048/8388608.0;

//	printf("%f, %f, %f\n", ax, ay, az);
	uart_printf("%f, %f, %f, %f\n", ain0, ain1, ain2, ain3);
}

/***********mid level definition */

void I2C_sm_start_ADS122C04_TEMP()
{
	alt_u8 dly = 50;

	I2C_sm_set_enable_ADS122C04_TEMP();
	while(dly--){}
	I2C_sm_set_disable_ADS122C04_TEMP();
}

void I2C_op_mode_sel_ADS122C04_TEMP(alt_u8 mode)
{
	alt_32 old = IORD(VARSET_BASE, O_VAR_I2C_CTRL);

	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, (old & 0xFFFFFFF1) | (mode<<ctrl_op_mode_pos));
}

void I2C_clock_rate_sel_ADS122C04_TEMP(alt_u8 rate)
{
	alt_32 old = IORD(VARSET_BASE, O_VAR_I2C_CTRL);

	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, (old & 0xFFFFFF8F) | (rate<<ctrl_clk_rate_pos));
}

void I2C_write_ADS122C04_TEMP_register(alt_u8 reg_addr, alt_u8 data)
{
	// setting mode to cpu write register
	I2C_op_mode_sel_ADS122C04_TEMP(CPU_WREG);
	// Set I2C device address
	I2C_set_device_addr_ADS122C04_TEMP(I2C_DEV_ADDR);
	// Set the target register address for read or write operations
	IOWR(VARSET_BASE, O_VAR_REG_ADDR, reg_addr);

	// Set the data value to be written to the target register
	IOWR(VARSET_BASE, O_VAR_W_DATA, data);
	// start the I2C SM 
	I2C_sm_start_ADS122C04_TEMP();
	// Wait for the I2C SM to complete the operation
	while( !I2C_sm_read_finish_ADS122C04_TEMP()){}
}

alt_u8 I2C_read_ADS122C04_TEMP_register(alt_u8 reg_addr, alt_u8 print)
{
	alt_u8 rt;

	// setting mode to cpu read register
	I2C_op_mode_sel_ADS122C04_TEMP(CPU_RREG);
	// Set I2C device address
	I2C_set_device_addr_ADS122C04_TEMP(I2C_DEV_ADDR);
	// Set the target register address for read or write operations
	IOWR(VARSET_BASE, O_VAR_REG_ADDR, reg_addr);

	// start the I2C SM 
	I2C_sm_start_ADS122C04_TEMP();
	// Wait for the I2C SM to complete the operation
	while( !I2C_sm_read_finish_ADS122C04_TEMP()){}
	// Retrieve the data read from the specified register
	rt = IORD(VARSET_BASE, O_VAR_I2C_RDATA_1);
	// Print the register address and its read value if 'print' is enabled
	if(print) 	INFO_PRINT("reg:%x, value:%x\n", reg_addr, rt);

	return rt;
}

void I2C_set_device_addr_ADS122C04_TEMP(alt_u8 dev)
{
	IOWR(VARSET_BASE, O_VAR_DEV_ADDR, dev);
}

/***********low level definition */

/*** Set the bit value at the spcified position without altering the values at other positions. */
 alt_u32 set_bit_safe_ADS122C04_TEMP(alt_u32 old_addr,  alt_u8 pos)
{
	// First, read the register value.
	alt_u32 old = IORD(VARSET_BASE, old_addr);

	// Returns the register value with the bit set at the specified position.
	return (old | (alt_32)(1<<pos)); 
}

/*** Clear the bit value at the spcified position without altering the values at other positions. */
 alt_u32 clear_bit_safe_ADS122C04_TEMP(alt_u32 old_addr,  alt_u8 pos)
{
	// First, read the register value.
	alt_u32 old = IORD(VARSET_BASE, old_addr);

	// Returns the register value with the bit cleared at the specified position.
	return (old & ~((alt_32)(1<<pos))); 
}

/*** Starts the state machine when it is in the IDLE state. */
 void I2C_sm_set_enable_ADS122C04_TEMP()
{
	IOWR(VARSET_BASE, O_VAR_I2C_CTRL,  set_bit_safe_ADS122C04_TEMP(O_VAR_I2C_CTRL, ctrl_en_pos));
}

 void I2C_sm_set_disable_ADS122C04_TEMP()
{
	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, clear_bit_safe_ADS122C04_TEMP(O_VAR_I2C_CTRL, ctrl_en_pos) );
}

//  void I2C_set_read_mode_ADS122C04_TEMP()
// {
// 	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, set_bit_safe_ADS122C04_TEMP(O_VAR_I2C_CTRL, ctrl_rw_reg_pos));
// }

//  void I2C_set_write_mode_ADS122C04_TEMP()
// {
// 	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, clear_bit_safe_ADS122C04_TEMP(O_VAR_I2C_CTRL, ctrl_rw_reg_pos));
// }


/*** Returns High when the state machine has finished. */
 alt_u8 I2C_sm_read_finish_ADS122C04_TEMP()
{
	alt_u8 finish=0;

	finish = (alt_u8)(IORD(VARSET_BASE, O_VAR_I2C_STATUS)>>status_finish_pos) & 0x01;

	return finish;
}
