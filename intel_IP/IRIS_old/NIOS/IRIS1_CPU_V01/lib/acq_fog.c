
#include "acq_fog.h"

#define INT_SYNC 1
#define EXT_SYNC 2
#define STOP_RUN 4

static const unsigned char KVH_HEADER[4] = {0xFE, 0x81, 0xFF, 0x55};


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
