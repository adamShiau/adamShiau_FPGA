#include "Tsensor_DS1775.h"

/**
 * 初始化 DS1775
 * @param resolution: 使用上面定義的 DS1775_RES_xBIT
 */
void ds1775_init(alt_u8 resolution) {
    // 1. 基本設定：連續轉換模式 (SD=0), 比較器模式 (TM=0), 警報低位準有效 (POL=0)
    // 2. 同時寫入使用者指定的精度
    ds1775_setConfiguration(resolution); 
    
    // 3. 將指標移回溫度暫存器 (00h)，方便後續直接讀取溫度
    ds1775_setCurPtr(TSENSOR_TEMP); 
}

/**
 * 獨立設定精度的方法
 */
void ds1775_set_resolution(alt_u8 resolution) {
    alt_u8 current_conf;
    
    // 先讀取目前的組態
    ds1775_setCurPtr(TSENSOR_CONF);
    current_conf = ds1775_readConf();
    
    // 清除舊的精度位元並寫入新的
    current_conf &= ~DS1775_RES_MASK;
    current_conf |= (resolution & DS1775_RES_MASK);
    
    // 寫回組態暫存器 
    ds1775_setConfiguration(current_conf);
    
    // 習慣性切換回溫度指標
    ds1775_setCurPtr(TSENSOR_TEMP);
}

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
	
	temp = rd_data_H<<8 | rd_data_L;
	return temp;
}

float ds1775_9B_readTemp_f()
{
    alt_u8 rd_data_H, rd_data_L;
    alt_16 raw_temp;
    
    IIC_Start();
    IIC_Send_Byte(DEV_ADDR | DEV_R); // 傳送讀取位址 (0x91) 
    IIC_Wait_Ack();
    rd_data_H = IIC_Read_Byte(ACK);  // 讀取 MSB (整數部分) 
    rd_data_L = IIC_Read_Byte(NACK); // 讀取 LSB (小數部分) 
    IIC_Stop();

    // 1. 將兩個 8-bit 合併為 16-bit 帶符號整數 
    // MSB 在高 8 位元，LSB 在低 8 位元
    raw_temp = (alt_16)((rd_data_H << 8) | rd_data_L);

    // 2. 轉換為浮點數
    // 根據手冊 Table 1，資料是左對齊的。
    // 16-bit 數值除以 256.0 等同於將二進位小數點向左移動 8 位 
    return (float)raw_temp / 256.0f;
}
