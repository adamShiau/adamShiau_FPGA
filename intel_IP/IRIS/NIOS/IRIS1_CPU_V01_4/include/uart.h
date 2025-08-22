#ifndef __UART_H
#define __UART_H
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "alt_types.h"
#include "unistd.h"


void uartInit(void);
int uartGetByte(void);
int uartGetc(void);
int uartAvailable(void);
void uartAck(alt_u8);


alt_u8* readDataDynamic(alt_u16* try_cnt);

// extern volatile alt_u8 uart_complete;

#endif /* __UART_H */
