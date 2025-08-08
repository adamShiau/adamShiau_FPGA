#ifndef __ADXL357_H
#define __ADXL357_H

#include "alt_types.h"
#include "altera_avalon_pio_regs.h"
#include "system.h"
#include "nios2_var_addr.h"
#include "io.h"
#include "common_V2.h"

/***ADXL357 ***/
#define SENS_ADXL357_10G 19.5e-6
#define SENS_ADXL357_20G 39e-6
#define SENS_ADXL357_40G 78e-6

/*** test function */
void test_CPU_ADXL357_ACCL(void);
void test_HW_ADXL357(void);

/*** high level declaration */
void init_ADXL357(void);
void read_357_temp_CPU(void);
void read_357_accl_CPU(void);
void read_357_all(void);

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
