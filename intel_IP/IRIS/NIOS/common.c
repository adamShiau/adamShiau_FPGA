#include "common.h"
#include <stdarg.h>
#include <string.h>

// Initialize the Moving Average filter
void moving_average_init(MovingAverage_t *ma, alt_u32 window) {
    ma->buffer = (float *)malloc(window * sizeof(float));
    if (!ma->buffer) {
        // printf("Memory allocation failed!\n");
        exit(1);
    }
    ma->window_size = window;
    ma->index = 0;
    ma->sum = 0.0f;
    for (alt_u32 i = 0; i < window; i++) {
        ma->buffer[i] = 0.0f;
    }
}

// Process new data and return filtered result
float moving_average_update(MovingAverage_t *ma, float din) {
    // Subtract the oldest value from sum
    ma->sum -= ma->buffer[ma->index];
    
    // Store new value in buffer
    ma->buffer[ma->index] = din;
    
    // Add new value to sum
    ma->sum += din;
    
    // Move index forward in circular manner
    ma->index = (ma->index + 1) % ma->window_size;
    
    // Return the average
    return ma->sum / (ma->window_size);
}

// Free allocated memory
void moving_average_free(MovingAverage_t *ma) {
    free(ma->buffer);
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

void uart_printf(const char *format, ...)
{
    char buffer[256];  // 128 is buffer size, can increase if need 
    va_list args;                   

    va_start(args, format);           
    vsnprintf(buffer, 256, format, args);  
    va_end(args);

    SerialWrite((alt_u8*)buffer, strlen(buffer));
}

void SerialWrite(alt_u8* buf, alt_u8 num) 
{
    for (alt_u8 i = 0; i < num; i++) 
    {
        while (!(IORD_ALTERA_AVALON_UART_STATUS(UART_BASE) & ALTERA_AVALON_UART_STATUS_TRDY_MSK));
        IOWR_ALTERA_AVALON_UART_TXDATA(UART_BASE, buf[i]);
    }
}

void SerialWrite_r(alt_u8* buf, alt_u8 num) 
{
    for (alt_u8 i = num; i > 0; i--) 
    {
        while (!(IORD_ALTERA_AVALON_UART_STATUS(UART_BASE) & ALTERA_AVALON_UART_STATUS_TRDY_MSK));
        IOWR_ALTERA_AVALON_UART_TXDATA(UART_BASE, buf[i - 1]);
    }
}

int IEEE_754_F2INT(float in)
{
	my_float_t temp;
	temp.float_val = in;

	return temp.int_val;
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

void get_uart_cmd(alt_u8* data, cmd_ctrl_t* rx)
{
    if(data){
        rx->complete = 1;
		rx->condition = data[0];
		rx->cmd = data[1];
		if(rx->condition == RX_CONDITION_ABBA_5556) { 
			rx->value = data[2]<<24 | data[3]<<16 | data[4]<<8 | data[5];
			rx->ch = data[6];
			DEBUG_PRINT("\nuart_cmd, uart_value, ch, condition: 0x%x, %ld, %d, %u\n", rx->cmd , rx->value, rx->ch, rx->condition);
		}
		else if(rx->condition == RX_CONDITION_CDDC_5758) {
			for (int i = 0; i < 12; i++) {
				rx->SN[i] = data[i + 2];  
			}
			rx->SN[12] = '\0'; 
			DEBUG_PRINT("\nuart_cmd, condition, SN: 0x%x, %u, %s\n", rx->cmd , rx->condition, rx->SN);
		}
        
    }
    else return;
}

void cmd_mux(cmd_ctrl_t* rx)
{
	if(rx->complete == 1)
	{
        
		rx->complete = 0;
		if(rx->cmd >7) rx->mux = MUX_PARAMETER; 
		else rx->mux = MUX_OUTPUT;
        // DEBUG_PRINT("cmd_mux: mux=%u, complete=%u\n", rx->mux, rx->complete);
	}
}

void Set_Dac_Gain(alt_32 gain)
{
	// for fogz, DAC_1CH with DAC2
	IOWR_ALTERA_AVALON_SPI_SLAVE_SEL(SPI_ADDA_BASE, SEL_CS_DAC_1CH); usleep (10); //select DAC_1CH
	// IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, (DAC1_GAIN_LSB_ADDR<<8) | (gain&0xFF)); usleep (10);
	// IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, (DAC1_GAIN_MSB_ADDR<<8) | (gain>>8)); usleep (10);
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, (DAC2_GAIN_LSB_ADDR<<8) | (gain&0xFF)); usleep (10);
	IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADDA_BASE, (DAC2_GAIN_MSB_ADDR<<8) | (gain>>8)); usleep (10);
}


// void fog_parameter(alt_u8 *data, fog_parameter_t* fog_inst)
void fog_parameter(cmd_ctrl_t* rx, fog_parameter_t* fog_inst)
{

	if(rx->mux == MUX_PARAMETER){
        // DEBUG_PRINT("fog_parameter\n");
        rx->mux = MUX_ESCAPE;
		alt_u8 base = 0, cmd2hwreg=0;

            if(rx->ch == 1) {
				base = MEM_BASE_X;
				cmd2hwreg = CMD_TO_HW_REG_OFFSET_CH1;
			}
			else if(rx->ch == 2) {
				base = MEM_BASE_Y;
				cmd2hwreg = CMD_TO_HW_REG_OFFSET_CH2;
			}
			else if(rx->ch == 3) {
				base = MEM_BASE_Z;
				cmd2hwreg = CMD_TO_HW_REG_OFFSET_CH3;
			}
			else if(rx->ch == 4) {
				base = MEM_BASE_MIS;
			}

			if(rx->condition == 1) {
				switch(rx->cmd ){
					case CMD_MOD_FREQ: {
						DEBUG_PRINT("CMD_MOD_FREQ:\n");					
						PARAMETER_Write_s(base, CMD_MOD_FREQ - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						IOWR(VARSET_BASE, CMD_MOD_FREQ + cmd2hwreg, rx->value);
						break;
					}
					case CMD_MOD_AMP_H: {
						DEBUG_PRINT("CMD_MOD_AMP_H:\n");					
						PARAMETER_Write_s(base, CMD_MOD_AMP_H - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						IOWR(VARSET_BASE, CMD_MOD_AMP_H + cmd2hwreg, rx->value);
						break;
					}
					case CMD_MOD_AMP_L: {
						DEBUG_PRINT("CMD_MOD_AMP_L:\n");					
						PARAMETER_Write_s(base, CMD_MOD_AMP_L - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						IOWR(VARSET_BASE, CMD_MOD_AMP_L + cmd2hwreg, rx->value);
						break;
					}
					case CMD_POLARITY: {
						DEBUG_PRINT("CMD_POLARITY:\n");					
						PARAMETER_Write_s(base, CMD_POLARITY - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						IOWR(VARSET_BASE, CMD_POLARITY + cmd2hwreg, rx->value);
						break;
					}
					case CMD_WAIT_CNT: {
						DEBUG_PRINT("CMD_WAIT_CNT:\n");
						PARAMETER_Write_s(base, CMD_WAIT_CNT - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						IOWR(VARSET_BASE, CMD_WAIT_CNT + cmd2hwreg, rx->value);
						break;
					} 
					case CMD_ERR_AVG: {
						DEBUG_PRINT("CMD_ERR_AVG:\n");
						PARAMETER_Write_s(base, CMD_ERR_AVG - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						IOWR(VARSET_BASE, CMD_ERR_AVG + cmd2hwreg, rx->value);
						break;
					} 
					case CMD_GAIN1: {
						DEBUG_PRINT("CMD_GAIN1:\n");
						PARAMETER_Write_s(base, CMD_GAIN1 - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						IOWR(VARSET_BASE, CMD_GAIN1 + cmd2hwreg, rx->value);
						break;
					} 
					case CMD_CONST_STEP: {
						DEBUG_PRINT("CMD_CONST_STEP:\n");
						PARAMETER_Write_s(base, CMD_CONST_STEP - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						IOWR(VARSET_BASE, CMD_CONST_STEP + cmd2hwreg, rx->value);
						break;
					} 
					case CMD_FB_ON: {
						DEBUG_PRINT("CMD_FB_ON:\n");
						PARAMETER_Write_s(base, CMD_FB_ON - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						IOWR(VARSET_BASE, CMD_FB_ON + cmd2hwreg, rx->value);
						break;
					} 
					case CMD_GAIN2: {
						DEBUG_PRINT("CMD_GAIN2:\n");
						PARAMETER_Write_s(base, CMD_GAIN2 - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						IOWR(VARSET_BASE, CMD_GAIN2 + cmd2hwreg, rx->value);
						break;
					} 
					case CMD_ERR_OFFSET: {
						DEBUG_PRINT("CMD_ERR_OFFSET:\n");
						PARAMETER_Write_s(base, CMD_ERR_OFFSET - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						IOWR(VARSET_BASE, CMD_ERR_OFFSET + cmd2hwreg, rx->value);
						break;
					} 
					case CMD_DAC_GAIN: {
						DEBUG_PRINT("CMD_DAC_GAIN:\n");
						PARAMETER_Write_s(base, CMD_DAC_GAIN - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						Set_Dac_Gain(rx->value);
						break;
					}
					case CMD_CUT_OFF: {
						DEBUG_PRINT("CMD_CUT_OFF:\n");
						PARAMETER_Write_s(base, CMD_CUT_OFF - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						IOWR(VARSET_BASE, CMD_CUT_OFF + cmd2hwreg, rx->value);
						break;
					}
					case CMD_SF_COMP_T1: {
						DEBUG_PRINT("CMD_SF_COMP_T1:\n");
						PARAMETER_Write_s(base, CMD_SF_COMP_T1 - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						// IOWR(VARSET_BASE, CMD_SF_COMP_T1 + cmd2hwreg, rx->value);
						break;
					}
					case CMD_SF_COMP_T2: {
						DEBUG_PRINT("CMD_SF_COMP_T2:\n");
						PARAMETER_Write_s(base, CMD_SF_COMP_T2 - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						// IOWR(VARSET_BASE, CMD_SF_COMP_T2 + cmd2hwreg, rx->value);
						break;
					}
					case CMD_SF_1_SLOPE: {
						DEBUG_PRINT("CMD_SF_1_SLOPE:\n");
						PARAMETER_Write_s(base, CMD_SF_1_SLOPE - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						// IOWR(VARSET_BASE, CMD_SF_1_SLOPE + cmd2hwreg, rx->value);
						break;
					}
					case CMD_SF_1_OFFSET: {
						DEBUG_PRINT("CMD_SF_1_OFFSET:\n");
						PARAMETER_Write_s(base, CMD_SF_1_OFFSET - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						// IOWR(VARSET_BASE, CMD_SF_1_OFFSET + cmd2hwreg, rx->value);
						break;
					}
					case CMD_SF_2_SLOPE: {
						DEBUG_PRINT("CMD_SF_2_SLOPE:\n");
						PARAMETER_Write_s(base, CMD_SF_2_SLOPE - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						// IOWR(VARSET_BASE, CMD_SF_2_SLOPE + cmd2hwreg, rx->value);
						break;
					}
					case CMD_SF_2_OFFSET: {
						DEBUG_PRINT("CMD_SF_2_OFFSET:\n");
						PARAMETER_Write_s(base, CMD_SF_2_OFFSET - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						// IOWR(VARSET_BASE, CMD_SF_2_OFFSET + cmd2hwreg, rx->value);
						break;
					}
					case CMD_SF_3_SLOPE: {
						DEBUG_PRINT("CMD_SF_3_SLOPE:\n");
						PARAMETER_Write_s(base, CMD_SF_3_SLOPE - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						// IOWR(VARSET_BASE, CMD_SF_3_SLOPE + cmd2hwreg, rx->value);
						break;
					}
					case CMD_SF_3_OFFSET: {
						DEBUG_PRINT("CMD_SF_3_OFFSET:\n");
						PARAMETER_Write_s(base, CMD_SF_3_OFFSET - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						// IOWR(VARSET_BASE, CMD_SF_3_OFFSET + cmd2hwreg, rx->value);
						break;
					}
					case CMD_BIAS_COMP_T1: {
						DEBUG_PRINT("CMD_BIAS_COMP_T1:\n");
						PARAMETER_Write_s(base, CMD_BIAS_COMP_T1 - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						// IOWR(VARSET_BASE, CMD_BIAS_COMP_T1 + cmd2hwreg, rx->value);
						break;
					}
					case CMD_BIAS_COMP_T2: {
						DEBUG_PRINT("CMD_BIAS_COMP_T2:\n");
						PARAMETER_Write_s(base, CMD_BIAS_COMP_T2 - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						// IOWR(VARSET_BASE, CMD_BIAS_COMP_T2 + cmd2hwreg, rx->value);
						break;
					}
					case CMD_BIAS_1_SLOPE: {
						DEBUG_PRINT("CMD_BIAS_1_SLOPE:\n");
						PARAMETER_Write_s(base, CMD_BIAS_1_SLOPE - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						// IOWR(VARSET_BASE, CMD_BIAS_1_SLOPE + cmd2hwreg, rx->value);
						break;
					}
					case CMD_BIAS_1_OFFSET: {
						DEBUG_PRINT("CMD_BIAS_1_OFFSET:\n");
						PARAMETER_Write_s(base, CMD_BIAS_1_OFFSET - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						// IOWR(VARSET_BASE, CMD_BIAS_1_OFFSET + cmd2hwreg, rx->value);
						break;
					}
					case CMD_BIAS_2_SLOPE: {
						DEBUG_PRINT("CMD_BIAS_2_SLOPE:\n");
						PARAMETER_Write_s(base, CMD_BIAS_2_SLOPE - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						// IOWR(VARSET_BASE, CMD_BIAS_2_SLOPE + cmd2hwreg, rx->value);
						break;
					}
					case CMD_BIAS_2_OFFSET: {
						DEBUG_PRINT("CMD_BIAS_2_OFFSET:\n");
						PARAMETER_Write_s(base, CMD_BIAS_2_OFFSET - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						// IOWR(VARSET_BASE, CMD_BIAS_2_OFFSET + cmd2hwreg, rx->value);
						break;
					}
					case CMD_BIAS_3_SLOPE: {
						DEBUG_PRINT("CMD_BIAS_3_SLOPE:\n");
						PARAMETER_Write_s(base, CMD_BIAS_3_SLOPE - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						// IOWR(VARSET_BASE, CMD_BIAS_3_SLOPE + cmd2hwreg, rx->value);
						break;
					}
					case CMD_BIAS_3_OFFSET: {
						DEBUG_PRINT("CMD_BIAS_3_OFFSET:\n");
						PARAMETER_Write_s(base, CMD_BIAS_3_OFFSET - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						// IOWR(VARSET_BASE, CMD_BIAS_3_OFFSET + cmd2hwreg, rx->value);
						break;
					}
					case CMD_SF_SLOPE_XLM: {
						DEBUG_PRINT("CMD_SF_SLOPE_XLM:\n");
						PARAMETER_Write_s(base, CMD_SF_SLOPE_XLM - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						break;
					}
					case CMD_SF_OFFSET_XLM: {
						DEBUG_PRINT("CMD_SF_OFFSET_XLM:\n");
						PARAMETER_Write_s(base, CMD_SF_OFFSET_XLM - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						break;
					}
					case CMD_BIAS_SLOPE_XLM: {
						DEBUG_PRINT("CMD_BIAS_SLOPE_XLM:\n");
						PARAMETER_Write_s(base, CMD_BIAS_SLOPE_XLM - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						break;
					}
					case CMD_BIAS_OFFSET_XLM: {
						DEBUG_PRINT("CMD_BIAS_OFFSET_XLM:\n");
						PARAMETER_Write_s(base, CMD_BIAS_OFFSET_XLM - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						break;
					}
					/***------------- mis-alignment command, accl */
					case CMD_MIS_AX: {
						DEBUG_PRINT("CMD_MIS_AX:\n");
						if(rx->ch != 4) {DEBUG_PRINT("Ch value must be 4:\n"); break;}
						PARAMETER_Write_s(base, CMD_MIS_AX - MIS_CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						break;
					}
					case CMD_MIS_AY: {
						DEBUG_PRINT("CMD_MIS_AY:\n");
						if(rx->ch != 4) {DEBUG_PRINT("Ch value must be 4:\n"); break;}
						PARAMETER_Write_s(base, CMD_MIS_AY - MIS_CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						break;
					}
					case CMD_MIS_AZ: {
						DEBUG_PRINT("CMD_MIS_AZ:\n");
						if(rx->ch != 4) {DEBUG_PRINT("Ch value must be 4:\n"); break;}
						PARAMETER_Write_s(base, CMD_MIS_AZ - MIS_CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						break;
					}
					case CMD_MIS_A11: {
						DEBUG_PRINT("CMD_MIS_A11:\n");
						if(rx->ch != 4) {DEBUG_PRINT("Ch value must be 4:\n"); break;}
						PARAMETER_Write_s(base, CMD_MIS_A11 - MIS_CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						break;
					}
					case CMD_MIS_A12: {
						DEBUG_PRINT("CMD_MIS_A12:\n");
						if(rx->ch != 4) {DEBUG_PRINT("Ch value must be 4:\n"); break;}
						PARAMETER_Write_s(base, CMD_MIS_A12 - MIS_CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						break;
					}
					case CMD_MIS_A13: {
						DEBUG_PRINT("CMD_MIS_A13:\n");
						if(rx->ch != 4) {DEBUG_PRINT("Ch value must be 4:\n"); break;}
						PARAMETER_Write_s(base, CMD_MIS_A13 - MIS_CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						break;
					}
					case CMD_MIS_A21: {
						DEBUG_PRINT("CMD_MIS_A21:\n");
						if(rx->ch != 4) {DEBUG_PRINT("Ch value must be 4:\n"); break;}
						PARAMETER_Write_s(base, CMD_MIS_A21 - MIS_CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						break;
					}
					case CMD_MIS_A22: {
						DEBUG_PRINT("CMD_MIS_A22:\n");
						if(rx->ch != 4) {DEBUG_PRINT("Ch value must be 4:\n"); break;}
						PARAMETER_Write_s(base, CMD_MIS_A22 - MIS_CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						break;
					}
					case CMD_MIS_A23: {
						DEBUG_PRINT("CMD_MIS_A23:\n");
						if(rx->ch != 4) {DEBUG_PRINT("Ch value must be 4:\n"); break;}
						PARAMETER_Write_s(base, CMD_MIS_A23 - MIS_CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						break;
					}
					case CMD_MIS_A31: {
						DEBUG_PRINT("CMD_MIS_A31:\n");
						if(rx->ch != 4) {DEBUG_PRINT("Ch value must be 4:\n"); break;}
						PARAMETER_Write_s(base, CMD_MIS_A31 - MIS_CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						break;
					}
					case CMD_MIS_A32: {
						DEBUG_PRINT("CMD_MIS_A32:\n");
						if(rx->ch != 4) {DEBUG_PRINT("Ch value must be 4:\n"); break;}
						PARAMETER_Write_s(base, CMD_MIS_A32 - MIS_CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						break;
					}
					case CMD_MIS_A33: {
						DEBUG_PRINT("CMD_MIS_A33:\n");
						if(rx->ch != 4) {DEBUG_PRINT("Ch value must be 4:\n"); break;}
						PARAMETER_Write_s(base, CMD_MIS_A33 - MIS_CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						break;
					}
					/***------------- mis-alignment command, gyro */
					case CMD_MIS_GX: {
						DEBUG_PRINT("CMD_MIS_GX:\n");
						if(rx->ch != 4) {DEBUG_PRINT("Ch value must be 4:\n"); break;}
						PARAMETER_Write_s(base, CMD_MIS_GX - MIS_CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						break;
					}
					case CMD_MIS_GY: {
						DEBUG_PRINT("CMD_MIS_GY:\n");
						if(rx->ch != 4) {DEBUG_PRINT("Ch value must be 4:\n"); break;}
						PARAMETER_Write_s(base, CMD_MIS_GY - MIS_CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						break;
					}
					case CMD_MIS_GZ: {
						DEBUG_PRINT("CMD_MIS_GZ:\n");
						if(rx->ch != 4) {DEBUG_PRINT("Ch value must be 4:\n"); break;}
						PARAMETER_Write_s(base, CMD_MIS_GZ - MIS_CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						break;
					}
					case CMD_MIS_G11: {
						DEBUG_PRINT("CMD_MIS_G11:\n");
						if(rx->ch != 4) {DEBUG_PRINT("Ch value must be 4:\n"); break;}
						PARAMETER_Write_s(base, CMD_MIS_G11 - MIS_CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						break;
					}
					case CMD_MIS_G12: {
						DEBUG_PRINT("CMD_MIS_G12:\n");
						if(rx->ch != 4) {DEBUG_PRINT("Ch value must be 4:\n"); break;}
						PARAMETER_Write_s(base, CMD_MIS_G12 - MIS_CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						break;
					}
					case CMD_MIS_G13: {
						DEBUG_PRINT("CMD_MIS_G13:\n");
						if(rx->ch != 4) {DEBUG_PRINT("Ch value must be 4:\n"); break;}
						PARAMETER_Write_s(base, CMD_MIS_G13 - MIS_CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						break;
					}
					case CMD_MIS_G21: {
						DEBUG_PRINT("CMD_MIS_G21:\n");
						if(rx->ch != 4) {DEBUG_PRINT("Ch value must be 4:\n"); break;}
						PARAMETER_Write_s(base, CMD_MIS_G21 - MIS_CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						break;
					}
					case CMD_MIS_G22: {
						DEBUG_PRINT("CMD_MIS_G22:\n");
						if(rx->ch != 4) {DEBUG_PRINT("Ch value must be 4:\n"); break;}
						PARAMETER_Write_s(base, CMD_MIS_G22 - MIS_CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						break;
					}
					case CMD_MIS_G23: {
						DEBUG_PRINT("CMD_MIS_G23:\n");
						if(rx->ch != 4) {DEBUG_PRINT("Ch value must be 4:\n"); break;}
						PARAMETER_Write_s(base, CMD_MIS_G23 - MIS_CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						break;
					}
					case CMD_MIS_G31: {
						DEBUG_PRINT("CMD_MIS_G31:\n");
						if(rx->ch != 4) {DEBUG_PRINT("Ch value must be 4:\n"); break;}
						PARAMETER_Write_s(base, CMD_MIS_G31 - MIS_CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						break;
					}
					case CMD_MIS_G32: {
						DEBUG_PRINT("CMD_MIS_G32:\n");
						if(rx->ch != 4) {DEBUG_PRINT("Ch value must be 4:\n"); break;}
						PARAMETER_Write_s(base, CMD_MIS_G32 - MIS_CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						break;
					}
					case CMD_MIS_G33: {
						DEBUG_PRINT("CMD_MIS_G33:\n");
						if(rx->ch != 4) {DEBUG_PRINT("Ch value must be 4:\n"); break;}
						PARAMETER_Write_s(base, CMD_MIS_G33 - MIS_CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
						break;
					}
					case CMD_DUMP_FOG: {
						DEBUG_PRINT("CMD_DUMP_FOG:\n");
						dump_fog_param(fog_inst, rx->ch);
						break;
					} 
					case CMD_DUMP_MIS: {
						DEBUG_PRINT("CMD_DUMP_MIS:\n");
						dump_misalignment_param(fog_inst);
						break;
					} 
					case CMD_DUMP_SN: {
						DEBUG_PRINT("CMD_DUMP_SN:\n");
						dump_SN(fog_inst);
						break;
					} 
					case CMD_DATA_OUT_START: { // not use now
						DEBUG_PRINT("CMD_DATA_OUT_START:\n");
						// start_flag = rx->value;
						break;
					}
					case CMD_SYNC_CNT: {
						DEBUG_PRINT("CMD_SYNC_CNT:\n");
						IOWR(VARSET_BASE, var_sync_count, rx->value);
						break;
					} 
					case CMD_HW_TIMER_RST: {
						DEBUG_PRINT("CMD_HW_TIMER_RST:\n");
						IOWR(VARSET_BASE, var_timer_rst, rx->value);
						break;
					}
					default:{
						DEBUG_PRINT("condition 1 default case\n");
					} 
				}
		
			}
			else if(rx->condition == 2) {
				switch(rx->cmd ){
					case CMD_WRITE_SN: {
						DEBUG_PRINT("CMD_WRITE_SN:\n");
						alt_32 SN1, SN2, SN3;
						SN1 =  rx->SN[0]<<24 | rx->SN[1]<<16 | rx->SN[2]<<8 | rx->SN[3];
						SN2 =  rx->SN[4]<<24 | rx->SN[5]<<16 | rx->SN[6]<<8 | rx->SN[7];
						SN3 =  rx->SN[8]<<24 | rx->SN[9]<<16 | rx->SN[10]<<8 | rx->SN[11];
						PARAMETER_Write_f(MEM_BASE_SN, 0, SN1);
						PARAMETER_Write_f(MEM_BASE_SN, 1, SN2);
						PARAMETER_Write_f(MEM_BASE_SN, 2, SN3);
						for (alt_u8 i = 0; i < 13; i++) {
							fog_inst->sn[i] = rx->SN[i];
						}
						break;
					}
					default:{
						DEBUG_PRINT("condition 2 default case\n");
					} 
				}
			}
			
		}

}
  

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
		DEBUG_PRINT("DAC GAIN: %d\n", fog_params->paramZ[11].data.int_val);
		Set_Dac_Gain(fog_params->paramZ[11].data.int_val);
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
		INFO_PRINT("is_valid = %d\n", is_valid);
		DEBUG_PRINT("DAC GAIN: %d\n", fog_params->paramX[11].data.int_val);
		Set_Dac_Gain(fog_params->paramX[11].data.int_val);
		INFO_PRINT("Done.\n ");
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
		INFO_PRINT("is_valid = %d\n", is_valid);
		DEBUG_PRINT("DAC GAIN: %d\n", fog_params->paramY[11].data.int_val);
		Set_Dac_Gain(fog_params->paramY[11].data.int_val);
		INFO_PRINT("Done.\n ");
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
    
    for (int i = 0; i < PAR_LEN; i++) {
		offset += snprintf(buffer + offset, sizeof(buffer) - offset, "\"%d\":%ld", i, param[i].data.int_val);
        if (i < PAR_LEN - 1) offset += snprintf(buffer + offset, sizeof(buffer) - offset, ", "); // Add comma if not the last element
    }
    
    snprintf(buffer + offset, sizeof(buffer) - offset, "}\n"); // Close JSON structure
    DEBUG_PRINT("%s", buffer); // Print the formatted JSON string
	// uart_printf("%s", buffer);
	send_json_uart(buffer); // Send the JSON data via UART
}

void dump_misalignment_param(fog_parameter_t* fog_inst) {
    if (!fog_inst) return; // Ensure the pointer is valid and ch is within range
    
	mem_unit_t* param;
	param = fog_inst->misalignment;
    
    char buffer[1024]; // Assume maximum output length
    int offset = 0;
    offset += snprintf(buffer + offset, sizeof(buffer) - offset, "{");
    
    for (int i = 0; i < MIS_LEN; i++) {
		offset += snprintf(buffer + offset, sizeof(buffer) - offset, "\"%d\":%ld", i, param[i].data.int_val);
        if (i < MIS_LEN - 1) offset += snprintf(buffer + offset, sizeof(buffer) - offset, ", "); // Add comma if not the last element
    }
    
    snprintf(buffer + offset, sizeof(buffer) - offset, "}\n"); // Close JSON structure
    DEBUG_PRINT("%s", buffer); // Print the formatted JSON string
	send_json_uart(buffer); // Send the JSON data via UART
}

void dump_SN(fog_parameter_t* fog_inst) {
	SerialWrite(&fog_inst->sn[0], 4);
	SerialWrite(&fog_inst->sn[4], 4);
	SerialWrite(&fog_inst->sn[8], 4);
	// for(alt_u8 i=0; i<12; i++) {
	// 	SerialWrite(&fog_inst->sn[i], 1);
	// }
}

void send_json_uart(const char* buffer) {
    while (*buffer) {
        checkByte((alt_u8)*buffer);
        buffer++;
    }
}


float SF_temp_compensation_1st_order_fog(my_sensor_t sensor, fog_parameter_t para, CH_t ch) {
    float temp;
    float slope;
    float offset;
    float compensated_value;

    // Select the corresponding temperature, slope, and offset based on the axis (ch)
    switch (ch) {
        case X_AXIS: // X-axis
            // Check if the parameter type is correct
            if (para.paramX[17].type != TYPE_FLOAT || para.paramX[18].type != TYPE_FLOAT) {
                DEBUG_PRINT("Error: Incorrect parameter type for X-axis compensation\n");
                return 0.0f; // Return a default value or handle the error appropriately
            }
            temp = sensor.temp.tempx.float_val;
            slope = para.paramX[17].data.float_val;
            offset = para.paramX[18].data.float_val;
            break;
        case Y_AXIS: // Y-axis
            // Check if the parameter type is correct
            if (para.paramY[17].type != TYPE_FLOAT || para.paramY[18].type != TYPE_FLOAT) {
                DEBUG_PRINT("Error: Incorrect parameter type for Y-axis compensation\n");
                return 0.0f; // Return a default value or handle the error appropriately
            }
            temp = sensor.temp.tempy.float_val;
            slope = para.paramY[17].data.float_val;
            offset = para.paramY[18].data.float_val;
            break;
        case Z_AXIS: // Z-axis
            // Check if the parameter type is correct
            if (para.paramZ[17].type != TYPE_FLOAT || para.paramZ[18].type != TYPE_FLOAT) {
                DEBUG_PRINT("Error: Incorrect parameter type for Z-axis compensation\n");
                return 0.0f; // Return a default value or handle the error appropriately
            }
            temp = sensor.temp.tempz.float_val;
            slope = para.paramZ[17].data.float_val;
            offset = para.paramZ[18].data.float_val;
            break;
        default:
            // Invalid axis selection, return 0 or other default value
            DEBUG_PRINT("Error: Invalid axis selection in SF_temp_compensation_1st_order\n");
            return 0.0f;
    }

    // Perform first-order temperature compensation calculation
    compensated_value = temp * slope + offset;

    return compensated_value;
}


float SF_temp_compensation_1st_order_adxl357(my_sensor_t sensor, fog_parameter_t para, CH_t ch) {
    float temp;
    float slope;
    float offset;
    float compensated_value;

    // Select the corresponding temperature, slope, and offset based on the axis (ch)
    switch (ch) {
        case X_AXIS: // X-axis
            // Check if the parameter type is correct
            if (para.paramX[31].type != TYPE_FLOAT || para.paramX[32].type != TYPE_FLOAT) {
                DEBUG_PRINT("Error: Incorrect parameter type for X-axis compensation\n");
                return 0.0f; // Return a default value or handle the error appropriately
            }
            temp = sensor.adxl357.temp.float_val;
            slope = para.paramX[31].data.float_val;
            offset = para.paramX[32].data.float_val;
            break;
        case Y_AXIS: // Y-axis
            // Check if the parameter type is correct
            if (para.paramY[31].type != TYPE_FLOAT || para.paramY[32].type != TYPE_FLOAT) {
                DEBUG_PRINT("Error: Incorrect parameter type for Y-axis compensation\n");
                return 0.0f; // Return a default value or handle the error appropriately
            }
            temp = sensor.adxl357.temp.float_val;
            slope = para.paramY[31].data.float_val;
            offset = para.paramY[32].data.float_val;
            break;
        case Z_AXIS: // Z-axis
            // Check if the parameter type is correct
            if (para.paramZ[31].type != TYPE_FLOAT || para.paramZ[32].type != TYPE_FLOAT) {
                DEBUG_PRINT("Error: Incorrect parameter type for Z-axis compensation\n");
                return 0.0f; // Return a default value or handle the error appropriately
            }
            temp = sensor.adxl357.temp.float_val;
            slope = para.paramZ[31].data.float_val;
            offset = para.paramZ[32].data.float_val;
            break;
        default:
            // Invalid axis selection, return 0 or other default value
            DEBUG_PRINT("Error: Invalid axis selection in SF_temp_compensation_1st_order\n");
            return 0.0f;
    }

    // Perform first-order temperature compensation calculation
    compensated_value = temp * slope + offset;

    return compensated_value;
}


float BIAS_temp_compensation_1st_order_fog_3T(my_sensor_t sensor, fog_parameter_t para, CH_t ch) {
    float temp;
    float T1, T2;
    float slope1, offset1, slope2, offset2, slope3, offset3;
    float compensated_value;

    // Select the corresponding parameters based on the axis (ch)
    switch (ch) {
        case X_AXIS: // X-axis
            // Check if the parameter type is correct
            if (para.paramX[23].type != TYPE_FLOAT || para.paramX[24].type != TYPE_FLOAT ||
                para.paramX[25].type != TYPE_FLOAT || para.paramX[26].type != TYPE_FLOAT ||
                para.paramX[27].type != TYPE_FLOAT || para.paramX[28].type != TYPE_FLOAT ||
                para.paramX[29].type != TYPE_FLOAT || para.paramX[30].type != TYPE_FLOAT) {
                DEBUG_PRINT("Error: Incorrect parameter type for X-axis bias compensation\n");
                return 0.0f; // Return a default value or handle the error appropriately
            }
            temp = sensor.temp.tempx.float_val;
            T1 = para.paramX[23].data.float_val;
            T2 = para.paramX[24].data.float_val;
            slope1 = para.paramX[25].data.float_val;
            offset1 = para.paramX[26].data.float_val;
            slope2 = para.paramX[27].data.float_val;
            offset2 = para.paramX[28].data.float_val;
            slope3 = para.paramX[29].data.float_val;
            offset3 = para.paramX[30].data.float_val;
            break;
        case Y_AXIS: // Y-axis
            // Check if the parameter type is correct
            if (para.paramY[23].type != TYPE_FLOAT || para.paramY[24].type != TYPE_FLOAT ||
                para.paramY[25].type != TYPE_FLOAT || para.paramY[26].type != TYPE_FLOAT ||
                para.paramY[27].type != TYPE_FLOAT || para.paramY[28].type != TYPE_FLOAT ||
                para.paramY[29].type != TYPE_FLOAT || para.paramY[30].type != TYPE_FLOAT) {
                DEBUG_PRINT("Error: Incorrect parameter type for Y-axis bias compensation\n");
                return 0.0f; // Return a default value or handle the error appropriately
            }
            temp = sensor.temp.tempy.float_val;
            T1 = para.paramY[23].data.float_val;
            T2 = para.paramY[24].data.float_val;
            slope1 = para.paramY[25].data.float_val;
            offset1 = para.paramY[26].data.float_val;
            slope2 = para.paramY[27].data.float_val;
            offset2 = para.paramY[28].data.float_val;
            slope3 = para.paramY[29].data.float_val;
            offset3 = para.paramY[30].data.float_val;
            break;
        case Z_AXIS: // Z-axis
            // Check if the parameter type is correct
            if (para.paramZ[23].type != TYPE_FLOAT || para.paramZ[24].type != TYPE_FLOAT ||
                para.paramZ[25].type != TYPE_FLOAT || para.paramZ[26].type != TYPE_FLOAT ||
                para.paramZ[27].type != TYPE_FLOAT || para.paramZ[28].type != TYPE_FLOAT ||
                para.paramZ[29].type != TYPE_FLOAT || para.paramZ[30].type != TYPE_FLOAT) {
                DEBUG_PRINT("Error: Incorrect parameter type for Z-axis bias compensation\n");
                return 0.0f; // Return a default value or handle the error appropriately
            }
            temp = sensor.temp.tempz.float_val;
            T1 = para.paramZ[23].data.float_val;
            T2 = para.paramZ[24].data.float_val;
            slope1 = para.paramZ[25].data.float_val;
            offset1 = para.paramZ[26].data.float_val;
            slope2 = para.paramZ[27].data.float_val;
            offset2 = para.paramZ[28].data.float_val;
            slope3 = para.paramZ[29].data.float_val;
            offset3 = para.paramZ[30].data.float_val;
            break;
        default:
            // Invalid axis selection, return 0 or other default value
            DEBUG_PRINT("Error: Invalid axis selection in BIAS_temp_compensation_1st_order_3T\n");
            return 0.0f;
    }

    // Perform temperature zone selection and compensation calculation
    if (temp < T1) {
        compensated_value = temp * slope1 + offset1;
    } else if (temp >= T1 && temp < T2) {
        compensated_value = temp * slope2 + offset2;
    } else { // temp >= T2
        compensated_value = temp * slope3 + offset3;
    }

    return compensated_value;
}

float BIAS_temp_compensation_1st_order_adxl357(my_sensor_t sensor, fog_parameter_t para, CH_t ch) {
    float temp;
    float slope;
    float offset;
    float compensated_value;

    // Select the corresponding temperature, slope, and offset based on the axis (ch)
    switch (ch) {
        case X_AXIS: // X-axis
            // Check if the parameter type is correct
            if (para.paramX[33].type != TYPE_FLOAT || para.paramX[34].type != TYPE_FLOAT) {
                DEBUG_PRINT("Error: Incorrect parameter type for X-axis compensation\n");
                return 0.0f; // Return a default value or handle the error appropriately
            }
            temp = sensor.adxl357.temp.float_val;
            slope = para.paramX[33].data.float_val;
            offset = para.paramX[34].data.float_val;
            break;
        case Y_AXIS: // Y-axis
            // Check if the parameter type is correct
            if (para.paramY[33].type != TYPE_FLOAT || para.paramY[34].type != TYPE_FLOAT) {
                DEBUG_PRINT("Error: Incorrect parameter type for Y-axis compensation\n");
                return 0.0f; // Return a default value or handle the error appropriately
            }
            temp = sensor.adxl357.temp.float_val;
            slope = para.paramY[33].data.float_val;
            offset = para.paramY[34].data.float_val;
            break;
        case Z_AXIS: // Z-axis
            // Check if the parameter type is correct
            if (para.paramZ[33].type != TYPE_FLOAT || para.paramZ[34].type != TYPE_FLOAT) {
                DEBUG_PRINT("Error: Incorrect parameter type for Z-axis compensation\n");
                return 0.0f; // Return a default value or handle the error appropriately
            }
            temp = sensor.adxl357.temp.float_val;
            slope = para.paramZ[33].data.float_val;
            offset = para.paramZ[34].data.float_val;
            break;
        default:
            // Invalid axis selection, return 0 or other default value
            DEBUG_PRINT("Error: Invalid axis selection in SF_temp_compensation_1st_order\n");
            return 0.0f;
    }

    // Perform first-order temperature compensation calculation
    compensated_value = temp * slope + offset;

    return compensated_value;
}

calibrated_data_t misalignment_calibration(float din_x, float din_y, float din_z, fog_parameter_t para, CH_t ch) {
    calibrated_data_t result;
    float cx, cy, cz;
    float c11, c12, c13, c21, c22, c23, c31, c32, c33;

    // Check if the parameter type is correct
    for (int i = 0; i < 24; i++) {
        if (para.misalignment[i].type != TYPE_FLOAT) {
            DEBUG_PRINT("Error: Incorrect parameter type for misalignment compensation\n");
            result.x.float_val = 0.0f;
            result.y.float_val = 0.0f;
            result.z.float_val = 0.0f;
            return result; // Return a default value or handle the error appropriately
        }
    }

    // Select the corresponding parameters based on the calibration type (ch)
    if (ch == MIS_CALI_GYRO) {
        cx = para.misalignment[12].data.float_val;
        cy = para.misalignment[13].data.float_val;
        cz = para.misalignment[14].data.float_val;
        c11 = para.misalignment[15].data.float_val;
        c12 = para.misalignment[16].data.float_val;
        c13 = para.misalignment[17].data.float_val;
        c21 = para.misalignment[18].data.float_val;
        c22 = para.misalignment[19].data.float_val;
        c23 = para.misalignment[20].data.float_val;
        c31 = para.misalignment[21].data.float_val;
        c32 = para.misalignment[22].data.float_val;
        c33 = para.misalignment[23].data.float_val;
    } else if (ch == MIS_CALI_ACCL) {
        cx = para.misalignment[0].data.float_val;
        cy = para.misalignment[1].data.float_val;
        cz = para.misalignment[2].data.float_val;
        c11 = para.misalignment[3].data.float_val;
        c12 = para.misalignment[4].data.float_val;
        c13 = para.misalignment[5].data.float_val;
        c21 = para.misalignment[6].data.float_val;
        c22 = para.misalignment[7].data.float_val;
        c23 = para.misalignment[8].data.float_val;
        c31 = para.misalignment[9].data.float_val;
        c32 = para.misalignment[10].data.float_val;
        c33 = para.misalignment[11].data.float_val;
    } else {
        // Invalid calibration type, return 0 or other default value
        DEBUG_PRINT("Error: Invalid calibration type in misalignment_calibration\n");
        result.x.float_val = 0.0f;
        result.y.float_val = 0.0f;
        result.z.float_val = 0.0f;
        return result;
    }

    // Perform misalignment calibration calculation
    result.x.float_val = c11 * din_x + c12 * din_y + c13 * din_z + cx;
    result.y.float_val = c21 * din_x + c22 * din_y + c23 * din_z + cy;
    result.z.float_val = c31 * din_x + c32 * din_y + c33 * din_z + cz;

    return result;
}

