#ifndef __ADXL357_H
#define __ADXL357_H

#include "alt_types.h"
#include "system.h"
#include "nios2_var_addr.h"
#include "io.h"
#include "common.h"

/******** I2C device address*********/
#define I2C_DEV_ADDR	0x1D

/******** I2C lock rate definition*********/
#define CLK_390K 	 7
#define CLK_781K 	 6
#define CLK_1562K 	 5
#define CLK_3125K 	 4


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


#endif /* __ADXL357_H */