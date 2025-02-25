#include <stdio.h>
#include <stdlib.h>  // malloc(), free()
#include <string.h>  // memcpy()
#include "sys/alt_irq.h"
#include "system.h"
#include "altera_avalon_uart_regs.h"

#include "IRIS_V1.h"

#define COE_TIMER 0.0001



void dump_fog_param(fog_parameter_t* fog_inst, alt_u8 ch);
void send_json_uart(const char* buffer);

void TRIGGER_IRQ_init(void);
void IRQ_TRIGGER_ISR(void *context);
void update_IRIS_config_to_HW_REG(void);


const alt_u8 cmd_header[2] = {0xAB, 0xBA};
const alt_u8 cmd_trailer[2] = {0x55, 0x56};
static alt_u16 try_cnt;

alt_u8 trigger_sig = 0;

my_float_t my_f;

// Definition and initialization of my_cmd, structure type is defined in common.h
cmd_ctrl_t my_cmd = {
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


#define BUFFER_SIZE_TT 100


int main(void)
{
	fog_parameter_t fog_params;	 //parameter container
	MovingAverage_t ma;

	INFO_PRINT("Running IRIS CPU!\n");

	float buffer[BUFFER_SIZE_TT];
	alt_u32 index = 0;

	TRIGGER_IRQ_init();
	moving_average_init(&ma, 13);
	uartInit(); //interrupt method of uart defined in uart.c not main()
	init_ADDA();
	init_EEPROM();
	init_ADXL357();

	// initialize_fog_params(&fog_params);
	// EEPROM_Write_initial_parameter();

	LOAD_FOG_PARAMETER(&fog_params);
	PRINT_FOG_PARAMETER(&fog_params);
	update_fog_parameters_to_HW_REG(MEM_BASE_Z, &fog_params); 
	update_fog_parameters_to_HW_REG(MEM_BASE_X, &fog_params); 
	update_fog_parameters_to_HW_REG(MEM_BASE_Y, &fog_params); 
	update_IRIS_config_to_HW_REG();
	// PRINT_FOG_PARAMETER(&fog_params);


	while(1){
		/*** fog */
		sensor_data.time.time.float_val = (float)IORD(VARSET_BASE, i_var_timer)*COE_TIMER;
		sensor_data.fog.fogz.err.int_val = IORD(VARSET_BASE, i_var_err_3);
		// sensor_data.fog.fogz.step.float_val = (float)IORD(VARSET_BASE, i_var_step_3);
		sensor_data.fog.fogz.step.float_val = moving_average_update(&ma, (float)IORD(VARSET_BASE, i_var_step_3));
		sensor_data.temp.tempz.float_val = 25.35;
		/*** ADXL357 */
		sensor_data.adxl357.ax.float_val = (float)IORD(VARSET_BASE, var_i2c_357_rdata_1);
		sensor_data.adxl357.ay.float_val = (float)IORD(VARSET_BASE, var_i2c_357_rdata_2);
		sensor_data.adxl357.az.float_val = (float)IORD(VARSET_BASE, var_i2c_357_rdata_3);
		sensor_data.adxl357.temp.float_val = 30.123;
		/***monitor */
		// sensor_data.fog.fogz.sum_high.int_val = IORD(VARSET_BASE, i_var_high);
		// sensor_data.fog.fogz.sum_low.int_val = IORD(VARSET_BASE, i_var_low);
		// sensor_data.fog.fogz.buf.int_val = IORD(VARSET_BASE, i_var_buf);
		// sensor_data.fog.fogz.o_step.int_val = IORD(VARSET_BASE, i_var_o_step3);
		

		// buffer[index++] = sensor_data.time.time.float_val;
		// if (index >= BUFFER_SIZE_TT) {
        //     printf("Buffered Values:\n");
        //     for (alt_u32 i = 0; i < BUFFER_SIZE_TT; i++) {
        //         printf("%.4f ", buffer[i]);
        //     }
        //     printf("\n");
        //     index = 0; // 重置索引
        // }


		get_uart_cmd(readData2(cmd_header, 2, &try_cnt, cmd_trailer, 2), &my_cmd);
		cmd_mux(&my_cmd);
		fog_parameter(&my_cmd, &fog_params);
		output_mode_setting(&my_cmd, &output_fn, &auto_rst);
		output_fn(&my_cmd, sensor_data, &trigger_sig, fog_params);
	}

  return 0;
}

void update_IRIS_config_to_HW_REG()
{
	IOWR(VARSET_BASE, var_sync_count, SYNC_100HZ);
}




/*** 
void checkByte(alt_u8 data)
{
    int timeout = 100000;  // 設定一個合理的超時值
    while (!(IORD_ALTERA_AVALON_UART_STATUS(UART_BASE) & ALTERA_AVALON_UART_STATUS_TRDY_MSK) && --timeout);
    
    if (timeout > 0) {
        IOWR_ALTERA_AVALON_UART_TXDATA(UART_BASE, data);
    } else {
        // 超時處理，例如記錄錯誤或重試
    }
}
*/




void dump_fog_param(fog_parameter_t* fog_inst, alt_u8 ch) {
    if (!fog_inst || ch < 1 || ch > 3) return; // Ensure the pointer is valid and ch is within range
    
    mem_unit_t* param;
    switch (ch) {
        case 1: param = fog_inst->paramX; break;
        case 2: param = fog_inst->paramY; break;
        case 3: param = fog_inst->paramZ; break;
        default: return; 
    }
    
    char buffer[1024]; // Assume maximum output length
    int offset = 0;
    offset += snprintf(buffer + offset, sizeof(buffer) - offset, "{");
    
    for (int i = 0; i < MEN_LEN; i++) {
		offset += snprintf(buffer + offset, sizeof(buffer) - offset, "\"%d\":%ld", i, param[i].data.int_val);
        if (i < MEN_LEN - 1) offset += snprintf(buffer + offset, sizeof(buffer) - offset, ", "); // Add comma if not the last element
    }
    
    snprintf(buffer + offset, sizeof(buffer) - offset, "}\n"); // Close JSON structure
    DEBUG_PRINT("%s", buffer); // Print the formatted JSON string
	send_json_uart(buffer); // Send the JSON data via UART
}

void send_json_uart(const char* buffer) {
    while (*buffer) {
        checkByte((alt_u8)*buffer);
        buffer++;
    }
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


