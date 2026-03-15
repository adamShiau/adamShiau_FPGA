/*** reversion 3-15-2026
 * 新增 ds1775_init, ds1775_set_resolution 方法
 */
#ifndef __TSENSOR_DS1775_H
#define __TSENSOR_DS1775_H

#include "myiic.h"
#include "alt_types.h"

#define DEV_ADDR 	0x90
#define DEV_W		0
#define DEV_R		1
#define ACK			1
#define NACK		0

// 在 Tsensor_DS1775.h 中新增
#define DS1775_RES_9BIT  0x00  // 0.5°C, 187.5ms 
#define DS1775_RES_10BIT 0x20  // 0.25°C, 375ms 
#define DS1775_RES_11BIT 0x40  // 0.125°C, 750ms 
#define DS1775_RES_12BIT 0x60  // 0.0625°C, 1.5s 

#define DS1775_RES_MASK  0x60  // R1, R0 位元遮罩

// T sensor pointer
#define TSENSOR_TEMP 0x00
#define TSENSOR_CONF 0x01

void ds1775_init(alt_u8 resolution);
void ds1775_set_resolution(alt_u8 resolution);
void ds1775_setCurPtr(alt_u8);
void ds1775_setConfiguration(alt_u8);

alt_u8 ds1775_readConf(void);
alt_16 ds1775_9B_readTemp_d(void);
float ds1775_9B_readTemp_f(void);

#endif