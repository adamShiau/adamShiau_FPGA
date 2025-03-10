#include "adxl357.h"
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
//#include "altera_avalon_pio_regs.h"

void IRQ_TRIGGER_ISR(void *context);
void TRIGGER_IRQ_init(void);
void update_IRIS_config_to_HW_REG(void);
void SerialWrite(alt_u8* buf, alt_u8 num);
void uart_printf(const char *format, ...);
#define UART_BUFFER_SIZE 128

alt_u8 trigger_sig = 0;

alt_u8 cnt=0;
int main()
{
  printf("Hello from Nios II!\n");
  update_IRIS_config_to_HW_REG();
  TRIGGER_IRQ_init(); // register EXTT interrupt

  init_ADXL357();

  while(1){
	  if(trigger_sig==1) {
		  trigger_sig = 0;
		  read_357_all();
//		  read_357_temp_CPU();
//		  read_357_accl_CPU();
	  }


  }
  return 0;
}

void SerialWrite(alt_u8* buf, alt_u8 num)
{
    for (alt_u8 i = 0; i < num; i++)
    {
        while (!(IORD_ALTERA_AVALON_UART_STATUS(UART_BASE) & ALTERA_AVALON_UART_STATUS_TRDY_MSK));
        IOWR_ALTERA_AVALON_UART_TXDATA(UART_BASE, buf[i]);
    }
}

void uart_printf(const char *format, ...)
{
    char buffer[UART_BUFFER_SIZE];   // ノㄓ纗Αて﹃
    va_list args;                    // ﹚竡跑把计

    va_start(args, format);           // ﹍て跑把计format 琌程㏕﹚把计
    vsnprintf(buffer, UART_BUFFER_SIZE, format, args);  // Αて﹃
    va_end(args);                     // 挡跑把计矪瞶

    SerialWrite((alt_u8*)buffer, strlen(buffer));  // ㄏノ UART 肚癳﹃
}

void update_IRIS_config_to_HW_REG()
{
	IOWR(VARSET_BASE, var_sync_count, 5e5);
}

void TRIGGER_IRQ_init()
{
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(TRIGGER_IN_BASE, 1); //clear edge capture register
	IOWR_ALTERA_AVALON_PIO_IRQ_MASK(TRIGGER_IN_BASE, 1); //enable irq mask
	alt_ic_isr_register(
	TRIGGER_IN_IRQ_INTERRUPT_CONTROLLER_ID,
	TRIGGER_IN_IRQ,
	IRQ_TRIGGER_ISR,
	0x0,
	0x0);
}

void IRQ_TRIGGER_ISR(void *context)
{
	(void) context;
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(TRIGGER_IN_BASE, 1); //clear edge capture register
	trigger_sig = 1;
}
