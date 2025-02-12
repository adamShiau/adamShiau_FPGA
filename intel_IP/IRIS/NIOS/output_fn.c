#include "output_fn.h"

#define INT_SYNC 1
#define EXT_SYNC 2
#define STOP_RUN 4


const unsigned char KVH_HEADER[4] = {0xFE, 0x81, 0xFF, 0x55};
alt_u32 dly_cnt = 0;

void acq_rst (cmd_ctrl_t* rx, my_sensor_t* data, alt_u8* sync)
{
    // if(*sync == 1) {
    //     *sync = 0;
    //     printf("acq_rst mode, ");
    //     printf("%u\n", *sync);
    // }
    if(dly_cnt++ > DLY_NUM) {
        dly_cnt = 0;
        printf("acq_rst mode, ");
    }

    
}

void acq_fog (cmd_ctrl_t* rx, my_sensor_t* data, alt_u8* sync)
{
    my_float_t time, err3, step3, temp3;

    time.float_val = data->time.time.float_val;
    err3.int_val = data->fog.fogz.err.int_val;
    step3.int_val = data->fog.fogz.step.int_val;
    temp3.float_val = data->temp.tempz.float_val;

    if(rx->select_fn == SEL_FOG) {
        rx->select_fn = SEL_IDLE; //clear select_fn
        printf("select acq_fog mode\n");
        if(rx->value == INT_SYNC) { //internal sync mode
            printf("acq_fog select internal mode\n");
            rx->run = 1;
        }
        else if(rx->value == EXT_SYNC) { //external sync mode
            printf("acq_fog select external mode\n");
            rx->run = 1;
        }
        else if(rx->value == STOP_RUN) { //stop
            printf("acq_fog select stop\n");
            rx->run = 0;
        }
    }
    if(rx->run == 1) {
        if(*sync == 1) {
            *sync = 0;

            alt_u8* imu_data = (alt_u8*)malloc(20+4); // KVH_HEADER:4 + time:4 + err:4 + fog:4 + temp:4 + time:4
			alt_u8 CRC32[4];

            memcpy(imu_data, KVH_HEADER, 4);
            memcpy(imu_data+4, time.bin_val, 4); 
            memcpy(imu_data+8, err3.bin_val, 4); 
            memcpy(imu_data+12, step3.bin_val, 4); 
            memcpy(imu_data+16, temp3.bin_val, 4); 
            memcpy(imu_data+20, time.bin_val, 4); 
            crc_32(imu_data, 24, CRC32);
            free(imu_data);

            SerialWrite((alt_u8*)KVH_HEADER, 4); 
            SerialWrite(time.bin_val, 4); 
            SerialWrite(err3.bin_val, 4); 
            SerialWrite(step3.bin_val, 4); 
            SerialWrite(temp3.bin_val, 4); 
            SerialWrite(time.bin_val, 4); 
            SerialWrite(CRC32, 4); 
            
            // printf("time: %f\n", data->time.time.float_val);
            // printf("err: %d\n", data->fog.fogz.err.int_val);
            // printf("temp: %f\n", data->temp.tempz.float_val);

        }
    }


}
