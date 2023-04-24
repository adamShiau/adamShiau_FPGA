#ifndef __UART_H
#define __UART_H
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "alt_types.h"
#include "unistd.h"

alt_u8* readData(alt_u8* expected_header, alt_u8 header_size, alt_u16* try_cnt);

#endif /* __UART_H */