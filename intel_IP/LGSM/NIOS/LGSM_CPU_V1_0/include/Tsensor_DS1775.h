#ifndef __TSENSOR_DS1775_H
#define __TSENSOR_DS1775_H

#include "myiic.h"
#include "alt_types.h"

#define DEV_ADDR 	0x90
#define DEV_W		0
#define DEV_R		1
#define ACK			1
#define NACK		0

// T sensor pointer
#define TSENSOR_TEMP 0x00
#define TSENSOR_CONF 0x01

void ds1775_setCurPtr(alt_u8);
void ds1775_setConfiguration(alt_u8);

alt_u8 ds1775_readConf(void);
alt_16 ds1775_9B_readTemp_d(void);
float ds1775_9B_readTemp_f(void);

#endif