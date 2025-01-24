#include <stdio.h>
#include "system.h"
#include "altera_avalon_uart_regs.h"

/******** NIOS II Variable IP address definition*******/
#include "nios2_var_addr.h"

/******** my Library *******/
// uart
#include "uart.h"
#include "uart.c"
// adda
#include "adda_config.h"
#include "adda_config.c"
//memory_manage
#include "memory_manage.h"
#include "memory_manage.c"
//eeprom
#include "eeprom.h"
#include "eeprom.c"


void sendTx(alt_32);
void checkByte(alt_u8);
void fog_parameter(alt_u8*);

const alt_u8 cmd_header[2] = {0xAB, 0xBA};
const alt_u8 cmd_trailer[2] = {0x55, 0x56};
static alt_u16 try_cnt;
volatile alt_u8 uart_complete;
static alt_u8 uart_cmd;
static alt_32 uart_value;

alt_32 cnt=0;
int main()
{
	alt_u8 eeprom_buf[4] = {0};
	fog_parameter_t fog_params;

	printf("Running IRIS CPU!\n");
	uartInit(); //interrupt method of uart defined in uart.c not main()
	init_ADDA();
	init_EEPROM();
	initialize_fog_params(&fog_params);

	Parameter_Write(0, 0x2234567F);
	Parameter_Write(1, 0x7865432F);
	Parameter_Write(2, -200000);
	printf("Parameter_Write done\n");
	Parameter_Read(0, eeprom_buf);
	Parameter_Read(1, eeprom_buf);
	Parameter_Read(2, eeprom_buf);
	printf("Stop testing EEPROM!\n");
	// ´ú¸Õ¿é¥X

	printf("Serial Number: %s\n", fog_params.sn);
	printf("paramX: ");
	for (int i = 0; i < MEN_LEN; i++) {
		printf("%d ", fog_params.paramX[i]);
	}
	printf("\n");

  while(1){
	  fog_parameter(readData2(cmd_header, 2, &try_cnt, cmd_trailer, 2));
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
//		printf("wait\n");
	IOWR_ALTERA_AVALON_UART_TXDATA(UART_BASE, data);
}

void fog_parameter(alt_u8 *data)
{
	if(data){
		if(uart_complete)
		{
			uart_complete = 0;
			uart_cmd = data[0];
			uart_value = data[1]<<24 | data[2]<<16 | data[3]<<8 | data[4];
			printf("uart_cmd, uart_value: %x, %d\n\n", uart_cmd, uart_value);
//			switch(uart_cmd){
//
//
//				default:{
//	//						printf("default case\n");
//				}
//			}
	 	}
	}

}


