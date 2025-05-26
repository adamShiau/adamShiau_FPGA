//v2版測試不要使用函數寫法的速度
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

void acq_fog (cmd_ctrl_t* rx, my_sensor_t data, fog_parameter_t fog_parameter)
{
    my_float_t err, step_cali, temp;
        
    float step_comp, sf_comp_gyro, bias_comp_gyro;
    static alt_u8 ch = 0;

    if(rx->select_fn == SEL_FOG) {
        UART_PRINT("acq_fog\n");
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
                // UART_PRINT("fog sf_x_comp: %f\n", sf_comp_gyro);
                // UART_PRINT("fog bias_x_comp: %f\n", bias_comp_gyro);
                // UART_PRINT("fog step_x_comp: %f\n", step_comp);
                // UART_PRINT("fog step_x_cali: %f\n", step_cali.float_val);
            break;
            case Y_AXIS:
            // UART_PRINT("%d,", get_timer_int());
            // g_time[2] = get_timer_int();
                err.float_val = data.fog.fogy.err.float_val;
                temp.float_val = data.temp.tempy.float_val;
                sf_comp_gyro = SF_temp_compensation_1st_order_fog(data, fog_parameter, Y_AXIS);
                bias_comp_gyro = BIAS_temp_compensation_1st_order_fog_3T(data, fog_parameter, Y_AXIS);
                step_comp = data.fog.fogy.step.float_val * sf_comp_gyro - bias_comp_gyro;
                /*** calculate mis-alignment calibrated gyro data */
                step_cali.float_val = misalignment_calibration(0, step_comp, 0, fog_parameter, MIS_CALI_GYRO).y.float_val;
                // UART_PRINT("fog sf_y_comp: %f\n", sf_comp_gyro);
                // UART_PRINT("fog bias_y_comp: %f\n", bias_comp_gyro);
                // UART_PRINT("fog step_y_comp: %f\n", step_comp);
                // UART_PRINT("fog step_y_cali: %f\n", step_cali.float_val);
            break;
            case Z_AXIS:
                err.float_val = data.fog.fogz.err.float_val;
                temp.float_val = data.temp.tempz.float_val;    
                sf_comp_gyro = SF_temp_compensation_1st_order_fog(data, fog_parameter, Z_AXIS);
                bias_comp_gyro = BIAS_temp_compensation_1st_order_fog_3T(data, fog_parameter, Z_AXIS);
                step_comp = data.fog.fogz.step.float_val * sf_comp_gyro - bias_comp_gyro;
                /*** calculate mis-alignment calibrated gyro data */
                step_cali.float_val = misalignment_calibration(0, 0, step_comp, fog_parameter, MIS_CALI_GYRO).z.float_val;
                // UART_PRINT("fog sf_z_comp: %f\n", sf_comp_gyro);
                // UART_PRINT("fog bias_z_comp: %f\n", bias_comp_gyro);
                // UART_PRINT("fog step_z_comp: %f\n", step_comp);
                // UART_PRINT("fog step_z_cali: %f\n", step_cali.float_val);
            break;
        }
            // g_time[3] = get_timer_int();
            alt_u8* imu_data = (alt_u8*)malloc(20); // KVH_HEADER:4 + time:4 + err:4 + fog:4 + temp:4
			alt_u8 CRC32[4];

            memcpy(imu_data, KVH_HEADER, 4);
            memcpy(imu_data+4, data.time.time.bin_val, 4); 
            memcpy(imu_data+8, err.bin_val, 4); 
            memcpy(imu_data+12, step_cali.bin_val, 4); 
            memcpy(imu_data+16, temp.bin_val, 4); // AIN0
            crc_32(imu_data, 20, CRC32);
            free(imu_data);

            // SerialWrite((alt_u8*)KVH_HEADER, 4); 
            // SerialWrite(data.time.time.bin_val, 4); 
            // SerialWrite(err.bin_val, 4); 
            // SerialWrite(step_cali.bin_val, 4); 
            // SerialWrite(temp.bin_val, 4); 
            // SerialWrite(CRC32, 4); 
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
        UART_PRINT("acq_imu\n");
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
        g_time[2] = get_timer_int();    
            /*** gyro scale factor temperature  compensation*/
            
            // sf_x_comp_gyro = SF_temp_compensation_1st_order_fog(data, fog_parameter, X_AXIS); // gyro x axis SF Temp. compensation
            // sf_y_comp_gyro = SF_temp_compensation_1st_order_fog(data, fog_parameter, Y_AXIS); // gyro y axis SF Temp. compensation
            // sf_z_comp_gyro = SF_temp_compensation_1st_order_fog(data, fog_parameter, Z_AXIS); // gyro z axis SF Temp. compensation

            float temp_gyro, slope_gyro, offset_gyro;

            // X-axis compensation
            temp_gyro   = data.temp.tempx.float_val;
            slope_gyro  = fog_parameter.paramX[17].data.float_val;
            offset_gyro = fog_parameter.paramX[18].data.float_val;
            sf_x_comp_gyro = SF_TEMP_COMPENSATION_1ST_ORDER(temp_gyro, slope_gyro, offset_gyro);

            // Y-axis compensation
            temp_gyro   = data.temp.tempy.float_val;
            slope_gyro  = fog_parameter.paramY[17].data.float_val;
            offset_gyro = fog_parameter.paramY[18].data.float_val;
            sf_y_comp_gyro = SF_TEMP_COMPENSATION_1ST_ORDER(temp_gyro, slope_gyro, offset_gyro);

            // Z-axis compensation
            temp_gyro   = data.temp.tempz.float_val;
            slope_gyro  = fog_parameter.paramZ[17].data.float_val;
            offset_gyro = fog_parameter.paramZ[18].data.float_val;
            sf_z_comp_gyro = SF_TEMP_COMPENSATION_1ST_ORDER(temp_gyro, slope_gyro, offset_gyro);


            g_time[3] = get_timer_int();   
            /*** ------ End of gyro scale factor temperature compensation*/ 

            /*** accelerometer scale factor temperature compensation*/
            // sf_x_comp_accl = SF_temp_compensation_1st_order_adxl357(data, fog_parameter, X_AXIS); // accl x axis SF Temp. compensation;
            // sf_y_comp_accl = SF_temp_compensation_1st_order_adxl357(data, fog_parameter, Y_AXIS); // accl y axis SF Temp. compensation;
            // sf_z_comp_accl = SF_temp_compensation_1st_order_adxl357(data, fog_parameter, Z_AXIS); // accl z axis SF Temp. compensation;

            float temp_acc, slope_acc, offset_acc;

            // X-axis compensation
            temp_acc = data.adxl357.temp.float_val;
            slope_acc = fog_parameter.paramX[31].data.float_val;
            offset_acc = fog_parameter.paramX[32].data.float_val;
            sf_x_comp_accl = SF_TEMP_COMPENSATION_1ST_ORDER(temp_acc, slope_acc, offset_acc);

            // Y-axis compensation
            temp_acc = data.adxl357.temp.float_val;
            slope_acc = fog_parameter.paramY[31].data.float_val;
            offset_acc = fog_parameter.paramY[32].data.float_val;
            sf_y_comp_accl = SF_TEMP_COMPENSATION_1ST_ORDER(temp_acc, slope_acc, offset_acc);

            // Z-axis compensation
            temp_acc = data.adxl357.temp.float_val;
            slope_acc = fog_parameter.paramZ[31].data.float_val;
            offset_acc = fog_parameter.paramZ[32].data.float_val;
            sf_z_comp_accl = SF_TEMP_COMPENSATION_1ST_ORDER(temp_acc, slope_acc, offset_acc);

            g_time[4] = get_timer_int();  
            /*** ------ End of accelerometer scale factor temperature compensation*/ 

            /*** gyro bias temperature  compensation*/
            // bias_x_comp_gyro = BIAS_temp_compensation_1st_order_fog_3T(data, fog_parameter, X_AXIS); // gyro x axis Bias Temp. compensation
            // bias_y_comp_gyro = BIAS_temp_compensation_1st_order_fog_3T(data, fog_parameter, Y_AXIS); // gyro y axis Bias Temp. compensation
            // bias_z_comp_gyro = BIAS_temp_compensation_1st_order_fog_3T(data, fog_parameter, Z_AXIS); // gyro z axis Bias Temp. compensation

            float temp_gyro_bias, T1, T2;
            float slope1, offset1, slope2, offset2, slope3, offset3;

            // X-axis bias compensation
            temp_gyro_bias  = data.temp.tempx.float_val;
            T1         = fog_parameter.paramX[23].data.float_val;
            T2         = fog_parameter.paramX[24].data.float_val;
            slope1     = fog_parameter.paramX[25].data.float_val;
            offset1    = fog_parameter.paramX[26].data.float_val;
            slope2     = fog_parameter.paramX[27].data.float_val;
            offset2    = fog_parameter.paramX[28].data.float_val;
            slope3     = fog_parameter.paramX[29].data.float_val;
            offset3    = fog_parameter.paramX[30].data.float_val;
            bias_x_comp_gyro = BIAS_TEMP_COMPENSATION_1ST_ORDER_3T(temp_gyro_bias, T1, T2, slope1, offset1, slope2, offset2, slope3, offset3);

            // Y-axis bias compensation
            temp_gyro_bias  = data.temp.tempy.float_val;
            T1         = fog_parameter.paramY[23].data.float_val;
            T2         = fog_parameter.paramY[24].data.float_val;
            slope1     = fog_parameter.paramY[25].data.float_val;
            offset1    = fog_parameter.paramY[26].data.float_val;
            slope2     = fog_parameter.paramY[27].data.float_val;
            offset2    = fog_parameter.paramY[28].data.float_val;
            slope3     = fog_parameter.paramY[29].data.float_val;
            offset3    = fog_parameter.paramY[30].data.float_val;
            bias_y_comp_gyro = BIAS_TEMP_COMPENSATION_1ST_ORDER_3T(temp_gyro_bias, T1, T2, slope1, offset1, slope2, offset2, slope3, offset3);

            // Z-axis bias compensation
            temp_gyro_bias  = data.temp.tempz.float_val;
            T1         = fog_parameter.paramZ[23].data.float_val;
            T2         = fog_parameter.paramZ[24].data.float_val;
            slope1     = fog_parameter.paramZ[25].data.float_val;
            offset1    = fog_parameter.paramZ[26].data.float_val;
            slope2     = fog_parameter.paramZ[27].data.float_val;
            offset2    = fog_parameter.paramZ[28].data.float_val;
            slope3     = fog_parameter.paramZ[29].data.float_val;
            offset3    = fog_parameter.paramZ[30].data.float_val;
            bias_z_comp_gyro = BIAS_TEMP_COMPENSATION_1ST_ORDER_3T(temp_gyro_bias, T1, T2, slope1, offset1, slope2, offset2, slope3, offset3);

            g_time[5] = get_timer_int();   
            /*** ------ End of gyro bias temperature compensation*/ 

            /*** xlm bias temperature  compensation*/
            // bias_x_comp_accl = BIAS_temp_compensation_1st_order_adxl357(data, fog_parameter, X_AXIS); // accl x axis Bias Temp. compensation
            // bias_y_comp_accl = BIAS_temp_compensation_1st_order_adxl357(data, fog_parameter, Y_AXIS); // accl y axis Bias Temp. compensation
            // bias_z_comp_accl = BIAS_temp_compensation_1st_order_adxl357(data, fog_parameter, Z_AXIS); // accl z axis Bias Temp. compensation

            float temp_acc_bias, slope_acc_bias, offset_acc_bias;

            // X-axis accl bias compensation
            temp_acc_bias     = data.adxl357.temp.float_val;
            slope_acc_bias    = fog_parameter.paramX[33].data.float_val;
            offset_acc_bias   = fog_parameter.paramX[34].data.float_val;
            bias_x_comp_accl = SF_TEMP_COMPENSATION_1ST_ORDER(temp_acc_bias, slope_acc_bias, offset_acc_bias);

            // Y-axis accl bias compensation
            temp_acc_bias     = data.adxl357.temp.float_val;
            slope_acc_bias    = fog_parameter.paramY[33].data.float_val;
            offset_acc_bias   = fog_parameter.paramY[34].data.float_val;
            bias_y_comp_accl = SF_TEMP_COMPENSATION_1ST_ORDER(temp_acc_bias, slope_acc_bias, offset_acc_bias);

            // Z-axis accl bias compensation
            temp_acc_bias     = data.adxl357.temp.float_val;
            slope_acc_bias    = fog_parameter.paramZ[33].data.float_val;
            offset_acc_bias   = fog_parameter.paramZ[34].data.float_val;
            bias_z_comp_accl = SF_TEMP_COMPENSATION_1ST_ORDER(temp_acc_bias, slope_acc_bias, offset_acc_bias);

            g_time[6] = get_timer_int();   
            /*** ------ End of xlm bias temperature  compensation*/ 

            /*** calculate temperature compensated gyro data */
            step_x_comp = data.fog.fogx.step.float_val * sf_x_comp_gyro - bias_x_comp_gyro;
            step_y_comp = data.fog.fogy.step.float_val * sf_y_comp_gyro - bias_y_comp_gyro;
            step_z_comp = data.fog.fogz.step.float_val * sf_z_comp_gyro - bias_z_comp_gyro;
            g_time[7] = get_timer_int();   

            /*** calculate temperature compensated accl data */
            accl_x_comp = data.adxl357.ax.float_val * sf_x_comp_accl - bias_x_comp_accl;
            accl_y_comp = data.adxl357.ay.float_val * sf_y_comp_accl - bias_y_comp_accl;
            accl_z_comp = data.adxl357.az.float_val * sf_z_comp_accl - bias_z_comp_accl;
            g_time[8] = get_timer_int();   

            /*** calculate mis-alignment calibrated gyro data */
            float cx, cy, cz;
            float c11, c12, c13, c21, c22, c23, c31, c32, c33;

            // === GYRO MISALIGNMENT CALIBRATION ===
            cx = fog_parameter.misalignment[12].data.float_val;
            cy = fog_parameter.misalignment[13].data.float_val;
            cz = fog_parameter.misalignment[14].data.float_val;
            c11 = fog_parameter.misalignment[15].data.float_val;
            c12 = fog_parameter.misalignment[16].data.float_val;
            c13 = fog_parameter.misalignment[17].data.float_val;
            c21 = fog_parameter.misalignment[18].data.float_val;
            c22 = fog_parameter.misalignment[19].data.float_val;
            c23 = fog_parameter.misalignment[20].data.float_val;
            c31 = fog_parameter.misalignment[21].data.float_val;
            c32 = fog_parameter.misalignment[22].data.float_val;
            c33 = fog_parameter.misalignment[23].data.float_val;

            gyro_misalign_calibrated.x.float_val = c11 * step_x_comp + c12 * step_y_comp + c13 * step_z_comp + cx;
            gyro_misalign_calibrated.y.float_val = c21 * step_x_comp + c22 * step_y_comp + c23 * step_z_comp + cy;
            gyro_misalign_calibrated.z.float_val = c31 * step_x_comp + c32 * step_y_comp + c33 * step_z_comp + cz;


            // gyro_misalign_calibrated = misalignment_calibration(step_x_comp, step_y_comp, step_z_comp, fog_parameter, MIS_CALI_GYRO);
            g_time[9] = get_timer_int();   

            /*** calculate mis-alignment calibrated accl data */
            // === ACCL MISALIGNMENT CALIBRATION ===
            cx = fog_parameter.misalignment[0].data.float_val;
            cy = fog_parameter.misalignment[1].data.float_val;
            cz = fog_parameter.misalignment[2].data.float_val;
            c11 = fog_parameter.misalignment[3].data.float_val;
            c12 = fog_parameter.misalignment[4].data.float_val;
            c13 = fog_parameter.misalignment[5].data.float_val;
            c21 = fog_parameter.misalignment[6].data.float_val;
            c22 = fog_parameter.misalignment[7].data.float_val;
            c23 = fog_parameter.misalignment[8].data.float_val;
            c31 = fog_parameter.misalignment[9].data.float_val;
            c32 = fog_parameter.misalignment[10].data.float_val;
            c33 = fog_parameter.misalignment[11].data.float_val;

            accl_misalign_calibrated.x.float_val = c11 * accl_x_comp + c12 * accl_y_comp + c13 * accl_z_comp + cx;
            accl_misalign_calibrated.y.float_val = c21 * accl_x_comp + c22 * accl_y_comp + c23 * accl_z_comp + cy;
            accl_misalign_calibrated.z.float_val = c31 * accl_x_comp + c32 * accl_y_comp + c33 * accl_z_comp + cz;

            // accl_misalign_calibrated = misalignment_calibration(accl_x_comp, accl_y_comp, accl_z_comp, fog_parameter, MIS_CALI_ACCL);
            g_time[10] = get_timer_int();   
            // UART_PRINT("\nimu sf_comp_gyro: %f, %f, %f\n", sf_x_comp_gyro, sf_y_comp_gyro, sf_z_comp_gyro);
            // UART_PRINT("imu bias_comp_gyro: %f, %f, %f\n", bias_x_comp_gyro, bias_y_comp_gyro, bias_z_comp_gyro);
            // UART_PRINT("imu step_comp: %f, %f, %f\n", step_x_comp, step_y_comp, step_z_comp);
            // UART_PRINT("step_cali: %f, %f, %f\n", gyro_misalign_calibrated.x.float_val, gyro_misalign_calibrated.y.float_val, gyro_misalign_calibrated.z.float_val);

            // UART_PRINT("\nimu sf_comp_accl: %f, %f, %f\n", sf_x_comp_accl, sf_y_comp_accl, sf_z_comp_accl);
            // UART_PRINT("imu raw_accl: %f, %f, %f\n", data.adxl357.ax.float_val, data.adxl357.ay.float_val,
            // 		data.adxl357.az.float_val);
            // UART_PRINT("imu bias_comp_accl: %f, %f, %f\n", bias_x_comp_accl, bias_y_comp_accl, bias_z_comp_accl);
            // UART_PRINT("imu accl_comp: %f, %f, %f\n", accl_x_comp, accl_y_comp, accl_z_comp);
            // UART_PRINT("accl_cali: %f, %f, %f\n", accl_misalign_calibrated.x.float_val, accl_misalign_calibrated.y.float_val, accl_misalign_calibrated.z.float_val);
            
            // g_time[3] = get_timer_int();
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
            memcpy(imu_data+32, data.temp.tempy.bin_val, 4); 
            memcpy(imu_data+36, data.temp.tempz.bin_val, 4); 
            memcpy(imu_data+40, data.adxl357.temp.bin_val, 4); 
            memcpy(imu_data+44, data.time.time.bin_val, 4);              
            crc_32(imu_data, 48, CRC32);
            free(imu_data);
            g_time[11] = get_timer_int();   
        //    SerialWrite((alt_u8*)KVH_HEADER, 4);
        //    SerialWrite(gyro_misalign_calibrated.x.bin_val, 4);
        //    SerialWrite(gyro_misalign_calibrated.y.bin_val, 4);
        //    SerialWrite(gyro_misalign_calibrated.z.bin_val, 4);
        //    SerialWrite(accl_misalign_calibrated.x.bin_val, 4);
        //    SerialWrite(accl_misalign_calibrated.y.bin_val, 4);
        //    SerialWrite(accl_misalign_calibrated.z.bin_val, 4);
        //    SerialWrite(data.temp.tempx.bin_val, 4);
        //    SerialWrite(data.temp.tempy.bin_val, 4);
        //    SerialWrite(data.temp.tempz.bin_val, 4);
        //    SerialWrite(data.adxl357.temp.bin_val, 4);
        //    SerialWrite(data.time.time.bin_val, 4);
        //    SerialWrite(CRC32, 4);
    }
}
