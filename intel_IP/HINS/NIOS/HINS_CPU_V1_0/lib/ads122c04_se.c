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
#define	O_VAR_DEV_ADDR		var_i2c_ads122c04_dev_addr
#define O_VAR_W_DATA		var_i2c_ads122c04_w_data
#define O_VAR_I2C_CTRL		var_i2c_ads122c04_ctrl
#define O_VAR_REG_ADDR		var_i2c_ads122c04_reg_addr
#define O_VAR_I2C_STATUS	i_var_i2c_ads122c04_status
#define O_VAR_I2C_RDATA_1	i_var_i2c_ads122c04_rdata_1
#define O_VAR_I2C_RDATA_2	i_var_i2c_ads122c04_rdata_2
#define O_VAR_I2C_RDATA_3	i_var_i2c_ads122c04_rdata_3
#define O_VAR_I2C_RDATA_4	i_var_i2c_ads122c04_rdata_4


#define I2C_READ			0x1
#define I2C_WRITE			0x0

/**** CTRL ******/
#define ctrl_en_pos			0
// #define ctrl_rw_reg_pos		1
#define ctrl_op_mode_pos 	1
#define ctrl_clk_rate_pos	4
#define ctrl_finish_clear_pos	7

/**** STATUS ******/
#define status_ready_pos	0
#define status_finish_pos	1
#define status_state_pos	9

/**** RESET ******/
#define RESET	0x06

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

/***-------Configuraiton register */
// register 0 parameters
/*** MUX  */
#define MUX_AIN0_AVSS 	(8<<4)
/*** GAIN  */
#define GAIN_1		0
#define GAIN_2		(1<<1)
#define GAIN_4		(2<<1)
#define GAIN_8		(3<<1)
#define GAIN_16		(4<<1)
#define GAIN_32		(5<<1)
#define GAIN_64		(6<<1)
#define GAIN_128	(7<<1)
/*** PGA_BYPASS  */
#define PGA_ENABLE	0
#define PGA_DISABLE	1

// register 1 parameters
/*** Data Rate  */
#define DR_20_40		0
#define DR_45_90		(1<<5)
#define DR_90_180		(2<<5)
#define DR_175_350		(3<<5)
#define DR_330_660		(4<<5)
#define DR_600_1200		(5<<5)
#define DR_1000_2000	(6<<5)
/*** Operating mode  */
#define MODE_NORMAL		0
#define MODE_TURBO		(1<<4) 
/*** Conversion mode  */
#define CM_SINGLE_SHOT		0
#define CM_CONTINUOUS		(1<<3) 
/*** Voltage reference selection  */
#define VREF_INTERNAL		0
#define VREF_EXTERNAL		(1<<1) 
#define VREF_ANALOG_SUPPLY  (2<<1) 
/*** Temperature sensor mode  */
#define TS_DISABLE		0
#define TS_ENABLE		1

// register 2 parameters

/***-------End of configuraiton register 1 */


/*** OP mode***/
#define CPU_WREG	0
#define CPU_RREG	1
#define HW		    2
#define CPU_CMD		3

#define True 1
#define False 0

static alt_u32 dly_cnt = 0, number = 5000;

/***********high level definition */
void init_ADS122C04_TEMP()
{
	/*** configure the ADXL355/357 ***/
	I2C_clock_rate_sel_ADS122C04_TEMP(CLK_390K);

	I2C_sm_set_finish_clear_pulse_ADS122C04_TEMP(); // let finish starts at zero

	/*** RESET ***/
	I2C_write_ADS122C04_TEMP_cmd(RESET);

	/*** set ADS122C04 parameters ***/
	I2C_write_ADS122C04_TEMP_register(WREG_CONFIG_0, MUX_AIN0_AVSS|GAIN_1|PGA_DISABLE);
	I2C_read_ADS122C04_TEMP_register(RREG_CONFIG_0, 1);
	
	I2C_write_ADS122C04_TEMP_register(WREG_CONFIG_1, DR_1000_2000|MODE_NORMAL|CM_SINGLE_SHOT|VREF_INTERNAL|TS_DISABLE);
	I2C_read_ADS122C04_TEMP_register(RREG_CONFIG_1, 1);

	I2C_write_ADS122C04_TEMP_register(WREG_CONFIG_2, 0x00);
	I2C_read_ADS122C04_TEMP_register(RREG_CONFIG_2, 1);

	I2C_write_ADS122C04_TEMP_register(WREG_CONFIG_3, 0x00);
	I2C_read_ADS122C04_TEMP_register(RREG_CONFIG_3, 1);

	// setting mode 
	// I2C_op_mode_sel_ADS122C04_TEMP(HW);
	// Set I2C device address
	// I2C_set_device_addr_ADS122C04_TEMP(I2C_DEV_ADDR);
	// test_ADS122C04();
}

void test_ADS122C04()
{
	DEBUG_PRINT("testing_ADS122C04\n");
	while(number-- != 0 ) {
		// dly_cnt = 0;
		// while(dly_cnt++ < DLY_NUM_357) {} // delay control
		read_ADS122C04_TEMP();
	}
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
	// uart_printf("%f\n", ain0);
	// uart_printf("%f, %f\n", ain0, ain1);
	// uart_printf("%f, %f, %f\n", ain0, ain1, ain2);
	DEBUG_PRINT("%f, %f, %f, %f\n", ain0, ain1, ain2, ain3);
	// uart_printf("%f, %f, %f, %f\n", ain0, ain1, ain2, ain3);
}

/***********mid level definition */

void I2C_sm_start_ADS122C04_TEMP()
{
	alt_u8 dly = 25;

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

void I2C_write_ADS122C04_TEMP_cmd(alt_u8 reg_addr)
{
	// printf("Start write cmd\n");
	// setting mode to cpu write register
	I2C_op_mode_sel_ADS122C04_TEMP(CPU_CMD);
	// Set I2C device address
	I2C_set_device_addr_ADS122C04_TEMP(I2C_DEV_ADDR);
	// Set the target register address for read or write operations
	IOWR(VARSET_BASE, O_VAR_REG_ADDR, reg_addr);

	// start the I2C SM 
	I2C_sm_start_ADS122C04_TEMP();
	// Wait for the I2C SM to complete the operation
	int timeout = 100000;
	while( !I2C_sm_read_finish_ADS122C04_TEMP() && timeout-- > 0 );
	if (timeout <= 0) {
        printf("ADS122C04 write timeout!\n");
        return;
    }
	I2C_sm_set_finish_clear_pulse_ADS122C04_TEMP();
	// printf("End write cmd\n");
}

void I2C_write_ADS122C04_TEMP_register(alt_u8 reg_addr, alt_u8 data)
{
	// printf("Start write reg\n");
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
	int timeout = 100000;
	while( !I2C_sm_read_finish_ADS122C04_TEMP() && timeout-- > 0 );
	if (timeout <= 0) {
        printf("ADS122C04 write timeout!\n");
        return;
    }
	I2C_sm_set_finish_clear_pulse_ADS122C04_TEMP();
	// printf("End write reg\n");
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

	I2C_sm_set_finish_clear_pulse_ADS122C04_TEMP();

	// Print the register address and its read value if 'print' is enabled
	if(print) 	DEBUG_PRINT("reg:%x, value:%x\n", reg_addr, rt);
	if(print) 	printf("reg:%x, value:%x\n", reg_addr, rt);
	

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

void I2C_sm_set_finish_clear_pulse_ADS122C04_TEMP() 
{
	IOWR(VARSET_BASE, O_VAR_I2C_CTRL,  set_bit_safe(O_VAR_I2C_CTRL, ctrl_finish_clear_pos));
	usleep(1);
	IOWR(VARSET_BASE, O_VAR_I2C_CTRL,  clear_bit_safe(O_VAR_I2C_CTRL, ctrl_finish_clear_pos));
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
