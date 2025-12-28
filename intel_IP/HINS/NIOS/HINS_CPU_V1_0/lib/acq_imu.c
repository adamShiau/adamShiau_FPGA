
#include "acq_imu.h"
#include "output_mode.h"

#define INT_SYNC 1
#define EXT_SYNC 2
#define STOP_RUN 4

extern alt_u32 g_time[12];

static const unsigned char KVH_HEADER[4] = {0xFE, 0x81, 0xFF, 0x55};

static const unsigned char HD_ABBA[2] = {0xAB, 0xBA};
static const unsigned char TR_5556[2] = {0x55, 0x56};

void acq_imu (cmd_ctrl_t* rx, my_sensor_t data, fog_parameter_t fog_parameter)
{

    if(rx->select_fn == SEL_IMU) {
        rx->select_fn = SEL_IDLE; //clear select_fn
        DEBUG_PRINT("select acq_imu mode\n");
        if(rx->sync_mode == INT_SYNC) { //internal sync mode
            DEBUG_PRINT("acq_imu select internal mode\n");
            rx->run = 1;
        }
        else if(rx->sync_mode == EXT_SYNC) { //external sync mode
            DEBUG_PRINT("acq_imu select external mode\n");
            rx->run = 1;
        }
        else if(rx->sync_mode == STOP_RUN) { //stop
            DEBUG_PRINT("acq_imu select stop\n");
            rx->run = 0;
        }
        DEBUG_PRINT("rx->run: %d\n", rx->run);
    }
    if(rx->run == 1) { 


        // g_time[2] = get_timer_int();   
        
        SerialWrite((alt_u8*)HD_ABBA, 2);
        SerialWrite(data.fog.fogz.step.bin_val, 4); //對應到FOG Z軸
        SerialWrite(data.asm330lhhx.wy.bin_val, 4); //對應到FOG Y軸
        SerialWrite(data.asm330lhhx.wx.bin_val, 4); //對應到FOG X軸
        // SerialWrite(gx.bin_val, 4);
        // SerialWrite(gy.bin_val, 4);
        // SerialWrite(gz.bin_val, 4);
        SerialWrite(data.asm330lhhx.ax.bin_val, 4); //對應到ACCL X軸
        SerialWrite(data.asm330lhhx.ay.bin_val, 4); //對應到ACCL Y軸
        SerialWrite(data.asm330lhhx.az.bin_val, 4); //對應到ACCL Z軸
        SerialWrite(data.ads122c04.ain0.bin_val, 4); //對應到TEMP Z軸
        SerialWrite(data.ads122c04.ain0.bin_val, 4); //對應到TEMP Y軸
        SerialWrite(data.ads122c04.ain0.bin_val, 4); //對應到TEMP X軸
        SerialWrite(data.asm330lhhx.temp.bin_val, 4);
        SerialWrite(data.time.time.bin_val, 4);
        SerialWrite((alt_u8*)TR_5556, 2);   

        // DEBUG_PRINT("%d,%f,%f,%f,%f,%f,%f,%f,%f\n", 
        // data.fog.fogz.step.int_val,
        // data.asm330lhhx.wy.float_val,
        // data.asm330lhhx.wx.float_val,
        // data.asm330lhhx.ax.float_val,
        // data.asm330lhhx.ay.float_val,
        // data.asm330lhhx.az.float_val,
        // data.ads122c04.ain0.float_val,
        // data.asm330lhhx.temp.float_val,
        // data.time.time.float_val);

    }
}
