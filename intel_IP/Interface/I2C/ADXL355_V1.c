/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"

/******** VAR Register*********/
#define	O_VAR_DEV_ADDR		0
#define O_VAR_W_DATA		1
#define O_VAR_I2C_CTRL		2
//#define O_VAR_I2C_RW		3
#define O_VAR_REG_ADDR		4
#define O_VAR_I2C_STATUS	25 + 0
#define O_VAR_I2C_RDATA_1	25 + 1
#define O_VAR_I2C_RDATA_2	25 + 2
#define O_VAR_I2C_RDATA_3	25 + 3
#define O_VAR_I2C_RDATA_4	25 + 4
#define O_VAR_I2C_RDATA_5	25 + 5
#define O_VAR_I2C_RDATA_6	25 + 6
#define O_VAR_I2C_RDATA_7	25 + 7
#define O_VAR_I2C_RDATA_8	25 + 8
#define O_VAR_I2C_RDATA_9	25 + 9
#define O_VAR_I2C_RDATA_10	25 + 10
#define O_VAR_I2C_RDATA_11	25 + 11

#define I2C_READ			0x1
#define I2C_WRITE			0x0

/**** CTRL ******/
#define ctrl_en_pos			0
#define ctrl_rw_reg_pos		1
#define ctrl_op_mode_pos 	2
#define ctrl_finish_ack 	4

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


#define SENS_10G 0.0000195
#define SENS_20G 0.000039
#define SENS_40G 0.000078

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

void IRQ_TRIGGER_ISR(void);
void TRIGGER_IRQ_init(void);
alt_u8 I2C_read_357(alt_u8 reg_addr);
void I2C_read_357_CPU11(alt_u8 reg_addr);
void I2C_write_357(alt_u8 reg_addr, alt_u8 data);
void init_ADXL355(void);
void ADXL355_enable(void);
void ADXL355_disable(void);
void ADXL355_write(void);
void ADXL355_read(void);
void read_355_temp();
void ADXL355_read_mode_sel(alt_u8 mode);
alt_u8 read_ADXL355_finish(void);

alt_u8 isr_flag = 0;

int main()
{
  printf("Hello from Nios II!\n");
  TRIGGER_IRQ_init(); // register EXTT interrupt
  ADXL355_disable();
  init_ADXL355();
  while(1){
//	while( !read_ADXL355_finish()){}
//	printf("rd1:%x\n", IORD(VARSET_BASE, O_VAR_I2C_RDATA_1));
//	printf("rd2:%x\n", IORD(VARSET_BASE, O_VAR_I2C_RDATA_2));
//	printf("rd3:%x\n", IORD(VARSET_BASE, O_VAR_I2C_RDATA_3));
//	printf("rd4:%x\n", IORD(VARSET_BASE, O_VAR_I2C_RDATA_4));
//	printf("rd5:%x\n", IORD(VARSET_BASE, O_VAR_I2C_RDATA_5));
//	printf("rd6:%x\n", IORD(VARSET_BASE, O_VAR_I2C_RDATA_6));
//	printf("rd7:%x\n", IORD(VARSET_BASE, O_VAR_I2C_RDATA_7));
//	printf("rd8:%x\n", IORD(VARSET_BASE, O_VAR_I2C_RDATA_8));
//	printf("rd9:%x\n", IORD(VARSET_BASE, O_VAR_I2C_RDATA_9));
//	printf("rd10:%x\n", IORD(VARSET_BASE, O_VAR_I2C_RDATA_10));
//	printf("rd11:%x\n", IORD(VARSET_BASE, O_VAR_I2C_RDATA_11));
  }

  return 0;
}

alt_u8 read_ADXL355_finish()
{
	alt_u8 finish=0;

	finish = (alt_u8)(IORD(VARSET_BASE, O_VAR_I2C_STATUS)>>status_finish_pos) & 0x01;

	return finish;
}

void ADXL355_enable()
{
	alt_32 old = IORD(VARSET_BASE, O_VAR_I2C_CTRL);

	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, (old | (alt_32)(1<<ctrl_en_pos)) & ~((alt_32)(1<<ctrl_finish_ack)) );
}

void ADXL355_disable()
{
	alt_32 old = IORD(VARSET_BASE, O_VAR_I2C_CTRL);

	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, (old & ~((alt_32)(1<<ctrl_en_pos))) | (alt_32)(1<<ctrl_finish_ack));
}

void ADXL355_read()
{
	alt_32 old = IORD(VARSET_BASE, O_VAR_I2C_CTRL);

	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, old | (alt_32)(1<<ctrl_rw_reg_pos));
}

void ADXL355_write()
{
	alt_32 old = IORD(VARSET_BASE, O_VAR_I2C_CTRL);

	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, old & ~((alt_32)(1<<ctrl_rw_reg_pos)));
}

void ADXL355_read_mode_sel(alt_u8 mode)
{
	alt_32 old = IORD(VARSET_BASE, O_VAR_I2C_CTRL);

	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, (old & 0xFFFFFFF3) | (mode<<ctrl_op_mode_pos));
}

void init_ADXL355()
{

	/*** set adxl357 parameters ***/
	I2C_write_357(RST_ADDR, POR);
	I2C_write_357(RANGE_ADDR, F_MODE | INT_POL_H | RANGE_40G);
	I2C_read_357(RANGE_ADDR);
//	I2C_write_357(FILTER_ADDR, ODR_500);
//	I2C_read_357(FILTER_ADDR);
	I2C_write_357(INTERRUPT_ADDR, 0x00);
	I2C_read_357(INTERRUPT_ADDR);
	I2C_write_357(SYNC_ADDR, EXT_SYNC);
	I2C_read_357(SYNC_ADDR);
	I2C_write_357(POWER_CTL_ADDR, MEASURE_MODE);
	I2C_read_357(POWER_CTL_ADDR);
//	usleep(10);
//	ADXL355_read_mode_sel(HW_11);
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

void IRQ_TRIGGER_ISR()
{
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(TRIGGER_IN_BASE, 1); //clear edge capture register
	printf("IRQ\n");
	read_355_temp();
//	I2C_read_357_CPU11(TEMP2_ADDR);

//	I2C_read_357(TEMP2_ADDR); // 0x06
//	I2C_read_357(TEMP1_ADDR); // 0x07
}

void read_355_temp()
{
	alt_u8 H, L;
	float temp;
	H = I2C_read_357(TEMP2_ADDR); // 0x06
	L = I2C_read_357(TEMP1_ADDR); // 0x06
	temp = ((float)((H<<8)|L)-1885.0)/(-9.05)+25.0;
	printf("%f\n", temp);
}

alt_u8 I2C_read_357(alt_u8 reg_addr)
{
	alt_u8 rt;

	ADXL355_read_mode_sel(CPU_1);
	IOWR(VARSET_BASE, O_VAR_DEV_ADDR, 0x1D);
	IOWR(VARSET_BASE, O_VAR_REG_ADDR, reg_addr);
	ADXL355_read();
	ADXL355_enable();
	while( !read_ADXL355_finish()){}
	ADXL355_disable();
	rt = IORD(VARSET_BASE, O_VAR_I2C_RDATA_1);
	printf("reg:%x, value:%x\n", reg_addr, rt);
	return rt;
}

void I2C_read_357_CPU11(alt_u8 reg_addr)
{
	ADXL355_read_mode_sel(CPU_11);
	IOWR(VARSET_BASE, O_VAR_DEV_ADDR, 0x1D);
	IOWR(VARSET_BASE, O_VAR_REG_ADDR, reg_addr);
	ADXL355_read();
	ADXL355_enable();
	while( !read_ADXL355_finish()){}
	ADXL355_disable();
	printf("rd1:%x\n", IORD(VARSET_BASE, O_VAR_I2C_RDATA_1));
	printf("rd2:%x\n", IORD(VARSET_BASE, O_VAR_I2C_RDATA_2));
	printf("rd3:%x\n", IORD(VARSET_BASE, O_VAR_I2C_RDATA_3));
	printf("rd4:%x\n", IORD(VARSET_BASE, O_VAR_I2C_RDATA_4));
	printf("rd5:%x\n", IORD(VARSET_BASE, O_VAR_I2C_RDATA_5));
	printf("rd6:%x\n", IORD(VARSET_BASE, O_VAR_I2C_RDATA_6));
	printf("rd7:%x\n", IORD(VARSET_BASE, O_VAR_I2C_RDATA_7));
	printf("rd8:%x\n", IORD(VARSET_BASE, O_VAR_I2C_RDATA_8));
	printf("rd9:%x\n", IORD(VARSET_BASE, O_VAR_I2C_RDATA_9));
	printf("rd10:%x\n", IORD(VARSET_BASE, O_VAR_I2C_RDATA_10));
	printf("rd11:%x\n", IORD(VARSET_BASE, O_VAR_I2C_RDATA_11));
}

void I2C_write_357(alt_u8 reg_addr, alt_u8 data)
{
	IOWR(VARSET_BASE, O_VAR_DEV_ADDR, 0x1D);
	IOWR(VARSET_BASE, O_VAR_REG_ADDR, reg_addr);
	ADXL355_write();
//	IOWR(VARSET_BASE, O_VAR_I2C_RW, I2C_WRITE);
	IOWR(VARSET_BASE, O_VAR_W_DATA, data);
	ADXL355_enable();
//	IOWR(VARSET_BASE, O_VAR_I2C_EN, 0x01);
	while( !read_ADXL355_finish()){}
	ADXL355_disable();
}


