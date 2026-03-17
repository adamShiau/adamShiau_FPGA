#ifndef __AASM330LHHX_H
#define __AASM330LHHX_H

/***
 * version: v1.3
 * data: 2026/03/04
 * 新增 Gyro_LPF1 與 Accl_LPF2 setter 
 * 
 * data: 2026/03/10 
 * 新增 SM 重置 IDLE 方法 I2C_sm_force_reset_ASM330LHHX()
 * 
 * data: 2026/03/17 
 * 配合 Verilog V4 進版優化：
 * 1. 修改 LOG 排版。
 * 2. Setter 採用「模式切換優先」策略，解決 HW 模式與 CPU 模式切換時的競爭風險。
 * 3. 優化等待與校驗機制，提升動態修改暫存器時的穩定性。
 * 
 */

#include "alt_types.h"
#include "altera_avalon_pio_regs.h"
#include "system.h"
#include "nios2_var_addr.h"
#include "io.h"
#include "common.h"


/*** high level declaration */
void init_ASM330LHHX(void);
int I2C_write_verify_ASM330LHHX(alt_u8 reg_addr, alt_u8 data);
void read_ASM330LHHX(void);
void test_ASM330LHHX(void);
void I2C_sm_force_reset_ASM330LHHX(void);

/*** 新增 Setter 宣告 ***/
void set_ASM330LHHX_Gyro_LPF1(alt_u8 ftype);
void set_ASM330LHHX_Accl_LPF2(alt_u8 cutoff_bw);
alt_u8 get_ASM330LHHX_SM_status(void);
void print_ASM330LHHX_SM_status(void);

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
