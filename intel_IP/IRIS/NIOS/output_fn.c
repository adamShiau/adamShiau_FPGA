#include "output_fn.h"


void acq_rst (cmd_ctrl_t* rx, my_sensor_t* data)
{
    // if(dly_cnt++ == DLY_NUM){
        printf("acq_rst mode\n");
    //     dly_cnt = 0;
    // }
    dly_cnt = 0;
    
}

void acq_fog (cmd_ctrl_t* rx, my_sensor_t* data)
{
    printf("select acq_fog mode\n");
    if(dly_cnt++ == DLY_NUM){
        printf("acq_fog mode\n");
        dly_cnt = 0;
    }
}
