
#include "acq_rst.h"

#define DLY_NUM 500

static alt_u32 dly_cnt = 0;


void acq_rst (cmd_ctrl_t* rx, my_sensor_t data, fog_parameter_t fog_parameter)
{
    if(dly_cnt++ > DLY_NUM) {
        dly_cnt = 0;
        // UART_PRINT("acq_rst mode\n");
    }  
}