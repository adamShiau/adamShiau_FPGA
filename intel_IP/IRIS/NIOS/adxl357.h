#ifndef __ADXL357_H
#define __ADXL357_H

#include "alt_types.h"
#include "altera_avalon_pio_regs.h"
#include "system.h"
#include "nios2_var_addr.h"
#include "io.h"
#include "common.h"

/*** high level declaration */
void I2C_read_357_CPU11(alt_u8 reg_addr);
void init_ADXL357(void);
void read_357_temp(void);
void print_11_reg(void);
void print_9_reg(void);

/*** mid level declaration */
void I2C_sm_start_ADXL357();
void I2C_op_mode_sel_ADXL357(alt_u8 mode);
void I2C_clock_rate_sel_ADXL357(alt_u8 rate);
void I2C_write_357_register(alt_u8 reg_addr, alt_u8 data);
alt_u8 I2C_read_357_register(alt_u8 reg_addr, alt_u8 print);

/*** low level declaration */
void I2C_sm_set_enable_ADXL357(void);
void I2C_sm_set_disable_ADXL357(void);
void I2C_set_write_mode_ADXL357(void);
void I2C_set_read_mode_ADXL357(void);
alt_u8 I2C_sm_read_finish_ADXL357(void);
alt_u32 set_bit_safe_ADXL357(alt_u32 old_addr,  alt_u8 pos);
alt_u32 clear_bit_safe_ADXL357(alt_u32 old_addr,  alt_u8 pos);


#endif /* __ADXL357_H */