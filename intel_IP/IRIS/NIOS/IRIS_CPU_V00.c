#include <stdio.h>
#include "system.h"
#include "altera_avalon_uart_regs.h"

/******** my Library *******/
#include "uart.h"
//#include "uart.c"

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
  printf("Hello from Nios II!\n");
  uartInit(); //interrupt method of uart defined in uart.c not main()

  while(1){
//	  sendTx(0xFE81FF55);
//	  checkByte(0xAB);
//	  usleep(5320);
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

