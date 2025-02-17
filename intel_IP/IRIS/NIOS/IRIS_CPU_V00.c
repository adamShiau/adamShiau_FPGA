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
void update_fog_parameters_to_HW_REG(alt_u8 base, fog_parameter_t* fog_params);

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
	}
};





int main(void)
{
	fog_parameter_t fog_params;	 

	INFO_PRINT("Running IRIS CPU!\n");

	TRIGGER_IRQ_init();
	uartInit(); //interrupt method of uart defined in uart.c not main()
	init_ADDA();
	init_EEPROM();

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
		sensor_data.time.time.float_val = (float)IORD(VARSET_BASE, i_var_timer)*COE_TIMER;
		sensor_data.fog.fogz.err.int_val = IORD(VARSET_BASE, i_var_err_3);
		sensor_data.fog.fogz.step.float_val = (float)IORD(VARSET_BASE, i_var_step_3);
		sensor_data.temp.tempz.float_val = 25.35;
		sensor_data.fog.fogz.pd_high.int_val = IORD(VARSET_BASE, i_var_high);
		sensor_data.fog.fogz.pd_low.int_val = IORD(VARSET_BASE, i_var_low);



		get_uart_cmd(readData2(cmd_header, 2, &try_cnt, cmd_trailer, 2), &my_cmd);
		cmd_mux(&my_cmd);
		fog_parameter(&my_cmd, &fog_params);
		output_mode_setting(&my_cmd, &output_fn, &auto_rst);
		output_fn(&my_cmd, &sensor_data, &trigger_sig);
	}

  return 0;
}

void update_IRIS_config_to_HW_REG()
{
	IOWR(VARSET_BASE, var_sync_count, 1e6);
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




void update_fog_parameters_to_HW_REG(alt_u8 base, fog_parameter_t* fog_params) 
{
	int rt_val, is_valid = 1, valid[10]={0};
	if(base == MEM_BASE_Z) 
	{
		INFO_PRINT("updating fog paramemetr Z to FPGA....\n ");
		for(int container_idx=0; container_idx<10+1; container_idx++) { // container index, check excel table
			// update the value from container to FPGA register 
			IOWR(VARSET_BASE, container_idx + CONTAINER_TO_CMD_OFFSET + CMD_TO_HW_REG_OFFSET_CH3, fog_params->paramZ[container_idx].data.int_val);
			// read back the value from FPGA register
			rt_val = IORD(VARSET_BASE, container_idx + CONTAINER_TO_CMD_OFFSET + CMD_TO_HW_REG_OFFSET_CH3);
			// check if two value are the same or not. 
			valid[container_idx] = fog_params->paramZ[container_idx].data.int_val == rt_val;
			is_valid &=  valid[container_idx];
			INFO_PRINT("container_idx: %d, %d, %d\n",container_idx, rt_val, valid[container_idx]);
		}
		INFO_PRINT("is_valid = %d\n", is_valid);
		INFO_PRINT("Done.\n ");
	}
	else if(base == MEM_BASE_X) 
	{
		DEBUG_PRINT("updating fog paramemetr X to FPGA....\n ");
		for(int container_idx=0; container_idx<10+1; container_idx++) { // container index, check excel table
			// update the value from container to FPGA register 
			IOWR(VARSET_BASE, container_idx + CONTAINER_TO_CMD_OFFSET + CMD_TO_HW_REG_OFFSET_CH1, fog_params->paramX[container_idx].data.int_val);
			// read back the value from FPGA register
			rt_val = IORD(VARSET_BASE, container_idx + CONTAINER_TO_CMD_OFFSET + CMD_TO_HW_REG_OFFSET_CH1);
			// check if two value are the same or not. 
			valid[container_idx] = fog_params->paramX[container_idx].data.int_val == rt_val;
			is_valid &=  valid[container_idx];
			DEBUG_PRINT("container_idx: %d, %d, %d\n",container_idx, rt_val, valid[container_idx]);
		}
		DEBUG_PRINT("is_valid = %d\n", is_valid);
		DEBUG_PRINT("Done.\n ");
	}
	else if(base == MEM_BASE_Y)
	{
		DEBUG_PRINT("updating fog paramemetr Y to FPGA....\n ");
		for(int container_idx=0; container_idx<10+1; container_idx++) { // container index, check excel table
			// update the value from container to FPGA register 
			IOWR(VARSET_BASE, container_idx + CONTAINER_TO_CMD_OFFSET + CMD_TO_HW_REG_OFFSET_CH2, fog_params->paramY[container_idx].data.int_val);
			// read back the value from FPGA register
			rt_val = IORD(VARSET_BASE, container_idx + CONTAINER_TO_CMD_OFFSET + CMD_TO_HW_REG_OFFSET_CH2);
			// check if two value are the same or not. 
			valid[container_idx] = fog_params->paramY[container_idx].data.int_val == rt_val;
			is_valid &=  valid[container_idx];
			DEBUG_PRINT("container_idx: %d, %d, %d\n",container_idx, rt_val, valid[container_idx]);
		}
		DEBUG_PRINT("is_valid = %d\n", is_valid);
		DEBUG_PRINT("Done.\n ");
	}
}

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
        // offset += snprintf(buffer + offset, sizeof(buffer) - offset, "\"%d\":\"%d\"", i, param[i].data.int_val);
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


