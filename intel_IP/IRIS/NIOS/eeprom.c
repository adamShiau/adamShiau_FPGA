#include "eeprom.h"

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

/*** Initialization method */
void init_EEPROM(void)
{
    I2C_clock_rate_sel(CLK_195K);
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