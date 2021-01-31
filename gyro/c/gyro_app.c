
#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xil_io.h"
#include "unistd.h"
#include "xil_types.h"
#include "xuartlite_l.h"

#define SIZE 20
#define UARTLITE_BASEADDR 	XPAR_UARTLITE_0_BASEADDR
#define UARTLITE_TX			XPAR_UARTLITE_0_BASEADDR + 4
#define UARTLITE_STATUS		XPAR_UARTLITE_0_BASEADDR + 2*4
#define UARTLITE_CTRL		XPAR_UARTLITE_0_BASEADDR + 3*4

#define XPAR_MYAXI_2017P4_50REG_S00_AXI_BASEADDR XPAR_MYAXI_2017P4_50REG_0_S00_AXI_BASEADDR
/*** gyro variable adderess definition***/
/***-------write------- ***/
#define ADDR_OUT_FREQ		XPAR_MYAXI_2017P4_50REG_S00_AXI_BASEADDR
#define ADDR_OUT_MOD_H  	XPAR_MYAXI_2017P4_50REG_S00_AXI_BASEADDR + 4
#define ADDR_OUT_MOD_L 		XPAR_MYAXI_2017P4_50REG_S00_AXI_BASEADDR + 2*4
#define ADDR_OUT_ERR_OFFSET	XPAR_MYAXI_2017P4_50REG_S00_AXI_BASEADDR + 3*4
#define ADDR_OUT_POLARITY	XPAR_MYAXI_2017P4_50REG_S00_AXI_BASEADDR + 4*4
#define ADDR_OUT_WAIT_CNT	XPAR_MYAXI_2017P4_50REG_S00_AXI_BASEADDR + 5*4
#define ADDR_OUT_ERR_TH		XPAR_MYAXI_2017P4_50REG_S00_AXI_BASEADDR + 6*4
#define ADDR_OUT_ERR_AVG	XPAR_MYAXI_2017P4_50REG_S00_AXI_BASEADDR + 7*4
#define ADDR_OUT_TIMER_RST	XPAR_MYAXI_2017P4_50REG_S00_AXI_BASEADDR + 8*4
#define ADDR_OUT_GAIN_SEL	XPAR_MYAXI_2017P4_50REG_S00_AXI_BASEADDR + 9*4
#define ADDR_OUT_STEP_MAX	XPAR_MYAXI_2017P4_50REG_S00_AXI_BASEADDR + 10*4
#define ADDR_OUT_V2PI		XPAR_MYAXI_2017P4_50REG_S00_AXI_BASEADDR + 11*4
#define ADDR_OUT_RSTN		XPAR_MYAXI_2017P4_50REG_S00_AXI_BASEADDR + 12*4


/***-------read------- ***/
#define ADDR_IN_ERR   		XPAR_MYAXI_2017P4_50REG_S00_AXI_BASEADDR + 25*4
#define ADDR_IN_ADC_REG_H   XPAR_MYAXI_2017P4_50REG_S00_AXI_BASEADDR + 26*4
#define ADDR_IN_ADC_REG_L   XPAR_MYAXI_2017P4_50REG_S00_AXI_BASEADDR + 27*4
#define ADDR_IN_TIMER   	XPAR_MYAXI_2017P4_50REG_S00_AXI_BASEADDR + 28*4
#define ADDR_IN_STEP		XPAR_MYAXI_2017P4_50REG_S00_AXI_BASEADDR + 29*4




/********global variable***************/
u8 string_in[SIZE];
u8 cmd_idx = 0;
u8 complete = 0;
u8 closeLoop_flag=0;
u32 timer = 0;
int cmd;
int value = 0, err;
int Loop_start = 0;

void serialEvent();


int main()
{
    init_platform();
    /*** initial value***/
    Xil_Out32(ADDR_OUT_RSTN, 0);
    Xil_Out32(ADDR_OUT_FREQ, 100);
    Xil_Out32(ADDR_OUT_MOD_H, 5000);
    Xil_Out32(ADDR_OUT_MOD_L, -5000);
    Xil_Out32(ADDR_OUT_ERR_OFFSET, 1);
    Xil_Out32(ADDR_OUT_POLARITY, 0);
    Xil_Out32(ADDR_OUT_WAIT_CNT, 10);
    Xil_Out32(ADDR_OUT_ERR_TH, 0);
    Xil_Out32(ADDR_OUT_ERR_AVG, 2);

    Xil_Out32(ADDR_OUT_GAIN_SEL, 0);
    Xil_Out32(ADDR_OUT_STEP_MAX, 1000);
    Xil_Out32(ADDR_OUT_V2PI, 20000);
    Xil_Out32(ADDR_OUT_RSTN, 1);

	while(1)
	{
		serialEvent();
	    if(complete == 1) {
			complete = 0;

			switch(cmd) {
				case 0: {
//							xil_printf("set mod freq: %d\n", value);
							Xil_Out32(ADDR_OUT_FREQ, value);

							break;}
				case 1: {
//							xil_printf("set mod amp_H: %d\n", value);
							Xil_Out32(ADDR_OUT_MOD_H, value);
							break;}
				case 2: {
//							xil_printf("set mod amp_L: %d\n", value);
							Xil_Out32(ADDR_OUT_MOD_L, value);
							break;}
				case 3: {
//							xil_printf("set err offset: %d\n", value);
							Xil_Out32(ADDR_OUT_ERR_OFFSET, value);
							break;}
				case 4: {
//							xil_printf("polarity: %d\n", value);
							Xil_Out32(ADDR_OUT_POLARITY, value);
							break;}

				case 5: {
//							xil_printf("wait_cnt: %d\n", value);
							Xil_Out32(ADDR_OUT_WAIT_CNT, value);
							break;}

				case 6: {
//							xil_printf("err_th: %d\n", value);
							Xil_Out32(ADDR_OUT_ERR_TH, value);
							break;}

				case 7: {
//							xil_printf("err_avg: %d\n", value);
							Xil_Out32(ADDR_OUT_ERR_AVG, value);
							break;}

				case 8: {
							Xil_Out32(ADDR_OUT_GAIN_SEL, value);
							if(value==15) closeLoop_flag = 0;
							else closeLoop_flag = 1;
							break;}
				case 9: {
							Xil_Out32(ADDR_OUT_STEP_MAX, value);
							break;}
				case 10: {
							Xil_Out32(ADDR_OUT_V2PI, value);
							break;}




				case 11: {	xil_printf("read freq: %d\n", Xil_In32(XPAR_MYAXI_2017P4_50REG_S00_AXI_BASEADDR));
							break;}

				case 12: {
							Loop_start = value;
							Xil_Out32(ADDR_OUT_TIMER_RST, 1);
							Xil_Out32(ADDR_OUT_TIMER_RST, 0);
//							xil_printf("openLoop_start: %d\n", openLoop_start);
							// Xil_Out32(UARTLITE_CTRL, 2); //clear rx buffer first
							// usleep(1000);
							// Xil_Out32(UARTLITE_CTRL, 0);
							// while(value)
							// {
								// if((Xil_In32(UARTLITE_STATUS)&0x1))
									// if(Xil_In32(XPAR_AXI_UARTLITE_BASEADDR)=='1') value = 0; //stop sending data when rx data = '1'

//								 err = Xil_In32(ADDR_IN_ERR);
//								 xil_printf("%d\n", err);
								// Xil_Out32(UARTLITE_TX,err >> 24);
								// Xil_Out32(UARTLITE_TX,err >> 16);
								// Xil_Out32(UARTLITE_TX,err >> 8);
								// Xil_Out32(UARTLITE_TX,err >> 0);
								// usleep(10000);
							// }

							break;
						}
				case 13: {
							xil_printf("ADC_REG_H: %d\n", Xil_In32(ADDR_IN_ADC_REG_H));
							break;
				}
//				case 14: {
//							xil_printf("ADC_REG_L: %d\n", Xil_In32(ADDR_IN_ADC_REG_L));
//							xil_printf("ADC_28: %d\n", Xil_In32(ADD_IN_28));
//							xil_printf("ADC_29: %d\n", Xil_In32(ADD_IN_29));
//
//							break;
//				}

				default : {xil_printf("default case\n"); break;}
			}
		} //end of complete=1 if loop

		if(Loop_start)
		{
			// if((Xil_In32(UARTLITE_STATUS)&0x1))
			// {
			timer = Xil_In32(ADDR_IN_TIMER);
			if(closeLoop_flag) err = Xil_In32(ADDR_IN_STEP);
			else err = Xil_In32(ADDR_IN_ERR);

			Xil_Out32(UARTLITE_TX,0xAA);

//				xil_printf("%d\n", err);
			Xil_Out32(UARTLITE_TX,timer >> 24);
			Xil_Out32(UARTLITE_TX,timer >> 16);
			Xil_Out32(UARTLITE_TX,timer >> 8);
			Xil_Out32(UARTLITE_TX,timer >> 0);

			Xil_Out32(UARTLITE_TX,err >> 24);
			Xil_Out32(UARTLITE_TX,err >> 16);
			Xil_Out32(UARTLITE_TX,err >> 8);
			Xil_Out32(UARTLITE_TX,err >> 0);

			usleep(10000);
			// }
		}


	} //end of while loop

    cleanup_platform();
    return 0;
}

void serialEvent()
{
	u8 rx_data;

	// rx_data = XUartLite_RecvByte(UARTLITE_BASEADDR);
//	xil_printf("rx_data: %d\n", rx_data);

	if((Xil_In32(UARTLITE_STATUS)&0x1))
	{
		rx_data = Xil_In32(UARTLITE_BASEADDR);
//		xil_printf("%d\n", rx_data);
		if((u8)rx_data != 13 && (u8)rx_data != 10) //13:carriage return, 10:NL
		{
			string_in[cmd_idx] = rx_data;
			cmd_idx ++;

		}
		else
		{
			for(int i=cmd_idx; i<SIZE; i++) {
				string_in[i]=' ' ;
//				xil_printf("%d\n", i);
			}
			sscanf(string_in, "%d%d", &cmd, &value);
//			xil_printf("cmd= %d\n", cmd);
//			xil_printf("value= %d\n", value);
			cmd_idx = 0;
			complete = 1;
		}
	}

}
