
#include "acq_imu.h"

#define INT_SYNC 1
#define EXT_SYNC 2
#define STOP_RUN 4

extern alt_u32 g_time[12];

static const unsigned char KVH_HEADER[4] = {0xFE, 0x81, 0xFF, 0x55};

static const unsigned char HD_ABBA[2] = {0xAB, 0xBA};
static const unsigned char TR_5556[2] = {0x55, 0x56};

void acq_imu (cmd_ctrl_t* rx, my_sensor_t data, fog_parameter_t fog_parameter)
{
    calibrated_data_t gyro_misalign_calibrated, accl_misalign_calibrated;
    
    float step_x_comp, step_y_comp, step_z_comp;
    float accl_x_comp, accl_y_comp, accl_z_comp;
    
    float sf_x_comp_gyro, sf_y_comp_gyro, sf_z_comp_gyro;
    float sf_x_comp_accl, sf_y_comp_accl, sf_z_comp_accl;
    float bias_x_comp_gyro, bias_y_comp_gyro, bias_z_comp_gyro;
    float bias_x_comp_accl, bias_y_comp_accl, bias_z_comp_accl;
    

    if(rx->select_fn == SEL_IMU) {
        // UART_PRINT("acq_imu\n");
        rx->select_fn = SEL_IDLE; //clear select_fn
        DEBUG_PRINT("select acq_imu mode\n");
        if(rx->value == INT_SYNC) { //internal sync mode
            // DEBUG_PRINT("acq_fog select internal mode\n");
            DEBUG_PRINT("acq_imu select internal mode\n");
            rx->run = 1;
        }
        else if(rx->value == EXT_SYNC) { //external sync mode
            DEBUG_PRINT("acq_imu select external mode\n");
            rx->run = 1;
        }
        else if(rx->value == STOP_RUN) { //stop
            DEBUG_PRINT("acq_imu select stop\n");
            rx->run = 0;
        }
    }
    if(rx->run == 1) { 

        // g_time[2] = get_timer_int();   
        
        SerialWrite((alt_u8*)HD_ABBA, 2);
        SerialWrite(data.fog.fogx.step.bin_val, 4);
        SerialWrite(data.fog.fogy.step.bin_val, 4);
        SerialWrite(data.fog.fogz.step.bin_val, 4);
        SerialWrite(data.adxl357.ax.bin_val, 4);
        SerialWrite(data.adxl357.ay.bin_val, 4);
        SerialWrite(data.adxl357.az.bin_val, 4);
        SerialWrite(data.temp.tempx.bin_val, 4);
        SerialWrite(data.temp.tempy.bin_val, 4);
        SerialWrite(data.temp.tempz.bin_val, 4);
        SerialWrite(data.adxl357.temp.bin_val, 4);
        SerialWrite(data.time.time.bin_val, 4);
        SerialWrite((alt_u8*)TR_5556, 2);  
    }
}
