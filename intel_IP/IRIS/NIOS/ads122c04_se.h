#ifndef __ADS122C04_SE_H
#define __ADS122C04_SE_H

#include "alt_types.h"
#include "altera_avalon_pio_regs.h"
#include "system.h"
#include "nios2_var_addr.h"
#include "io.h"
#include "common.h"

/***ADXL357 ***/
#define SENS_ADXL357_10G 19.5e-6
#define SENS_ADXL357_20G 39e-6
#define SENS_ADXL357_40G 78e-6

/*** high level declaration */
//void I2C_read_357_CPU11(alt_u8 reg_addr);
void init_ADS122C04_TEMP(void);
void read_ADS122C04_TEMP(void);
// void read_357_temp_CPU(void);
// void read_357_accl_CPU(void);
// void read_357_all(void);
// void print_11_reg(void);
// void print_9_reg(void);

/*** mid level declaration */
void I2C_sm_start_ADS122C04_TEMP();
void I2C_op_mode_sel_ADS122C04_TEMP(alt_u8 mode);
void I2C_clock_rate_sel_ADS122C04_TEMP(alt_u8 rate);
void I2C_set_device_addr_ADS122C04_TEMP(alt_u8 dev);
void I2C_write_ADS122C04_TEMP_register(alt_u8 reg_addr, alt_u8 data);
alt_u8 I2C_read_ADS122C04_TEMP_register(alt_u8 reg_addr, alt_u8 print);

/*** low level declaration */
void I2C_sm_set_enable_ADS122C04_TEMP(void);
void I2C_sm_set_disable_ADS122C04_TEMP(void);
// void I2C_set_write_mode_ADS122C04_TEMP(void);
// void I2C_set_read_mode_ADS122C04_TEMP(void);
alt_u8 I2C_sm_read_finish_ADS122C04_TEMP(void);
alt_u32 set_bit_safe_ADS122C04_TEMP(alt_u32 old_addr,  alt_u8 pos);
alt_u32 clear_bit_safe_ADS122C04_TEMP(alt_u32 old_addr,  alt_u8 pos);


#endif /* __ADS122C04_SE_H */
