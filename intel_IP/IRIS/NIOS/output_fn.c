#include "output_fn.h"

#define INT_SYNC 1
#define EXT_SYNC 2
#define STOP_RUN 4

/*** ADC convertion coefficient */
#define ADC_CONV_TEMP 0.00004447005 // 2.048/8388608.0*1000.0/5.49



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
    my_float_t time, err1, step1, err2, step2, err3, step3;
    my_float_t temp3, temp2, temp1;
    my_float_t ax, ay, az, acc_temp;
    
    /*** update container parameters */
    float sf_1_slope, sf_2_slope, sf_3_slope;
    float sf_1_offset, sf_2_offset, sf_3_offset;

    if(rx->select_fn == SEL_FOG) {
        rx->select_fn = SEL_IDLE; //clear select_fn
        DEBUG_PRINT("select acq_fog mode\n");
        if(rx->value == INT_SYNC) { //internal sync mode
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
            temp1.float_val = data.temp.tempx.float_val*ADC_CONV_TEMP-273.15;
            temp2.float_val = data.temp.tempy.float_val*ADC_CONV_TEMP-273.15;
            temp3.float_val = data.temp.tempz.float_val*ADC_CONV_TEMP-273.15;
            err3.int_val = data.fog.fogz.err.int_val;
            step3.float_val = data.fog.fogz.step.float_val*(sf_3_slope*temp1.float_val + sf_3_offset); 
            // step3.float_val = data.fog.fogz.step.float_val*(sf_1_slope*temp1.float_val + sf_1_offset); // temporary use temp1 for IRIS configuration

            ax.float_val = data.adxl357.ax.float_val*SENS_ADXL357_20G;
            ay.float_val = data.adxl357.ay.float_val*SENS_ADXL357_20G;
            az.float_val = data.adxl357.az.float_val*SENS_ADXL357_20G;
            acc_temp.float_val = 233.2873 - 0.1105*data.adxl357.temp.float_val;
            
            alt_u8* imu_data = (alt_u8*)malloc(20); // KVH_HEADER:4 + time:4 + err:4 + fog:4 + temp:4
			alt_u8 CRC32[4];

            memcpy(imu_data, KVH_HEADER, 4);
            memcpy(imu_data+4, time.bin_val, 4); 
            memcpy(imu_data+8, err3.bin_val, 4); 
            memcpy(imu_data+12, step3.bin_val, 4); 
            memcpy(imu_data+16, temp1.bin_val, 4); // AIN0
            crc_32(imu_data, 20, CRC32);
            free(imu_data);

            SerialWrite((alt_u8*)KVH_HEADER, 4); 
            SerialWrite(time.bin_val, 4); 
            SerialWrite(err3.bin_val, 4); 
            SerialWrite(step3.bin_val, 4); 
            SerialWrite(temp1.bin_val, 4); 
            SerialWrite(CRC32, 4); 

            // INFO_PRINT("%f, %f, %f. %f\n", ax.float_val, ay.float_val, az.float_val, acc_temp.float_val);
            // INFO_PRINT("%f, %f, %f\n", temp1.float_val, temp2.float_val, temp3.float_val);
        }
    }
}

void acq_imu (cmd_ctrl_t* rx, my_sensor_t data, alt_u8* sync, fog_parameter_t fog_parameter)
{
    my_float_t time, err_z, err_y, err_x, step_z, step_y, step_x, temp_z, temp_y, temp_x;
    my_float_t ax, ay, az, acc_temp;
    
    /*** local variables for gyro container parameters */
    float sf_x_slope, sf_y_slope, sf_z_slope;
    float sf_x_offset, sf_y_offset, sf_z_offset;
    float sf_x_comp, sf_y_comp, sf_z_comp;
    float bias_x_T1, bias_x_T2, bias_y_T1, bias_y_T2, bias_z_T1, bias_z_T2;
    float bias_x_slope_1, bias_x_slope_2, bias_x_slope_3, bias_x_offset_1, bias_x_offset_2, bias_x_offset_3;
    float bias_y_slope_1, bias_y_slope_2, bias_y_slope_3, bias_y_offset_1, bias_y_offset_2, bias_y_offset_3;
    float bias_z_slope_1, bias_z_slope_2, bias_z_slope_3, bias_z_offset_1, bias_z_offset_2, bias_z_offset_3;
    float bias_x_comp, bias_y_comp, bias_z_comp;
    /*** local variables for xlm container parameters */
    // float bias_x_slope_xlm, bias_y_slope_xlm, bias_z_slope_xlm;
    // float bias_x_offset_xlm, bias_y_offset_xlm, bias_z_offset_xlm;
    

    if(rx->select_fn == SEL_IMU) {
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
        if(*sync == 1) {
            *sync = 0;

            /*** obtain gyro temperature  compensation parameters*/
            /*** -------scale factor------- */
            sf_x_slope = fog_parameter.paramX[17].data.float_val;
            sf_x_offset = fog_parameter.paramX[18].data.float_val;
            sf_y_slope = fog_parameter.paramY[17].data.float_val;
            sf_y_offset = fog_parameter.paramY[18].data.float_val;
            sf_z_slope = fog_parameter.paramZ[17].data.float_val;
            sf_z_offset = fog_parameter.paramZ[18].data.float_val;
            /*** -------bias------- */
            bias_x_T1 = fog_parameter.paramX[23].data.float_val;
            bias_x_T2 = fog_parameter.paramX[24].data.float_val;
            bias_y_T1 = fog_parameter.paramY[23].data.float_val;
            bias_y_T2 = fog_parameter.paramY[24].data.float_val;
            bias_z_T1 = fog_parameter.paramZ[23].data.float_val;
            bias_z_T2 = fog_parameter.paramZ[24].data.float_val;
            bias_x_slope_1 = fog_parameter.paramX[25].data.float_val;
            bias_x_slope_2 = fog_parameter.paramX[27].data.float_val;
            bias_x_slope_3 = fog_parameter.paramX[29].data.float_val;
            bias_x_offset_1 = fog_parameter.paramX[26].data.float_val;
            bias_x_offset_2 = fog_parameter.paramX[28].data.float_val;
            bias_x_offset_3 = fog_parameter.paramX[30].data.float_val;
            bias_y_slope_1 = fog_parameter.paramY[25].data.float_val;
            bias_y_slope_2 = fog_parameter.paramY[27].data.float_val;
            bias_y_slope_3 = fog_parameter.paramY[29].data.float_val;
            bias_y_offset_1 = fog_parameter.paramY[26].data.float_val;
            bias_y_offset_2 = fog_parameter.paramY[28].data.float_val;
            bias_y_offset_3 = fog_parameter.paramY[30].data.float_val;
            bias_z_slope_1 = fog_parameter.paramZ[25].data.float_val;
            bias_z_slope_2 = fog_parameter.paramZ[27].data.float_val;
            bias_z_slope_3 = fog_parameter.paramZ[29].data.float_val;
            bias_z_offset_1 = fog_parameter.paramZ[26].data.float_val;
            bias_z_offset_2 = fog_parameter.paramZ[28].data.float_val;
            bias_z_offset_3 = fog_parameter.paramZ[30].data.float_val;
            /*** obtain xlm temperature  compensation parameters*/
            /*** -------bias------- */
            // bias_x_slope_xlm = fog_parameter.paramX[31].data.float_val;
            // bias_x_offset_xlm = fog_parameter.paramX[32].data.float_val;
            // bias_y_slope_xlm = fog_parameter.paramY[31].data.float_val;
            // bias_y_offset_xlm = fog_parameter.paramY[32].data.float_val;
            // bias_z_slope_xlm = fog_parameter.paramZ[31].data.float_val;
            // bias_z_offset_xlm = fog_parameter.paramZ[32].data.float_val;

            time.float_val = data.time.time.float_val;
            temp_x.float_val = data.temp.tempx.float_val*ADC_CONV_TEMP - 273.15;
            temp_y.float_val = data.temp.tempy.float_val*ADC_CONV_TEMP - 273.15;
            temp_z.float_val = data.temp.tempz.float_val*ADC_CONV_TEMP - 273.15;
            err_z.int_val = data.fog.fogz.err.int_val;
            err_y.int_val = data.fog.fogy.err.int_val;
            err_x.int_val = data.fog.fogx.err.int_val;
            // step_z.float_val = data.fog.fogz.step.float_val*(sf_z_slope*temp_z.float_val + sf_z_offset);
            // step_y.float_val = data.fog.fogy.step.float_val*(sf_y_slope*temp_y.float_val + sf_y_offset);
            // step_x.float_val = data.fog.fogx.step.float_val*(sf_x_slope*temp_x.float_val + sf_x_offset);
            
            /*** gyro scale factor temperature  compesation*/
            sf_x_comp = temp_compensation_1st_order(temp_x.float_val, sf_x_slope, sf_x_offset);
            sf_y_comp = temp_compensation_1st_order(temp_y.float_val, sf_y_slope, sf_y_offset);
            sf_z_comp = temp_compensation_1st_order(temp_z.float_val, sf_z_slope, sf_z_offset);
            /*** gyro bias temperature  compesation*/
            // bias_x_comp = temp_compensation_1st_order_3T(temp_x.float_val, bias_x_T1, bias_x_T2, bias_x_slope_1, bias_x_offset_1, 
            //     bias_x_slope_2, bias_x_offset_2, bias_x_slope_3, bias_x_offset_3);
            // bias_y_comp = temp_compensation_1st_order_3T(temp_y.float_val, bias_y_T1, bias_y_T2, bias_y_slope_1, bias_y_offset_1, 
            //     bias_y_slope_2, bias_y_offset_2, bias_y_slope_3, bias_y_offset_3);
            // bias_z_comp = temp_compensation_1st_order_3T(temp_z.float_val, bias_z_T1, bias_z_T2, bias_z_slope_1, bias_z_offset_1, 
            //     bias_z_slope_2, bias_z_offset_2, bias_z_slope_3, bias_z_offset_3);

            step_x.float_val = data.fog.fogx.step.float_val * sf_x_comp;
            step_y.float_val = data.fog.fogy.step.float_val * sf_y_comp;
            step_z.float_val = data.fog.fogz.step.float_val * sf_z_comp;

            ax.float_val = data.adxl357.ax.float_val*SENS_ADXL357_20G;
            ay.float_val = data.adxl357.ay.float_val*SENS_ADXL357_20G;
            az.float_val = data.adxl357.az.float_val*SENS_ADXL357_20G;
            acc_temp.float_val = 233.2873 - 0.1105*data.adxl357.temp.float_val;
            
            alt_u8* imu_data = (alt_u8*)malloc(48); // KVH_HEADER:4 + fog:12 + accl:12 + fog_temp:12 + accl_temp:4 + time:4 
			alt_u8 CRC32[4];

            memcpy(imu_data, KVH_HEADER, 4);
            memcpy(imu_data+4, step_x.bin_val, 4); 
            memcpy(imu_data+8, step_y.bin_val, 4); 
            memcpy(imu_data+12, step_z.bin_val, 4); 
            memcpy(imu_data+16, ax.bin_val, 4); 
            memcpy(imu_data+20, ay.bin_val, 4); 
            memcpy(imu_data+24, az.bin_val, 4); 
            memcpy(imu_data+28, temp_x.bin_val, 4); 
            memcpy(imu_data+32, temp_y.bin_val, 4); 
            memcpy(imu_data+36, temp_z.bin_val, 4); 
            memcpy(imu_data+40, acc_temp.bin_val, 4); 
            memcpy(imu_data+44, time.bin_val, 4);            
            crc_32(imu_data, 48, CRC32);
            free(imu_data);

            SerialWrite((alt_u8*)KVH_HEADER, 4); 
            SerialWrite(step_x.bin_val, 4); 
            SerialWrite(step_y.bin_val, 4); 
            SerialWrite(step_z.bin_val, 4); 
            SerialWrite(ax.bin_val, 4); 
            SerialWrite(ay.bin_val, 4); 
            SerialWrite(az.bin_val, 4); 
            SerialWrite(temp_x.bin_val, 4);
            SerialWrite(temp_y.bin_val, 4);
            SerialWrite(temp_z.bin_val, 4); 
            SerialWrite(acc_temp.bin_val, 4);
            SerialWrite(time.bin_val, 4);
            SerialWrite(CRC32, 4); 

            // INFO_PRINT("%f, %f, %f. %f\n", ax.float_val, ay.float_val, az.float_val, acc_temp.float_val);
            // INFO_PRINT("%f, %f, %f\n", temp_x.float_val, temp_y.float_val, temp_z.float_val);
        }
    }
}
