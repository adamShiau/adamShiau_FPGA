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

alt_u8* readData(alt_u8* expected_header, alt_u8 header_size, alt_u16* try_cnt, 
                alt_u8* expected_trailer, alt_u8 trailer_sizes, alt_u8* cmd_complete);

alt_u8* readData2(const alt_u8* expected_header, alt_u8 header_size, alt_u16* try_cnt,
		const alt_u8* expected_trailer, alt_u8 trailer_sizes);

alt_u8* readDataDynamic(alt_u16* try_cnt);

// extern volatile alt_u8 uart_complete;

#endif /* __UART_H */
