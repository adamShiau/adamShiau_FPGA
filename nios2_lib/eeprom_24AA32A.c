#include "eeprom_24AA32A.h"

void eeprom_ByteWrite(alt_u16 addr, alt_u8 data)
{
	alt_u8 rd_data;
	
	IIC_Start();
	IIC_Send_Byte(DEV_ADDR|DEV_W);
	IIC_Wait_Ack();
	IIC_Send_Byte(addr>>8);
	IIC_Wait_Ack();
	IIC_Send_Byte(addr);
	IIC_Wait_Ack();
	IIC_Send_Byte(data);
	IIC_Wait_Ack();
	IIC_Stop();
}

alt_u8 eeprom_RandomRead(alt_u16 addr)
{
	alt_u8 rd_data;
	
	IIC_Start();
	IIC_Send_Byte(DEV_ADDR|DEV_W);
	IIC_Wait_Ack();
	IIC_Send_Byte(addr>>8);
	IIC_Wait_Ack();
	IIC_Send_Byte(addr);
	IIC_Wait_Ack();
	IIC_Start();
	IIC_Send_Byte(DEV_ADDR|DEV_R);
	IIC_Wait_Ack();
	rd_data = IIC_Read_Byte(NACK);
//	printf("%x\n", rd_data);
	IIC_Stop();
	
	return rd_data;
}

alt_u8 eeprom_CurrentAddrRead()
{
	alt_u8 rd_data;
	
	IIC_Start();
	IIC_Send_Byte(DEV_ADDR|DEV_R);
	IIC_Wait_Ack();
	rd_data = IIC_Read_Byte(NACK);
	IIC_Stop();
	printf("%x\n", rd_data);
	return rd_data;
}
