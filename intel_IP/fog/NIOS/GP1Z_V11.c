#include <stdio.h>
#include "unistd.h"
#include <string.h>
#include "system.h"
#include "altera_avalon_spi.h"
#include "altera_avalon_spi_regs.h"
#include "altera_avalon_uart_regs.h"
#include "sys/alt_irq.h"
#include "sys/alt_stdio.h"
#include "stddef.h"
#include "alt_types.h"
#include "altera_avalon_pio_regs.h"
#include "sys/alt_timestamp.h"
#include "sys/alt_alarm.h"

//#include "delay.h"
//#include "delay.c"
#include "myiic.h"
#include "myiic.c"
#include "uart.h"
#include "uart.c"
#include "Tsensor_DS1775.h"
#include "Tsensor_DS1775.c"



#define FPGA_VERSION "FPGA-GP-PLL100-11"

#define TRIGGER_IN_BASE 0x2002160
#define FLOAT_1 0x3f800000

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
#define O_VAR_LED1  		15
/***R***/
#define I_VAR_TIMER		25
#define I_VAR_STEP		26 //before divided by gain1
#define I_VAR_AMP_H		27
#define I_VAR_AMP_L		28
#define I_VAR_ERR		29
#define I_VAR_OFFSET	30
#define I_VAR_STEP_ORI	31 // after divided by gain1
#define I_VAR_FB_ON		32
#define I_VAR_NSTATE	33
#define I_VAR_CSTATE	34
#define I_VAR_ERR_KAL	35

/**CMD address**/
#define SF0_ADDR 15
#define SF1_ADDR 16
#define SF2_ADDR 17
#define SF3_ADDR 18
#define SF4_ADDR 19
#define SF5_ADDR 20
#define SF6_ADDR 21
#define SF7_ADDR 22
#define SF8_ADDR 23
#define SF9_ADDR 24
#define TMIN_ADDR 25
#define TMAX_ADDR 26
#define DAC_GAIN_ADDR 50
#define DUMP_PARAMETERS 102


/***CRC ***/
#define WIDTH  4
#define TOPBIT (1 << (WIDTH - 1))
#define POLYNOMIAL 0x07

/*** MV ***/
#define MV_NUM 2

const alt_u8 KVH_HEADER[4] = {0xFE, 0x81, 0xFF, 0x55};
const alt_u8 cmd_header[2] = {0xAB, 0xBA};
const alt_u8 cmd_trailer[2] = {0x55, 0x56};
static alt_u8 rxdata = 0, start_flag = 0;
static alt_u8 rx_cnt = 0, uart_cmd;
static alt_32 uart_value, cnt=0, delay_time=1500;
static alt_u8 trigger_sig = 0;
static alt_u16 try_cnt;
//alt_32 kal_p, kal_x, kal_Q, kal_R;
alt_32 mv_data_arr[MV_NUM], mv_ptr, mv_sum;

//void IRQ_UART_ISR(void);
//void IRQ_init(void);
void IRQ_TRIGGER_ISR(void);
void TRIGGER_IRQ_init(void);
void FOG_init(void);
void fog_parameter(alt_u8*);
void sendTx(alt_32);
void checkByte(alt_u8);
alt_u8 crc(alt_u8 [], int);
void Set_Dac_Gain(alt_32);
void Set_FB_Polarity(alt_32);
void Set_CloseLoop_mode();
alt_32 Kal_Update(alt_32);
void Kal_Predict(alt_32, alt_32);
void MV_Init(void);
alt_32 MV_Update(alt_32, alt_u8);
void update_temperature(void);

volatile alt_u8 uart_complete;
volatile alt_32 SF0, SF1, SF2, SF3, SF4;
volatile alt_32 SF5, SF6, SF7, SF8, SF9;
volatile alt_32 TMIN, TMAX;
float Tmin_f, T1_f, T2_f, T3_f, T4_f, T5_f, T6_f, T7_f, Tmax_f;
alt_u8 version[50] = FPGA_VERSION;



typedef union
{
  float float_val;
  alt_u8 bin_val[4];
  alt_32 int_val;
}
my_float_t;

my_float_t my_f, my_SF, my_TEMP;


#define MAX_STR_LENGTH 20
#define PARAMETER_CNT 34
#define MAX_TOTAL_LENGTH (MAX_STR_LENGTH * PARAMETER_CNT)

typedef struct {
    char str[MAX_STR_LENGTH];
    int value;
} DumpParameter;

DumpParameter my_para[PARAMETER_CNT];
char fog_para_dump[MAX_TOTAL_LENGTH] = "";

void my_parameter(const char *, int , DumpParameter *);

void my_parameter(const char *parameter_name, int input_value, DumpParameter *output_data) {
    snprintf(output_data->str, MAX_STR_LENGTH, "\"%s\":%d", parameter_name, input_value);
    output_data->value = input_value;
}

void blink_LED()
{
	for(int i=0; i<100; i++){
		IOWR(VARSET_BASE, O_VAR_LED1, 0x1);
		usleep(300000);
		IOWR(VARSET_BASE, O_VAR_LED1, 0x0);
		usleep(300000);
	}

}

alt_u32 readSPI_DAC1_GAIN()
{
	alt_u8 MSB, LSB;
	alt_32 rt;

	IOWR_ALTERA_AVALON_SPI_SLAVE_SEL(SPI_ADDA_BASE, 1); usleep (10); //select DAC
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, DAC1_GAIN_MSB_R); usleep(10);
	IORD_ALTERA_AVALON_SPI_RXDATA(SPI_ADDA_BASE); // must add this to read old data
	MSB = IORD_ALTERA_AVALON_SPI_RXDATA(SPI_ADDA_BASE);

	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, DAC1_GAIN_LSB_R); usleep(10);
	IORD_ALTERA_AVALON_SPI_RXDATA(SPI_ADDA_BASE); // must add this to read old data
	LSB = IORD_ALTERA_AVALON_SPI_RXDATA(SPI_ADDA_BASE);
	rt = MSB<<8 | LSB;
//	printf("%x\n", rt);
	return rt;
}

void dump_fog_parameter(void) {
	my_parameter("FREQ", IORD(VARSET_BASE, O_VAR_FREQ), &my_para[0]);
	my_parameter("MOD_H", IORD(VARSET_BASE, O_VAR_AMP_H), &my_para[1]);
	my_parameter("MOD_L", IORD(VARSET_BASE, O_VAR_AMP_L), &my_para[2]);
	my_parameter("ERR_OFFSET", IORD(VARSET_BASE, O_VAR_OFFSET), &my_para[3]);
	my_parameter("POLARITY", IORD(VARSET_BASE, O_VAR_POLARITY), &my_para[4]);
	my_parameter("WAIT_CNT", IORD(VARSET_BASE, O_VAR_WAITCNT), &my_para[5]);
	my_parameter("ERR_TH", IORD(VARSET_BASE, O_VAR_ERRTH), &my_para[6]);
	my_parameter("ERR_AVG", IORD(VARSET_BASE, O_VAR_AVGSEL), &my_para[7]);
	my_parameter("GAIN1", IORD(VARSET_BASE, O_VAR_GAIN1_SEL), &my_para[8]);
	my_parameter("GAIN2", IORD(VARSET_BASE, O_VAR_GAIN2_SEL), &my_para[9]);
	my_parameter("FB_ON", IORD(VARSET_BASE, O_VAR_FB_ON), &my_para[10]);
	my_parameter("CONST_STEP", IORD(VARSET_BASE, O_VAR_CONST_STEP), &my_para[11]);
	my_parameter("HD_Q", IORD(VARSET_BASE, O_VAR_KAL_Q), &my_para[12]);
	my_parameter("HD_R", IORD(VARSET_BASE, O_VAR_KAL_R), &my_para[13]);
	my_parameter("SF0", SF0, &my_para[14]);
	my_parameter("SF1", SF1, &my_para[15]);
	my_parameter("SF2", SF2, &my_para[16]);
	my_parameter("SF3", SF3, &my_para[17]);
	my_parameter("SF4", SF4, &my_para[18]);
	my_parameter("SF5", SF5, &my_para[19]);
	my_parameter("SF6", SF6, &my_para[20]);
	my_parameter("SF7", SF7, &my_para[21]);
	my_parameter("SF8", SF8, &my_para[22]);
	my_parameter("SF9", SF9, &my_para[23]);
	my_parameter("TMIN", Tmin_f, &my_para[24]);
	my_parameter("T1", T1_f, &my_para[25]);
	my_parameter("T2", T2_f, &my_para[26]);
	my_parameter("T3", T3_f, &my_para[27]);
	my_parameter("T4", T4_f, &my_para[28]);
	my_parameter("T5", T5_f, &my_para[29]);
	my_parameter("T6", T6_f, &my_para[30]);
	my_parameter("T7", T7_f, &my_para[31]);
	my_parameter("TMAX", Tmax_f, &my_para[32]);
	my_parameter("DAC_GAIN", readSPI_DAC1_GAIN(), &my_para[33]);

}

int main()
{
	alt_u16 cnt=0, p=1;
	alt_32 time, err, step;
	alt_16 PD_temp;
	float PD_temp_f;
	alt_u32 sdram_var, sdram_var2;
	alt_u8 sdram_0, sdram_1, sdram_2, sdram_3;

//	alt_32 reg1, reg2;

	strcat(version, "\n");

	IIC_Init();
	uartInit(); //interrupt method of uart defined in uart.c not main()
	TRIGGER_IRQ_init(); // register EXTT interrupt
	MV_Init();

	IOWR_ALTERA_AVALON_SPI_SLAVE_SEL(SPI_ADDA_BASE, 2); usleep (10); //select ADC
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, ADC_RESET); usleep (10);
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, ADC_FMT); usleep (10);
//	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, ADC_ALL_ZERO); usleep (10);
//	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, ADC_ALL_ONE); usleep (10);


	IOWR_ALTERA_AVALON_SPI_SLAVE_SEL(SPI_ADDA_BASE, 1); usleep (10); //select DAC
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, DAC1_GAIN_MSB_W_NR); usleep (10);
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, DAC1_GAIN_LSB_W_NR); usleep (10);
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, DAC2_GAIN_MSB_W_NR); usleep (10);
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, DAC2_GAIN_LSB_W_NR); usleep (10);

	ds1775_setConfiguration(0x0);  //setting configuration reg, see data sheet p8
	ds1775_setCurPtr(TSENSOR_TEMP);//write to temperature addr
	FOG_init();

	// write sdram for HIGH energy proton test //
	IOWR_32DIRECT(SDRAM_BASE, 0x0, 0xAAABAAAB);
	IOWR_32DIRECT(SDRAM_BASE, 0xFFFFFF, 0xFFFF);
	sdram_var = IORD(SDRAM_BASE, 0);
	sdram_var2 = IORD(SDRAM_BASE, 0x3fffff);

//	kal_p = 0;
//	kal_x = 0;
//	kal_Q = 1;
//	kal_R = 1;

	while(1) {
		time = IORD(VARSET_BASE, I_VAR_TIMER);
		err = IORD(VARSET_BASE, I_VAR_ERR);
//		err = IORD(VARSET_BASE, I_VAR_ERR_KAL);
		step = IORD(VARSET_BASE, I_VAR_STEP_ORI);
//		step = MV_Update(IORD(VARSET_BASE, I_VAR_STEP_ORI), 1);
		PD_temp = ds1775_9B_readTemp_d();
		PD_temp_f = (PD_temp>>8) + ((PD_temp&0xFF)>>7)*0.5;
		if(start_flag == 0){ 	//IDLE mode
//			/***
//			printf("nstate: %d, ", IORD(VARSET_BASE, I_VAR_NSTATE));
//			printf("cstate: %d\n ", IORD(VARSET_BASE, I_VAR_CSTATE));
//			printf("%4.1f\n", ds1775_9B_readTemp_f());
//			sdram_0 = IORD(SDRAM_BASE, 0)>>16;
//			sdram_1 = IORD(SDRAM_BASE, 0)>>8;
//			sdram_2 = IORD(SDRAM_BASE, 0x3fffff)>>16;
//			sdram_3 = IORD(SDRAM_BASE, 0x3fffff)>>8;
//			printf("sdram_0: ");
//			printf("%x\n", sdram_0);
//			printf("sdram_1: ");
//			printf("%x\n", sdram_1);
//			printf("sdram_2: ");
//			printf("%x\n", sdram_2);
//			printf("sdram_3: ");
//			printf("%x\n", sdram_3);
//			usleep(100000);
//			checkByte(0xCD);
//			readData(cmd_header, 2, &try_cnt, &uart_complete);
//			printf("rx count: %d\n", uartAvailable());

//			***/
//			printf("%f\n", PD_temp_f);
			if(PD_temp_f <= Tmin_f) my_SF.int_val = SF0;
			else if(PD_temp_f >= Tmax_f) my_SF.int_val = SF9;
			else if(PD_temp_f > Tmin_f && PD_temp_f <= T1_f) my_SF.int_val = SF1;
			else if(PD_temp_f > T1_f && PD_temp_f <= T2_f) my_SF.int_val = SF2;
			else if(PD_temp_f > T2_f && PD_temp_f <= T3_f){
				my_SF.int_val = SF3;
//				printf("%f ~ %f\n", T2_f, T3_f);
//				printf("SF3\n");
			}
			else if(PD_temp_f > T3_f && PD_temp_f <= T4_f){
				my_SF.int_val = SF4;
//				printf("%f ~ %f\n", T3_f, T4_f);
//				printf("SF4\n");
			}
			else if(PD_temp_f > T4_f && PD_temp_f <= T5_f){
				my_SF.int_val = SF5;
//				printf("%f ~ %f\n", T4_f, T5_f);
//				printf("SF5\n");
			}
			else if(PD_temp_f > T5_f && PD_temp_f <= T6_f){
				my_SF.int_val = SF6;
//				printf("%f ~ %f\n", T5_f, T6_f);
//				printf("SF6\n");
			}
			else if(PD_temp_f > T6_f && PD_temp_f <= T7_f) my_SF.int_val = SF7;
			else if(PD_temp_f > T7_f && PD_temp_f < Tmax_f) my_SF.int_val = SF8;

//			reg1 = IORD(VARSET_BASE, O_VAR_FREQ);
//			reg2 = IORD(VARSET_BASE, O_VAR_AMP_L);
//			printf("freq: %d\n", reg1);
//			printf("freq: %d\n", reg2);
//			printf("%.1f, %.11f\n ", PD_temp_f, my_SF.float_val);

//			usleep(300000);
		}
		else if(start_flag == 1) { //INT mode
			my_f.float_val = (float)time*0.0001;
			checkByte(171); //AB
			checkByte(186); //BA
//			sendTx(time);
			sendTx(my_f.int_val);
			sendTx(err);
			sendTx(step);
			checkByte(PD_temp>>8);
			checkByte(PD_temp);
			usleep(delay_time);
		}

		else if(start_flag == 2) { //EXT mode
			if(trigger_sig) {
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

		else if(start_flag == 3) { //High Energy Proton test mode
			if(trigger_sig) {

				trigger_sig = 0;

				sdram_0 = IORD(SDRAM_BASE, 0)>>16;
				sdram_1 = IORD(SDRAM_BASE, 0)>>8;
				sdram_2 = IORD(SDRAM_BASE, 0x3fffff)>>16;
				sdram_3 = IORD(SDRAM_BASE, 0x3fffff)>>8;

				checkByte(171);
				checkByte(186);
				sendTx(time);
//				sendTx(err);
				checkByte(sdram_0);
				checkByte(sdram_1);
				checkByte(sdram_2);
				checkByte(sdram_3);
				sendTx(step);
				checkByte(PD_temp>>8);
				checkByte(PD_temp);
			}
				}
//		fog_parameter(readData(cmd_header, 2, &try_cnt, cmd_trailer, 2, &uart_complete));
		fog_parameter(readData2(cmd_header, 2, &try_cnt, cmd_trailer, 2));
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


void TRIGGER_IRQ_init()
{
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(TRIGGER_IN_BASE, 1); //clear edge capture register
	IOWR_ALTERA_AVALON_PIO_IRQ_MASK(TRIGGER_IN_BASE, 1); //enable irq mask
	alt_ic_isr_register(
	TRIGGER_IN_IRQ_INTERRUPT_CONTROLLER_ID,
	TRIGGER_IN_IRQ                        ,
	IRQ_TRIGGER_ISR          ,
	0x0                             ,
	0x0);
}

void IRQ_TRIGGER_ISR()
{
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(TRIGGER_IN_BASE, 1); //clear edge capture register
	trigger_sig = 1;
}

void fog_parameter(alt_u8 *data)
{
	if(data){
		if(uart_complete)
		{
			uart_complete = 0;
			uart_cmd = data[0];
			uart_value = data[1]<<24 | data[2]<<16 | data[3]<<8 | data[4];
//			printf("uart_cmd, uart_value: %d, %d\n\n", uart_cmd, uart_value);
			switch(uart_cmd){
					case 0: {
						IOWR(VARSET_BASE, O_VAR_FREQ, uart_value);
						break;
					}
					case 1: {
						IOWR(VARSET_BASE, O_VAR_AMP_H, uart_value);
						break;
					}
					case 2: {
						IOWR(VARSET_BASE, O_VAR_AMP_L, uart_value);
						break;
					}
					case 3: {
						IOWR(VARSET_BASE, O_VAR_OFFSET, uart_value);
						break;
					}
					case 4: {
						IOWR(VARSET_BASE, O_VAR_POLARITY, uart_value);
						break;
					}
					case 5: {
						IOWR(VARSET_BASE, O_VAR_WAITCNT, uart_value);
						break;
					}
					case 6: {
						IOWR(VARSET_BASE, O_VAR_ERRTH, uart_value);
						break;
					}
					case 7: {
						IOWR(VARSET_BASE, O_VAR_AVGSEL, uart_value);
						break;
					}
					case 8: {
						IOWR(VARSET_BASE, O_VAR_TIMER_RST, 1);
						IOWR(VARSET_BASE, O_VAR_TIMER_RST, 0);
						break;
					}
					case 9: {
						IOWR(VARSET_BASE, O_VAR_GAIN1_SEL, uart_value);
						break;
					}
					case 10: {
						IOWR(VARSET_BASE, O_VAR_GAIN2_SEL, uart_value);
						break;
					}
					case 11: {
						IOWR(VARSET_BASE, O_VAR_FB_ON, uart_value);
						break;
					}
					case 12: {
						IOWR(VARSET_BASE, O_VAR_CONST_STEP, uart_value);
						break;
					}
					case 13: {
						IOWR(VARSET_BASE, O_VAR_KAL_Q, uart_value);
			//			kal_Q = uart_value;
			//			printf("kal_Q: %d\n", kal_Q);
						break;
					}
					case 14: {
						IOWR(VARSET_BASE, O_VAR_KAL_R, uart_value);
			//			kal_R = uart_value;
			//			printf("kal_R: %d\n", kal_R);
						break;
					}
					case SF0_ADDR: SF0 = uart_value;break;
					case SF1_ADDR: SF1 = uart_value;break;
					case SF2_ADDR: SF2 = uart_value;break;
					case SF3_ADDR: SF3 = uart_value;break;
					case SF4_ADDR: SF4 = uart_value;break;
					case SF5_ADDR: SF5 = uart_value;break;
					case SF6_ADDR: SF6 = uart_value;break;
					case SF7_ADDR: SF7 = uart_value;break;
					case SF8_ADDR: SF8 = uart_value;break;
					case SF9_ADDR: SF9 = uart_value;break;
					case TMIN_ADDR:{
						TMIN = uart_value;
						my_TEMP.int_val = TMIN;
						Tmin_f = my_TEMP.float_val;
						update_temperature();
						break;
					}
					case TMAX_ADDR:{
						TMAX = uart_value;
						my_TEMP.int_val = TMAX;
						Tmax_f = my_TEMP.float_val;
						break;
					}

					case DAC_GAIN_ADDR: {
						IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, (DAC1_GAIN_LSB_ADDR<<8) | (uart_value&0xFF)); usleep (10);
						IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, (DAC1_GAIN_MSB_ADDR<<8) | (uart_value>>8)); usleep (10);
						IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, (DAC2_GAIN_LSB_ADDR<<8) | (uart_value&0xFF)); usleep (10);
						IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, (DAC2_GAIN_MSB_ADDR<<8) | (uart_value>>8)); usleep (10);

						break;
					}
					case 98: delay_time = uart_value; break;
					case 99: start_flag = uart_value; break;
					case 101: {

						int i=0;
//						printf("%c\n",version[i]);
						checkByte(version[i]);
						/*** 
 						while(fpga_version[i++] != 0xa) {
//							printf("%c\n",fpga_version[i]);
							checkByte(fpga_version[i]);
						}
						*/
						while(version[i++] != 0xa) {
//							printf("%c\n",version[i]);
							checkByte(version[i]);
						}
						break;
					}
					case DUMP_PARAMETERS:{

						dump_fog_parameter();
//						printf("%f\n", Tmin_f);
//						printf("%f\n", T2_f);
//						printf("%f\n", T3_f);
//						printf("%f\n", T4_f);
//						printf("%f\n", Tmax_f);

						for (int i = 0; i < PARAMETER_CNT; i++) {
							strcat(fog_para_dump, my_para[i].str);
							if(i<PARAMETER_CNT-1) strcat(fog_para_dump, ", ");

						}
						int para_size=0;
//
						for(int i=0; i<sizeof(fog_para_dump); i++){
//							printf("%d, %x\n", i, fog_para_dump[i]);
							if(fog_para_dump[i]==0) {
								para_size = i;
								break;
							}
						}
//						printf("para_size: %d\n", para_size);
						char fog_para_dump_out[para_size];

						memset(fog_para_dump_out, 0, para_size); // initialize fog_para_dump_out to zeros
						strcat(fog_para_dump_out, fog_para_dump);
//
//						printf("%s, %d\n", fog_para_dump, sizeof(fog_para_dump));
//						printf("%s, %d\n", fog_para_dump_out, sizeof(fog_para_dump_out));

						strcpy(fog_para_dump, ""); // reset fog_para_dump to ""
						checkByte(0x7B);// {
						for(int i=0; i<sizeof(fog_para_dump_out);i++){
							checkByte(fog_para_dump_out[i]);
						}
						checkByte(0x7D);// }
						checkByte(0x0A);// \n

						break;
					}
			}
	 	}
	}

}


void Delay2(unsigned long p)
{
    while(--p);
}

void MV_Init(void)
{
	for (int i=0; i<MV_NUM; i++) mv_data_arr[i] = 0;
	mv_ptr = 0;
	mv_sum = 0;
}

alt_32 MV_Update(alt_32 z, alt_u8 shift)
{
	mv_sum -= mv_data_arr[mv_ptr];
	mv_data_arr[mv_ptr++] = z;
	mv_sum += z;
//	mv_ptr++;
	if(mv_ptr==MV_NUM) mv_ptr = 0;
	return (mv_sum >> shift);
}

//alt_32 Kal_Update(alt_32 z)
//{
//	alt_32 k, x, p;
//
//	k = kal_p/(kal_p + kal_R);
//	x = kal_x + k*(z - kal_x);
//	p = (1 - k)*kal_p;
//	Kal_Predict(x, p);
//	return x;
//}
//
//void Kal_Predict(alt_32 x, alt_32 p)
//{
//	kal_x = x;
//	kal_p = p + kal_Q;
//}

void Set_Dac_Gain(alt_32 gain)
{
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, (DAC1_GAIN_LSB_ADDR<<8) | (gain&0xFF)); usleep (10);
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, (DAC1_GAIN_MSB_ADDR<<8) | (gain>>8)); usleep (10);
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, (DAC2_GAIN_LSB_ADDR<<8) | (gain&0xFF)); usleep (10);
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, (DAC2_GAIN_MSB_ADDR<<8) | (gain>>8)); usleep (10);
}

void Set_CloseLoop_mode()
{
	IOWR(VARSET_BASE, O_VAR_FB_ON, 0);
	usleep(1000);
	IOWR(VARSET_BASE, O_VAR_FB_ON, 1);
	usleep(1000);
}

void Set_FB_Polarity(alt_32 pol)
{
	if(pol==0) {
		IOWR(VARSET_BASE, O_VAR_POLARITY, 1);
		usleep(1000);
		IOWR(VARSET_BASE, O_VAR_POLARITY, 0);
		usleep(1000);
	}
	else {
		IOWR(VARSET_BASE, O_VAR_POLARITY, 0);
		usleep(1000);
		IOWR(VARSET_BASE, O_VAR_POLARITY, 1);
	}
}

void FOG_init()
{
	/*** user variable init***/
	IOWR(VARSET_BASE, O_VAR_FREQ, 102);
	IOWR(VARSET_BASE, O_VAR_AMP_H, 4100);
	IOWR(VARSET_BASE, O_VAR_AMP_L, -4100);
	IOWR(VARSET_BASE, O_VAR_OFFSET, 0);
//	IOWR(VARSET_BASE, O_VAR_POLARITY, 1);
	Set_FB_Polarity(0);
	Set_CloseLoop_mode();
//	IOWR(VARSET_BASE, O_VAR_FB_ON, 0);
	IOWR(VARSET_BASE, O_VAR_WAITCNT, 20);
	IOWR(VARSET_BASE, O_VAR_ERRTH, 0);
	IOWR(VARSET_BASE, O_VAR_AVGSEL, 0);
//	IOWR(VARSET_BASE, O_VAR_FB_ON, 1); //0: OPEN loop
	IOWR(VARSET_BASE, O_VAR_GAIN1_SEL, 7);
	IOWR(VARSET_BASE, O_VAR_GAIN2_SEL, 6);
	IOWR(VARSET_BASE, O_VAR_CONST_STEP, 0);
	IOWR(VARSET_BASE, O_VAR_TIMER_RST, 1); usleep (10); //reset timer
	IOWR(VARSET_BASE, O_VAR_TIMER_RST, 0);
	IOWR(VARSET_BASE, O_VAR_KAL_Q, 10);
	IOWR(VARSET_BASE, O_VAR_KAL_R, 20);
//	Set_FB_Polarity(0);
//	usleep(1000);
//	IOWR(VARSET_BASE, O_VAR_POLARITY, 0);
//	usleep(1000);
//	IOWR(VARSET_BASE, O_VAR_POLARITY, 1);
	Set_Dac_Gain(505);
	SF0 = FLOAT_1;
	SF1 = FLOAT_1;
	SF2 = FLOAT_1;
	SF3 = FLOAT_1;
	SF4 = FLOAT_1;
	SF5 = FLOAT_1;
	SF6 = FLOAT_1;
	SF7 = FLOAT_1;
	SF8 = FLOAT_1;
	SF9 = FLOAT_1;
	Tmin_f = -20.0;
	T1_f = TMIN + 10.0;
	T2_f = T1_f + 10.0;
	T3_f = T2_f + 10.0;
	T4_f = T3_f + 10.0;
	T5_f = T4_f + 10.0;
	T6_f = T5_f + 10.0;
	T7_f = T6_f + 10.0;
	Tmax_f = 80.0;
}

void update_temperature(void)
{
	T1_f = Tmin_f + 10.0;
	T2_f = T1_f + 10.0;
	T3_f = T2_f + 10.0;
	T4_f = T3_f + 10.0;
	T5_f = T4_f + 10.0;
	T6_f = T5_f + 10.0;
	T7_f = T6_f + 10.0;
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

