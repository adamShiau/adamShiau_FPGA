#ifndef __ACQ_RST_H
#define __ACQ_RST_H


#include "stdio.h"
#include <stdlib.h>  // malloc(), free()
#include <string.h>  // memcpy()
#include "common_V2.h"
#include "uart_V2.h"

// extern alt_u32 g_time[12];

void acq_rst (cmd_ctrl_t*, my_sensor_t, fog_parameter_t);

#endif /* __ACQ_RST_H */