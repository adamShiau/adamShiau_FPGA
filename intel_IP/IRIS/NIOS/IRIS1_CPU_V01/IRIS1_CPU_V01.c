#include <stdio.h>
#include <stdlib.h>  // malloc(), free()
#include <string.h>  // memcpy()
#include "sys/alt_irq.h"
#include "system.h"
#include "altera_avalon_uart_regs.h"

#include "IRIS1_V1.h"


#define COE_TIMER 0.0001

alt_u32 g_time[12];
// void dump_fog_param(fog_parameter_t* fog_inst, alt_u8 ch);
// void send_json_uart(const char* buffer);

void TRIGGER_IRQ_init(void);
void IRQ_TRIGGER_ISR(void *context);
void update_IRIS_config_to_HW_REG(void);
void update_sensor_data(my_sensor_t *data); 


const alt_u8 cmd_header[2] = {0xAB, 0xBA};
const alt_u8 cmd_trailer[2] = {0x55, 0x56};
static alt_u16 try_cnt;
alt_u32 get_timer_int(void);

volatile alt_u8 trigger_sig = 0;

my_float_t my_f;

// Definition and initialization of my_cmd, structure type is defined in common.h
cmd_ctrl_t my_cmd = {
	.condition = RX_CONDITION_INIT,
	.SN = {0},
    .complete = 0,
    .mux = MUX_ESCAPE,
    .select_fn = SEL_IDLE,
    .ch = 0,
    .cmd = 0,
	.run = 0,
    .value = 0
};

// Definition and initialization of auto_rst, structure type is defined in common.h
auto_rst_t auto_rst = {
	.status = 0,
	.fn_mode = MODE_RST
};


// Definition of a function pointer for output processing.  
// Initialized to NULL to prevent undefined behavior.  
// The assigned function will be implemented in output_fn.c.  
fn_ptr output_fn = acq_rst;
// fn_ptr output_fn = NULL;


// Definition and initialization of sensor, structure type is defined in common.h
my_sensor_t sensor_data = {
    .fog = {
        .fogx = { .err = { .int_val = 0 }, .step = { .int_val = 0 }},
        .fogy = { .err = { .int_val = 0 }, .step = { .int_val = 0 }},
        .fogz = { .err = { .int_val = 0 }, .step = { .int_val = 0 }}
    },
	.time = {.time.float_val = 0},
	.temp = {
		.tempx.float_val = 0,
		.tempy.float_val = 0,
		.tempz.float_val = 0
	},
	.adxl357 = {
		.ax.float_val = 0,
		.ay.float_val = 0,
		.az.float_val = 0,
		.temp.float_val = 0
	}
};

MovingAverage_t mz_x, mz_y, mz_z;

int cntt = 100;

int main(void)
{
	fog_parameter_t fog_params;	 //parameter container
	
	INFO_PRINT("Running IRIS CPU!\n");
	UART_PRINT("Running IRIS CPU!\n");
	update_IRIS_config_to_HW_REG();
	// while(cntt-- >0)
	// {
	// 	UART_PRINT("%d\n",cntt);
	// 	DEBUG_PRINT("%d\n",cntt);
	// 	usleep(100000);
	// }
	UART_PRINT("TRIGGER_IRQ_init\n");
	crc32_init_table();
	TRIGGER_IRQ_init();
	moving_average_init(&mz_x, 13);
	moving_average_init(&mz_y, 13);
	moving_average_init(&mz_z, 13);
	UART_PRINT("uartInit\n");
	DEBUG_PRINT("uartInit\n");
	uartInit(); //interrupt method of uart defined in uart.c not main()
	UART_PRINT("init_ADDA\n");
	DEBUG_PRINT("init_ADDA\n");
	set_DAC_reset();
	usleep(50);
	clear_DAC_reset();
	init_ADDA();
	UART_PRINT("init_EEPROM\n");
	DEBUG_PRINT("init_EEPROM\n");
	init_EEPROM();
	UART_PRINT("init_ADXL357\n");
	DEBUG_PRINT("init_ADXL357\n");
	init_ADXL357();
	// test_CPU_ADXL357_ACCL();
	UART_PRINT("init_ADS122C04_TEMP\n");
	DEBUG_PRINT("init_ADS122C04_TEMP\n");
	init_ADS122C04_TEMP();
	UART_PRINT("initialize_fog_params_type\n");
	DEBUG_PRINT("initialize_fog_params_type\n");
	initialize_fog_params_type(&fog_params);
	// EEPROM_Write_initial_parameter();

	LOAD_FOG_PARAMETER(&fog_params);
	LOAD_FOG_MISALIGNMENT(&fog_params);
	LOAD_FOG_SN(&fog_params);
	PRINT_FOG_PARAMETER(&fog_params);
	update_fog_parameters_to_HW_REG(MEM_BASE_Z, &fog_params); 
	update_fog_parameters_to_HW_REG(MEM_BASE_X, &fog_params); 
	update_fog_parameters_to_HW_REG(MEM_BASE_Y, &fog_params); 
	// PRINT_FOG_PARAMETER(&fog_params);


	while(1){

		get_uart_cmd(readDataDynamic(&try_cnt), &my_cmd);
		cmd_mux(&my_cmd);
		fog_parameter(&my_cmd, &fog_params);
		output_mode_setting(&my_cmd, &output_fn, &auto_rst);
		if (trigger_sig == 1) {
			// g_time[0] = get_timer_int();
			update_sensor_data(&sensor_data);
			// g_time[9] = get_timer_int();
			// g_time[1] = get_timer_int();
			// UART_PRINT("%d,", get_timer_int());
			output_fn(&my_cmd, sensor_data, fog_params);
			// g_time[10] = get_timer_int();
			// UART_PRINT("%d,", get_timer_int());
			trigger_sig = 0;
			// g_time[11] = get_timer_int();
			
			// g_time[4] = get_timer_int();
			// UART_PRINT("%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n", g_time[0],g_time[1],g_time[2],g_time[3],g_time[4],g_time[5],g_time[6],g_time[7],g_time[8],
			// 	g_time[9],g_time[10],g_time[11]);
		}

	}

  return 0;
}

alt_u32 get_timer_int()
{
	return IORD(VARSET_BASE, i_var_timer);
}

void update_sensor_data(my_sensor_t *data) {
	// g_time[1] = get_timer_int();
    /*** fog */
    data->time.time.float_val = (float)IORD(VARSET_BASE, i_var_timer) * COE_TIMER;
	// g_time[2] = get_timer_int();
    /***---x axis--- */
    data->fog.fogx.err.int_val = IORD(VARSET_BASE, i_var_err_1);
    data->fog.fogx.step.float_val = moving_average_update(&mz_x, (float)IORD(VARSET_BASE, i_var_step_1));
	// data->fog.fogx.step.float_val = 1.0;
	// g_time[3] = get_timer_int();
    /***---y axis--- */
    data->fog.fogy.err.int_val = IORD(VARSET_BASE, i_var_err_2);
    data->fog.fogy.step.float_val = moving_average_update(&mz_y, (float)IORD(VARSET_BASE, i_var_step_2));
	// data->fog.fogy.step.float_val = 2.0;
	// g_time[4] = get_timer_int();
    /***---z axis--- */
    data->fog.fogz.err.int_val = IORD(VARSET_BASE, i_var_err_3);
    data->fog.fogz.step.float_val = moving_average_update(&mz_z, (float)IORD(VARSET_BASE, i_var_step_3));
	// data->fog.fogz.step.float_val = 3.0;
	// g_time[5] = get_timer_int();
    /***ads122c04 temperature */
    // data->temp.tempx.float_val = (float)IORD(VARSET_BASE, var_i2c_ads122c04_temp_rdata_1) * ADC_CONV_TEMP - 273.15;
    // data->temp.tempy.float_val = (float)IORD(VARSET_BASE, var_i2c_ads122c04_temp_rdata_2) * ADC_CONV_TEMP - 273.15;
    // data->temp.tempz.float_val = (float)IORD(VARSET_BASE, var_i2c_ads122c04_temp_rdata_3) * ADC_CONV_TEMP - 273.15;

	alt_32 raw = IORD(VARSET_BASE, var_i2c_ads122c04_temp_rdata_2);
	alt_64 scaled = ((alt_64)raw * ADC_SCALE_INT * 1000) / ADC_SCALE_DIV;
	alt_32 temp_x1000 = (alt_32)(scaled - TEMP_OFFSET_x1000);
	data->temp.tempx.float_val = temp_x1000 / 1000.0f;
	raw = IORD(VARSET_BASE, var_i2c_ads122c04_temp_rdata_4);
	scaled = ((alt_64)raw * ADC_SCALE_INT * 1000) / ADC_SCALE_DIV;
	temp_x1000 = (alt_32)(scaled - TEMP_OFFSET_x1000);
	data->temp.tempy.float_val = temp_x1000 / 1000.0f;
	raw = IORD(VARSET_BASE, var_i2c_ads122c04_temp_rdata_3);
	scaled = ((alt_64)raw * ADC_SCALE_INT * 1000) / ADC_SCALE_DIV;
	temp_x1000 = (alt_32)(scaled - TEMP_OFFSET_x1000);
	data->temp.tempz.float_val = temp_x1000 / 1000.0f;
	// g_time[6] = get_timer_int();
    /*** ADXL357 */
    data->adxl357.ax.float_val = (float)IORD(VARSET_BASE, var_i2c_357_rdata_1) * SENS_ADXL357_20G;
    data->adxl357.ay.float_val = (float)IORD(VARSET_BASE, var_i2c_357_rdata_2) * SENS_ADXL357_20G;
    data->adxl357.az.float_val = (float)IORD(VARSET_BASE, var_i2c_357_rdata_3) * SENS_ADXL357_20G;
	// raw = IORD(VARSET_BASE, var_i2c_357_rdata_1);
	// alt_32 scaled_val = (raw * ADXL357_SCALE_INT) >> ADXL357_SCALE_SHIFT;
	// data->adxl357.ax.float_val = (float)scaled_val;

	// raw = IORD(VARSET_BASE, var_i2c_357_rdata_2);
	// scaled_val = (raw * ADXL357_SCALE_INT) >> ADXL357_SCALE_SHIFT;
	// data->adxl357.ay.float_val = (float)scaled_val;

	// raw = IORD(VARSET_BASE, var_i2c_357_rdata_3);
	// scaled_val = (raw * ADXL357_SCALE_INT) >> ADXL357_SCALE_SHIFT;
	// data->adxl357.az.float_val = (float)scaled_val;

	// g_time[7] = get_timer_int();
    // data->adxl357.temp.float_val = 233.2873 - 0.1105 * (float)IORD(VARSET_BASE, var_i2c_357_rdata_4);

	raw = IORD(VARSET_BASE, var_i2c_357_rdata_4);
	alt_32 temp_scaled = 2332873 - 1105 * raw; // 放大 10000 倍進行計算
	data->adxl357.temp.float_val = (float)temp_scaled / 10000.0;
	// g_time[8] = get_timer_int();
	// UART_PRINT("step_x,y,z: %f, %f, %f \n", data->fog.fogx.step.float_val, data->fog.fogy.step.float_val, data->fog.fogz.step.float_val);
}

void update_IRIS_config_to_HW_REG()
{
	IOWR(VARSET_BASE, var_sync_count, SYNC_100HZ); // set sync data rate
	set_MUX_RS422(); // set RS422 output mode
	// set_MUX_RS232();
	// set_MUX_CAN();
}


void TRIGGER_IRQ_init()
{
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(TRIGGER_IN_BASE, 1); //clear edge capture register
	IOWR_ALTERA_AVALON_PIO_IRQ_MASK(TRIGGER_IN_BASE, 1); //enable irq mask
	alt_ic_isr_register(
	TRIGGER_IN_IRQ_INTERRUPT_CONTROLLER_ID,
	TRIGGER_IN_IRQ,
	IRQ_TRIGGER_ISR,
	0x0,
	0x0);
}

void IRQ_TRIGGER_ISR(void *context)
{
	(void) context;
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(TRIGGER_IN_BASE, 1); //clear edge capture register
	trigger_sig = 1;
}


