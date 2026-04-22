#ifndef __ACQ_FOG_H
#define __ACQ_FOG_H


#include "stdio.h"
#include <stdlib.h>  // malloc(), free()
#include <string.h>  // memcpy()
#include "common.h"

// extern alt_u32 g_time[12];

void acq_fog (cmd_ctrl_t*, my_sensor_t, fog_parameter_t);

#endif /* __ACQ_FOG_H */