#include <stdio.h>
#include "unistd.h"
#include "system.h"
#include "altera_avalon_spi.h"
#include "altera_avalon_spi_regs.h"
#include "altera_avalon_uart_regs.h"
#include "sys/alt_irq.h"
#include "stddef.h"
#include "alt_types.h"
#include "altera_avalon_pio_regs.h"
#include "sys/alt_timestamp.h"
#include "sys/alt_alarm.h"

//#include "delay.h"
//#include "delay.c"
#include "myiic.h"
#include "myiic.c"
#include "Tsensor_DS1775.h"
#include "Tsensor_DS1775.c"



//void delay1_stat(alt_u16);
//void delay2_stat(alt_u16);

#define TRIGGER_IN_BASE 0x2002160

#define DAC1_GAIN_LSB_ADDR	0x0B
#define DAC1_GAIN_MSB_ADDR	0x0C
#define DAC1_GAIN_MSB_W_NR  0x0C01
#define DAC1_GAIN_LSB_W_NR  0x0BF9
#define DAC1_GAIN_MSB_W_min 0x0C00
#define DAC1_GAIN_LSB_W_min 0x0B00
#define DAC1_GAIN_MSB_W_MAX 0x0C03
#define DAC1_GAIN_LSB_W_MAX 0x0BFF
#define DAC1_GAIN_LSB_R 	0x8B00
#define DAC1_GAIN_MSB_R 	0x8C00

#define DAC2_GAIN_LSB_ADDR	0x0F
#define DAC2_GAIN_MSB_ADDR	0x10
#define DAC2_GAIN_MSB_W_NR  0x1001
#define DAC2_GAIN_LSB_W_NR  0x0FF9
#define DAC2_GAIN_MSB_W_min 0x1000
#define DAC2_GAIN_LSB_W_min 0x0F00
#define DAC2_GAIN_MSB_W_MAX 0x1003
#define DAC2_GAIN_LSB_W_MAX 0x0FFF
#define DAC2_GAIN_LSB_R 	0x8F00
#define DAC2_GAIN_MSB_R 	0x9000

#define ADC_RESET			0x0080
#define ADC_FMT				0x0401
#define ADC_TEST			0x0455
#define ADC_FMT_R			0x8400
#define ADC_ALL_ZERO		0x0409
#define ADC_ALL_ONE			0x0419

/******** FOG Register*********/
/***W***/
#define	O_VAR_FREQ			0
#define O_VAR_AMP_H			1
#define O_VAR_AMP_L			2
#define O_VAR_OFFSET		3
#define O_VAR_POLARITY		4
#define O_VAR_WAITCNT		5
#define O_VAR_ERRTH			6
#define O_VAR_AVGSEL		7
#define O_VAR_TIMER_RST 	8
#define O_VAR_GAIN1_SEL		9
#define O_VAR_GAIN2_SEL		10
#define O_VAR_FB_ON			11
#define O_VAR_CONST_STEP  	12
#define O_VAR_KAL_Q			13
#define O_VAR_KAL_R  		14
/***R***/
#define I_VAR_TIMER		25
#define I_VAR_STEP		26 //before divided by gain1
#define I_VAR_AMP_H		27
#define I_VAR_AMP_L		28
#define I_VAR_ERR		29
#define I_VAR_OFFSET	30
#define I_VAR_STEP_ORI	31 // after divided by gain1
#define I_VAR_FB_ON		32

/***CRC ***/
#define WIDTH  8
#define TOPBIT (1 << (WIDTH - 1))
#define POLYNOMIAL 0x07

const alt_u8 KVH_HEADER[4] = {0xFE, 0x81, 0xFF, 0x55};
const alt_u8 PIG_HEADER[2] = {0xAB, 0xBA}, PIG_TAIL = 0xFE;
static alt_u8 rxdata = 0, start_flag = 0;
static alt_u8 rx_cnt = 0, uart_complete = 0, uart_cmd, data;
static alt_32 uart_value, cnt=0, delay_time=2200;
static alt_u8 trigger_sig = 0;

void IRQ_UART_ISR2(void);
void IRQ_init(void);
void IRQ_TRIGGER_ISR(void);
void TRIGGER_IRQ_init(void);
void FOG_init(void);
void sendTx(alt_32);
void checkByte(alt_u8);
alt_u8 crc(alt_u8 [], int);

int main()
{
	alt_u16 cnt=0, p=1;
	alt_32 time, err, step;
	alt_16 PD_temp;


	IIC_Init();
	IRQ_init();
	TRIGGER_IRQ_init();
	IOWR_ALTERA_AVALON_SPI_SLAVE_SEL(SPI_ADDA_BASE, 2); usleep (10); //select ADC
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, ADC_RESET); usleep (10);
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, ADC_FMT); usleep (10);
//	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, ADC_ALL_ZERO); usleep (10);
//	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, ADC_ALL_ONE); usleep (10);


	IOWR_ALTERA_AVALON_SPI_SLAVE_SEL(SPI_ADDA_BASE, 1); usleep (10); //select DAC
//	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, DAC1_GAIN_MSB_W_min); usleep (10);
//	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, DAC1_GAIN_LSB_W_min); usleep (10);
//	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, DAC2_GAIN_MSB_W_min); usleep (10);
//	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, DAC2_GAIN_LSB_W_min); usleep (10);
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, DAC1_GAIN_MSB_W_NR); usleep (10);
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, DAC1_GAIN_LSB_W_NR); usleep (10);
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, DAC2_GAIN_MSB_W_NR); usleep (10);
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, DAC2_GAIN_LSB_W_NR); usleep (10);



	ds1775_setConfiguration(0x0);  //setting configuration reg, see data sheet p8
	ds1775_setCurPtr(TSENSOR_TEMP);//write to temperature addr

	FOG_init();
//	printf("HELLO\n");


	while(1) {
		time = IORD(VARSET_BASE, I_VAR_TIMER);
		err = IORD(VARSET_BASE, I_VAR_ERR);
		step = IORD(VARSET_BASE, I_VAR_STEP_ORI);
		PD_temp = ds1775_9B_readTemp_d();
		if(start_flag == 0){ 	//IDLE mode
//			/***
//			printf("time: %d, ", IORD(VARSET_BASE, I_VAR_TIMER));
//			printf("%4.1f\n", ds1775_9B_readTemp_f());
			usleep(220000);
//			***/
		}
		else if(start_flag == 1) { //INT mode

//			time = IORD(VARSET_BASE, I_VAR_TIMER);
//			err = IORD(VARSET_BASE, I_VAR_ERR);
//			step = IORD(VARSET_BASE, I_VAR_STEP_ORI);
//			PD_temp = ds1775_9B_readTemp_d();
			checkByte(171); //AB
			checkByte(186); //BA
			sendTx(time);
			sendTx(err);
			sendTx(step);
			checkByte(PD_temp>>8);
			checkByte(PD_temp);
			usleep(delay_time);
		}

		else if(start_flag == 2) { //EXT mode
			if(trigger_sig) {
//				err = IORD(VARSET_BASE, I_VAR_ERR);
//				step = IORD(VARSET_BASE, I_VAR_STEP_ORI);
//				PD_temp = ds1775_9B_readTemp_d();
				trigger_sig = 0;
				checkByte(171);
				checkByte(186);
				sendTx(time);
				sendTx(err);
				sendTx(step);
				checkByte(PD_temp>>8);
				checkByte(PD_temp);
			}
		}
	}

  return 0;
}

void checkByte(alt_u8 data)
{
	while(!(IORD_ALTERA_AVALON_UART_STATUS(UART_BASE)& ALTERA_AVALON_UART_STATUS_TRDY_MSK));
//		printf("wait\n");
	IOWR_ALTERA_AVALON_UART_TXDATA(UART_BASE, data);
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

void IRQ_init()
{
     //clear status register
     IOWR_ALTERA_AVALON_UART_STATUS(UART_BASE,0);
     IOWR_ALTERA_AVALON_UART_CONTROL(UART_BASE,0X80);
     alt_ic_isr_register(
     UART_IRQ_INTERRUPT_CONTROLLER_ID,
     UART_IRQ                        ,
     IRQ_UART_ISR2          ,
     0x0                             ,
     0x0);
 }

void TRIGGER_IRQ_init()
{
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(TRIGGER_IN_BASE, 1); //clear edge capture register
	IOWR_ALTERA_AVALON_PIO_IRQ_MASK(TRIGGER_IN_BASE, 1); //enable irq mask
	alt_ic_isr_register(
	0,
	5                        ,
	IRQ_TRIGGER_ISR          ,
	0x0                             ,
	0x0);
}

void IRQ_TRIGGER_ISR()
{
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(TRIGGER_IN_BASE, 1); //clear edge capture register
	trigger_sig = 1;
}

void IRQ_UART_ISR3()
{
	const alt_u8 expected_header[2] = {PIG_HEADER[0], PIG_HEADER[1]};
	const alt_u8 buffer_size = 5, header_size = 2;
	const alt_u8 data_size_expected = buffer_size;
	static alt_u8 buffer[5];
	static alt_u8 bytes_received = 0;
	static enum {
		EXPECTING_HEADER,
		EXPECTING_DATA,
		EXPECTING_TAIL
	}state = EXPECTING_HEADER;

	data = IORD_ALTERA_AVALON_UART_RXDATA(UART_BASE);
	switch (state)
	{
		case EXPECTING_HEADER:
			printf("\nEXPECTING_HEADER");
			if (data != expected_header[bytes_received++])
			{
				state = EXPECTING_HEADER;
				bytes_received = 0;
			}
			// Serial.print("bytes_received: ");
			// Serial.println(bytes_received);
			if(bytes_received >= header_size)
			{
				state = EXPECTING_DATA;
				bytes_received = 0;
			}
			break;

		case EXPECTING_DATA:
			printf("\nEXPECTING_DATA, %d\n", bytes_received);
			buffer[bytes_received++] = data;
			printf("\nbytes_received: %d, %x\n", bytes_received, buffer[bytes_received-1]);
			if(bytes_received >= data_size_expected)
			{
				bytes_received = 0;
				state = EXPECTING_TAIL;
			}
			break;
			
		case EXPECTING_TAIL:
			printf("\nEXPECTING_TAIL");
			uart_cmd = data;
			if(uart_cmd != PIG_HEADER) 
			{
				state = EXPECTING_HEADER;
				bytes_received = 0;
				break;
			}
			printf("\npass!");
			uart_cmd = buffer[0];
			uart_value = buffer[1]<<24 | buffer[2]<<16 | buffer[3]<<8 | buffer[4];
			printf("\nuart_cmd: %x\n", uart_cmd);
			printf("\nuart_value: %x\n", uart_value);
			// uart_complete = 1;
			state = EXPECTING_HEADER;
			bytes_received = 0;
			break;
	}
	if(uart_complete) {
//		uart_complete = 0;
//		printf("uart_cmd, uart_value: %x, %x\n", uart_cmd, uart_value);
		switch(uart_cmd){
		case 0: IOWR(VARSET_BASE, O_VAR_FREQ, uart_value); break;
		case 1: IOWR(VARSET_BASE, O_VAR_AMP_H, uart_value); break;
		case 2: IOWR(VARSET_BASE, O_VAR_AMP_L, uart_value); break;
		case 3: IOWR(VARSET_BASE, O_VAR_OFFSET, uart_value); break;
		case 4: IOWR(VARSET_BASE, O_VAR_POLARITY, uart_value); break;
		case 5: IOWR(VARSET_BASE, O_VAR_WAITCNT, uart_value); break;
		case 6: IOWR(VARSET_BASE, O_VAR_ERRTH, uart_value); break;
		case 7: IOWR(VARSET_BASE, O_VAR_AVGSEL, uart_value); break;
		case 8: {
				IOWR(VARSET_BASE, O_VAR_TIMER_RST, 1);
				IOWR(VARSET_BASE, O_VAR_TIMER_RST, 0);
				break;
		}
		case 9: IOWR(VARSET_BASE, O_VAR_GAIN1_SEL, uart_value); break;
		case 10: IOWR(VARSET_BASE, O_VAR_GAIN2_SEL, uart_value); break;
		case 11: IOWR(VARSET_BASE, O_VAR_FB_ON, uart_value); break;
		case 12: IOWR(VARSET_BASE, O_VAR_CONST_STEP, uart_value); break;
		case 13: IOWR(VARSET_BASE, O_VAR_KAL_Q, uart_value); break;
		case 14: IOWR(VARSET_BASE, O_VAR_KAL_R, uart_value); break;
		case 50: {
			IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, (DAC1_GAIN_LSB_ADDR<<8) | (uart_value&0xFF)); usleep (10);
			IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, (DAC1_GAIN_MSB_ADDR<<8) | (uart_value>>8)); usleep (10);
			IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, (DAC2_GAIN_LSB_ADDR<<8) | (uart_value&0xFF)); usleep (10);
			IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, (DAC2_GAIN_MSB_ADDR<<8) | (uart_value>>8)); usleep (10);
			break;
		}
		case 98: delay_time = uart_value; break;
		case 99: start_flag = uart_value; break;
		}
	}
	uart_complete = 0;
}

void IRQ_UART_ISR2()
{
	const alt_u8 expected_header[2] = {PIG_HEADER[0], PIG_HEADER[1]};
	const alt_u8 buffer_size = 4, header_size = 2;
	const alt_u8 data_size_expected = buffer_size;
	static alt_u8 buffer[4];
	static alt_u8 bytes_received = 0;
	static enum {
		EXPECTING_HEADER,
		EXPECTING_CMD,
		EXPECTING_VALUE
	}state = EXPECTING_HEADER;

	data = IORD_ALTERA_AVALON_UART_RXDATA(UART_BASE);
//	printf("%x\n", data);
	switch (state)
	{
		case EXPECTING_HEADER:
			printf("\nEXPECTING_HEADER");
			if (data != expected_header[bytes_received++])
			{
				state = EXPECTING_HEADER;
				bytes_received = 0;
			}
			// Serial.print("bytes_received: ");
			// Serial.println(bytes_received);
			if(bytes_received >= header_size)
			{
				state = EXPECTING_CMD;
				bytes_received = 0;
			}
			break;

		case EXPECTING_CMD:
			printf("\nEXPECTING_CMD");
			uart_cmd = data;
			printf("\nuart_cmd: %x\n", uart_cmd);
			state = EXPECTING_VALUE;
			bytes_received = 0;
			break;

		case EXPECTING_VALUE:
			printf("\nEXPECTING_VALUE, %d\n", bytes_received);
			buffer[bytes_received++] = data;
			printf("\nbytes_received: %d, %x\n", bytes_received, buffer[bytes_received-1]);
			if(bytes_received >= data_size_expected)
			{
				bytes_received = 0;
				uart_value = buffer[0]<<24 | buffer[1]<<16 | buffer[2]<<8 | buffer[3];
				state = EXPECTING_HEADER;
				printf("\nuart_value: %x\n", uart_value);
			}
			break;
	}
//	switch(rx_cnt) {
//		case 0: {
//			uart_cmd = IORD_ALTERA_AVALON_UART_RXDATA(UART_BASE);
//			rx_cnt = 1;
//			break;
//		}
//		case 1: {
//			uart_value = IORD_ALTERA_AVALON_UART_RXDATA(UART_BASE)<<24;
//			rx_cnt = 2;
//			break;
//		}
//		case 2: {
//			uart_value |= IORD_ALTERA_AVALON_UART_RXDATA(UART_BASE)<<16;
//			rx_cnt = 3;
//			break;
//		}
//		case 3: {
//			uart_value |= IORD_ALTERA_AVALON_UART_RXDATA(UART_BASE)<<8;
//			rx_cnt = 4;
//			break;
//		}
//		case 4: {
//			uart_value |= IORD_ALTERA_AVALON_UART_RXDATA(UART_BASE);
//			rx_cnt = 0;
//			uart_complete = 1;
//			break;
//		}
//	}
	if(uart_complete) {
//		uart_complete = 0;
//		printf("uart_cmd, uart_value: %x, %x\n", uart_cmd, uart_value);
		switch(uart_cmd){
		case 0: IOWR(VARSET_BASE, O_VAR_FREQ, uart_value); break;
		case 1: IOWR(VARSET_BASE, O_VAR_AMP_H, uart_value); break;
		case 2: IOWR(VARSET_BASE, O_VAR_AMP_L, uart_value); break;
		case 3: IOWR(VARSET_BASE, O_VAR_OFFSET, uart_value); break;
		case 4: IOWR(VARSET_BASE, O_VAR_POLARITY, uart_value); break;
		case 5: IOWR(VARSET_BASE, O_VAR_WAITCNT, uart_value); break;
		case 6: IOWR(VARSET_BASE, O_VAR_ERRTH, uart_value); break;
		case 7: IOWR(VARSET_BASE, O_VAR_AVGSEL, uart_value); break;
		case 8: {
				IOWR(VARSET_BASE, O_VAR_TIMER_RST, 1);
				IOWR(VARSET_BASE, O_VAR_TIMER_RST, 0);
				break;
		}
		case 9: IOWR(VARSET_BASE, O_VAR_GAIN1_SEL, uart_value); break;
		case 10: IOWR(VARSET_BASE, O_VAR_GAIN2_SEL, uart_value); break;
		case 11: IOWR(VARSET_BASE, O_VAR_FB_ON, uart_value); break;
		case 12: IOWR(VARSET_BASE, O_VAR_CONST_STEP, uart_value); break;
		case 13: IOWR(VARSET_BASE, O_VAR_KAL_Q, uart_value); break;
		case 14: IOWR(VARSET_BASE, O_VAR_KAL_R, uart_value); break;
		case 50: {
			IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, (DAC1_GAIN_LSB_ADDR<<8) | (uart_value&0xFF)); usleep (10);
			IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, (DAC1_GAIN_MSB_ADDR<<8) | (uart_value>>8)); usleep (10);
			IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, (DAC2_GAIN_LSB_ADDR<<8) | (uart_value&0xFF)); usleep (10);
			IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, (DAC2_GAIN_MSB_ADDR<<8) | (uart_value>>8)); usleep (10);
			break;
		}
		case 98: delay_time = uart_value; break;
		case 99: start_flag = uart_value; break;
		}
	}
	uart_complete = 0;
}


void IRQ_UART_ISR()
{
	printf("%x\n", IORD_ALTERA_AVALON_UART_RXDATA(UART_BASE));
	switch(rx_cnt) {
		case 0: {
			uart_cmd = IORD_ALTERA_AVALON_UART_RXDATA(UART_BASE);
			rx_cnt = 1;
			break;
		}
		case 1: {
			uart_value = IORD_ALTERA_AVALON_UART_RXDATA(UART_BASE)<<24;
			rx_cnt = 2;
			break;
		}
		case 2: {
			uart_value |= IORD_ALTERA_AVALON_UART_RXDATA(UART_BASE)<<16;
			rx_cnt = 3;
			break;
		}
		case 3: {
			uart_value |= IORD_ALTERA_AVALON_UART_RXDATA(UART_BASE)<<8;
			rx_cnt = 4;
			break;
		}
		case 4: {
			uart_value |= IORD_ALTERA_AVALON_UART_RXDATA(UART_BASE);
			rx_cnt = 0;
			uart_complete = 1;
			break;
		}
	}
	if(uart_complete) {
		uart_complete = 0;
//		printf("uart_cmd, uart_value: %x, %x\n", uart_cmd, uart_value);
		switch(uart_cmd){
		case 0: IOWR(VARSET_BASE, O_VAR_FREQ, uart_value); break;
		case 1: IOWR(VARSET_BASE, O_VAR_AMP_H, uart_value); break;
		case 2: IOWR(VARSET_BASE, O_VAR_AMP_L, uart_value); break;
		case 3: IOWR(VARSET_BASE, O_VAR_OFFSET, uart_value); break;
		case 4: IOWR(VARSET_BASE, O_VAR_POLARITY, uart_value); break;
		case 5: IOWR(VARSET_BASE, O_VAR_WAITCNT, uart_value); break;
		case 6: IOWR(VARSET_BASE, O_VAR_ERRTH, uart_value); break;
		case 7: IOWR(VARSET_BASE, O_VAR_AVGSEL, uart_value); break;
		case 8: {
				IOWR(VARSET_BASE, O_VAR_TIMER_RST, 1);
				IOWR(VARSET_BASE, O_VAR_TIMER_RST, 0);
				break;
		}
		case 9: IOWR(VARSET_BASE, O_VAR_GAIN1_SEL, uart_value); break;
		case 10: IOWR(VARSET_BASE, O_VAR_GAIN2_SEL, uart_value); break;
		case 11: IOWR(VARSET_BASE, O_VAR_FB_ON, uart_value); break;
		case 12: IOWR(VARSET_BASE, O_VAR_CONST_STEP, uart_value); break;
		case 13: IOWR(VARSET_BASE, O_VAR_KAL_Q, uart_value); break;
		case 14: IOWR(VARSET_BASE, O_VAR_KAL_R, uart_value); break;
		case 50: {
			IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, (DAC1_GAIN_LSB_ADDR<<8) | (uart_value&0xFF)); usleep (10);
			IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, (DAC1_GAIN_MSB_ADDR<<8) | (uart_value>>8)); usleep (10);
			IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, (DAC2_GAIN_LSB_ADDR<<8) | (uart_value&0xFF)); usleep (10);
			IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, (DAC2_GAIN_MSB_ADDR<<8) | (uart_value>>8)); usleep (10);
			break;
		}
		case 98: delay_time = uart_value; break;
		case 99: start_flag = uart_value; break;
		}
	}
}

void Delay2(unsigned long p)
{
    while(--p);
}

void FOG_init()
{
	/*** user variable init***/
	IOWR(VARSET_BASE, O_VAR_FREQ, 100);
	IOWR(VARSET_BASE, O_VAR_AMP_H, 20000);
	IOWR(VARSET_BASE, O_VAR_AMP_L, -20000);
	IOWR(VARSET_BASE, O_VAR_OFFSET, 0);
	IOWR(VARSET_BASE, O_VAR_POLARITY, 1);
	IOWR(VARSET_BASE, O_VAR_WAITCNT, 69);
	IOWR(VARSET_BASE, O_VAR_ERRTH, 0);
	IOWR(VARSET_BASE, O_VAR_AVGSEL, 6);
	IOWR(VARSET_BASE, O_VAR_FB_ON, 0); //0: OPEN loop
	IOWR(VARSET_BASE, O_VAR_GAIN1_SEL, 8);
	IOWR(VARSET_BASE, O_VAR_GAIN2_SEL, 0);
	IOWR(VARSET_BASE, O_VAR_CONST_STEP, 0);
	IOWR(VARSET_BASE, O_VAR_TIMER_RST, 1); usleep (10); //reset timer
	IOWR(VARSET_BASE, O_VAR_TIMER_RST, 0);
	IOWR(VARSET_BASE, O_VAR_KAL_Q, 1);
	IOWR(VARSET_BASE, O_VAR_KAL_R, 1);
}

alt_u8 crc(alt_u8  message[], int nBytes)
{
	alt_u8  remainder = 0;

    /*
     * Perform modulo-2 division, a byte at a time.
     */
    for (int byte = 0; byte < nBytes; ++byte)
    {
        /*
         * Bring the next byte into the remainder.
         */
        remainder ^= (message[byte] << (WIDTH - 8));

//        printf("\nremainder start = %x\n",remainder );


        /*
         * Perform modulo-2 division, a bit at a time.
         */
        for (alt_u8 bit = 8; bit > 0; --bit)
        {
            /*
             * Try to divide the current data bit.
             */
//            printf("bit: %d, ", bit);
//            printf("%x, ", remainder);
            if (remainder & TOPBIT)
            {
                remainder = (remainder << 1) ^ POLYNOMIAL;
            }
            else
            {
                remainder = (remainder << 1);
            }
//            printf("%x\n", remainder);
        }
    }

    /*
     * The final remainder is the CRC result.
     */
    return (remainder);
}
