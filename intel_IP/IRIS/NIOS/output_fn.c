#include "output_fn.h"

#define INT_SYNC 1
#define EXT_SYNC 2
#define STOP_RUN 4


const unsigned char KVH_HEADER[4] = {0xFE, 0x81, 0xFF, 0x55};
alt_u32 dly_cnt = 0;

void acq_rst (cmd_ctrl_t* rx, my_sensor_t data, alt_u8* sync, fog_parameter_t fog_parameter)
{
    if(dly_cnt++ > DLY_NUM) {
        dly_cnt = 0;
        // DEBUG_PRINT("acq_rst mode\n");
    }

    
}

void acq_fog (cmd_ctrl_t* rx, my_sensor_t data, alt_u8* sync, fog_parameter_t fog_parameter)
{
    my_float_t time, err3, step3, temp3;
    my_float_t ax, ay, az, acc_temp;
    
    /*** update container parameters */
    float sf_1_slope, sf_2_slope, sf_3_slope;
    float sf_1_offset, sf_2_offset, sf_3_offset;

    if(rx->select_fn == SEL_FOG) {
        rx->select_fn = SEL_IDLE; //clear select_fn
        DEBUG_PRINT("select acq_fog mode\n");
        if(rx->value == INT_SYNC) { //internal sync mode
            // DEBUG_PRINT("acq_fog select internal mode\n");
            DEBUG_PRINT("acq_fog select internal mode\n");
            rx->run = 1;
        }
        else if(rx->value == EXT_SYNC) { //external sync mode
            DEBUG_PRINT("acq_fog select external mode\n");
            rx->run = 1;
        }
        else if(rx->value == STOP_RUN) { //stop
            DEBUG_PRINT("acq_fog select stop\n");
            rx->run = 0;
        }
    }
    if(rx->run == 1) {
        if(*sync == 1) {
            *sync = 0;

            sf_1_slope = fog_parameter.paramZ[17].data.float_val;
            sf_1_offset = fog_parameter.paramZ[18].data.float_val;
            sf_2_slope = fog_parameter.paramZ[19].data.float_val;
            sf_2_offset = fog_parameter.paramZ[20].data.float_val;
            sf_3_slope = fog_parameter.paramZ[21].data.float_val;
            sf_3_offset = fog_parameter.paramZ[22].data.float_val;

            time.float_val = data.time.time.float_val;
            temp3.float_val = data.temp.tempz.float_val;
            err3.int_val = data.fog.fogz.err.int_val;
            step3.float_val = data.fog.fogz.step.float_val*(sf_1_slope*temp3.float_val + sf_1_offset);

            ax.float_val = data.adxl357.ax.float_val*SENS_ADXL357_20G;
            ay.float_val = data.adxl357.ay.float_val*SENS_ADXL357_20G;
            az.float_val = data.adxl357.az.float_val*SENS_ADXL357_20G;
            acc_temp.float_val = 233.2873 - 0.1105*data.adxl357.temp.float_val;
            
            alt_u8* imu_data = (alt_u8*)malloc(16+4); // KVH_HEADER:4 + time:4 + err:4 + fog:4 + temp:4
			alt_u8 CRC32[4];

            memcpy(imu_data, KVH_HEADER, 4);
            memcpy(imu_data+4, time.bin_val, 4); 
            memcpy(imu_data+8, err3.bin_val, 4); 
            memcpy(imu_data+12, step3.bin_val, 4); 
            memcpy(imu_data+16, temp3.bin_val, 4); 
            crc_32(imu_data, 20, CRC32);
            free(imu_data);

            SerialWrite((alt_u8*)KVH_HEADER, 4); 
            SerialWrite(time.bin_val, 4); 
            SerialWrite(err3.bin_val, 4); 
            SerialWrite(step3.bin_val, 4); 
            SerialWrite(temp3.bin_val, 4); 
            SerialWrite(CRC32, 4); 

            INFO_PRINT("%f, %f, %f. %f\n", ax.float_val, ay.float_val, az.float_val, acc_temp.float_val);

        }
    }


}
