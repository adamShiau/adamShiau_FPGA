#ifndef __EEPROM_24AA32A_H
#define __EEPROM_24AA32A_H

#include "myiic.h"
#include "alt_types.h"

#define DEV_ADDR 	0xAE
#define DEV_W		0
#define DEV_R		1
#define ACK			1
#define NACK		0

void eeprom_ByteWrite(alt_u16, alt_u8);
alt_u8 eeprom_CurrentAddrRead(void);
alt_u8 eeprom_RandomRead(alt_u16);

#endif