#ifndef __LGSM_V1_H
#define __LGSM_V1_H

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
//#include "sys/alt_timestamp.h"
//#include "sys/alt_alarm.h"

/******** NIOS II Variable IP address definition*******/
#include "nios2_var_addr.h"

/******** my Library *******/
#include "uart.h"
#include "myiic.h"
#include "Tsensor_DS1775.h"

#define FPGA_VERSION "LGSM_V1_allFilter"
#define NMEA_HEADER "YAW,"

#define TRIGGER_IN_BASE 0x2002160
#define FLOAT_1   0x3f800000
#define FLOAT_650 0x44228000

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

/**CMD address**/
#define MOD_FREQ_ADDR		0
#define MOD_AMP_H_ADDR  	1
#define MOD_AMP_L_ADDR  	2
#define ERR_OFFSET_ADDR 	3
#define POLARITY_ADDR  		4
#define WAIT_CNT_ADDR  		5
#define ERR_TH_ADDR  		6
#define ERR_AVG_ADDR  		7
#define TIMER_RST_ADDR  	8
#define GAIN1_ADDR  		9
#define GAIN2_ADDR  		10
#define FB_ON_ADDR  		11
#define CONST_STEP_ADDR  	12
#define FPGA_Q_ADDR			13
#define FPGA_R_ADDR  		14
/*** scale factor temperature compensation ***/
#define SF0_ADDR 			15
#define SF1_ADDR 			16
#define SF2_ADDR 			17
#define SF3_ADDR			18
#define SF4_ADDR 			19
#define SF5_ADDR 			20
#define SF6_ADDR 			21
#define SF7_ADDR 			22
#define SF8_ADDR 			23
#define SF9_ADDR 			24
#define TMIN_ADDR 			25
#define TMAX_ADDR 			26
/*** end of scale factor temperature compensation ***/
#define SFB_ADDR            27
#define CUTOFF_ADDR         28
/*** bias temperature compensation ***/
#define BIAS_COMP_T1_ADDR 	29
#define BIAS_COMP_T2_ADDR 	30
#define SFB_1_SLOPE_ADDR 	31
#define SFB_1_OFFSET_ADDR 	32
#define SFB_2_SLOPE_ADDR 	33
#define SFB_2_OFFSET_ADDR 	34
#define SFB_3_SLOPE_ADDR 	35
#define SFB_3_OFFSET_ADDR 	36
/*** end of bias temperature compensation ***/

#define DAC_GAIN_ADDR 		50
#define DATA_INT_DELAY_ADDR	98
#define DATA_OUT_START_ADDR	99
#define FPGA_WAKEUP_ADDR 	100
#define FPGA_VERSION_ADDR	101
#define DUMP_PARAMETERS 	102

/***CRC ***/
#define WIDTH  4
#define TOPBIT (1 << (WIDTH - 1))
#define POLYNOMIAL 0x07

/*** MV ***/
#define MV_NUM 8
#define COE_TIMER 0.0001

#endif // __LGSM_V1_H





