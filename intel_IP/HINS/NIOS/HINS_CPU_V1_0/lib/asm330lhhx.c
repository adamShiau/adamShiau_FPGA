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
#define ctrl_finish_clear_pos	7

/**** STATUS ******/
#define status_ready_pos	0
#define status_finish_pos	1
#define status_state_pos	9

/**** Scale Factor ******/
#define SF_ACCL_2G	0.061e-3
#define SF_ACCL_4G	0.122e-3
#define SF_ACCL_8G	0.244e-3
#define SF_ACCL_16G	0.488e-3

#define SF_GYRO_125DPS	4.37e-3
#define SF_GYRO_250DPS	8.75e-3
#define SF_GYRO_500DPS	17.5e-3
#define SF_GYRO_1000DPS	35e-3
#define SF_GYRO_2000DPS	70e-3
#define SF_GYRO_4000DPS	140e-3

#define SF_TEMP 0.00390625

/***-------Setup register*/
/*** Setup Register: COUNTER_BDR_REG1  */
#define COUNTER_BDR_REG1 0x0B

/*** Enables pulsed data-ready mode  */
#define DATAREADY_PULSED (1<<7)

/*** Setup Register: INT1_CTRL  */
#define INT1_CTRL 0x0D

#define INT1_DRDY_XL 	0
#define INT1_DRDY_G 	(1<<1)

/*** Setup Register: INT2_CTRL  */
#define INT2_CTRL 0x0E

#define INT2_DRDY_TEMP 	(1<<2)


/***-------Configuraiton register*/
/*** Control Register: CTRL1_XL  */
#define CTRL1_XL	0x10
// CTRL1_XL parameters
/***Accelerometer high-resolution selection  */
#define LPF2_XL_EN 	(1<<1)
/***Accelerometer full-scale selection  */
#define ACCL_FS_2G 	0
#define ACCL_FS_16G (1<<2)
#define ACCL_FS_4G 	(2<<2)
#define ACCL_FS_8G 	(3<<2)
/***Accelerometer ODR selection  */
#define ACCL_ODR_416HZ	(6<<4)
#define ACCL_ODR_833HZ	(7<<4)
#define ACCL_ODR_1667HZ	(8<<4)
#define ACCL_ODR_3333HZ	(9<<4)
#define ACCL_ODR_6667HZ	(10<<4)
/*** End of CTRL1_XL  */

/*** Control Register: CTRL2_G  */
#define CTRL2_G		0x11
// CTRL2_G parameters
/***Gyroscope full-scale selection  */
#define GYRO_FS_250DPS	0
#define GYRO_FS_500DPS	(1<<2)
#define GYRO_FS_1000DPS	(2<<2)
#define GYRO_FS_2000DPS	(3<<2)
/***Gyroscope ODR selection  */
#define GYRO_ODR_416HZ	(6<<4)
#define GYRO_ODR_833HZ	(7<<4)
#define GYRO_ODR_1667HZ	(8<<4)
#define GYRO_ODR_3333HZ	(9<<4)
#define GYRO_ODR_6667HZ	(10<<4)
/*** End of CTRL2_G  */

/*** Control Register: CTRL3_C  */
#define CTRL3_C		0x12

/***Block data update  */
#define BDU (1<<6)
/***Register address automatically incremented during a multiple byte access with a serial interface  */
#define IF_INC (1<<2)
/*** End of CTRL3_C  */

/*** Control Register: CTRL4_C  */
#define CTRL4_C		0x13

/***Enables all interrupt signals available on the INT1 pin  */
#define INT2_ON_INT1 (1<<5)

/***Enables gyroscope digital LPF1; the bandwidth can be selected through FTYPE[2:0] in CTRL6_C   */
#define LPF1_SEL_G (1<<1)

/*** End of CTRL4_C  */

/*** Control Register: CTRL5_C  */
#define CTRL5_C		0x14
/*** End of CTRL5_C  */

/*** Control Register: CTRL6_C  */
#define CTRL6_C		0x15

/*** Gyroscope low-pass filter (LPF1) bandwidth selection  */
#define LPF1_FTYPE_0 0
#define LPF1_FTYPE_1 1
#define LPF1_FTYPE_2 2
#define LPF1_FTYPE_3 3
#define LPF1_FTYPE_4 4
#define LPF1_FTYPE_5 5
#define LPF1_FTYPE_6 6
#define LPF1_FTYPE_7 7

/*** End of CTRL6_C  */

/*** Control Register: CTRL7_G  */
#define CTRL7_G		0x16
/*** End of CTRL7_G  */

/*** Control Register: CTRL8_XL  */
#define CTRL8_XL	0x17
/*** Accelerometer LPF2 and HP filter configuration and cutoff setting  */
#define HPCF_XL_0 0			// LPF = ODR/4
#define HPCF_XL_1 (1<<5)	// LPF = ODR/10
#define HPCF_XL_2 (2<<5)	// LPF = ODR/20
#define HPCF_XL_3 (3<<5)	// LPF = ODR/45
#define HPCF_XL_4 (4<<5)	// LPF = ODR/100
#define HPCF_XL_5 (5<<5)	// LPF = ODR/200
#define HPCF_XL_6 (6<<5)	// LPF = ODR/400
#define HPCF_XL_7 (7<<5)	// LPF = ODR/800
/*** End of CTRL8_XL  */

#define CTRL9_XL	0x18
#define CTRL10_C	0x19

/*** Who am I Register  */
#define WHO_AM_I	0x0F



/***-------End of configuraiton register 1 */


/*** OP mode***/
#define CPU_WREG	0
#define CPU_RREG	1
#define HW		    2

#define True 1
#define False 0

static alt_u32 dly_cnt = 0, number = 5000;
static const DELAY_NUM = 100000;

/***********high level definition */
void init_ASM330LHHX()
{
	/*** configure the ADXL355/357 ***/
	I2C_clock_rate_sel_ASM330LHHX(CLK_390K);
	/*** set ASM330LHHX parameters ***/

	I2C_read_ASM330LHHX_register(WHO_AM_I, 1);

	I2C_write_ASM330LHHX_register(CTRL1_XL, ACCL_FS_16G|ACCL_ODR_416HZ|LPF2_XL_EN, 1);
	I2C_read_ASM330LHHX_register(CTRL1_XL, 1);

	I2C_write_ASM330LHHX_register(CTRL2_G, GYRO_FS_1000DPS|GYRO_ODR_416HZ, 1);
	I2C_read_ASM330LHHX_register(CTRL2_G, 1);

	I2C_write_ASM330LHHX_register(CTRL3_C, BDU|IF_INC, 1);
	I2C_read_ASM330LHHX_register(CTRL3_C, 1);

	I2C_write_ASM330LHHX_register(CTRL4_C, INT2_ON_INT1|LPF1_SEL_G, 1);
	I2C_read_ASM330LHHX_register(CTRL4_C, 1);

	I2C_write_ASM330LHHX_register(CTRL6_C, LPF1_FTYPE_0, 1); // GYRO BW = 133 Hz @416Hz ODR
	I2C_read_ASM330LHHX_register(CTRL6_C, 1);

	I2C_write_ASM330LHHX_register(CTRL8_XL, HPCF_XL_0, 1); // ACCL BW = 104 Hz @416Hz ODR
	I2C_read_ASM330LHHX_register(CTRL8_XL, 1);

	I2C_write_ASM330LHHX_register(COUNTER_BDR_REG1, DATAREADY_PULSED, 1);
	I2C_read_ASM330LHHX_register(COUNTER_BDR_REG1, 1);

	I2C_write_ASM330LHHX_register(INT1_CTRL, INT1_DRDY_XL|INT1_DRDY_G, 1);
	I2C_read_ASM330LHHX_register(INT1_CTRL, 1);

	I2C_write_ASM330LHHX_register(INT2_CTRL, INT2_DRDY_TEMP, 1);
	I2C_read_ASM330LHHX_register(INT2_CTRL, 1);

	test_ASM330LHHX();

	// setting mode 
	I2C_op_mode_sel_ASM330LHHX(HW);
	// Set I2C device address
	I2C_set_device_addr_ASM330LHHX(I2C_DEV_ADDR);
}

void test_ASM330LHHX()
{
	DEBUG_PRINT("testing_ASM330LHHX\n");
	while(number-- != 0 ) {
		while(dly_cnt++ < DELAY_NUM) {} // delay control
		dly_cnt = 0;
		read_ASM330LHHX();
	}

	
}

void read_ASM330LHHX()
{
	float gx, gy, gz, ax, ay, az, temp;

	// setting mode 
	I2C_op_mode_sel_ASM330LHHX(HW);
	// Set I2C device address
	I2C_set_device_addr_ASM330LHHX(I2C_DEV_ADDR);

	gx = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_1) * SF_GYRO_1000DPS;
	gy = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_2) * SF_GYRO_1000DPS;
	gz = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_3) * SF_GYRO_1000DPS;
	ax = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_4) * SF_ACCL_16G;
	ay = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_5) * SF_ACCL_16G;
	az = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_6) * SF_ACCL_16G;
	temp = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_7) * SF_TEMP + 25.0;

	// printf("%f, %f, %f, %f, %f, %f, %f\n", gx, gy, gz, ax, ay, az, temp);
	DEBUG_PRINT("%f, %f, %f, %f, %f, %f, %f\n", gx, gy, gz, ax, ay, az, temp);
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

void I2C_write_ASM330LHHX_register(alt_u8 reg_addr, alt_u8 data, alt_u8 print)
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
	int timeout = 100000;
	while( !I2C_sm_read_finish_ASM330LHHX() && timeout-- > 0 );
	if (timeout <= 0) {
        printf("ASM330LHHX write timeout!\n");
        return;
    }
	I2C_sm_set_finish_clear_pulse_ASM330LHHX();
	if(print) 	printf("write reg:%x, value:%x\n", reg_addr, data);
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

	I2C_sm_set_finish_clear_pulse_ASM330LHHX();

	// Print the register address and its read value if 'print' is enabled
	if(print) 	DEBUG_PRINT("reg:%x, value:%x\n", reg_addr, rt);
	if(print) 	printf("read reg:%x, value:%x\n", reg_addr, rt);

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

void I2C_sm_set_finish_clear_pulse_ASM330LHHX() 
{
	IOWR(VARSET_BASE, O_VAR_I2C_CTRL,  set_bit_safe(O_VAR_I2C_CTRL, ctrl_finish_clear_pos));
	usleep(1);
	IOWR(VARSET_BASE, O_VAR_I2C_CTRL,  clear_bit_safe(O_VAR_I2C_CTRL, ctrl_finish_clear_pos));
}


/*** Returns High when the state machine has finished. */
 alt_u8 I2C_sm_read_finish_ASM330LHHX()
{
	alt_u8 finish=0;

	finish = (alt_u8)(IORD(VARSET_BASE, O_VAR_I2C_STATUS)>>status_finish_pos) & 0x01;

	return finish;
}
