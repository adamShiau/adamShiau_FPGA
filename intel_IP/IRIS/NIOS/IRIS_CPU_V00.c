#include <stdio.h>
#include "system.h"
#include "altera_avalon_uart_regs.h"

#include "IRIS_V1.h"

#define COE_TIMER 0.0001
#define WIDTH_32 32
#define TOPBIT_32 (1 << (WIDTH_32 - 1))
#define POLYNOMIAL_32 0x04C11DB7

void sendTx(alt_32);
void checkByte(alt_u8);
void fog_parameter(alt_u8*, fog_parameter_t*);
void dump_fog_param(fog_parameter_t* fog_inst, alt_u8 ch);
void send_json_uart(const char* buffer);
void update_fog_parameters_to_HW_REG(alt_u8 base, fog_parameter_t* fog_params); 
int IEEE_754_F2INT(float in);
void TRIGGER_IRQ_init(void);
void IRQ_TRIGGER_ISR(void);
void crc_32(alt_u8  message[], alt_u8 nBytes, alt_u8* crc);
void SerialWrite(alt_u8* buf, alt_u8 num); 
void Serialwrite_r(alt_u8* buf, alt_u8 num); 
void update_IRIS_config_to_HW_REG(void);


const unsigned char KVH_HEADER[4] = {0xFE, 0x81, 0xFF, 0x55};
const alt_u8 cmd_header[2] = {0xAB, 0xBA};
const alt_u8 cmd_trailer[2] = {0x55, 0x56};
static alt_u16 try_cnt;
volatile alt_u8 uart_complete;
static alt_u8 uart_cmd, uart_ch;
static alt_32 uart_value;
static alt_u8 start_flag = 0;
static alt_u8 trigger_sig = 0;

alt_32 cnt=0;

typedef union
{
  float float_val;
  alt_u8 bin_val[4];
  alt_32 int_val;
}
my_float_t;

my_float_t my_f;

typedef union
{
	alt_32	int_val;
	alt_u8	bin_val[4];
}my_aalt32_t;

int main(void)
{
	my_aalt32_t eeprom_buf;
	fog_parameter_t fog_params;
	my_float_t err3, time, step3, temp3;
	 

	printf("Running IRIS CPU!\n");
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
	// PARAMETER_Write_s(MEM_BASE_X, 0, 121, &fog_params);
	// PARAMETER_Write_s(MEM_BASE_Y, 0, 131, &fog_params);
	// PARAMETER_Write_s(MEM_BASE_Z, 0, 141, &fog_params);
	// PRINT_FOG_PARAMETER(&fog_params);


	while(1){
		fog_parameter(readData2(cmd_header, 2, &try_cnt, cmd_trailer, 2), &fog_params);
		time.float_val = (float)IORD(VARSET_BASE, i_var_timer)*COE_TIMER;
		err3.int_val = IORD(VARSET_BASE, i_var_err_3);
		step3.int_val = IORD(VARSET_BASE, i_var_step_3);
		temp3.float_val = 25.35;

		if(start_flag == 0){ 	//IDLE mode

		}
		else if(start_flag == 2){ // sync mode
		
		if(trigger_sig) {

			alt_u8* imu_data = (alt_u8*)malloc(20+4); // KVH_HEADER:4 + pig:16
			alt_u8 CRC32[4];

			trigger_sig = 0;

			memcpy(imu_data, KVH_HEADER, 4);
			memcpy(imu_data+4, time.bin_val, 4); 
			memcpy(imu_data+8, err3.bin_val, 4); 
			memcpy(imu_data+12, step3.bin_val, 4); 
			memcpy(imu_data+16, temp3.bin_val, 4); 
			memcpy(imu_data+20, time.bin_val, 4); 
			crc_32(imu_data, 24, CRC32);
			free(imu_data);



			SerialWrite(KVH_HEADER, 4); 
			SerialWrite(time.bin_val, 4); 
			SerialWrite(err3.bin_val, 4); 
			SerialWrite(step3.bin_val, 4); 
			SerialWrite(temp3.bin_val, 4); 
			SerialWrite(time.bin_val, 4); 
			SerialWrite(CRC32, 4); 

			// printf("%f, %d\n", time.float_val, err3.int_val);
		}
		}
	}

  return 0;
}

void update_IRIS_config_to_HW_REG()
{
	IOWR(VARSET_BASE, var_sync_count, 1e6);
}

void crc_32(alt_u8  message[], alt_u8 nBytes, alt_u8* crc)
{
	alt_u32  remainder = 0xFFFFFFFF;
	
	
	for (alt_u8 byte = 0; byte < nBytes; ++byte)
	{
		remainder ^= (message[byte] << (WIDTH_32 - 8));
		
		
		for (alt_u8 bit = 8; bit > 0; --bit)
		{
			if (remainder & TOPBIT_32)
			{
				remainder = (remainder << 1) ^ POLYNOMIAL_32;
			}
			else
			{
				remainder = (remainder << 1);
			}
		}
	}
	for (alt_u8 i=0; i<sizeof(remainder); i++) 
	{
		*(crc + i) = remainder >> (24 - (i<<3));
		
	}
}

void sendTx(alt_32 data)
{
	while(!(IORD_ALTERA_AVALON_UART_STATUS(UART_BASE)& ALTERA_AVALON_UART_STATUS_TRDY_MSK));
	IOWR_ALTERA_AVALON_UART_TXDATA(UART_BASE, data>>24);
	while(!(IORD_ALTERA_AVALON_UART_STATUS(UART_BASE)& ALTERA_AVALON_UART_STATUS_TRDY_MSK));
	IOWR_ALTERA_AVALON_UART_TXDATA(UART_BASE, data>>16);
	while(!(IORD_ALTERA_AVALON_UART_STATUS(UART_BASE)& ALTERA_AVALON_UART_STATUS_TRDY_MSK));
	IOWR_ALTERA_AVALON_UART_TXDATA(UART_BASE, data>>8);
	while(!(IORD_ALTERA_AVALON_UART_STATUS(UART_BASE)& ALTERA_AVALON_UART_STATUS_TRDY_MSK));
	IOWR_ALTERA_AVALON_UART_TXDATA(UART_BASE, data);
}
void checkByte(alt_u8 data)
{
	while(!(IORD_ALTERA_AVALON_UART_STATUS(UART_BASE)& ALTERA_AVALON_UART_STATUS_TRDY_MSK));
	IOWR_ALTERA_AVALON_UART_TXDATA(UART_BASE, data);
}
void SerialWrite(alt_u8* buf, alt_u8 num) 
{
    for (alt_u8 i = 0; i < num; i++) 
    {
        while (!(IORD_ALTERA_AVALON_UART_STATUS(UART_BASE) & ALTERA_AVALON_UART_STATUS_TRDY_MSK));
        IOWR_ALTERA_AVALON_UART_TXDATA(UART_BASE, buf[i]);
    }
}

void Serialwrite_r(alt_u8* buf, alt_u8 num) 
{
    for (alt_u8 i = num; i > 0; i--) 
    {
        while (!(IORD_ALTERA_AVALON_UART_STATUS(UART_BASE) & ALTERA_AVALON_UART_STATUS_TRDY_MSK));
        IOWR_ALTERA_AVALON_UART_TXDATA(UART_BASE, buf[i - 1]);
    }
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

int IEEE_754_F2INT(float in)
{
	my_float_t temp;
	temp.float_val = in;

	return temp.int_val;
}

void fog_parameter(alt_u8 *data, fog_parameter_t* fog_inst)
{

	if(data){
		alt_u8 base = 0, cmd2hwreg=0;
		// if(uart_complete)
		// {
			// uart_complete = 0;
			uart_cmd = data[0];
			uart_value = data[1]<<24 | data[2]<<16 | data[3]<<8 | data[4];
			uart_ch = data[5];
			printf("\nuart_cmd, uart_value, ch: %u, %d, %d\n", uart_cmd, uart_value, uart_ch);

			if(uart_ch == 1) {
				base = MEM_BASE_X;
				cmd2hwreg = CMD_TO_HW_REG_OFFSET_CH1;
			}
			else if(uart_ch == 2) {
				base = MEM_BASE_Y;
				cmd2hwreg = CMD_TO_HW_REG_OFFSET_CH2;
			}
			else if(uart_ch == 3) {
				base = MEM_BASE_Z;
				cmd2hwreg = CMD_TO_HW_REG_OFFSET_CH3;
			}

			switch(uart_cmd){
				case CMD_MOD_FREQ: {
					printf("CMD_MOD_FREQ:\n");					
					PARAMETER_Write_s(base, CMD_MOD_FREQ - CONTAINER_TO_CMD_OFFSET, uart_value, fog_inst);
					IOWR(VARSET_BASE, CMD_MOD_FREQ + cmd2hwreg, uart_value);
					break;
				}
				case CMD_MOD_AMP_H: {
					printf("CMD_MOD_AMP_H:\n");					
					PARAMETER_Write_s(base, CMD_MOD_AMP_H - CONTAINER_TO_CMD_OFFSET, uart_value, fog_inst);
					IOWR(VARSET_BASE, CMD_MOD_AMP_H + cmd2hwreg, uart_value);
					break;
				}
				case CMD_MOD_AMP_L: {
					printf("CMD_MOD_AMP_L:\n");					
					PARAMETER_Write_s(base, CMD_MOD_AMP_L - CONTAINER_TO_CMD_OFFSET, uart_value, fog_inst);
					IOWR(VARSET_BASE, CMD_MOD_AMP_L + cmd2hwreg, uart_value);
					break;
				}
				case CMD_POLARITY: {
					printf("CMD_POLARITY:\n");					
					PARAMETER_Write_s(base, CMD_POLARITY - CONTAINER_TO_CMD_OFFSET, uart_value, fog_inst);
					IOWR(VARSET_BASE, CMD_POLARITY + cmd2hwreg, uart_value);
					break;
				}
				case CMD_WAIT_CNT: {
					printf("CMD_WAIT_CNT:\n");
					PARAMETER_Write_s(base, CMD_WAIT_CNT - CONTAINER_TO_CMD_OFFSET, uart_value, fog_inst);
					IOWR(VARSET_BASE, CMD_WAIT_CNT + cmd2hwreg, uart_value);
					break;
				} 
				case CMD_ERR_AVG: {
					printf("CMD_ERR_AVG:\n");
					PARAMETER_Write_s(base, CMD_ERR_AVG - CONTAINER_TO_CMD_OFFSET, uart_value, fog_inst);
					IOWR(VARSET_BASE, CMD_ERR_AVG + cmd2hwreg, uart_value);
					break;
				} 
				case CMD_GAIN1: {
					printf("CMD_GAIN1:\n");
					PARAMETER_Write_s(base, CMD_GAIN1 - CONTAINER_TO_CMD_OFFSET, uart_value, fog_inst);
					IOWR(VARSET_BASE, CMD_GAIN1 + cmd2hwreg, uart_value);
					break;
				} 
				case CMD_CONST_STEP: {
					printf("CMD_CONST_STEP:\n");
					PARAMETER_Write_s(base, CMD_CONST_STEP - CONTAINER_TO_CMD_OFFSET, uart_value, fog_inst);
					IOWR(VARSET_BASE, CMD_CONST_STEP + cmd2hwreg, uart_value);
					break;
				} 
				case CMD_FB_ON: {
					printf("CMD_FB_ON:\n");
					PARAMETER_Write_s(base, CMD_FB_ON - CONTAINER_TO_CMD_OFFSET, uart_value, fog_inst);
					IOWR(VARSET_BASE, CMD_FB_ON + cmd2hwreg, uart_value);
					break;
				} 
				case CMD_GAIN2: {
					printf("CMD_GAIN2:\n");
					PARAMETER_Write_s(base, CMD_GAIN2 - CONTAINER_TO_CMD_OFFSET, uart_value, fog_inst);
					IOWR(VARSET_BASE, CMD_GAIN2 + cmd2hwreg, uart_value);
					break;
				} 
				case CMD_ERR_OFFSET: {
					printf("CMD_ERR_OFFSET:\n");
					PARAMETER_Write_s(base, CMD_ERR_OFFSET - CONTAINER_TO_CMD_OFFSET, uart_value, fog_inst);
					IOWR(VARSET_BASE, CMD_ERR_OFFSET + cmd2hwreg, uart_value);
					break;
				} 

				case CMD_CUT_OFF: {
					printf("CMD_CUT_OFF:\n");
					PARAMETER_Write_s(base, CMD_CUT_OFF - CONTAINER_TO_CMD_OFFSET, uart_value, fog_inst);
					IOWR(VARSET_BASE, CMD_CUT_OFF + cmd2hwreg, uart_value);
					break;
				}
				case CMD_DUMP_FOG: {
					printf("CMD_DUMP_FOG:\n");
					dump_fog_param(fog_inst, uart_ch);
					break;
				} 
				case CMD_DATA_OUT_START: {
					printf("CMD_DATA_OUT_START:\n");
					start_flag = uart_value;
					break;
				}
				case CMD_SYNC_CNT: {
					printf("CMD_SYNC_CNT:\n");
					IOWR(VARSET_BASE, var_sync_count, uart_value);
					break;
				} 
				case CMD_HW_TIMER_RST: {
					printf("CMD_HW_TIMER_RST:\n");
					IOWR(VARSET_BASE, var_timer_rst, uart_value);
					break;
				}

				default:{
					printf("default case\n");
				}
			}
	 	// }
	}

}
  
void update_fog_parameters_to_HW_REG(alt_u8 base, fog_parameter_t* fog_params) 
{
	int rt_val, is_valid = 1, valid[10]={0};
	if(base == MEM_BASE_Z) 
	{
		printf("updating fog paramemetr Z to FPGA....\n ");
		for(int container_idx=0; container_idx<10+1; container_idx++) { // container index, check excel table
			// update the value from container to FPGA register 
			IOWR(VARSET_BASE, container_idx + CONTAINER_TO_CMD_OFFSET + CMD_TO_HW_REG_OFFSET_CH3, fog_params->paramZ[container_idx].data.int_val);
			// read back the value from FPGA register
			rt_val = IORD(VARSET_BASE, container_idx + CONTAINER_TO_CMD_OFFSET + CMD_TO_HW_REG_OFFSET_CH3);
			// check if two value are the same or not. 
			valid[container_idx] = fog_params->paramZ[container_idx].data.int_val == rt_val;
			is_valid &=  valid[container_idx];
			printf("container_idx: %d, %d, %d\n",container_idx, rt_val, valid[container_idx]);
		}
		printf("is_valid = %d\n", is_valid);
		printf("Done.\n ");
	}
	else if(base == MEM_BASE_X) 
	{
		printf("updating fog paramemetr X to FPGA....\n ");
		for(int container_idx=0; container_idx<10+1; container_idx++) { // container index, check excel table
			// update the value from container to FPGA register 
			IOWR(VARSET_BASE, container_idx + CONTAINER_TO_CMD_OFFSET + CMD_TO_HW_REG_OFFSET_CH1, fog_params->paramX[container_idx].data.int_val);
			// read back the value from FPGA register
			rt_val = IORD(VARSET_BASE, container_idx + CONTAINER_TO_CMD_OFFSET + CMD_TO_HW_REG_OFFSET_CH1);
			// check if two value are the same or not. 
			valid[container_idx] = fog_params->paramX[container_idx].data.int_val == rt_val;
			is_valid &=  valid[container_idx];
			printf("container_idx: %d, %d, %d\n",container_idx, rt_val, valid[container_idx]);
		}
		printf("is_valid = %d\n", is_valid);
		printf("Done.\n ");
	}
	else if(base == MEM_BASE_Y)
	{
		printf("updating fog paramemetr Y to FPGA....\n ");
		for(int container_idx=0; container_idx<10+1; container_idx++) { // container index, check excel table
			// update the value from container to FPGA register 
			IOWR(VARSET_BASE, container_idx + CONTAINER_TO_CMD_OFFSET + CMD_TO_HW_REG_OFFSET_CH2, fog_params->paramY[container_idx].data.int_val);
			// read back the value from FPGA register
			rt_val = IORD(VARSET_BASE, container_idx + CONTAINER_TO_CMD_OFFSET + CMD_TO_HW_REG_OFFSET_CH2);
			// check if two value are the same or not. 
			valid[container_idx] = fog_params->paramY[container_idx].data.int_val == rt_val;
			is_valid &=  valid[container_idx];
			printf("container_idx: %d, %d, %d\n",container_idx, rt_val, valid[container_idx]);
		}
		printf("is_valid = %d\n", is_valid);
		printf("Done.\n ");
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
		offset += snprintf(buffer + offset, sizeof(buffer) - offset, "\"%d\":%d", i, param[i].data.int_val);
        if (i < MEN_LEN - 1) offset += snprintf(buffer + offset, sizeof(buffer) - offset, ", "); // Add comma if not the last element
    }
    
    snprintf(buffer + offset, sizeof(buffer) - offset, "}\n"); // Close JSON structure
    printf("%s", buffer); // Print the formatted JSON string
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

void IRQ_TRIGGER_ISR()
{
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(TRIGGER_IN_BASE, 1); //clear edge capture register
	trigger_sig = 1;
}


