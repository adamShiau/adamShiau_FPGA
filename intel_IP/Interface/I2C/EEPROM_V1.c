#include <stdio.h>
#include <unistd.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"

/******** I2C device address*********/
#define I2C_DEV_ADDR	0x57

/******** SYNC rate definition*********/
#define SYNC_100Hz 	250000
#define SYNC_200Hz 	125000
#define SYNC_400Hz 	62500
#define SYNC_800Hz 	31250
#define SYNC_1000Hz 2500

/******** I2C lock rate definition*********/
#define CLK_195K 	 7
#define CLK_390K 	 6
#define CLK_781K 	 5
#define CLK_1562K 	 4

/******** VAR Register*********/
#define	O_VAR_DEV_ADDR		5
#define O_VAR_W_DATA		6
#define O_VAR_I2C_CTRL		7
#define O_VAR_REG_ADDR		8
#define O_VAR_I2C_STATUS	25 + 12
#define O_VAR_I2C_RDATA_1	25 + 13
#define O_VAR_I2C_RDATA_2	25 + 14
#define O_VAR_I2C_RDATA_3	25 + 15
#define O_VAR_I2C_RDATA_4	25 + 16

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


/*** OP mode***/
#define CPU_1	0
#define CPU_11	1
#define HW_11	2

#define True 1
#define False 0

// void IRQ_TRIGGER_ISR(void);
// void TRIGGER_IRQ_init(void);

/*** high level declaration */


/*** mid level declaration */
void I2C_sm_start();
void I2C_op_mode_sel(alt_u8 mode);
void I2C_clock_rate_sel(alt_u8 rate);
void I2C_write_357_register(alt_u8 reg_addr, alt_u8 data);
alt_u8 I2C_read_357_register(alt_u8 reg_addr, alt_u8 print);
void Parameter_Write(alt_u16 reg_addr, alt_32 data);
void Parameter_Read(alt_u16 reg_addr, alt_u8* buf);

/*** low level declaration */
void I2C_sm_set_enable(void);
void I2C_sm_set_disable(void);
void I2C_set_write_mode(void);
void I2C_set_read_mode(void);
alt_u8 I2C_sm_read_finish(void);
alt_u32 set_bit_safe(alt_u32 old_addr,  alt_u8 pos);
alt_u32 clear_bit_safe(alt_u32 old_addr,  alt_u8 pos);


int main()
{
alt_u8 eeprom_buf[4] = {0};

  printf("Start testing EEPROM!\n");
  I2C_clock_rate_sel(CLK_195K);
  Parameter_Write(0, 0x12345678);
  Parameter_Write(1, 0x78654321);
  Parameter_Write(2, -20000);
  printf("Parameter_Write done\n");
  Parameter_Read(0, eeprom_buf);
  Parameter_Read(1, eeprom_buf);
  Parameter_Read(2, eeprom_buf);
  printf("Stop testing EEPROM!\n");
  return 0;
}

// void TRIGGER_IRQ_init()
// {
// 	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(TRIGGER_IN_BASE, 1); //clear edge capture register
// 	IOWR_ALTERA_AVALON_PIO_IRQ_MASK(TRIGGER_IN_BASE, 1); //enable irq mask
// 	alt_ic_isr_register(
// 	TRIGGER_IN_IRQ_INTERRUPT_CONTROLLER_ID,
// 	TRIGGER_IN_IRQ,
// 	IRQ_TRIGGER_ISR,
// 	0x0,
// 	0x0);
// }

// void IRQ_TRIGGER_ISR()
// {
// 	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(TRIGGER_IN_BASE, 1); //clear edge capture register
// }

void Parameter_Read(alt_u16 reg_addr, alt_u8* buf)
{
	alt_u8 i=0;

	reg_addr <<= 2;
	// Set I2C device address
	IOWR(VARSET_BASE, O_VAR_DEV_ADDR, I2C_DEV_ADDR);
	// Set the target register address for read or write operations
	IOWR(VARSET_BASE, O_VAR_REG_ADDR, reg_addr);
	// Set the I2C SM to read mode
	I2C_set_read_mode();
	// start the I2C SM 
	I2C_sm_start();
	// Wait for the I2C SM to complete the operation
	 while( !I2C_sm_read_finish()){}
	// Retrieve the data read from the specified register
	buf[0] = IORD(VARSET_BASE, O_VAR_I2C_RDATA_1);
	buf[1] = IORD(VARSET_BASE, O_VAR_I2C_RDATA_2);
	buf[2] = IORD(VARSET_BASE, O_VAR_I2C_RDATA_3);
	buf[3] = IORD(VARSET_BASE, O_VAR_I2C_RDATA_4);
	printf("MSB: %x, %x, %x, %x\n", buf[0], buf[1], buf[2], buf[3]);
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

void Parameter_Write(alt_u16 reg_addr, alt_32 data)
{
	reg_addr <<= 2;
	// Set I2C device address
	IOWR(VARSET_BASE, O_VAR_DEV_ADDR, I2C_DEV_ADDR);
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
	usleep(1320);
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


