#include "myiic.h"
#include <unistd.h>
/***
//initialize IIC
void IIC_Init(void)
{
    IIC_SCL(1);
    IIC_SDA(1);
}

//master sends IIC Start
void IIC_Start(void)
{
    SDA_OUT();   //sda set as Outout
    IIC_SDA(1);
    IIC_SCL(1);
    usleep(1);
    IIC_SDA(0);  //START: SCL=H, SDA=H->L
    usleep(1);
    IIC_SCL(0);  //clamp I2C line, ready to W/R
}

//master sends IIC Stop
void IIC_Stop(void)
{
    SDA_OUT();  //sda set as Outout
    IIC_SCL(0);
    IIC_SDA(0); //STOP: SCL=H, SDA=L->H
    usleep(1);
    IIC_SCL(1);
    usleep(1);
    IIC_SDA(1); 
    usleep(1);
}

//wait slave ACK response
//return: 1, ACK fail
//        0, ACK success
alt_u8 IIC_Wait_Ack(void)
{
    alt_u8 ucErrTime=0;
    SDA_IN();      //sda set as Input
    IIC_SDA(1);		//now SDA is HighZ, is it necessary to set SDA to H ?
    usleep(1);
    IIC_SCL(1);
    usleep(1);
    while(READ_SDA) { 
        ucErrTime++;
        if(ucErrTime>250) {
            IIC_Stop();
            return 1;
        }
    }
    IIC_SCL(0);
    return 0;
}

//master sends ACK
void IIC_Ack(void)
{
    IIC_SCL(0);
    SDA_OUT(); //sda set as Outout
    IIC_SDA(0);
    usleep(1);
    IIC_SCL(1);
    usleep(1);
    IIC_SCL(0);
}

//master sends NACK
void IIC_NAck(void)
{
    IIC_SCL(0);
    SDA_OUT(); //sda set as Outout
    IIC_SDA(1);
    usleep(1);
    IIC_SCL(1);
    usleep(1);
    IIC_SCL(0);
}

//IIC sends one byte
void IIC_Send_Byte(alt_u8 txd)
{
    alt_u8 t;
    SDA_OUT(); //sda set as Outout
    IIC_SCL(0);
    for(t=0; t<8; t++) {
        IIC_SDA((txd&0x80)>>7);
        txd<<=1;
        usleep(1);
        IIC_SCL(1);
        usleep(1);
        IIC_SCL(0);
        usleep(1);
    }
}

//read one byte, followed by ACK as ack=1; followed by nACK as ack=0
alt_u8 IIC_Read_Byte(unsigned char ack)
{
    unsigned char i,receive=0;
    SDA_IN(); //sda set as Input
    for(i=0; i<8; i++ ) {
        IIC_SCL(0);
        usleep(1);
        IIC_SCL(1);
        receive<<=1;
        if(READ_SDA)
            receive++;
        usleep(1);
    }
    if (!ack)
        IIC_NAck();//master sends nACK 
    else
        IIC_Ack(); //master sends ACK 
    return receive;
}
***/
//initialize IIC
void IIC_Init(void)
{
    IIC_SCL(1);
    IIC_SDA(1);
}

void IIC_Start(void)
{
    SDA_OUT();   //sda set as Outout
    IIC_SDA(1);
    IIC_SCL(1);
    while(--p);
	p = DLY;
    IIC_SDA(0);  //START: SCL=H, SDA=H->L
    while(--p);
	p = DLY;
    IIC_SCL(0);  //clamp I2C line, ready to W/R
}

//master sends IIC Stop
void IIC_Stop(void)
{
    SDA_OUT();  //sda set as Outout
    IIC_SCL(0);
    IIC_SDA(0); //STOP: SCL=H, SDA=L->H
    while(--p);
	p = DLY;
    IIC_SCL(1);
    while(--p);
	p = DLY;
    IIC_SDA(1); 
    while(--p);
	p = DLY;
}

//wait slave ACK response
//return: 1, ACK fail
//        0, ACK success
alt_u8 IIC_Wait_Ack(void)
{
    alt_u8 ucErrTime=0;
    SDA_IN();      //sda set as Input
    IIC_SDA(1);		//now SDA is HighZ, is it necessary to set SDA to H ?
    while(--p);
	p = DLY;
    IIC_SCL(1);
    while(--p);
	p = DLY;
    while(READ_SDA) { 
        ucErrTime++;
        if(ucErrTime>250) {
            IIC_Stop();
            return 1;
        }
    }
    IIC_SCL(0);
    return 0;
}

//master sends ACK
void IIC_Ack(void)
{
    IIC_SCL(0);
    SDA_OUT(); //sda set as Outout
    IIC_SDA(0);
    while(--p);
	p = DLY;
    IIC_SCL(1);
    while(--p);
	p = DLY;
    IIC_SCL(0);
}

//master sends NACK
void IIC_NAck(void)
{
    IIC_SCL(0);
    SDA_OUT(); //sda set as Outout
    IIC_SDA(1);
    while(--p);
	p = DLY;
    IIC_SCL(1);
    while(--p);
	p = DLY;
    IIC_SCL(0);
}

//IIC sends one byte
void IIC_Send_Byte(alt_u8 txd)
{
    alt_u8 t;
    SDA_OUT(); //sda set as Outout
    IIC_SCL(0);
    for(t=0; t<8; t++) {
        IIC_SDA((txd&0x80)>>7);
        txd<<=1;
        while(--p);
		p = DLY;
        IIC_SCL(1);
        while(--p);
		p = DLY;
        IIC_SCL(0);
        while(--p);
		p = DLY;
    }
}

//read one byte, followed by ACK as ack=1; followed by nACK as ack=0
alt_u8 IIC_Read_Byte(unsigned char ack)
{
    unsigned char i,receive=0;
    SDA_IN(); //sda set as Input
    for(i=0; i<8; i++ ) {
        IIC_SCL(0);
        while(--p);
		p = DLY;
        IIC_SCL(1);
        receive<<=1;
        if(READ_SDA)
            receive++;
    }
    if (!ack)
        IIC_NAck();//master sends nACK 
    else
        IIC_Ack(); //master sends ACK 
    return receive;
}