/***
 * uart_V2.c
 * Version: V2.0
 * Date: 2025/07/21
 * Author: ChatGPT for Adam
 *
 * Changelog:
 * - V2.0: 支援第二組 UART（Debug）與環狀緩衝區中斷式收發
 *         封裝通道選擇邏輯（is_debug）
 *         整合封包解析 readDataDynamic()
 */


#include "uart_V2.h"
#include <string.h>
#include <stdio.h>

#define RX_BUF_SIZE         256
#define RX_BUF_SIZE_MASK    (RX_BUF_SIZE - 1)
#define TX_BUF_SIZE         256
#define TX_BUF_SIZE_MASK    (TX_BUF_SIZE - 1)

typedef struct {
    uint8_t rxBuf[RX_BUF_SIZE];
    volatile int rxBufCount;
    int rxBufPut;
    int rxBufTake;

    uint8_t txBuf[TX_BUF_SIZE];
    volatile int txBufCount;
    int txBufPut;
    int txBufTake;
    uint32_t uart_base;
} UartBuffer_t;

static UartBuffer_t gUartBufferMain = { .uart_base = UART_BASE };
static UartBuffer_t gUartBufferDbg  = { .uart_base = UART_DBG_BASE };

static UartBuffer_t* getUartBuf(int is_debug) {
    return is_debug ? &gUartBufferDbg : &gUartBufferMain;
}

static void uartISR(void* context) {
    UartBuffer_t* buf = (UartBuffer_t*)context;
    uint32_t base = buf->uart_base;

    uint32_t status = IORD_ALTERA_AVALON_UART_STATUS(base);

    if (status & ALTERA_AVALON_UART_STATUS_RRDY_MSK) {
        int b = IORD_ALTERA_AVALON_UART_RXDATA(base);
        buf->rxBuf[buf->rxBufPut] = (uint8_t)(b);
        buf->rxBufPut = (buf->rxBufPut + 1) & RX_BUF_SIZE_MASK;
        if (buf->rxBufCount < RX_BUF_SIZE) buf->rxBufCount++;
    }

    if (status & ALTERA_AVALON_UART_STATUS_TRDY_MSK) {
        if (buf->txBufCount > 0) {
            IOWR_ALTERA_AVALON_UART_TXDATA(base, buf->txBuf[buf->txBufTake]);
            buf->txBufTake = (buf->txBufTake + 1) & TX_BUF_SIZE_MASK;
            buf->txBufCount--;
        }
    }
}

void uartInit(void) {
    gUartBufferMain.rxBufCount = gUartBufferMain.rxBufPut = gUartBufferMain.rxBufTake = 0;
    gUartBufferMain.txBufCount = gUartBufferMain.txBufPut = gUartBufferMain.txBufTake = 0;
    alt_ic_isr_register(UART_IRQ_INTERRUPT_CONTROLLER_ID, UART_IRQ, uartISR, &gUartBufferMain, NULL);

    gUartBufferDbg.rxBufCount = gUartBufferDbg.rxBufPut = gUartBufferDbg.rxBufTake = 0;
    gUartBufferDbg.txBufCount = gUartBufferDbg.txBufPut = gUartBufferDbg.txBufTake = 0;
    alt_ic_isr_register(UART_DBG_IRQ_INTERRUPT_CONTROLLER_ID, UART_DBG_IRQ, uartISR, &gUartBufferDbg, NULL);
}

void uartPutByte_internal(UartBuffer_t* buf, uint8_t data) {
    while (buf->txBufCount >= TX_BUF_SIZE);
    buf->txBuf[buf->txBufPut] = data;
    buf->txBufPut = (buf->txBufPut + 1) & TX_BUF_SIZE_MASK;
    buf->txBufCount++;
    IOWR_ALTERA_AVALON_UART_CONTROL(buf->uart_base,
        IORD_ALTERA_AVALON_UART_CONTROL(buf->uart_base) | ALTERA_AVALON_UART_CONTROL_TRDY_MSK);
}

void uartPutByte(uint8_t data) { uartPutByte_internal(&gUartBufferMain, data); }
void uartPutByte_dbg(uint8_t data) { uartPutByte_internal(&gUartBufferDbg, data); }

void uartWrite_internal(UartBuffer_t* buf, uint8_t* data, uint8_t len) {
    for (uint8_t i = 0; i < len; i++) uartPutByte_internal(buf, data[i]);
}

void uartWrite(uint8_t* data, uint8_t len) { uartWrite_internal(&gUartBufferMain, data, len); }
void uartWrite_dbg(uint8_t* data, uint8_t len) { uartWrite_internal(&gUartBufferDbg, data, len); }

void uartWrite_r(uint8_t* data, uint8_t len) {
    for (int i = len - 1; i >= 0; i--) uartPutByte_internal(&gUartBufferMain, data[i]);
}
void uartWrite_dbg_r(uint8_t* data, uint8_t len) {
    for (int i = len - 1; i >= 0; i--) uartPutByte_internal(&gUartBufferDbg, data[i]);
}

void uartPrintf(const char* fmt, ...) {
    char buffer[256];
    va_list args;
    va_start(args, fmt);
    int len = vsnprintf(buffer, sizeof(buffer), fmt, args);
    va_end(args);
    uartWrite((uint8_t*)buffer, len);
}

void uartPrintf_dbg(const char* fmt, ...) {
    char buffer[256];
    va_list args;
    va_start(args, fmt);
    int len = vsnprintf(buffer, sizeof(buffer), fmt, args);
    va_end(args);
    uartWrite_dbg((uint8_t*)buffer, len);
}

int uartAvailable(int is_debug) {
    return getUartBuf(is_debug)->rxBufCount;
}

int uartGetByte(int is_debug) {
    UartBuffer_t* buf = getUartBuf(is_debug);
    if (buf->rxBufCount == 0) return -1;
    int b = buf->rxBuf[buf->rxBufTake];
    buf->rxBufTake = (buf->rxBufTake + 1) & RX_BUF_SIZE_MASK;
    buf->rxBufCount--;
    return b;
}

int uartGetc(int is_debug) {
    int b;
    while ((b = uartGetByte(is_debug)) == -1);
    return b;
}

// ========================= Packet Parsing =========================
#define HEADER1_SIZE 2
#define HEADER2_SIZE 2
#define HEADER3_SIZE 2
#define TRAILER1_SIZE 2
#define TRAILER2_SIZE 2
#define TRAILER3_SIZE 2
#define DATA1_SIZE 6
#define DATA2_SIZE 13
#define DATA3_SIZE 6
#define MAX_DATA_SIZE 13
#define BUFFER_SIZE (MAX_DATA_SIZE + 1)

static const uint8_t HEADER1[] = {0xAB, 0xBA};
static const uint8_t TRAILER1[] = {0x55, 0x56};
static const uint8_t HEADER2[] = {0xCD, 0xDC};
static const uint8_t TRAILER2[] = {0x57, 0x58};
static const uint8_t HEADER3[] = {0xEF, 0xFE};
static const uint8_t TRAILER3[] = {0x53, 0x54};

typedef enum {
    EXPECTING_HEADER,
    EXPECTING_PAYLOAD,
    EXPECTING_TRAILER
} State;

uint8_t* readDataDynamic(int is_debug, uint16_t* try_cnt) {
    static uint8_t buffer[BUFFER_SIZE];
    static uint8_t bytes_received = 0;
    static State state = EXPECTING_HEADER;
    static uint8_t condition = 0;
    static uint8_t data_size_expected = 0;
    static const uint8_t* expected_trailer = NULL;
    static uint8_t trailer_size = 0;

    if (uartAvailable(is_debug) == 0) return NULL;
    int data = uartGetByte(is_debug);

    switch (state) {
        case EXPECTING_HEADER:
            if (bytes_received < HEADER1_SIZE) {
                if (data == HEADER1[bytes_received]) {
                    bytes_received++;
                    if (bytes_received == HEADER1_SIZE) {
                        condition = 1;
                        data_size_expected = DATA1_SIZE;
                        expected_trailer = TRAILER1;
                        trailer_size = TRAILER1_SIZE;
                        state = EXPECTING_PAYLOAD;
                        bytes_received = 0;
                    }
                } else if (data == HEADER2[bytes_received]) {
                    bytes_received++;
                    if (bytes_received == HEADER2_SIZE) {
                        condition = 2;
                        data_size_expected = DATA2_SIZE;
                        expected_trailer = TRAILER2;
                        trailer_size = TRAILER2_SIZE;
                        state = EXPECTING_PAYLOAD;
                        bytes_received = 0;
                    }
                } else if (data == HEADER3[bytes_received]) {
                    bytes_received++;
                    if (bytes_received == HEADER3_SIZE) {
                        condition = 3;
                        data_size_expected = DATA3_SIZE;
                        expected_trailer = TRAILER3;
                        trailer_size = TRAILER3_SIZE;
                        state = EXPECTING_PAYLOAD;
                        bytes_received = 0;
                    }
                } else {
                    bytes_received = 0;
                    (*try_cnt)++;
                }
            }
            break;

        case EXPECTING_PAYLOAD:
            buffer[bytes_received + 1] = data;
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
                    state = EXPECTING_HEADER;
                    bytes_received = 0;
                    *try_cnt = 0;
                    buffer[0] = condition;
                    return buffer;
                }
            }
            break;
    }
    return NULL;
}
