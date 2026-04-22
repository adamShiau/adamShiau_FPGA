#include "uart.h"
#include <stdio.h>
#include <string.h>
#include "alt_types.h"
#include "altera_avalon_uart_regs.h"
#include "sys/alt_irq.h"
#include "system.h"
#include "common.h"

// #include "generic.h"

// #define TEST_MODE

#define CMD_LENGTH 6

// The receive buffer size
#define	RX_BUF_SIZE			256				// Must be an even power of two
#define	RX_BUF_SIZE_MASK	RX_BUF_SIZE - 1

// The transmit buffer size
#define	TX_BUF_SIZE			256				// Must be an even power of two
#define	TX_BUF_SIZE_MASK	TX_BUF_SIZE - 1

// Receive interrupt control macros
// #define	RX_INTERRUPT_ON()	IOWR_ALTERA_AVALON_UART_CONTROL(UART_BASE,IORD_ALTERA_AVALON_UART_CONTROL(UART_BASE) | ALTERA_AVALON_UART_CONTROL_RRDY_MSK)
// #define	RX_INTERRUPT_OFF()	IOWR_ALTERA_AVALON_UART_CONTROL(UART_BASE,IORD_ALTERA_AVALON_UART_CONTROL(UART_BASE) & ~ALTERA_AVALON_UART_CONTROL_RRDY_MSK)
#define	RX_INTERRUPT_ON()	IOWR_ALTERA_AVALON_UART_CONTROL(UART_DBG_BASE,IORD_ALTERA_AVALON_UART_CONTROL(UART_DBG_BASE) | ALTERA_AVALON_UART_CONTROL_RRDY_MSK)
#define	RX_INTERRUPT_OFF()	IOWR_ALTERA_AVALON_UART_CONTROL(UART_DBG_BASE,IORD_ALTERA_AVALON_UART_CONTROL(UART_DBG_BASE) & ~ALTERA_AVALON_UART_CONTROL_RRDY_MSK)

// Transmit interrupt control macros
// #define	TX_INTERRUPT_ON()	IOWR_ALTERA_AVALON_UART_CONTROL(UART_BASE,IORD_ALTERA_AVALON_UART_CONTROL(UART_BASE) | ALTERA_AVALON_UART_CONTROL_TRDY_MSK)
// #define	TX_INTERRUPT_OFF()	IOWR_ALTERA_AVALON_UART_CONTROL(UART_BASE,IORD_ALTERA_AVALON_UART_CONTROL(UART_BASE) & ~ALTERA_AVALON_UART_CONTROL_TRDY_MSK)
#define	TX_INTERRUPT_ON()	IOWR_ALTERA_AVALON_UART_CONTROL(UART_DBG_BASE,IORD_ALTERA_AVALON_UART_CONTROL(UART_DBG_BASE) | ALTERA_AVALON_UART_CONTROL_TRDY_MSK)
#define	TX_INTERRUPT_OFF()	IOWR_ALTERA_AVALON_UART_CONTROL(UART_DBG_BASE,IORD_ALTERA_AVALON_UART_CONTROL(UART_DBG_BASE) & ~ALTERA_AVALON_UART_CONTROL_TRDY_MSK)



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

	// uart_complete = 1;

	/**
	 * If new RX data arrives, store the data into rxBuf[rxBufPut], 
	 * then increment rxBufPut and rxBufCount by 1.
	 * rxBufPut: Indicates the current position in the buffer where RX data is stored; 
	 * it cycles between 0 and RX_BUF_SIZE_MASK.
	 * rxBufCount: Indicates the current amount of RX data; it will not increase beyond RX_BUF_SIZE.
	 */
	// if(IORD_ALTERA_AVALON_UART_STATUS(UART_BASE) & ALTERA_AVALON_UART_STATUS_RRDY_MSK)
	// {
	// 	// Get the byte
	// 	b = (int)(IORD_ALTERA_AVALON_UART_RXDATA(UART_BASE));

	// 	// Store the byte
	// 	pUartBuffer->rxBuf[pUartBuffer->rxBufPut] = (alt_u8)(b);

	// 	// Increment the put index
	// 	pUartBuffer->rxBufPut++;
	// 	pUartBuffer->rxBufPut &= RX_BUF_SIZE_MASK;

	// 	// Increment the count while preventing buffer overrun
	// 	if(pUartBuffer->rxBufCount < RX_BUF_SIZE) pUartBuffer->rxBufCount++;
	// }
    if(IORD_ALTERA_AVALON_UART_STATUS(UART_DBG_BASE) & ALTERA_AVALON_UART_STATUS_RRDY_MSK)
	{
		// Get the byte
		b = (int)(IORD_ALTERA_AVALON_UART_RXDATA(UART_DBG_BASE));

		// Store the byte
		pUartBuffer->rxBuf[pUartBuffer->rxBufPut] = (alt_u8)(b);

		// Increment the put index
		pUartBuffer->rxBufPut++;
		pUartBuffer->rxBufPut &= RX_BUF_SIZE_MASK;

		// Increment the count while preventing buffer overrun
		if(pUartBuffer->rxBufCount < RX_BUF_SIZE) pUartBuffer->rxBufCount++;
	}

	// if(IORD_ALTERA_AVALON_UART_STATUS(UART_BASE) & ALTERA_AVALON_UART_STATUS_TRDY_MSK)
	// {
	// 	if(pUartBuffer->txBufCount)
	// 	{
	// 		// Write the byte
	// 		IOWR_ALTERA_AVALON_UART_TXDATA(UART_BASE,(int)(pUartBuffer->txBuf[pUartBuffer->txBufTake]));

	// 		// Increment the take index
	// 		pUartBuffer->txBufTake++;
	// 		pUartBuffer->txBufTake &= TX_BUF_SIZE_MASK;

	// 		// Decrement the count
	// 		pUartBuffer->txBufCount--;

	// 		// Turn off the interrupt if no more bytes remain
	// 		if(!pUartBuffer->txBufCount)
	// 		{
	// 			TX_INTERRUPT_OFF();
	// 		}
	// 	}
	// }
    if(IORD_ALTERA_AVALON_UART_STATUS(UART_DBG_BASE) & ALTERA_AVALON_UART_STATUS_TRDY_MSK)
	{
		if(pUartBuffer->txBufCount)
		{
			// Write the byte
			IOWR_ALTERA_AVALON_UART_TXDATA(UART_DBG_BASE,(int)(pUartBuffer->txBuf[pUartBuffer->txBufTake]));

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

	// uart_complete = 0;

	// Disable interrupts
	// IOWR_ALTERA_AVALON_UART_CONTROL(UART_BASE,0);
    IOWR_ALTERA_AVALON_UART_CONTROL(UART_DBG_BASE,0);

	// Set the baud rate
	// div = (ALT_CPU_FREQ / UART_BAUD_RATE) - 1;
	// IOWR_ALTERA_AVALON_UART_DIVISOR(UART_BASE,div);

	// Register the interrupt handler
    // alt_ic_isr_register(UART_IRQ_INTERRUPT_CONTROLLER_ID,
    //     UART_IRQ,
    //     uartISR,
    //     &gUartBuffer,
    //     NULL
    // );

    alt_ic_isr_register(UART_DBG_IRQ_INTERRUPT_CONTROLLER_ID,
        UART_DBG_IRQ,
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

alt_u8* readData2(const alt_u8* expected_header, alt_u8 header_size, alt_u16* try_cnt,
		const alt_u8* expected_trailer, alt_u8 trailer_size)
{
	const alt_u8 data_size_expected = CMD_LENGTH;
    static alt_u8 buffer[CMD_LENGTH];
	// printf("uartAvailable: %d\n", uartAvailable());
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

                return buffer;
			}
          break;
        
	}
	return NULL;
}

// 定義兩種狀況的常數
#define HEADER1_SIZE 2
#define HEADER2_SIZE 2
#define HEADER3_SIZE 2
#define TRAILER1_SIZE 2
#define TRAILER2_SIZE 2
#define TRAILER3_SIZE 2
#define DATA1_SIZE 6   // 狀況 1 的數據長度
#define DATA2_SIZE 13  // 狀況 2 的數據長度
#define DATA3_SIZE 6  // 狀況 2 的數據長度
#define MAX_DATA_SIZE 13  // 最大數據長度 (狀況 2)
#define BUFFER_SIZE (MAX_DATA_SIZE + 1)  // 緩衝區大小，包含狀況 byte

// 狀況 1 的 Header 和 Trailer, for 一般 cmd 設定
static const alt_u8 HEADER1[] = {0xAB, 0xBA};
static const alt_u8 TRAILER1[] = {0x55, 0x56};

// 狀況 2 的 Header 和 Trailer, for SN 寫入
static const alt_u8 HEADER2[] = {0xCD, 0xDC};
static const alt_u8 TRAILER2[] = {0x57, 0x58};

// 狀況 3 的 Header 和 Trailer, for EEPROM 讀數據測試
static const alt_u8 HEADER3[] = {0xEF, 0xFE};
static const alt_u8 TRAILER3[] = {0x53, 0x54};

// 定義狀態枚舉
typedef enum {
    EXPECTING_HEADER,
    EXPECTING_PAYLOAD,
    EXPECTING_TRAILER
} State;

alt_u8* readDataDynamic(alt_u16* try_cnt)
{
    static alt_u8 buffer[BUFFER_SIZE];  // 緩衝區：1 byte 狀況 + 最大數據長度
    static alt_u8 bytes_received = 0;
    static State state = EXPECTING_HEADER;
    static alt_u8 condition = 0;  // 0: 未確定, 1: 狀況 1, 2: 狀況 2
    static alt_u8 data_size_expected = 0;  // 動態數據長度
    static const alt_u8* expected_trailer = NULL;  // 動態 Trailer
    static alt_u8 trailer_size = 0;

    // 檢查 UART 是否有數據
    if (uartAvailable() == 0) return NULL;
    int data = uartGetByte();

    switch (state) {
        case EXPECTING_HEADER:
            // 檢查是否匹配任一 Header
            if (bytes_received < HEADER1_SIZE) {
                if (data == HEADER1[bytes_received]) {
                    bytes_received++;
                    if (bytes_received == HEADER1_SIZE) {
                        condition = 1;  // 狀況 1
                        data_size_expected = DATA1_SIZE;
                        expected_trailer = TRAILER1;
                        trailer_size = TRAILER1_SIZE;
                        state = EXPECTING_PAYLOAD;
                        bytes_received = 0;
                    }
                } 
				else if (data == HEADER2[bytes_received]) {
                    bytes_received++;
                    if (bytes_received == HEADER2_SIZE) {
                        condition = 2;  // 狀況 2
                        data_size_expected = DATA2_SIZE;
                        expected_trailer = TRAILER2;
                        trailer_size = TRAILER2_SIZE;
                        state = EXPECTING_PAYLOAD;
                        bytes_received = 0;
                    }
                } 
				else if (data == HEADER3[bytes_received]) {
                    bytes_received++;
                    if (bytes_received == HEADER3_SIZE) {
                        condition = 3;  // 狀況 3
                        data_size_expected = DATA3_SIZE;
                        expected_trailer = TRAILER3;
                        trailer_size = TRAILER3_SIZE;
                        state = EXPECTING_PAYLOAD;
                        bytes_received = 0;
                    }
                } 
				else {
                    bytes_received = 0;
                    (*try_cnt)++;
                }
            }
            break;

        case EXPECTING_PAYLOAD:
            buffer[bytes_received + 1] = data;  // 數據從 buffer[1] 開始存儲
            bytes_received++;

            if (bytes_received >= data_size_expected) {
                state = EXPECTING_TRAILER;
                bytes_received = 0;
            }
            break;

        case EXPECTING_TRAILER:
            if (data != expected_trailer[bytes_received]) {
                state = EXPECTING_HEADER;
                bytes_received = 0;
                condition = 0;
                (*try_cnt)++;
            } else {
                bytes_received++;
                if (bytes_received >= trailer_size) {
                    // Trailer 確認完成，準備返回數據
                    state = EXPECTING_HEADER;
                    bytes_received = 0;
                    *try_cnt = 0;

                    // 在 buffer[0] 存儲狀況 byte
                    buffer[0] = condition;
                    // 返回緩衝區指針
                    return buffer;
                }
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

// void uartAck(alt_u8 data)
// {
// 	while(! (IORD_ALTERA_AVALON_UART_STATUS(UART_BASE)& ALTERA_AVALON_UART_STATUS_TRDY_MSK) );
// 	IOWR_ALTERA_AVALON_UART_TXDATA(UART_BASE, data);
// }
void uartAck(alt_u8 data)
{
	while(! (IORD_ALTERA_AVALON_UART_STATUS(UART_DBG_BASE)& ALTERA_AVALON_UART_STATUS_TRDY_MSK) );
	IOWR_ALTERA_AVALON_UART_TXDATA(UART_DBG_BASE, data);
}