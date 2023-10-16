#include "Tsensor_DS1775.h"

void ds1775_setCurPtr(alt_u8 ptr)
{
	IIC_Start();
	IIC_Send_Byte(DEV_ADDR|DEV_W); 
	IIC_Wait_Ack();
	IIC_Send_Byte(ptr);
	IIC_Wait_Ack();
	IIC_Stop();
}

void ds1775_setConfiguration(alt_u8 value)
{
	IIC_Start();
	IIC_Send_Byte(DEV_ADDR|DEV_W); 
	IIC_Wait_Ack();
	IIC_Send_Byte(TSENSOR_CONF);
	IIC_Wait_Ack();
	IIC_Send_Byte(value);
	IIC_Wait_Ack();
	IIC_Stop();
}

alt_u8 ds1775_readConf()
{
	alt_u8 rd_data;
	
	IIC_Start();
	IIC_Send_Byte(DEV_ADDR|DEV_R);
	IIC_Wait_Ack();
	rd_data = IIC_Read_Byte(NACK);
	IIC_Stop();
	return rd_data;
}

alt_16 ds1775_9B_readTemp_d()
{
	alt_16 temp;
	alt_u8 rd_data_H, rd_data_L;
	
	IIC_Start();
	IIC_Send_Byte(DEV_ADDR|DEV_R); 
	IIC_Wait_Ack();
	rd_data_H = IIC_Read_Byte(ACK);
	rd_data_L = IIC_Read_Byte(NACK);
	IIC_Stop();
	
//	temp = rd_data_H<<1 |  rd_data_L>>7;
	temp = rd_data_H<<8 | rd_data_L;
//	if(rd_data_H>>7) return (temp-512);
	return temp;
}

float ds1775_9B_readTemp_f()
{
	float temp;
	alt_8 rd_data_H, rd_data_L;
	
	IIC_Start();
	IIC_Send_Byte(DEV_ADDR|DEV_R); //slace address 0x90@W, 0x91@R
	IIC_Wait_Ack();
	rd_data_H = IIC_Read_Byte(ACK);
	rd_data_L = IIC_Read_Byte(NACK);
	IIC_Stop();

	temp = (float)rd_data_H + (float)(rd_data_L>>7)*0.5;

	return temp;
}
