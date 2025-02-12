#ifndef __COMMON_H
#define __COMMON_H

#include "alt_types.h"
#include "system.h"
#include "altera_avalon_uart_regs.h"
#include "memory_manage.h"
#include "nios2_var_addr.h"
// #include "output_fn.h"

#define VARSET_BASE VARSET_1_BASE

#define WIDTH_32 32
#define TOPBIT_32 (1 << (WIDTH_32 - 1))
#define POLYNOMIAL_32 0x04C11DB7

#define MUX_OUTPUT		    0
#define MUX_PARAMETER	    1
#define MUX_ESCAPE		    2
#define MUX_DEFAULT       3

#define SEL_IDLE      0
#define SEL_RST			  1
#define SEL_FOG 		  2
#define SEL_FOG_2		  3
#define SEL_FOG_3 		4
#define SEL_IMU 		  5
#define SEL_NMEA	 		6
#define SEL_FOG_PARA  7
#define SEL_HP_TEST 	8
#define SEL_ATT_NMEA 	9

#define MODE_RST 	        0
#define MODE_FOG	        1
#define MODE_IMU	        2
#define MODE_FOG_HP_TEST	3
#define MODE_NMEA		    4
#define MODE_ATT_NMEA		5
#define MODE_FOG_PARAMETER  6

typedef union
{
  float float_val;
  alt_u8 bin_val[4];
  alt_32 int_val;
}
my_float_t;

/*** cmd control structure delaration */
typedef struct
{
  alt_u8 complete;
  alt_u8 mux;
  alt_u8 select_fn;
  alt_u8 ch;
  alt_u8 cmd;
  alt_u8 run;
  alt_32 value;
}cmd_ctrl_t;


/*** sensor data structure delaration */
typedef struct {
  my_float_t err;  
  my_float_t step; 
} fog_component_t;

typedef struct {
  fog_component_t fogx;
  fog_component_t fogy;
  fog_component_t fogz;
} fog_t;

typedef struct {
  my_float_t tempx;  
  my_float_t tempy; 
  my_float_t tempz; 
} temp_t;

typedef struct {
  my_float_t time;  
} my_time_t;

typedef struct 
{
  my_time_t time;
  fog_t fog;
  temp_t temp;
  
}my_sensor_t;

/*** output function type delaration */
typedef void (*fn_ptr) (cmd_ctrl_t*, my_sensor_t*, alt_u8*);

// typedef struct cmd_ctrl_t cmd_ctrl_t;

/*** auto reset structure delaration */
typedef struct {
  alt_u8 status;
  alt_u8 fn_mode;
} auto_rst_t;


void sendTx(alt_32);
void checkByte(alt_u8);
void SerialWrite(alt_u8* buf, alt_u8 num); 
void Serialwrite_r(alt_u8* buf, alt_u8 num); 
void crc_32(alt_u8  message[], alt_u8 nBytes, alt_u8* crc);

void get_uart_cmd(alt_u8*, cmd_ctrl_t*);
void cmd_mux(cmd_ctrl_t*);
void fog_parameter(cmd_ctrl_t*, fog_parameter_t*);
void output_mode_setting(cmd_ctrl_t*, fn_ptr*, auto_rst_t*);

#endif /* __COMMON_H */
