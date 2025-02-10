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

void get_uart_cmd(alt_u8* data, uart_rx_t* rx)
{
    if(data){
        rx->complete = 1;
        rx->cmd = data[0];
        rx->value = data[1]<<24 | data[2]<<16 | data[3]<<8 | data[4];
        rx->ch = data[5];
        printf("\nuart_cmd, uart_value, ch: %u, %ld, %d\n", rx->cmd , rx->value, rx->ch);
    }
    else return;
}

void cmd_mux(uart_rx_t* rx)
{
	if(rx->complete == 1)
	{
        
		rx->complete = 0;
		if(rx->cmd >7) rx->mux = MUX_PARAMETER; 
		else rx->mux = MUX_OUTPUT;
        printf("cmd_mux: mux=%u, complete=%u\n", rx->mux, rx->complete);
	}
}

void output_mode_setting(uart_rx_t* rx)
{
	if(rx->mux == MUX_OUTPUT)
	{
		rx->mux = MUX_ESCAPE;

		switch(rx->cmd) {
			case MODE_RST: {
				output_fn = fn_rst;
				select_fn = SEL_RST;
       			rst_fn_flag = MODE_RST;
				break;
			}
			case MODE_FOG: {
				output_fn = acq_fog;
				select_fn = SEL_FOG_1;
        		rst_fn_flag = MODE_FOG;
				break;
			}

      default: break;
      }
	}

//   if(fog_op_status==1) // for auto reset
//   {
    // fog_op_status=0;
    // Serial.println("AUTO RST select function");
	// 	switch(rst_fn_flag) {
	// 		case MODE_RST: {
	// 			output_fn = fn_rst;
	// 			break;
	// 		}
	// 		case MODE_FOG: {
	// 			output_fn = acq_fog;
    //     Serial.println("MODE_FOG");
	// 			break;
	// 		}
	// 		case MODE_IMU: {
	// 			output_fn = acq_imu; 
	// 			break;
	// 		}
	// 		case MODE_FOG_HP_TEST: {
	// 			output_fn = acq_HP_test; 
	// 			break;
	// 		}
	// 		case MODE_NMEA: {
	// 			output_fn = acq_nmea;
	// 			break;
    //         }
    //   case MODE_ATT_NMEA: {
	// 			output_fn = acq_att_nmea;
	// 			break;
    //         }
    //   case MODE_FOG_PARAMETER: {
    //       output_fn = acq_fog_parameter;
    //       break;
    //   }
    //   default: break;
    //   }
    //   eeprom.Parameter_Write(EEPROM_ADDR_SELECT_FN, select_fn);
    //   eeprom.Parameter_Write(EEPROM_ADDR_OUTPUT_FN, rst_fn_flag);
    //   eeprom.Parameter_Write(EEPROM_ADDR_REG_VALUE, uart_value);
	// }
}


// void fog_parameter(alt_u8 *data, fog_parameter_t* fog_inst)
void fog_parameter(uart_rx_t* rx, fog_parameter_t* fog_inst)
{

	if(rx->mux == MUX_PARAMETER){
        printf("fog_parameter\n");
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
					printf("CMD_MOD_FREQ:\n");					
					PARAMETER_Write_s(base, CMD_MOD_FREQ - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
					IOWR(VARSET_BASE, CMD_MOD_FREQ + cmd2hwreg, rx->value);
					break;
				}
				case CMD_MOD_AMP_H: {
					printf("CMD_MOD_AMP_H:\n");					
					PARAMETER_Write_s(base, CMD_MOD_AMP_H - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
					IOWR(VARSET_BASE, CMD_MOD_AMP_H + cmd2hwreg, rx->value);
					break;
				}
				case CMD_MOD_AMP_L: {
					printf("CMD_MOD_AMP_L:\n");					
					PARAMETER_Write_s(base, CMD_MOD_AMP_L - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
					IOWR(VARSET_BASE, CMD_MOD_AMP_L + cmd2hwreg, rx->value);
					break;
				}
				case CMD_POLARITY: {
					printf("CMD_POLARITY:\n");					
					PARAMETER_Write_s(base, CMD_POLARITY - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
					IOWR(VARSET_BASE, CMD_POLARITY + cmd2hwreg, rx->value);
					break;
				}
				case CMD_WAIT_CNT: {
					printf("CMD_WAIT_CNT:\n");
					PARAMETER_Write_s(base, CMD_WAIT_CNT - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
					IOWR(VARSET_BASE, CMD_WAIT_CNT + cmd2hwreg, rx->value);
					break;
				} 
				case CMD_ERR_AVG: {
					printf("CMD_ERR_AVG:\n");
					PARAMETER_Write_s(base, CMD_ERR_AVG - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
					IOWR(VARSET_BASE, CMD_ERR_AVG + cmd2hwreg, rx->value);
					break;
				} 
				case CMD_GAIN1: {
					printf("CMD_GAIN1:\n");
					PARAMETER_Write_s(base, CMD_GAIN1 - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
					IOWR(VARSET_BASE, CMD_GAIN1 + cmd2hwreg, rx->value);
					break;
				} 
				case CMD_CONST_STEP: {
					printf("CMD_CONST_STEP:\n");
					PARAMETER_Write_s(base, CMD_CONST_STEP - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
					IOWR(VARSET_BASE, CMD_CONST_STEP + cmd2hwreg, rx->value);
					break;
				} 
				case CMD_FB_ON: {
					printf("CMD_FB_ON:\n");
					PARAMETER_Write_s(base, CMD_FB_ON - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
					IOWR(VARSET_BASE, CMD_FB_ON + cmd2hwreg, rx->value);
					break;
				} 
				case CMD_GAIN2: {
					printf("CMD_GAIN2:\n");
					PARAMETER_Write_s(base, CMD_GAIN2 - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
					IOWR(VARSET_BASE, CMD_GAIN2 + cmd2hwreg, rx->value);
					break;
				} 
				case CMD_ERR_OFFSET: {
					printf("CMD_ERR_OFFSET:\n");
					PARAMETER_Write_s(base, CMD_ERR_OFFSET - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
					IOWR(VARSET_BASE, CMD_ERR_OFFSET + cmd2hwreg, rx->value);
					break;
				} 

				case CMD_CUT_OFF: {
					printf("CMD_CUT_OFF:\n");
					PARAMETER_Write_s(base, CMD_CUT_OFF - CONTAINER_TO_CMD_OFFSET, rx->value, fog_inst);
					IOWR(VARSET_BASE, CMD_CUT_OFF + cmd2hwreg, rx->value);
					break;
				}
				case CMD_DUMP_FOG: {
					printf("CMD_DUMP_FOG:\n");
					dump_fog_param(fog_inst, rx->ch);
					break;
				} 
				case CMD_DATA_OUT_START: {
					printf("CMD_DATA_OUT_START:\n");
					// start_flag = rx->value;
					break;
				}
				case CMD_SYNC_CNT: {
					printf("CMD_SYNC_CNT:\n");
					IOWR(VARSET_BASE, var_sync_count, rx->value);
					break;
				} 
				case CMD_HW_TIMER_RST: {
					printf("CMD_HW_TIMER_RST:\n");
					IOWR(VARSET_BASE, var_timer_rst, rx->value);
					break;
				}

				default:{
					printf("default case\n");
				}
			}
	}

}
  