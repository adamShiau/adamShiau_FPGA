#ifndef __EEPROM_H
#define __EEPROM_H

// test no PU version
#include "alt_types.h"
#include "system.h"
#include "nios2_var_addr.h"
#include "io.h"
#include "memory_manage.h" 
#include "common.h"


void PARAMETER_Write_f(alt_u8 base, alt_u8 number , alt_32 data);
void PARAMETER_Write_s(alt_u8 base, alt_u8 number , alt_32 data, fog_parameter_t* fog_params);
void PARAMETER_Read(alt_u8 base, alt_u8 number , alt_u8* buf);
void PARAMETER_Read_R(alt_u8 base, alt_u8 number , alt_u8* buf);


void EEPROM_Write_initial_parameter(void);
void LOAD_FOG_PARAMETER(fog_parameter_t* fog_params);
void PRINT_FOG_PARAMETER(fog_parameter_t* fog_params);
void LOAD_FOG_MISALIGNMENT(fog_parameter_t* fog_params);
void LOAD_FOG_SN(fog_parameter_t* fog_params);
void EEPROM_RW_TEST(void);

/*** Initialization method */
void init_EEPROM(void);

/*** EEPROM LOW Level method */
void EEPROM_Write_4B(alt_u16 reg_addr, alt_32 data);
void EEPROM_Read_4B(alt_u16 reg_addr, alt_u8* buf);
void EEPROM_Read_4B_R(alt_u16 reg_addr, alt_u8* buf);

/*** I2C mid level declaration */
void I2C_sm_start();
void I2C_op_mode_sel_EEPROM(alt_u8 mode);
void I2C_clock_rate_sel(alt_u8 rate);

/*** I2C low level declaration */
void I2C_sm_set_enable(void);
void I2C_sm_set_disable(void);
void I2C_sm_set_finish_clear_pulse(void);
void I2C_set_write_mode(void);
void I2C_set_read_mode(void);
alt_u8 I2C_sm_read_finish(void);
alt_u32 set_bit_safe(alt_u32 old_addr,  alt_u8 pos);
alt_u32 clear_bit_safe(alt_u32 old_addr,  alt_u8 pos);


#endif /* __EEPROM_H */