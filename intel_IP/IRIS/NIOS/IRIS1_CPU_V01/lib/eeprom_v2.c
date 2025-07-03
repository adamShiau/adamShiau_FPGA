#include "eeprom_v2.h" 
#define VARSET_BASE VARSET_1_BASE

/******** I2C device address*********/
#define I2C_DEV_ADDR	0x57

/******** I2C lock rate definition*********/
#define CLK_390K 	 7
#define CLK_781K 	 6
#define CLK_1562K 	 5
#define CLK_3125K 	 4

/******** VAR Register*********/
#define	O_VAR_DEV_ADDR		var_i2c_EEPROM_dev_addr
#define O_VAR_W_DATA		var_i2c_EEPROM_w_data
#define O_VAR_I2C_CTRL		var_i2c_EEPROM_ctrl
#define O_VAR_REG_ADDR		var_i2c_EEPROM_reg_addr
#define O_VAR_I2C_STATUS	var_i2c_EEPROM_status
#define O_VAR_I2C_RDATA_1	var_i2c_EEPROM_rdata_1
#define O_VAR_I2C_RDATA_2	var_i2c_EEPROM_rdata_2
#define O_VAR_I2C_RDATA_3	var_i2c_EEPROM_rdata_3
#define O_VAR_I2C_RDATA_4	var_i2c_EEPROM_rdata_4

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

/*** OP mode***/
#define CPU_WREG	0
#define CPU_RREG	1

#define True 1
#define False 0

typedef union
{
  alt_32 int_val;
  alt_u8 bin_val[4];
}my_alt32_t;

void EEPROM_RW_TEST()
{
	my_float_t data, tt;
	DEBUG_PRINT("Start EEPROM R/W testing function\n");


	tt.float_val = 1.23456;
	DEBUG_PRINT("Write int value 123 to memory location 200. \n");
	PARAMETER_Write_f(MEM_BASE_X, 200, 123);
	PARAMETER_Read(MEM_BASE_X, 200 , data.bin_val);
	DEBUG_PRINT("Read out int value: %d\n", data.int_val);
	DEBUG_PRINT("Raw bytes: %02X %02X %02X %02X\n",
           data.bin_val[0],
           data.bin_val[1],
           data.bin_val[2],
           data.bin_val[3]);
	DEBUG_PRINT("Write int value -123 to memory location 201. \n");
	PARAMETER_Write_f(MEM_BASE_X, 201, -123);
	PARAMETER_Read(MEM_BASE_X, 201 , data.bin_val);
	DEBUG_PRINT("Read int value: %d\n", data.int_val);
	DEBUG_PRINT("Raw bytes: %02X %02X %02X %02X\n",
           data.bin_val[0],
           data.bin_val[1],
           data.bin_val[2],
           data.bin_val[3]);
	DEBUG_PRINT("Write float value 1.23456 to memory location 202. \n");
	PARAMETER_Write_f(MEM_BASE_X, 202, tt.int_val);
	PARAMETER_Read(MEM_BASE_X, 202 , data.bin_val);
	DEBUG_PRINT("Read float value: %f\n", data.float_val);
	DEBUG_PRINT("Raw bytes: %02X %02X %02X %02X\n",
           data.bin_val[0],
           data.bin_val[1],
           data.bin_val[2],
           data.bin_val[3]);
	DEBUG_PRINT("End EEPROM R/W testing function\n");

}

void EEPROM_Write_4B(alt_u16 reg_addr, alt_32 data)
{
	reg_addr <<= 2;
	// setting mode to cpu write register
	I2C_op_mode_sel_EEPROM(CPU_WREG);
	// Set I2C device address
	IOWR(VARSET_BASE, O_VAR_DEV_ADDR, I2C_DEV_ADDR);
	// Set the target register address for read or write operations
	IOWR(VARSET_BASE, O_VAR_REG_ADDR, reg_addr);

	// Set the data value to be written to the target register
	IOWR(VARSET_BASE, O_VAR_W_DATA, data);
	// start the I2C SM 
	I2C_sm_start();
	// Wait for the I2C SM to complete the operation
	 while( !I2C_sm_read_finish()){}
	usleep(1320);
}

/*** force write eeprom on address 
 * write the new value to the eeprom
*/
void PARAMETER_Write_f(alt_u8 base, alt_u8 number , alt_32 data)
{
	// DEBUG_PRINT("reg_addr: %d, data: %d\n", base + number, data);
	EEPROM_Write_4B( (alt_u16) (base + number), data);
}

/*** safe write eeprom on address 
 * compare the new value to the old value,
 * if the two are difference,
 * write the new value to the eeprom and container
*/
void PARAMETER_Write_s(alt_u8 base, alt_u8 number , alt_32 data, fog_parameter_t* fog_params)
{
	alt_32 check;
	float data_f;
	alt_8 type;
	data_t my_data;

	my_data.int_val = data;

	// load old value from parameter container
	if(base == MEM_BASE_X) {
		check = fog_params->paramX[number].data.int_val;
		data_f = fog_params->paramX[number].data.float_val;
		type = fog_params->paramX[number].type;
	}
	else if(base == MEM_BASE_Y ) {
		check = fog_params->paramY[number].data.int_val;
		data_f = fog_params->paramX[number].data.float_val;
		type = fog_params->paramX[number].type;
	}
	else if(base == MEM_BASE_Z ) {
		check = fog_params->paramZ[number].data.int_val;
		data_f = fog_params->paramX[number].data.float_val;
		type = fog_params->paramX[number].type;
	}
	else if(base == MEM_BASE_MIS ) {
		check = fog_params->misalignment[number].data.int_val;
		data_f = fog_params->misalignment[number].data.float_val;
		type = fog_params->misalignment[number].type;
		DEBUG_PRINT("base: %d\n", base);
		DEBUG_PRINT("container idx: %d\n", number);
		DEBUG_PRINT("type: %d\n", type);
	}
	else {
		DEBUG_PRINT("Base address ERROR!\n");
		return;
	}
	
	// compare new value to the old value. if changed, write to eeprom. 
	if(data == check) DEBUG_PRINT("The data is the same\n");
	else {
		if(type == TYPE_INT) {
			DEBUG_PRINT("Data changed: %d -> %d\n", check, data);
			DEBUG_PRINT("update to eeprom!");
			UART_PRINT("Data changed: %d -> %d\n", check, data);
			UART_PRINT("update to eeprom!");
			PARAMETER_Write_f(base, number, data);
		}
		else if(type == TYPE_FLOAT) {
			DEBUG_PRINT("Data changed: %f -> %f\n", data_f, my_data.float_val);
			DEBUG_PRINT("update to eeprom!");
			UART_PRINT("Data changed: %f -> %f\n", data_f, my_data.float_val);
			UART_PRINT("update to eeprom!");
			PARAMETER_Write_f(base, number, data);
		}
		else DEBUG_PRINT("data type error!\n");
		// PARAMETER_Write_f(base, number, data);

		// update new value to container
		if(base == MEM_BASE_X) fog_params->paramX[number].data.int_val = data;
		else if(base == MEM_BASE_Y ) fog_params->paramY[number].data.int_val = data;
		else if(base == MEM_BASE_Z ) fog_params->paramZ[number].data.int_val = data;
		else if(base == MEM_BASE_MIS ) fog_params->misalignment[number].data.int_val = data;
	}

}

void EEPROM_Write_initial_parameter()
{	
	DEBUG_PRINT("starting EEPROM_Write_initial_parameter()...\n");
	for(int i=0; i<PAR_LEN; i++)
	{
		PARAMETER_Write_f(MEM_BASE_X, i, fog_parameter_init[i].data.int_val);
		PARAMETER_Write_f(MEM_BASE_Y, i, fog_parameter_init[i].data.int_val);
		PARAMETER_Write_f(MEM_BASE_Z, i, fog_parameter_init[i].data.int_val);
	}
	DEBUG_PRINT("writing EEPROM_Write_initial_parameter() done! \n");
} 

void LOAD_FOG_SN(fog_parameter_t* fog_params)
{
    DEBUG_PRINT("Loading EEPROM SN...\n");
    for (int i = 0; i < 3; i++) {
        PARAMETER_Read_R(MEM_BASE_SN, i, &fog_params->sn[i * 4]);
    }
	fog_params->sn[12] = '\0'; 
    DEBUG_PRINT("Loading EEPROM Mis-alignment Parameters done!\n");
}

void LOAD_FOG_MISALIGNMENT(fog_parameter_t* fog_params)
{
	// int dlt = 10000;
	// while(dlt--) {};
	DEBUG_PRINT("Loading EEPROM Mis-alignment Parameters...\n");
	for (int i = 0; i < MIS_LEN; i++) {
		PARAMETER_Read(MEM_BASE_MIS, i , fog_params->misalignment[i].data.bin_val);
		fog_params->misalignment[i].type = TYPE_FLOAT;
		UART_PRINT("idx %d, %d, %f\n", i, fog_params->misalignment[i].data.int_val, fog_params->misalignment[i].data.float_val);
    }
	DEBUG_PRINT("Loading EEPROM Mis-alignment Parameters done!\n");
}

void LOAD_FOG_PARAMETER(fog_parameter_t* fog_params)
{
	DEBUG_PRINT("Loading EEPROM FOG Parameters...\n");
	for (int i = 0; i < PAR_LEN; i++) {
		PARAMETER_Read(MEM_BASE_X, i , fog_params->paramX[i].data.bin_val);
        PARAMETER_Read(MEM_BASE_Y, i , fog_params->paramY[i].data.bin_val);
		PARAMETER_Read(MEM_BASE_Z, i , fog_params->paramZ[i].data.bin_val);

		fog_params->paramX[i].type = fog_parameter_init[i].type;
		fog_params->paramY[i].type = fog_parameter_init[i].type;
		fog_params->paramZ[i].type = fog_parameter_init[i].type;
    }
	DEBUG_PRINT("Loading EEPROM FOG Parameters done!\n");
}

void PRINT_FOG_PARAMETER(fog_parameter_t* fog_params)
{
	DEBUG_PRINT("Printing EEPROM FOG Parameters...\n");
	// DEBUG_PRINT("FOG X Parameter:\n");
	// for (int i = 0; i < PAR_LEN; i++) {
	// 	DEBUG_PRINT("%d. %d, type: %d\n", i, fog_params->paramX[i].data.int_val, fog_params->paramX[i].type);
	// }
	// DEBUG_PRINT("FOG Y Parameter:\n");
	// for (int i = 0; i < PAR_LEN; i++) {
	// 	DEBUG_PRINT("%d. %d, type: %d\n", i, fog_params->paramY[i].data.int_val, fog_params->paramY[i].type);
	// }
	DEBUG_PRINT("FOG Z Parameter:\n");
	for (int i = 0; i < PAR_LEN; i++) {
		DEBUG_PRINT("%d. %d, type: %d\n", i, fog_params->paramZ[i].data.int_val, fog_params->paramZ[i].type);
	}
	DEBUG_PRINT("Printing EEPROM FOG Parameters done!\n");
}

void EEPROM_Read_4B(alt_u16 reg_addr, alt_u8* buf)
{
	alt_u8 i=0;

	reg_addr <<= 2;

	// setting mode to cpu read register
	I2C_op_mode_sel_EEPROM(CPU_RREG);
	// Set I2C device address
	IOWR(VARSET_BASE, O_VAR_DEV_ADDR, I2C_DEV_ADDR);
	// Set the target register address for read or write operations
	IOWR(VARSET_BASE, O_VAR_REG_ADDR, reg_addr);

	// start the I2C SM 
	I2C_sm_start();
	// Wait for the I2C SM to complete the operation
	 while( !I2C_sm_read_finish()){}
	// Retrieve the data read from the specified register
	buf[3] = IORD(VARSET_BASE, O_VAR_I2C_RDATA_1);
	buf[2] = IORD(VARSET_BASE, O_VAR_I2C_RDATA_2);
	buf[1] = IORD(VARSET_BASE, O_VAR_I2C_RDATA_3);
	buf[0] = IORD(VARSET_BASE, O_VAR_I2C_RDATA_4);

}

void EEPROM_Read_4B_R(alt_u16 reg_addr, alt_u8* buf)
{
	alt_u8 i=0;

	// DEBUG_PRINT("VARSET_BASE22 18: %d\n", IORD(VARSET_BASE, 18));
	// DEBUG_PRINT("VARSET_BASE22 19: %d\n", IORD(VARSET_BASE, 19));

	reg_addr <<= 2;
	// setting mode to cpu read register
	I2C_op_mode_sel_EEPROM(CPU_RREG);
	// Set I2C device address
	IOWR(VARSET_BASE, O_VAR_DEV_ADDR, I2C_DEV_ADDR);
	// Set the target register address for read or write operations
	IOWR(VARSET_BASE, O_VAR_REG_ADDR, reg_addr);

	// start the I2C SM 
	I2C_sm_start();
	// Wait for the I2C SM to complete the operation
	 while( !I2C_sm_read_finish()){}
	// Retrieve the data read from the specified register
	buf[0] = IORD(VARSET_BASE, O_VAR_I2C_RDATA_1);
	buf[1] = IORD(VARSET_BASE, O_VAR_I2C_RDATA_2);
	buf[2] = IORD(VARSET_BASE, O_VAR_I2C_RDATA_3);
	buf[3] = IORD(VARSET_BASE, O_VAR_I2C_RDATA_4);
	// DEBUG_PRINT("MSB: %x, %x, %x, %x\n", buf[3], buf[2], buf[1], buf[0]);
	// DEBUG_PRINT("%d\n", buf[3]<<24|buf[2]<<16|buf[1]<<8|buf[0]);
}

void PARAMETER_Read(alt_u8 base, alt_u8 number , alt_u8* buf)
{
	EEPROM_Read_4B((alt_u16) (base + number), buf);
}

void PARAMETER_Read_R(alt_u8 base, alt_u8 number , alt_u8* buf)
{
	EEPROM_Read_4B_R((alt_u16) (base + number), buf);
}
/*** Initialization method */
void init_EEPROM(void)
{
    I2C_clock_rate_sel(CLK_390K);
}

/***********mid level definition */

void I2C_sm_start()
{
	alt_u8 dly = 50;

	I2C_sm_set_enable();
	while(dly--){}
	I2C_sm_set_disable();
}

void I2C_op_mode_sel_EEPROM(alt_u8 mode)
{
	alt_32 old = IORD(VARSET_BASE, O_VAR_I2C_CTRL);

	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, (old & 0xFFFFFFF1) | (mode<<ctrl_op_mode_pos));
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
	// DEBUG_PRINT("I2C_sm_read_finish: %x, %d\n", VARSET_BASE, O_VAR_I2C_STATUS);

	return finish;
}
