#ifndef __MYIIC_H
#define __MYIIC_H
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "alt_types.h"
#include "unistd.h"
#include "delay.h"

//IO direction setting
#define SDA_IN()  IOWR_ALTERA_AVALON_PIO_DIRECTION(I2C_SDA_BASE,0x0)
#define SDA_OUT() IOWR_ALTERA_AVALON_PIO_DIRECTION(I2C_SDA_BASE,0x1) 

//IO operation function
#define IIC_SCL(x)  IOWR_ALTERA_AVALON_PIO_DATA(I2C_SCL_BASE,x)  //SCL
#define IIC_SDA(x)  IOWR_ALTERA_AVALON_PIO_DATA(I2C_SDA_BASE,x)  //SDA W
#define READ_SDA    IORD_ALTERA_AVALON_PIO_DATA(I2C_SDA_BASE)    //SDA R

#define DLY 1

//IIC functions definition
void IIC_Init(void);                    //initialization IO ports
void IIC_Start(void);                   //master sends IIC Start
void IIC_Stop(void);                    //master sends IIC Stop
void IIC_Send_Byte(alt_u8);             //IIC send one byte
alt_u8   IIC_Read_Byte(unsigned char);  //IIC read one byte
alt_u8   IIC_Wait_Ack(void);                //wait slave ACK response
void IIC_Ack(void);                     //master sends ACK
void IIC_NAck(void);                    //master sends NACK

alt_u8 p;
#endif
