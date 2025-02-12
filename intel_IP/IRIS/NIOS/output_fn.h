#ifndef __OUTPUT_FN_H
#define __OUTPUT_FN_H

#include "stdio.h"
#include <stdlib.h>  // malloc(), free()
#include <string.h>  // memcpy()
#include "common.h"

#define DLY_NUM 10000


/*** output function type delaration */
typedef void (*fn_ptr) (cmd_ctrl_t*, my_sensor_t*, alt_u8*);

void acq_rst (cmd_ctrl_t*, my_sensor_t*, alt_u8*);
void acq_fog (cmd_ctrl_t*, my_sensor_t*, alt_u8*);


#endif /* __OUTPUT_FN_H */
