#ifndef __UART_DUAL_H
#define __UART_DUAL_H
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "alt_types.h"
#include "unistd.h"

// 初始化（同時初始化 UART_BASE 與 UART_DBG_BASE、掛 ISR、開 RX 中斷）
void uartInit(void);

// ===== 服務 UART_BASE（相容你原有呼叫）======
int  uartAvailable(void);
int  uartGetByte(void);   // non-blocking，無資料回 -1
int  uartGetc(void);      // blocking，直到讀到
void uartAck(alt_u8 data);

// 你原本的動態封包讀取器（保留相同介面與行為）
alt_u8* readDataDynamic(alt_u16* try_cnt);

// ===== 服務 UART_DBG_BASE（新增的 dbg 版本）=====
int  uartAvailable_dbg(void);
int  uartGetByte_dbg(void);
int  uartGetc_dbg(void);
void uartAck_dbg(alt_u8 data);

// 與上面對應的封包讀取器（dbg 埠）
alt_u8* readDataDynamic_dbg(alt_u16* try_cnt);

#endif /* __UART_DUAL_H */
