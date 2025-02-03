#include <stdio.h>
#include "system.h"
#include "altera_avalon_uart_regs.h"

#include "IRIS_V1.h"

void sendTx(alt_32);
void checkByte(alt_u8);
void fog_parameter(alt_u8*, fog_parameter_t*);
void dump_fog_param(fog_parameter_t* fog_inst, alt_u8 ch);
void send_json_uart(const char* buffer);

const alt_u8 cmd_header[2] = {0xAB, 0xBA};
const alt_u8 cmd_trailer[2] = {0x55, 0x56};
static alt_u16 try_cnt;
volatile alt_u8 uart_complete;
static alt_u8 uart_cmd, uart_ch;
static alt_32 uart_value;

alt_32 cnt=0;

typedef union
{
	alt_32	int_val;
	alt_u8	bin_val[4];
}my_aalt32_t;

int main(void)
{
	my_aalt32_t eeprom_buf;
	fog_parameter_t fog_params;

	printf("Running IRIS CPU!\n");
	uartInit(); //interrupt method of uart defined in uart.c not main()
	init_ADDA();
	init_EEPROM();

	// initialize_fog_params(&fog_params);
	// EEPROM_Write_initial_parameter();

	 LOAD_FOG_PARAMETER(&fog_params);
	 PRINT_FOG_PARAMETER(&fog_params);


	// PARAMETER_Write_s(MEM_BASE_X, 0, 121, &fog_params);
	// PARAMETER_Write_s(MEM_BASE_Y, 0, 131, &fog_params);
	// PARAMETER_Write_s(MEM_BASE_Z, 0, 141, &fog_params);
	// PRINT_FOG_PARAMETER(&fog_params);


  while(1){
	  fog_parameter(readData2(cmd_header, 2, &try_cnt, cmd_trailer, 2), &fog_params);
  }

  return 0;
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

#define PARAMETER_OFFSET 8

void fog_parameter(alt_u8 *data, fog_parameter_t* fog_inst)
{

	if(data){
		alt_u8 base = 0;
		// if(uart_complete)
		// {
			// uart_complete = 0;
			uart_cmd = data[0];
			uart_value = data[1]<<24 | data[2]<<16 | data[3]<<8 | data[4];
			uart_ch = data[5];
			printf("\nuart_cmd, uart_value, ch: %u, %d, %d\n", uart_cmd, uart_value, uart_ch);

			if(uart_ch == 1) base = MEM_BASE_X;
			else if(uart_ch == 2) base = MEM_BASE_Y;
			else if(uart_ch == 3) base = MEM_BASE_Z;

			switch(uart_cmd){
				case MOD_FREQ: {
					printf("MOD_FREQ:\n");
					// printf("BASE: %d\n", base);
					
					PARAMETER_Write_s(base, MOD_FREQ - PARAMETER_OFFSET, uart_value, fog_inst);
					IOWR(VARSET_BASE, var_freq_cnt_DAC3, uart_value);

					break;
				}
				case WAIT_CNT: {
					printf("WAIT_CNT:\n");
					PARAMETER_Write_s(base, WAIT_CNT - PARAMETER_OFFSET, uart_value, fog_inst);
					IOWR(VARSET_BASE, var_wait_cnt_DAC3, uart_value);

					break;
				} 
				case CUT_OFF: {
					printf("CUT_OFF:\n");
					PARAMETER_Write_s(base, CUT_OFF - PARAMETER_OFFSET, uart_value, fog_inst);
					// IOWR(VARSET_BASE, var_wait_cnt_DAC3, uart_value); not yet
					break;
				}
				case DUMP_FOG: {
					printf("DUMP_FOG:\n");
					dump_fog_param(fog_inst, uart_ch);
					break;
				}

				default:{
					printf("default case\n");
				}
			}
	 	// }
	}

}

void dump_fog_param(fog_parameter_t* fog_inst, alt_u8 ch) {
    if (!fog_inst || ch < 1 || ch > 3) return; // 確保指標有效，ch 在範圍內
    
    mem_unit_t* param;
    switch (ch) {
        case 1: param = fog_inst->paramX; break;
        case 2: param = fog_inst->paramY; break;
        case 3: param = fog_inst->paramZ; break;
        default: return; 
    }
    
    char buffer[1024]; // 假設最大輸出長度
    int offset = 0;
    offset += snprintf(buffer + offset, sizeof(buffer) - offset, "{");
    
    for (int i = 0; i < MEN_LEN; i++) {
        offset += snprintf(buffer + offset, sizeof(buffer) - offset, "\"%d\":\"%d\"", i, param[i].data.int_val);
        if (i < MEN_LEN - 1) offset += snprintf(buffer + offset, sizeof(buffer) - offset, ", ");
    }
    
    snprintf(buffer + offset, sizeof(buffer) - offset, "}\n");
    printf("%s", buffer);
	send_json_uart(buffer);
}

void send_json_uart(const char* buffer) {
    while (*buffer) {
        checkByte((alt_u8)*buffer);
        buffer++;
    }
}

// void dump_fog_param(fog_parameter_t* fog_inst, alt_u8 ch) {
//     if (!fog_inst || ch < 1 || ch > 3) { // 確保指標有效，ch 在範圍內
// 		printf("dump_fog_param err\n");
// 		return; 
// 	}
//     mem_unit_t* param;
//     switch (ch) {
//         case 1: param = fog_inst->paramX; break;
//         case 2: param = fog_inst->paramY; break;
//         case 3: param = fog_inst->paramZ; break;
//         default: return; 
//     }
    
//     printf("{");
//     for (int i = 0; i < MEN_LEN; i++) {
//         printf("\"%d\":\"%d\"", i, param[i].data.int_val);
//         if (i < MEN_LEN - 1) printf(", ");
//     }
//     printf("}\n");
// }

