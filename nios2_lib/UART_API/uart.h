
//
// NIOS II UART API - Courtesy of John Speth
//

#ifndef _UART_H
#define _UART_H

//
// Public function prototypes
//
extern void uartInit(void);
extern void uartWaitEmpty(void);
extern void uartSendByte(int b);
extern void uartWrite(char *pData,size_t size);
extern void uartPrintf(const char *fmt, ...);
extern int uartGetByte(void);
extern int uartGetc(void);
extern int uartChecks(void);
extern int uartGets(char *s,size_t size);

#endif

