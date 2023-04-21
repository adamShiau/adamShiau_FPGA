
//
// NIOS II UART API - Courtesy of John Speth
//

#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#include "alt_types.h"
#include "altera_avalon_uart_regs.h"
#include "sys/alt_irq.h"
#include "system.h"

#include "generic.h"

// Chosen UART baud rate
#define	UART_BAUD_RATE		115200			// Bits/sec

// The receive buffer size
#define	RX_BUF_SIZE			256				// Must be an even power of two
#define	RX_BUF_SIZE_MASK	RX_BUF_SIZE - 1

// The transmit buffer size
#define	TX_BUF_SIZE			256				// Must be an even power of two
#define	TX_BUF_SIZE_MASK	TX_BUF_SIZE - 1

// Receive interrupt control macros
#define	RX_INTERRUPT_ON()	IOWR_ALTERA_AVALON_UART_CONTROL(UART_BASE,IORD_ALTERA_AVALON_UART_CONTROL(UART_BASE) | ALTERA_AVALON_UART_CONTROL_RRDY_MSK)
#define	RX_INTERRUPT_OFF()	IOWR_ALTERA_AVALON_UART_CONTROL(UART_BASE,IORD_ALTERA_AVALON_UART_CONTROL(UART_BASE) & ~ALTERA_AVALON_UART_CONTROL_RRDY_MSK)

// Transmit interrupt control macros
#define	TX_INTERRUPT_ON()	IOWR_ALTERA_AVALON_UART_CONTROL(UART_BASE,IORD_ALTERA_AVALON_UART_CONTROL(UART_BASE) | ALTERA_AVALON_UART_CONTROL_TRDY_MSK)
#define	TX_INTERRUPT_OFF()	IOWR_ALTERA_AVALON_UART_CONTROL(UART_BASE,IORD_ALTERA_AVALON_UART_CONTROL(UART_BASE) & ~ALTERA_AVALON_UART_CONTROL_TRDY_MSK)

typedef struct
{
	// The receive buffer and indices
	byte rxBuf[RX_BUF_SIZE];

	volatile int rxBufCount;
	int rxBufPut;
	int rxBufTake;

	// The transmit buffer and indices
	byte txBuf[TX_BUF_SIZE];

	volatile int txBufCount;
	int txBufPut;
	int txBufTake;
} UartBuffer_t;

// The UART working memory
static UartBuffer_t gUartBuffer;

/*-----------------------------------------------------------------------------
--------------------------------------------------------------- uartISR
-------------------------------------------------------------------------------
DESCRIPTION:
	The UART interrupt work function.  It runs in the interrupt execution
	context.

PARAMETERS:
	None.

RETURNS:
	Nothing.
-----------------------------------------------------------------------------*/
static void uartISR(void *context,alt_u32 id)
{
	int b;
	UartBuffer_t *pUartBuffer;

	pUartBuffer = context;

	if(IORD_ALTERA_AVALON_UART_STATUS(UART_BASE) & ALTERA_AVALON_UART_STATUS_RRDY_MSK)
	{
		// Get the byte
		b = (int)(IORD_ALTERA_AVALON_UART_RXDATA(UART_BASE));

		// Store the byte
		pUartBuffer->rxBuf[pUartBuffer->rxBufPut] = (byte)(b);

		// Increment the put index
		pUartBuffer->rxBufPut++;
		pUartBuffer->rxBufPut &= RX_BUF_SIZE_MASK;

		// Increment the count while preventing buffer overrun
		if(pUartBuffer->rxBufCount < RX_BUF_SIZE) pUartBuffer->rxBufCount++;
	}

	if(IORD_ALTERA_AVALON_UART_STATUS(UART_BASE) & ALTERA_AVALON_UART_STATUS_TRDY_MSK)
	{
		if(pUartBuffer->txBufCount)
		{
			// Write the byte
			IOWR_ALTERA_AVALON_UART_TXDATA(UART_BASE,(int)(pUartBuffer->txBuf[pUartBuffer->txBufTake]));

			// Increment the take index
			pUartBuffer->txBufTake++;
			pUartBuffer->txBufTake &= TX_BUF_SIZE_MASK;

			// Decrement the count
			pUartBuffer->txBufCount--;

			// Turn off the interrupt if no more bytes remain
			if(!pUartBuffer->txBufCount)
			{
				TX_INTERRUPT_OFF();
			}
		}
	}
}

/*-----------------------------------------------------------------------------
--------------------------------------------------------------- uartInit
-------------------------------------------------------------------------------
DESCRIPTION:
	Initializes the UART.

PARAMETERS:
	None.

RETURNS:
	Nothing.
-----------------------------------------------------------------------------*/
void uartInit(void)
{
	int div;

	// Initialize buffer indices
	gUartBuffer.rxBufCount = 0;
	gUartBuffer.rxBufPut = 0;
	gUartBuffer.rxBufTake = 0;

	gUartBuffer.txBufCount = 0;
	gUartBuffer.txBufPut = 0;
	gUartBuffer.txBufTake = 0;

	// Disable interrupts
	IOWR_ALTERA_AVALON_UART_CONTROL(UART_BASE,0);

	// Set the baud rate
	div = (ALT_CPU_FREQ / UART_BAUD_RATE) - 1;
	IOWR_ALTERA_AVALON_UART_DIVISOR(UART_BASE,div);

	// Register the interrupt handler
	alt_irq_register(UART_IRQ,&gUartBuffer,uartISR);

	// Turn on the receive interrupt
	RX_INTERRUPT_ON();
}

/*-----------------------------------------------------------------------------
--------------------------------------------------------------- uartWaitEmpty
-------------------------------------------------------------------------------
DESCRIPTION:
	Waits for the UART buffer to empty.

PARAMETERS:
	None.

RETURNS:
	Nothing.
-----------------------------------------------------------------------------*/
void uartWaitEmpty(void)
{
	while(gUartBuffer.txBufCount);
}

/*-----------------------------------------------------------------------------
--------------------------------------------------------------- uartSendByte
-------------------------------------------------------------------------------
DESCRIPTION:
	Sends a byte to the serial port.

PARAMETERS:
	The byte to send.

RETURNS:
	Nothing.
-----------------------------------------------------------------------------*/
void uartSendByte(int b)
{
	// Test for overflow
	if(gUartBuffer.txBufCount == TX_BUF_SIZE) return;

	// Store the byte
	gUartBuffer.txBuf[gUartBuffer.txBufPut] = (byte)(b);

	// Increment the put index
	gUartBuffer.txBufPut++;
	gUartBuffer.txBufPut &= TX_BUF_SIZE_MASK;

	TX_INTERRUPT_OFF();

	// Increment the count
	gUartBuffer.txBufCount++;

	// Turn on the transmit interrupt to start the send process
	TX_INTERRUPT_ON();
}

/*-----------------------------------------------------------------------------
--------------------------------------------------------------- uartWrite
-------------------------------------------------------------------------------
DESCRIPTION:
	Sends a data buffer to the UART.

PARAMETERS:
	A pointer to the data buffer and its size.

RETURNS:
	Nothing.
-----------------------------------------------------------------------------*/
void uartWrite(char *pData,size_t size)
{
	size_t i;

	for(i = 0; i < size; i++) uartSendByte((int)(*pData++));
}

/*-----------------------------------------------------------------------------
--------------------------------------------------------------- uartPrintf
-------------------------------------------------------------------------------
DESCRIPTION:
	Writes a formatted string to the UART.

PARAMETERS:
	The printf style arguments.

RETURNS:
	Nothing.
-----------------------------------------------------------------------------*/
void uartPrintf(const char *fmt, ...)
{
	char line[100];
	va_list ap;

	va_start(ap,fmt);
	vsprintf(line,fmt,ap);
	va_end(ap);

	uartWrite(line,strlen(line));
}

/*-----------------------------------------------------------------------------
--------------------------------------------------------------- uartGetByte
-------------------------------------------------------------------------------
DESCRIPTION:
	Gets a byte from the serial port.

PARAMETERS:
	None.

RETURNS:
	The next byte waiting in the receive buffer.  If the receive buffer is
	empty, -1 is returned.
-----------------------------------------------------------------------------*/
int uartGetByte(void)
{
	int b;

	// Test for any bytes ready
	if(gUartBuffer.rxBufCount == 0) return -1;

	// Store the byte
	b = (int)(gUartBuffer.rxBuf[gUartBuffer.rxBufTake]);

	// Increment the take index
	gUartBuffer.rxBufTake++;
	gUartBuffer.rxBufTake &= RX_BUF_SIZE_MASK;

	RX_INTERRUPT_OFF();

	// Decrement the count
	gUartBuffer.rxBufCount--;

	RX_INTERRUPT_ON();

	return b;
}

/*-----------------------------------------------------------------------------
--------------------------------------------------------------- uartGetc
-------------------------------------------------------------------------------
DESCRIPTION:
	Waits for the next byte from the serial port.

PARAMETERS:
	None.

RETURNS:
	The next byte waiting in the receive buffer.
-----------------------------------------------------------------------------*/
int uartGetc(void)
{
	int b;

	for(;;)
	{
		b = uartGetByte();
		if(b != -1) return b;
	}
}

/*-----------------------------------------------------------------------------
--------------------------------------------------------------- uartChecks
-------------------------------------------------------------------------------
DESCRIPTION:
	Checks if a complete string is in the receive buffer.  A complete string
	has a CR terminator.

PARAMETERS:
	None.

RETURNS:
	True if a string is ready and false if not.
-----------------------------------------------------------------------------*/
int uartChecks(void)
{
	int i;
	int count;
	int take;
	byte b;

	count = gUartBuffer.rxBufCount;
	take = gUartBuffer.rxBufTake;

	for(i = 0; i < count; i++)
	{
		b = gUartBuffer.rxBuf[take];
		if(b == '\r') return TRUE;

		take++;
		take &= RX_BUF_SIZE_MASK;
	}

	return FALSE;
}

/*-----------------------------------------------------------------------------
--------------------------------------------------------------- uartGets
-------------------------------------------------------------------------------
DESCRIPTION:
	Gets a string from the serial port.  The number of characters captured is
	returned or zero if there were no characters captured.

PARAMETERS:
	A pointer to where the string will be stored and a size of storage
	indicator to prevent memory overrun.

RETURNS:
	The length of the returned string.
-----------------------------------------------------------------------------*/
int uartGets(char *s,size_t size)
{
	int b;
	size_t count;

	count = 0;

	if(size <= 1) return -1;
	size--;

	for(;;)
	{
		// Poll for a new byte
		b = uartGetByte();

		// Check for any characters available
		if(b == -1) continue;

		if(b == '\n') continue;

		// CR terminates
		if(b == '\r') break;

		// Save the character
		*s++ = (char)(b);

		// Prevent overruns
		count++;
		if(count == size) break;
	}

	// Terminate
	*s = '\0';

	return (int)(count);
}

