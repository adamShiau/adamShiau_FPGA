#include "common.h"

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
        rx->cmd = data[0];
        rx->value = data[1]<<24 | data[2]<<16 | data[3]<<8 | data[4];
        rx->ch = data[5];
        // DEBUG_PRINT("\nuart_cmd, uart_value, ch: %u, %ld, %d\n", rx->cmd , rx->value, rx->ch);
		DEBUG_PRINT("\nuart_cmd, uart_value, ch: %u, %ld, %d\n", rx->cmd , rx->value, rx->ch);
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
				case CMD_DUMP_FOG: {
					DEBUG_PRINT("CMD_DUMP_FOG:\n");
					dump_fog_param(fog_inst, rx->ch);
					break;
				} 
				case CMD_DATA_OUT_START: {
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
					DEBUG_PRINT("default case\n");
				}
			}
	}

}
  
