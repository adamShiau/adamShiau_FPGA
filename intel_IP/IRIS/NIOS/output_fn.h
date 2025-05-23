#ifndef __OUTPUT_FN_H
#define __OUTPUT_FN_H

#include "stdio.h"
#include <stdlib.h>  // malloc(), free()
#include <string.h>  // memcpy()
#include "common.h"
#include "adxl357.h"

#define DLY_NUM 10000

extern alt_u32 g_time[12];

/*** output function type delaration */
// typedef void (*fn_ptr) (cmd_ctrl_t*, my_sensor_t, alt_u8*, fog_parameter_t);
typedef void (*fn_ptr) (cmd_ctrl_t*, my_sensor_t, fog_parameter_t);

// void acq_rst (cmd_ctrl_t*, my_sensor_t, alt_u8*, fog_parameter_t);
// void acq_fog (cmd_ctrl_t*, my_sensor_t, alt_u8*, fog_parameter_t);
// void acq_imu (cmd_ctrl_t*, my_sensor_t, alt_u8*, fog_parameter_t);
void acq_rst (cmd_ctrl_t*, my_sensor_t, fog_parameter_t);
void acq_fog (cmd_ctrl_t*, my_sensor_t, fog_parameter_t);
void acq_imu (cmd_ctrl_t*, my_sensor_t, fog_parameter_t);

#endif /* __OUTPUT_FN_H */
