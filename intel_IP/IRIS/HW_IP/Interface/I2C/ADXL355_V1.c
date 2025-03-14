#include <stdio.h>
#include <unistd.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"

#define VARSET_BASE VARSET_1_BASE


/******** SYNC rate definition*********/
#define SYNC_100Hz 	250000
#define SYNC_200Hz 	125000
#define SYNC_400Hz 	62500
#define SYNC_800Hz 	31250
#define SYNC_1000Hz 2500

/******** I2C lock rate definition*********/
#define CLK_390K 	 7
#define CLK_781K 	 6
#define CLK_1562K 	 5
#define CLK_3125K 	 4

/******** VAR Register*********/
#define	O_VAR_DEV_ADDR		0
#define O_VAR_W_DATA		1
#define O_VAR_I2C_CTRL		2
#define O_VAR_SYNC_PER		3
#define O_VAR_REG_ADDR		4
#define var_sync_count 		59
#define O_VAR_I2C_STATUS	60 + 0
#define O_VAR_I2C_RDATA_1	60 + 1
#define O_VAR_I2C_RDATA_2	60 + 2
#define O_VAR_I2C_RDATA_3	60 + 3
#define O_VAR_I2C_RDATA_4	60 + 4
#define O_VAR_I2C_RDATA_5	60 + 5
#define O_VAR_I2C_RDATA_6	60 + 6
#define O_VAR_I2C_RDATA_7	60 + 7
#define O_VAR_I2C_RDATA_8	60 + 8
#define O_VAR_I2C_RDATA_9	60 + 9
#define O_VAR_I2C_RDATA_10	60 + 10
#define O_VAR_I2C_RDATA_11	60 + 11

#define I2C_READ			0x1
#define I2C_WRITE			0x0

/**** CTRL ******/
#define ctrl_en_pos			0
#define ctrl_rw_reg_pos		1
#define ctrl_op_mode_pos 	2
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

/***ADXL357 ***/
#define SENS_10G 19.5e-6
#define SENS_20G 39e-6
#define SENS_40G 78e-6
/***ADXL355 ***/
#define SENS_2G 3.9e-6
#define SENS_4G 7.8e-6
#define SENS_8G 15.6e-6


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
#define CPU_1	0
#define CPU_11	1
#define HW_11	2

#define True 1
#define False 0

void IRQ_TRIGGER_ISR(void *context);
void TRIGGER_IRQ_init(void);
void update_IRIS_config_to_HW_REG(void);

/*** high level declaration */
void I2C_read_357_CPU11(alt_u8 reg_addr);
void init_ADXL355(void);
void read_355_temp(void);
void print_11_reg(void);
void print_9_reg(void);

/*** mid level declaration */
void I2C_sm_start();
void I2C_op_mode_sel(alt_u8 mode);
void I2C_clock_rate_sel(alt_u8 rate);
void I2C_write_357_register(alt_u8 reg_addr, alt_u8 data);
alt_u8 I2C_read_357_register(alt_u8 reg_addr, alt_u8 print);

/*** low level declaration */
void I2C_sm_set_enable(void);
void I2C_sm_set_disable(void);
void I2C_set_write_mode(void);
void I2C_set_read_mode(void);
alt_u8 I2C_sm_read_finish(void);
alt_u32 set_bit_safe(alt_u32 old_addr,  alt_u8 pos);
alt_u32 clear_bit_safe(alt_u32 old_addr,  alt_u8 pos);

alt_u8 trigger_sig = 0;


int main()
{
  printf("Hello from Nios II!\n");
  update_IRIS_config_to_HW_REG();
  TRIGGER_IRQ_init(); // register EXTT interrupt

  init_ADXL355();
  
  while(1){
	  if(trigger_sig==1) {
		  trigger_sig = 0;
//		  printf("1\n");
//		  print_11_reg();
//		  read_355_temp();
		  print_9_reg();
	  }


  }
  return 0;
}



void init_ADXL355()
{
//	IOWR(VARSET_BASE, O_VAR_SYNC_PER, SYNC_100Hz);

	/*** configure the ADXL355/357 ***/
	I2C_clock_rate_sel(CLK_390K);
	/*** set adxl357 parameters ***/
	I2C_write_357_register(RST_ADDR, POR);
	I2C_write_357_register(RANGE_ADDR, F_MODE | INT_POL_H | RANGE_40G);
	I2C_read_357_register(RANGE_ADDR, 1);
//	I2C_write_357_register(FILTER_ADDR, ODR_500);
//	I2C_read_357_register(FILTER_ADDR);
	I2C_write_357_register(INTERRUPT_ADDR, 0x00);
	I2C_read_357_register(INTERRUPT_ADDR, 1);
	I2C_write_357_register(SYNC_ADDR, EXT_SYNC);
	I2C_read_357_register(SYNC_ADDR, 1);
	I2C_write_357_register(POWER_CTL_ADDR, MEASURE_MODE);
	I2C_read_357_register(POWER_CTL_ADDR, 1); 

	// Set I2C operation mode to read 11 bytes (HW mode 11)
	I2C_op_mode_sel(HW_11);
}

void TRIGGER_IRQ_init()
{
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(TRIGGER_IN_BASE, 1); //clear edge capture register
	IOWR_ALTERA_AVALON_PIO_IRQ_MASK(TRIGGER_IN_BASE, 1); //enable irq mask
	alt_ic_isr_register(
	TRIGGER_IN_IRQ_INTERRUPT_CONTROLLER_ID,
	TRIGGER_IN_IRQ,
	IRQ_TRIGGER_ISR,
	0x0,
	0x0);
}

void IRQ_TRIGGER_ISR(void *context)
{
	(void) context;
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(TRIGGER_IN_BASE, 1); //clear edge capture register
	trigger_sig = 1;
}

void read_355_temp()
{
	alt_u8 H, L;
	float temp;
	H = I2C_read_357_register(TEMP2_ADDR, 0); // 0x06
	L = I2C_read_357_register(TEMP1_ADDR, 0); // 0x06
	temp = ((float)((H<<8)|L)-1885.0)/(-9.05)+25.0;
	printf("%f\n", temp);
}

alt_u8 I2C_read_357_register(alt_u8 reg_addr, alt_u8 print)
{
	alt_u8 rt;

	// setting mode to r/w 1 byte
	I2C_op_mode_sel(CPU_1);
	// Set I2C device address for ADXL355/357 (0x1D)
	IOWR(VARSET_BASE, O_VAR_DEV_ADDR, 0x1D);
	// Set the target register address for read or write operations
	IOWR(VARSET_BASE, O_VAR_REG_ADDR, reg_addr);
	// Set the I2C SM to read mode
	I2C_set_read_mode();
	// start the I2C SM 
	I2C_sm_start();
	// Wait for the I2C SM to complete the operation
	while( !I2C_sm_read_finish()){}
	// Retrieve the data read from the specified register
	rt = IORD(VARSET_BASE, O_VAR_I2C_RDATA_1);
	// Print the register address and its read value if 'print' is enabled
	if(print) 	printf("reg:%x, value:%x\n", reg_addr, rt);

	return rt;
}

void I2C_write_357_register(alt_u8 reg_addr, alt_u8 data)
{
	// setting mode to r/w 1 byte
	I2C_op_mode_sel(CPU_1); 
	// Set I2C device address for ADXL355/357 (0x1D)
	IOWR(VARSET_BASE, O_VAR_DEV_ADDR, 0x1D);
	// Set the target register address for read or write operations
	IOWR(VARSET_BASE, O_VAR_REG_ADDR, reg_addr);
	// set I2C SM to write mode
	I2C_set_write_mode();
	// Set the data value to be written to the target register
	IOWR(VARSET_BASE, O_VAR_W_DATA, data);
	// start the I2C SM 
	I2C_sm_start();
	// Wait for the I2C SM to complete the operation
	while( !I2C_sm_read_finish()){}
}

void I2C_read_357_CPU11(alt_u8 reg_addr)
{
	// Set I2C operation mode to read 11 bytes (CPU mode 11)
	I2C_op_mode_sel(CPU_11);
	// Set I2C device address for ADXL355/357 (0x1D)
	IOWR(VARSET_BASE, O_VAR_DEV_ADDR, 0x1D);
	// Set the starting register address for reading 11 successive registers
	IOWR(VARSET_BASE, O_VAR_REG_ADDR, reg_addr);
	// Set the I2C SM to read mode
	I2C_set_read_mode();
	// start the I2C SM 
	I2C_sm_start();
	// Print data from 11 successive registers of ADXL355/357
	print_11_reg();
}

void print_11_reg()
{
	alt_u8 H, L;
	alt_u8 XH, XM, XL;
	alt_u8 YH, YM, YL;
	alt_u8 ZH, ZM, ZL;
	float temp, accl_x, accl_y, accl_z;

	while( !I2C_sm_read_finish()){}
	H = IORD(VARSET_BASE, O_VAR_I2C_RDATA_1);
	L = IORD(VARSET_BASE, O_VAR_I2C_RDATA_2);
	XH = IORD(VARSET_BASE, O_VAR_I2C_RDATA_3);
	XM = IORD(VARSET_BASE, O_VAR_I2C_RDATA_4);
	XL = IORD(VARSET_BASE, O_VAR_I2C_RDATA_5);
	YH = IORD(VARSET_BASE, O_VAR_I2C_RDATA_6);
	YM = IORD(VARSET_BASE, O_VAR_I2C_RDATA_7);
	YL = IORD(VARSET_BASE, O_VAR_I2C_RDATA_8);
	ZH = IORD(VARSET_BASE, O_VAR_I2C_RDATA_9);
	ZM = IORD(VARSET_BASE, O_VAR_I2C_RDATA_10);
	ZL = IORD(VARSET_BASE, O_VAR_I2C_RDATA_11);

	temp = ((float)((H<<8)|L)-1885.0)/(-9.05)+25.0;
	accl_x = (XH>>7)? ((float)(XH<<12|XM<<4|XL>>4)-1048576.0)*SENS_40G : (float)(XH<<12|XM<<4|XL>>4)*SENS_40G;
	accl_y = (YH>>7)? ((float)(YH<<12|YM<<4|YL>>4)-1048576.0)*SENS_40G : (float)(YH<<12|YM<<4|YL>>4)*SENS_40G;
	accl_z = (ZH>>7)? ((float)(ZH<<12|ZM<<4|ZL>>4)-1048576.0)*SENS_40G : (float)(ZH<<12|ZM<<4|ZL>>4)*SENS_40G;

	printf("%.3f, %.4f, %.4f, %.4f\n", temp, accl_x, accl_y, accl_z);

}

void print_9_reg()
{
	alt_u8 XH, XM, XL;
	alt_u8 YH, YM, YL;
	alt_u8 ZH, ZM, ZL;
	float accl_x, accl_y, accl_z;

	while( !I2C_sm_read_finish()){}
	XH = IORD(VARSET_BASE, O_VAR_I2C_RDATA_1);
	XM = IORD(VARSET_BASE, O_VAR_I2C_RDATA_2);
	XL = IORD(VARSET_BASE, O_VAR_I2C_RDATA_3);
	YH = IORD(VARSET_BASE, O_VAR_I2C_RDATA_4);
	YM = IORD(VARSET_BASE, O_VAR_I2C_RDATA_5);
	YL = IORD(VARSET_BASE, O_VAR_I2C_RDATA_6);
	ZH = IORD(VARSET_BASE, O_VAR_I2C_RDATA_7);
	ZM = IORD(VARSET_BASE, O_VAR_I2C_RDATA_8);
	ZL = IORD(VARSET_BASE, O_VAR_I2C_RDATA_9);

	accl_x = (XH>>7)? ((float)(XH<<12|XM<<4|XL>>4)-1048576.0)*SENS_40G : (float)(XH<<12|XM<<4|XL>>4)*SENS_40G;
	accl_y = (YH>>7)? ((float)(YH<<12|YM<<4|YL>>4)-1048576.0)*SENS_40G : (float)(YH<<12|YM<<4|YL>>4)*SENS_40G;
	accl_z = (ZH>>7)? ((float)(ZH<<12|ZM<<4|ZL>>4)-1048576.0)*SENS_40G : (float)(ZH<<12|ZM<<4|ZL>>4)*SENS_40G;

	printf("%.4f, %.4f, %.4f\n", accl_x, accl_y, accl_z);

}


/***********mid level definition */

void I2C_sm_start()
{
	alt_u8 dly = 50;

	I2C_sm_set_enable();
	while(dly--){}
	I2C_sm_set_disable();
}

void I2C_op_mode_sel(alt_u8 mode)
{
	alt_32 old = IORD(VARSET_BASE, O_VAR_I2C_CTRL);

	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, (old & 0xFFFFFFF3) | (mode<<ctrl_op_mode_pos));
}

void I2C_clock_rate_sel(alt_u8 rate)
{
	alt_32 old = IORD(VARSET_BASE, O_VAR_I2C_CTRL);

	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, (old & 0xFFFFFF8F) | (rate<<ctrl_clk_rate_pos));
}


/***********low level definition */

/*** Set the bit value at the spcified position without altering the values at other positions. */
alt_u32 set_bit_safe(alt_u32 old_addr,  alt_u8 pos)
{
	// First, read the register value.
	alt_u32 old = IORD(VARSET_BASE, old_addr);

	// Returns the register value with the bit set at the specified position.
	return (old | (alt_32)(1<<pos)); 
}

/*** Clear the bit value at the spcified position without altering the values at other positions. */
alt_u32 clear_bit_safe(alt_u32 old_addr,  alt_u8 pos)
{
	// First, read the register value.
	alt_u32 old = IORD(VARSET_BASE, old_addr);

	// Returns the register value with the bit cleared at the specified position.
	return (old & ~((alt_32)(1<<pos))); 
}

/*** Starts the state machine when it is in the IDLE state. */
void I2C_sm_set_enable()
{
	IOWR(VARSET_BASE, O_VAR_I2C_CTRL,  set_bit_safe(O_VAR_I2C_CTRL, ctrl_en_pos));
}

void I2C_sm_set_disable()
{
	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, clear_bit_safe(O_VAR_I2C_CTRL, ctrl_en_pos) );
}

void I2C_set_read_mode()
{
	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, set_bit_safe(O_VAR_I2C_CTRL, ctrl_rw_reg_pos));
}

void I2C_set_write_mode()
{
	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, clear_bit_safe(O_VAR_I2C_CTRL, ctrl_rw_reg_pos));
}


/*** Returns High when the state machine has finished. */
alt_u8 I2C_sm_read_finish()
{
	alt_u8 finish=0;

	finish = (alt_u8)(IORD(VARSET_BASE, O_VAR_I2C_STATUS)>>status_finish_pos) & 0x01;

	return finish;
}

void update_IRIS_config_to_HW_REG()
{
	IOWR(VARSET_BASE, var_sync_count, 5e5);
}


// void I2C_sm_set_enable()
// {
// 	alt_32 old = IORD(VARSET_BASE, O_VAR_I2C_CTRL);
// 	alt_u8 dly = 50;

// 	// IOWR(VARSET_BASE, O_VAR_I2C_CTRL, (old | (alt_32)(1<<ctrl_en_pos)) & ~((alt_32)(1<<ctrl_finish_ack)) );
// 	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, (old | (alt_32)(1<<ctrl_en_pos)) );
// 	while(dly--){}
// 	I2C_sm_set_disable();
// }



// void I2C_sm_set_disable()
// {
// 	alt_32 old = IORD(VARSET_BASE, O_VAR_I2C_CTRL);

// 	// IOWR(VARSET_BASE, O_VAR_I2C_CTRL, (old & ~((alt_32)(1<<ctrl_en_pos))) | (alt_32)(1<<ctrl_finish_ack));
// 	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, (old & ~((alt_32)(1<<ctrl_en_pos))) );
// }



// void I2C_set_read_mode()
// {
// 	alt_32 old = IORD(VARSET_BASE, O_VAR_I2C_CTRL);

// 	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, old | (alt_32)(1<<ctrl_rw_reg_pos));
// }

// void I2C_set_write_mode()
// {
// 	alt_32 old = IORD(VARSET_BASE, O_VAR_I2C_CTRL);

// 	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, old & ~((alt_32)(1<<ctrl_rw_reg_pos)));
// }

// alt_u8 I2C_sm_read_finish()
// {
// 	alt_u8 finish=0;

// 	finish = (alt_u8)(IORD(VARSET_BASE, O_VAR_I2C_STATUS)>>status_finish_pos) & 0x01;

// 	return finish;
// }


