#ifndef __COMMON_H
#define __COMMON_H

#include "alt_types.h"
#include "system.h"
#include "altera_avalon_uart_regs.h"
#include "memory_manage.h"
#include "nios2_var_addr.h"

#define VARSET_BASE VARSET_1_BASE

#define MUX_OUTPUT		    0
#define MUX_PARAMETER	    1
#define MUX_ESCAPE		    2

#define SEL_DEFAULT         0
#define SEL_RST			    1
#define SEL_FOG_1 		    2
#define SEL_FOG_2		    3
#define SEL_FOG_3 		    4
#define SEL_IMU 		    5
#define SEL_NMEA	 		6
#define SEL_FOG_PARA	    7
#define SEL_HP_TEST 	    8
#define SEL_ATT_NMEA 	    9

typedef union
{
  float float_val;
  alt_u8 bin_val[4];
  alt_32 int_val;
}
my_float_t;

typedef struct
{
    alt_u8 complete;
    alt_u8 mux;
    alt_u8 select_fn;
    alt_u8 ch;
    alt_u8 cmd;
    alt_32 value;
}uart_rx_t;



void sendTx(alt_32);
void checkByte(alt_u8);
void SerialWrite(alt_u8* buf, alt_u8 num); 
void Serialwrite_r(alt_u8* buf, alt_u8 num); 

void get_uart_cmd(alt_u8*, uart_rx_t*);
void cmd_mux(uart_rx_t*);
void fog_parameter(uart_rx_t*, fog_parameter_t*);

#endif /* __COMMON_H */