#ifndef __ADDA_CONFIG_H
#define __ADDA_CONFIG_H

#include "alt_types.h"
#include "system.h"
#include "altera_avalon_spi_regs.h"

/*** version ***/
/***
 * date: 07-01-2025
 * project: IRIS_CPIU_V01
 * change:
 * Separate FPGA ADDA SPI configuration to ADC and DAC part
 * assign CS_DAC_1 = DAC_CFG_SS[0];
 * assign CS_DAC_2 = DAC_CFG_SS[1];
 * assign CS_ADC_1 = ADC_CFG_SS[0];
 * assign CS_ADC_2 = ADC_CFG_SS[1];
 *  */ 



/******** ADC config definition*********/
/***from datasheet p28, The first bit of the 16-bit input word is the R/W bit. 
 * The next seven bits are the address of the register (A6:A0). 
 * The final eight bits are the register data (D7:D0).  */

#define SEL_CS_ADC_1CH		1<<0
#define SEL_CS_ADC_2CH		1<<1
#define ADC_RESET			0x0080
#define ADC_FMT				0x0401
#define ADC_TEST			0x0455
#define ADC_FMT_R			0x8400
#define ADC_ALL_ZERO		0x0409
#define ADC_ALL_ONE			0x0419

/******** DAC config definition*********/
/***from data sheet 19, data interface = instruction cycle + data transfer cycle
 * 
# Instruction byte
# +-----+----+----+----+----+----+----+----+
# | MSB | B7 | B6 | B5 | B4 | B3 | B2 | B1 | B0 | LSB |
# +-----+----+----+----+----+----+----+----+
# | Bit | R/W| N1 | N0 | A4 | A3 | A2 | A1 | A0 |
# +-----+----+----+----+----+----+----+----+

Bit 7, R/W, determines whether a read or a write data transfer 
occurs after the instruction byte write.

Bits<6:5>, N1 and N0, determine the number of bytes to be 
transferred during the data transfer cycle.

Bits<4:0>, A4, A3, A2, A1, and A0, determine which register is
accessed during the data transfer of the communications cycle.

# +----+----+---------------------+
# | N1 | N0 | Description         |
# +----+----+---------------------+
# |  0 |  0 | Transfer one byte   |
# |  0 |  1 | Transfer two bytes  |
# |  1 |  0 | Transfer three bytes|
# |  1 |  1 | Transfer four bytes |
# +----+----+---------------------+

 */

#define SEL_CS_DAC_1CH		1<<0
#define SEL_CS_DAC_2CH		1<<1
#define DAC1_GAIN_LSB_ADDR	0x0B
#define DAC1_GAIN_MSB_ADDR	0x0C
#define DAC1_GAIN_MSB_W_NR  0x0C01
#define DAC1_GAIN_LSB_W_NR  0x0BF9
#define DAC1_GAIN_MSB_W_min 0x0C00
#define DAC1_GAIN_LSB_W_min 0x0B00
#define DAC1_GAIN_MSB_W_MAX 0x0C03
#define DAC1_GAIN_LSB_W_MAX 0x0BFF
#define DAC1_GAIN_LSB_R 	0x8B00
#define DAC1_GAIN_MSB_R 	0x8C00

#define DAC2_GAIN_LSB_ADDR	0x0F
#define DAC2_GAIN_MSB_ADDR	0x10
#define DAC2_GAIN_MSB_W_NR  0x1001
#define DAC2_GAIN_LSB_W_NR  0x0FF9
#define DAC2_GAIN_MSB_W_min 0x1000
#define DAC2_GAIN_LSB_W_min 0x0F00
#define DAC2_GAIN_MSB_W_MAX 0x1003
#define DAC2_GAIN_LSB_W_MAX 0x0FFF
#define DAC2_GAIN_LSB_R 	0x8F00
#define DAC2_GAIN_MSB_R 	0x9000

void init_ADDA(void);
void set_ADC_all_zero(void);
void set_ADC_all_one(void);


#endif /* __ADDA_CONFIG_H */