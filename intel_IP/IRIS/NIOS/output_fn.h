#ifndef __OUTPUT_FN_H
#define __OUTPUT_FN_H

#include "stdio.h"
#include "common.h"

#define DLY_NUM 10000

alt_u32 dly_cnt;


/*** output function type delaration */
typedef void (*fn_ptr) (cmd_ctrl_t*, my_sensor_t*);

void acq_rst (cmd_ctrl_t*, my_sensor_t*);
void acq_fog (cmd_ctrl_t*, my_sensor_t*);


#endif /* __OUTPUT_FN_H */