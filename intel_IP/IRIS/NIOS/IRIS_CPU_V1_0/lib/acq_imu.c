
#include "acq_imu.h"
#include "output_mode.h"

#define INT_SYNC 1
#define EXT_SYNC 2
#define STOP_RUN 4

extern alt_u32 g_time[12];

static const unsigned char KVH_HEADER[4] = {0xFE, 0x81, 0xFF, 0x55};

static const unsigned char HD_ABBA[2] = {0xAB, 0xBA};
static const unsigned char TR_5556[2] = {0x55, 0x56};

/*** 將硬體累加器 step_H(高32bit)/step_L(低32bit) 合併成64-bit有號值，
     再除以取樣次數 step_cnt 還原成平均 step，語意對齊舊版軟體 moving average
     的輸出（單一個 float，4 bytes）。step_cnt 為 0 時回傳 0，避免除以0。 */
static float combine_step_avg(my_float_t step_H, my_float_t step_L, my_float_t step_cnt)
{
    alt_64 accu = ((alt_64)step_H.int_val << 32) | (alt_u32)step_L.int_val;
    if (step_cnt.int_val == 0) {
        return 0.0f;
    }
    return (float)accu / (float)step_cnt.int_val;
}

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

        my_float_t step_avg_x, step_avg_y, step_avg_z;
        step_avg_x.float_val = combine_step_avg(data.fog.fogx.step_H, data.fog.fogx.step_L, data.fog.fogx.step_cnt);
        step_avg_y.float_val = combine_step_avg(data.fog.fogy.step_H, data.fog.fogy.step_L, data.fog.fogy.step_cnt);
        step_avg_z.float_val = combine_step_avg(data.fog.fogz.step_H, data.fog.fogz.step_L, data.fog.fogz.step_cnt);

        /*** header*/
        SerialWrite((alt_u8*)HD_ABBA, 2);
        /*** 對齊舊版封包：每軸只送 1 個 4-byte 平均 step 值，軸順序不變 */
        SerialWrite(step_avg_x.bin_val, 4); //對應到FOG Z軸
        SerialWrite(step_avg_y.bin_val, 4); //對應到FOG Y軸
        SerialWrite(step_avg_z.bin_val, 4); //對應到FOG X軸
        /*** adxl357 acc data*/
        SerialWrite(data.adxl357.ax.bin_val, 4); //對應到ACCL X軸
        SerialWrite(data.adxl357.ay.bin_val, 4); //對應到ACCL Y軸
        SerialWrite(data.adxl357.az.bin_val, 4); //對應到ACCL Z軸
        /*** OSH temperature */
        SerialWrite(data.temp.tempx.bin_val, 4); //對應到TEMP Z軸
        SerialWrite(data.temp.tempy.bin_val, 4); //對應到TEMP Y軸
        SerialWrite(data.temp.tempz.bin_val, 4); //對應到TEMP X軸
        /*** adxl357 temp data*/
        SerialWrite(data.adxl357.temp.bin_val, 4);
        /*** time*/
        SerialWrite(data.time.time.bin_val, 4);
        /*** trailer*/
        SerialWrite((alt_u8*)TR_5556, 2);

        /*** for degub */
        // DEBUG_PRINT("time: %f\n", data.time.time.float_val);
        // DEBUG_PRINT("acc: %f, %f, %f, %f\n", data.adxl357.ax.float_val,
        //     data.adxl357.ay.float_val,
        //     data.adxl357.az.float_val,
        //     data.adxl357.temp.float_val
        // );
    }
}
