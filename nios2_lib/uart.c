#include "uart.h"

#include <stdio.h>
#include <string.h>

#include "alt_types.h"
#include "altera_avalon_uart_regs.h"
#include "sys/alt_irq.h"
#include "system.h"

// #include "generic.h"

// #define TEST_MODE

#define CMD_LENGTH 5

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
	alt_u8 rxBuf[RX_BUF_SIZE];

	volatile int rxBufCount;
	int rxBufPut;
	int rxBufTake;

	// The transmit buffer and indices
	alt_u8 txBuf[TX_BUF_SIZE];

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
static void uartISR(void *context)
{
	int b;
	UartBuffer_t *pUartBuffer;

	pUartBuffer = context;

	/**
	 * 若有新的rx數據進來，將數據存入rxBuf[rxBufPut]，然後將 rxBufPut 與 rxBufCount 加1。
	 * rxBufPut:目前rx的數據到buffer哪個位置了，會一直在0~RX_BUF_SIZE_MASK之間循環
	 * rxBufCount: 目前rx數據量，最大到RX_BUF_SIZE就不會增加了
	 */
	if(IORD_ALTERA_AVALON_UART_STATUS(UART_BASE) & ALTERA_AVALON_UART_STATUS_RRDY_MSK)
	{
		// Get the byte
		b = (int)(IORD_ALTERA_AVALON_UART_RXDATA(UART_BASE));

		// Store the byte
		pUartBuffer->rxBuf[pUartBuffer->rxBufPut] = (alt_u8)(b);

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
	// int div;

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
	// div = (ALT_CPU_FREQ / UART_BAUD_RATE) - 1;
	// IOWR_ALTERA_AVALON_UART_DIVISOR(UART_BASE,div);

	// Register the interrupt handler
    alt_ic_isr_register(UART_IRQ_INTERRUPT_CONTROLLER_ID,
        UART_IRQ,
        uartISR,
        &gUartBuffer,
        NULL
    );

	// Turn on the receive interrupt
	RX_INTERRUPT_ON();
}

/*-----------------------------------------------------------------------------
--------------------------------------------------------------- uartAvailable
-------------------------------------------------------------------------------
DESCRIPTION:
	Return data count in Rx buffer

PARAMETERS:
	None.

RETURNS:
	Data count.
-----------------------------------------------------------------------------*/
int uartAvailable(void)
{

	return gUartBuffer.rxBufCount;
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

alt_u8* readData(alt_u8* expected_header, alt_u8 header_size, alt_u16* try_cnt, 
                 alt_u8* expected_trailer, alt_u8 trailer_size, alt_u8* cmd_complete)
{
	const alt_u8 data_size_expected = CMD_LENGTH;
    static alt_u8 buffer[CMD_LENGTH];
    
    
    if ( uartAvailable() == 0 ) return NULL; //return immediately if no serial data in buffer 

    int data = uartGetByte();

    #if defined(TEST_MODE)
        printf("\ndata: %d, %x\n", uartAvailable(), data);
    #endif

	static alt_u8 bytes_received = 0;
	static enum {
		EXPECTING_HEADER, 
		EXPECTING_PAYLOAD,
        EXPECTING_TRAILER
	} state = EXPECTING_HEADER; // state machine definition
	
	switch (state) {
		case EXPECTING_HEADER:
            #if defined(TEST_MODE)
                printf("state : EXPECTING_HEADER\n");
            #endif
			
			if (data != expected_header[bytes_received++])
			{
				state = EXPECTING_HEADER;
				bytes_received = 0;
                (*try_cnt)++;
			}

            #if defined(TEST_MODE)
                printf("bytes_received: ");
                printf("%d", bytes_received);
                printf(", ");
                printf("%x\n", data);
            #endif

			if(bytes_received >= header_size){
				state = EXPECTING_PAYLOAD;
				bytes_received = 0;
			}

			break;

		case EXPECTING_PAYLOAD:
			#if defined(TEST_MODE)
                printf("state : EXPECTING_PAYLOAD\n");
            #endif

			buffer[bytes_received++] = data;

            #if defined(TEST_MODE)
                printf("bytes_received: ");
                printf("%d", bytes_received);
                printf(", ");
                printf("%x\n", buffer[bytes_received-1]);
            #endif

			if(bytes_received >= data_size_expected)
            {
                bytes_received = 0;
                // state = EXPECTING_HEADER;
                // Serial.print("buf: ");
                // Serial.print((long)buffer, HEX);
                // Serial.print(", ");
                // Serial.print((long)&buffer[0], HEX);
                // Serial.print(", ");
                // Serial.println((long)&buffer[1], HEX);

                state = EXPECTING_TRAILER;
                *try_cnt = 0;
                
			}
			break;

        case EXPECTING_TRAILER:
            #if defined(TEST_MODE)
                printf("state : EXPECTING_TRAILER\n");
                printf("Trailer: ");
                printf("%x\n", data);
            #endif

            if (data != expected_trailer[bytes_received++])
			{
				state = EXPECTING_HEADER;
				bytes_received = 0;
                (*try_cnt)++;
			}

            if(bytes_received >= trailer_size){
				state = EXPECTING_HEADER;
				bytes_received = 0;
                *try_cnt = 0;
                #if defined(TEST_MODE)
                    printf("\nstate : RESPONSE_ACK\n");
                    printf("buf: %x, %x, %x, %x, %x\n", buffer[0], buffer[1], buffer[2], buffer[3], buffer[4]);
                #endif
                #if defined(TEST_MODE)
                    printf("*********reset try_cnt: ************\n");
                    printf("%d\n\n", *try_cnt);
                #endif
                // uartAck(0xCC);
                *cmd_complete = 1;

                return buffer;
			}
          break;
        
	}
	return NULL;
}

/*-----------------------------------------------------------------------------
--------------------------------------------------------------- uartAck
-------------------------------------------------------------------------------
DESCRIPTION:
	Send one byte data.

PARAMETERS:
	None.

RETURNS:
	Nothing.
-----------------------------------------------------------------------------*/

void uartAck(alt_u8 data)
{
	while(! (IORD_ALTERA_AVALON_UART_STATUS(UART_BASE)& ALTERA_AVALON_UART_STATUS_TRDY_MSK) );
	IOWR_ALTERA_AVALON_UART_TXDATA(UART_BASE, data);
}