#ifndef __EEPROM_H
#define __EEPROM_H

/******** I2C device address*********/
#define I2C_DEV_ADDR	0x57

/******** I2C lock rate definition*********/
#define CLK_195K 	 7
#define CLK_390K 	 6
#define CLK_781K 	 5
#define CLK_1562K 	 4

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

/*** EEPROM method */
void Parameter_Write(alt_u16 reg_addr, alt_32 data);
void Parameter_Read(alt_u16 reg_addr, alt_u8* buf);

/*** Initialization method */
void init_EEPROM(void);

/*** I2C mid level declaration */
void I2C_sm_start();
void I2C_op_mode_sel(alt_u8 mode);
void I2C_clock_rate_sel(alt_u8 rate);
// void I2C_write_357_register(alt_u8 reg_addr, alt_u8 data);
// alt_u8 I2C_read_357_register(alt_u8 reg_addr, alt_u8 print);

/*** I2C low level declaration */
void I2C_sm_set_enable(void);
void I2C_sm_set_disable(void);
void I2C_set_write_mode(void);
void I2C_set_read_mode(void);
alt_u8 I2C_sm_read_finish(void);
alt_u32 set_bit_safe(alt_u32 old_addr,  alt_u8 pos);
alt_u32 clear_bit_safe(alt_u32 old_addr,  alt_u8 pos);



#endif /* __EEPROM_H */