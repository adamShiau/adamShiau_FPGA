#include "output_fn.h"

#define INT_SYNC 1
#define EXT_SYNC 2
#define STOP_RUN 4



const unsigned char KVH_HEADER[4] = {0xFE, 0x81, 0xFF, 0x55};
alt_u32 dly_cnt = 0;

// void acq_rst (cmd_ctrl_t* rx, my_sensor_t data, alt_u8* sync, fog_parameter_t fog_parameter)
// {
//     if(dly_cnt++ > DLY_NUM) {
//         dly_cnt = 0;
//         // DEBUG_PRINT("acq_rst mode\n");
//     }  
// }

void acq_rst (cmd_ctrl_t* rx, my_sensor_t data, fog_parameter_t fog_parameter)
{
    if(dly_cnt++ > DLY_NUM) {
        dly_cnt = 0;
        // DEBUG_PRINT("acq_rst mode\n");
    }  
}

// void acq_fog (cmd_ctrl_t* rx, my_sensor_t data, alt_u8* sync, fog_parameter_t fog_parameter)
// void acq_fog (cmd_ctrl_t* rx, my_sensor_t data, fog_parameter_t fog_parameter)
// {
//     my_float_t time, err1, step1, err2, step2, err3, step3;
//     my_float_t temp3, temp2, temp1;
//     my_float_t ax, ay, az, acc_temp;
    
//     /*** update container parameters */
//     float sf_1_slope, sf_2_slope, sf_3_slope;
//     float sf_1_offset, sf_2_offset, sf_3_offset;

//     if(rx->select_fn == SEL_FOG) {
//         rx->select_fn = SEL_IDLE; //clear select_fn
//         DEBUG_PRINT("select acq_fog mode\n");
//         if(rx->value == INT_SYNC) { //internal sync mode
//             DEBUG_PRINT("acq_fog select internal mode\n");
//             rx->run = 1;
//         }
//         else if(rx->value == EXT_SYNC) { //external sync mode
//             DEBUG_PRINT("acq_fog select external mode\n");
//             rx->run = 1;
//         }
//         else if(rx->value == STOP_RUN) { //stop
//             DEBUG_PRINT("acq_fog select stop\n");
//             rx->run = 0;
//         }
//     }
//     if(rx->run == 1) {

//             sf_1_slope = fog_parameter.paramZ[17].data.float_val;
//             sf_1_offset = fog_parameter.paramZ[18].data.float_val;
//             sf_2_slope = fog_parameter.paramZ[19].data.float_val;
//             sf_2_offset = fog_parameter.paramZ[20].data.float_val;
//             sf_3_slope = fog_parameter.paramZ[21].data.float_val;
//             sf_3_offset = fog_parameter.paramZ[22].data.float_val;

//             time.float_val = data.time.time.float_val;
//             temp1.float_val = data.temp.tempx.float_val*ADC_CONV_TEMP-273.15;
//             temp2.float_val = data.temp.tempy.float_val*ADC_CONV_TEMP-273.15;
//             temp3.float_val = data.temp.tempz.float_val*ADC_CONV_TEMP-273.15;
//             err3.int_val = data.fog.fogz.err.int_val;
//             step3.float_val = data.fog.fogz.step.float_val*(sf_3_slope*temp1.float_val + sf_3_offset); 
//             // step3.float_val = data.fog.fogz.step.float_val*(sf_1_slope*temp1.float_val + sf_1_offset); // temporary use temp1 for IRIS configuration

//             ax.float_val = data.adxl357.ax.float_val*SENS_ADXL357_20G;
//             ay.float_val = data.adxl357.ay.float_val*SENS_ADXL357_20G;
//             az.float_val = data.adxl357.az.float_val*SENS_ADXL357_20G;
//             acc_temp.float_val = 233.2873 - 0.1105*data.adxl357.temp.float_val;
            
//             alt_u8* imu_data = (alt_u8*)malloc(20); // KVH_HEADER:4 + time:4 + err:4 + fog:4 + temp:4
// 			alt_u8 CRC32[4];

//             memcpy(imu_data, KVH_HEADER, 4);
//             memcpy(imu_data+4, time.bin_val, 4); 
//             memcpy(imu_data+8, err3.bin_val, 4); 
//             memcpy(imu_data+12, step3.bin_val, 4); 
//             memcpy(imu_data+16, temp1.bin_val, 4); // AIN0
//             crc_32(imu_data, 20, CRC32);
//             free(imu_data);

//             SerialWrite((alt_u8*)KVH_HEADER, 4); 
//             SerialWrite(time.bin_val, 4); 
//             SerialWrite(err3.bin_val, 4); 
//             SerialWrite(step3.bin_val, 4); 
//             SerialWrite(temp1.bin_val, 4); 
//             SerialWrite(CRC32, 4); 

//             // INFO_PRINT("%f, %f, %f. %f\n", ax.float_val, ay.float_val, az.float_val, acc_temp.float_val);
//             // INFO_PRINT("%f, %f, %f\n", temp1.float_val, temp2.float_val, temp3.float_val);
//     }
// }

void acq_fog (cmd_ctrl_t* rx, my_sensor_t data, fog_parameter_t fog_parameter)
{
    my_float_t err, step_cali, temp;
        
    float step_comp, sf_comp_gyro, bias_comp_gyro;
    static alt_u8 ch = 0;

    if(rx->select_fn == SEL_FOG) {
        rx->select_fn = SEL_IDLE; //clear select_fn
        ch = rx->ch;
        DEBUG_PRINT("select acq_fog mode with ch%u\n", ch);
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
        switch(ch) {
            case X_AXIS:
                err.float_val = data.fog.fogx.err.float_val;
                temp.float_val = data.temp.tempx.float_val;
                sf_comp_gyro = SF_temp_compensation_1st_order_fog(data, fog_parameter, X_AXIS);
                bias_comp_gyro = BIAS_temp_compensation_1st_order_fog_3T(data, fog_parameter, X_AXIS);
                step_comp = data.fog.fogx.step.float_val * sf_comp_gyro - bias_comp_gyro;
                /*** calculate mis-alignment calibrated gyro data */
                step_cali.float_val = misalignment_calibration(step_comp, 0, 0, fog_parameter, MIS_CALI_GYRO).x.float_val;
                UART_PRINT("fog sf_x_comp: %f\n", sf_comp_gyro);
                UART_PRINT("fog bias_x_comp: %f\n", bias_comp_gyro);
                UART_PRINT("fog step_x_comp: %f\n", step_comp);
                UART_PRINT("fog step_x_cali: %f\n", step_cali.float_val);
            break;
            case Y_AXIS:
                err.float_val = data.fog.fogy.err.float_val;
                temp.float_val = data.temp.tempy.float_val;
                sf_comp_gyro = SF_temp_compensation_1st_order_fog(data, fog_parameter, Y_AXIS);
                bias_comp_gyro = BIAS_temp_compensation_1st_order_fog_3T(data, fog_parameter, Y_AXIS);
                step_comp = data.fog.fogy.step.float_val * sf_comp_gyro - bias_comp_gyro;
                /*** calculate mis-alignment calibrated gyro data */
                step_cali.float_val = misalignment_calibration(0, step_comp, 0, fog_parameter, MIS_CALI_GYRO).y.float_val;
                UART_PRINT("fog sf_y_comp: %f\n", sf_comp_gyro);
                UART_PRINT("fog bias_y_comp: %f\n", bias_comp_gyro);
                UART_PRINT("fog step_y_comp: %f\n", step_comp);
                UART_PRINT("fog step_y_cali: %f\n", step_cali.float_val);
            break;
            case Z_AXIS:
                err.float_val = data.fog.fogz.err.float_val;
                temp.float_val = data.temp.tempz.float_val;    
                sf_comp_gyro = SF_temp_compensation_1st_order_fog(data, fog_parameter, Z_AXIS);
                bias_comp_gyro = BIAS_temp_compensation_1st_order_fog_3T(data, fog_parameter, Z_AXIS);
                step_comp = data.fog.fogz.step.float_val * sf_comp_gyro - bias_comp_gyro;
                /*** calculate mis-alignment calibrated gyro data */
                step_cali.float_val = misalignment_calibration(0, 0, step_comp, fog_parameter, MIS_CALI_GYRO).z.float_val;
                UART_PRINT("fog sf_z_comp: %f\n", sf_comp_gyro);
                UART_PRINT("fog bias_z_comp: %f\n", bias_comp_gyro);
                UART_PRINT("fog step_z_comp: %f\n", step_comp);
                UART_PRINT("fog step_z_cali: %f\n", step_cali.float_val);
            break;
        }
        
            alt_u8* imu_data = (alt_u8*)malloc(20); // KVH_HEADER:4 + time:4 + err:4 + fog:4 + temp:4
			alt_u8 CRC32[4];

            memcpy(imu_data, KVH_HEADER, 4);
            memcpy(imu_data+4, data.time.time.bin_val, 4); 
            memcpy(imu_data+8, err.bin_val, 4); 
            memcpy(imu_data+12, step_cali.bin_val, 4); 
            memcpy(imu_data+16, temp.bin_val, 4); // AIN0
            crc_32(imu_data, 20, CRC32);
            free(imu_data);

            SerialWrite((alt_u8*)KVH_HEADER, 4); 
            SerialWrite(data.time.time.bin_val, 4); 
            SerialWrite(err.bin_val, 4); 
            SerialWrite(step_cali.bin_val, 4); 
            SerialWrite(temp.bin_val, 4); 
            SerialWrite(CRC32, 4); 
    }
}


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
            /*** gyro scale factor temperature  compensation*/
            sf_x_comp_gyro = SF_temp_compensation_1st_order_fog(data, fog_parameter, X_AXIS); // gyro x axis SF Temp. compensation
            sf_y_comp_gyro = SF_temp_compensation_1st_order_fog(data, fog_parameter, Y_AXIS); // gyro y axis SF Temp. compensation
            sf_z_comp_gyro = SF_temp_compensation_1st_order_fog(data, fog_parameter, Z_AXIS); // gyro z axis SF Temp. compensation
            UART_PRINT("imu sf_comp_gyro: %f, %f, %f\n", sf_x_comp_gyro, sf_y_comp_gyro, sf_z_comp_gyro);
            /*** accelerometer scale factor temperature compensation*/
            sf_x_comp_accl = SF_temp_compensation_1st_order_adxl357(data, fog_parameter, X_AXIS); // accl x axis SF Temp. compensation;
            sf_y_comp_accl = SF_temp_compensation_1st_order_adxl357(data, fog_parameter, Y_AXIS); // accl y axis SF Temp. compensation;
            sf_z_comp_accl = SF_temp_compensation_1st_order_adxl357(data, fog_parameter, Z_AXIS); // accl z axis SF Temp. compensation;
            /*** gyro bias temperature  compensation*/
            bias_x_comp_gyro = BIAS_temp_compensation_1st_order_fog_3T(data, fog_parameter, X_AXIS); // gyro x axis Bias Temp. compensation
            bias_y_comp_gyro = BIAS_temp_compensation_1st_order_fog_3T(data, fog_parameter, Y_AXIS); // gyro y axis Bias Temp. compensation
            bias_z_comp_gyro = BIAS_temp_compensation_1st_order_fog_3T(data, fog_parameter, Z_AXIS); // gyro z axis Bias Temp. compensation
            UART_PRINT("imu bias_comp_gyro: %f, %f, %f\n", bias_x_comp_gyro, bias_y_comp_gyro, bias_z_comp_gyro);
            /*** xlm bias temperature  compensation*/
            bias_x_comp_accl = BIAS_temp_compensation_1st_order_adxl357(data, fog_parameter, X_AXIS); // accl x axis Bias Temp. compensation
            bias_y_comp_accl = BIAS_temp_compensation_1st_order_adxl357(data, fog_parameter, Y_AXIS); // accl y axis Bias Temp. compensation
            bias_z_comp_accl = BIAS_temp_compensation_1st_order_adxl357(data, fog_parameter, Z_AXIS); // accl z axis Bias Temp. compensation
            /*** calculate temperature compensated gyro data */
            step_x_comp = data.fog.fogx.step.float_val * sf_x_comp_gyro - bias_x_comp_gyro;
            step_y_comp = data.fog.fogy.step.float_val * sf_y_comp_gyro - bias_y_comp_gyro;
            step_z_comp = data.fog.fogz.step.float_val * sf_z_comp_gyro - bias_z_comp_gyro;
            UART_PRINT("imu step_comp: %f, %f, %f\n", step_x_comp, step_y_comp, step_z_comp);
            /*** calculate temperature compensated accl data */
            accl_x_comp = data.adxl357.ax.float_val * sf_x_comp_accl - bias_x_comp_accl;
            accl_y_comp = data.adxl357.ay.float_val * sf_y_comp_accl - bias_y_comp_accl;
            accl_z_comp = data.adxl357.az.float_val * sf_z_comp_accl - bias_z_comp_accl;
            /*** calculate mis-alignment calibrated gyro data */
            gyro_misalign_calibrated = misalignment_calibration(step_x_comp, step_y_comp, step_z_comp, fog_parameter, MIS_CALI_GYRO);
            UART_PRINT("step_cali: %f, %f, %f\n", gyro_misalign_calibrated.x.float_val, gyro_misalign_calibrated.y.float_val, gyro_misalign_calibrated.z.float_val);
            /*** calculate mis-alignment calibrated accl data */
            accl_misalign_calibrated = misalignment_calibration(accl_x_comp, accl_y_comp, accl_z_comp, fog_parameter, MIS_CALI_ACCL);

            
            alt_u8* imu_data = (alt_u8*)malloc(48); // KVH_HEADER:4 + fog:12 + accl:12 + fog_temp:12 + accl_temp:4 + time:4 
			alt_u8 CRC32[4];

            memcpy(imu_data, KVH_HEADER, 4);
            memcpy(imu_data+4, gyro_misalign_calibrated.x.bin_val, 4); 
            memcpy(imu_data+8, gyro_misalign_calibrated.y.bin_val, 4); 
            memcpy(imu_data+12, gyro_misalign_calibrated.z.bin_val, 4); 
            memcpy(imu_data+16, accl_misalign_calibrated.x.bin_val, 4); 
            memcpy(imu_data+20, accl_misalign_calibrated.y.bin_val, 4); 
            memcpy(imu_data+24, accl_misalign_calibrated.z.bin_val, 4); 
            memcpy(imu_data+28, data.temp.tempx.bin_val, 4); 
            memcpy(imu_data+28, data.temp.tempy.bin_val, 4); 
            memcpy(imu_data+28, data.temp.tempz.bin_val, 4); 
            memcpy(imu_data+40, data.adxl357.temp.bin_val, 4); 
            memcpy(imu_data+44, data.time.time.bin_val, 4);              
            crc_32(imu_data, 48, CRC32);
            free(imu_data);

            SerialWrite((alt_u8*)KVH_HEADER, 4); 
            SerialWrite(gyro_misalign_calibrated.x.bin_val, 4); 
            SerialWrite(gyro_misalign_calibrated.y.bin_val, 4); 
            SerialWrite(gyro_misalign_calibrated.z.bin_val, 4); 
            SerialWrite(accl_misalign_calibrated.x.bin_val, 4); 
            SerialWrite(accl_misalign_calibrated.y.bin_val, 4); 
            SerialWrite(accl_misalign_calibrated.z.bin_val, 4); 
            SerialWrite(data.temp.tempx.bin_val, 4);
            SerialWrite(data.temp.tempy.bin_val, 4);
            SerialWrite(data.temp.tempz.bin_val, 4); 
            SerialWrite(data.adxl357.temp.bin_val, 4);
            SerialWrite(data.time.time.bin_val, 4);
            SerialWrite(CRC32, 4); 
    }
}
