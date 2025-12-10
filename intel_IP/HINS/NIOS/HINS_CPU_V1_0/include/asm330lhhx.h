#ifndef __AASM330LHHX_H
#define __AASM330LHHX_H

#include "alt_types.h"
#include "altera_avalon_pio_regs.h"
#include "system.h"
#include "nios2_var_addr.h"
#include "io.h"
#include "common.h"


/*** high level declaration */
void init_ASM330LHHX(void);
void read_ASM330LHHX(void);
void test_ASM330LHHX(void);


/*** mid level declaration */
void I2C_sm_start_ASM330LHHX();
void I2C_op_mode_sel_ASM330LHHX(alt_u8 mode);
void I2C_clock_rate_sel_ASM330LHHX(alt_u8 rate);
void I2C_set_device_addr_ASM330LHHX(alt_u8 dev);
void I2C_write_ASM330LHHX_register(alt_u8 reg_addr, alt_u8 data, alt_u8 print);
alt_u8 I2C_read_ASM330LHHX_register(alt_u8 reg_addr, alt_u8 print);

/*** low level declaration */
void I2C_sm_set_enable_ASM330LHHX(void);
void I2C_sm_set_disable_ASM330LHHX(void);
void I2C_sm_set_finish_clear_pulse_ASM330LHHX(void);

// void I2C_set_write_mode_ASM330LHHX(void);
// void I2C_set_read_mode_ASM330LHHX(void);
alt_u8 I2C_sm_read_finish_ASM330LHHX(void);
alt_u32 set_bit_safe_ASM330LHHX(alt_u32 old_addr,  alt_u8 pos);
alt_u32 clear_bit_safe_ASM330LHHX(alt_u32 old_addr,  alt_u8 pos);


#endif /* __AASM330LHHX_H */
