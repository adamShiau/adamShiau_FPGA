#include "uart_dual.h"
#include <string.h>
#include "altera_avalon_uart_regs.h"
#include "sys/alt_irq.h"
#include "system.h"
#include "common.h"

// ---------------- Ring buffer 參數 ----------------
#define RX_BUF_SIZE       256           // power of two
#define RX_BUF_SIZE_MASK  (RX_BUF_SIZE - 1)
#define TX_BUF_SIZE       256           // power of two
#define TX_BUF_SIZE_MASK  (TX_BUF_SIZE - 1)

// ---------------- 中斷開關（分 BASE / DBG 各自控制） ----------------
#define RX_INTERRUPT_ON_BASE()  IOWR_ALTERA_AVALON_UART_CONTROL(UART_BASE, \
    IORD_ALTERA_AVALON_UART_CONTROL(UART_BASE) | ALTERA_AVALON_UART_CONTROL_RRDY_MSK)
#define RX_INTERRUPT_OFF_BASE() IOWR_ALTERA_AVALON_UART_CONTROL(UART_BASE, \
    IORD_ALTERA_AVALON_UART_CONTROL(UART_BASE) & ~ALTERA_AVALON_UART_CONTROL_RRDY_MSK)
#define TX_INTERRUPT_ON_BASE()  IOWR_ALTERA_AVALON_UART_CONTROL(UART_BASE, \
    IORD_ALTERA_AVALON_UART_CONTROL(UART_BASE) | ALTERA_AVALON_UART_CONTROL_TRDY_MSK)
#define TX_INTERRUPT_OFF_BASE() IOWR_ALTERA_AVALON_UART_CONTROL(UART_BASE, \
    IORD_ALTERA_AVALON_UART_CONTROL(UART_BASE) & ~ALTERA_AVALON_UART_CONTROL_TRDY_MSK)

#define RX_INTERRUPT_ON_DBG()   IOWR_ALTERA_AVALON_UART_CONTROL(UART_DBG_BASE, \
    IORD_ALTERA_AVALON_UART_CONTROL(UART_DBG_BASE) | ALTERA_AVALON_UART_CONTROL_RRDY_MSK)
#define RX_INTERRUPT_OFF_DBG()  IOWR_ALTERA_AVALON_UART_CONTROL(UART_DBG_BASE, \
    IORD_ALTERA_AVALON_UART_CONTROL(UART_DBG_BASE) & ~ALTERA_AVALON_UART_CONTROL_RRDY_MSK)
#define TX_INTERRUPT_ON_DBG()   IOWR_ALTERA_AVALON_UART_CONTROL(UART_DBG_BASE, \
    IORD_ALTERA_AVALON_UART_CONTROL(UART_DBG_BASE) | ALTERA_AVALON_UART_CONTROL_TRDY_MSK)
#define TX_INTERRUPT_OFF_DBG()  IOWR_ALTERA_AVALON_UART_CONTROL(UART_DBG_BASE, \
    IORD_ALTERA_AVALON_UART_CONTROL(UART_DBG_BASE) & ~ALTERA_AVALON_UART_CONTROL_TRDY_MSK)

// ---------------- 緩衝區結構 ----------------
typedef struct {
    // RX ring
    alt_u8 rxBuf[RX_BUF_SIZE];
    volatile int rxBufCount;
    int rxBufPut;
    int rxBufTake;

    // TX ring（若你未使用可保留為 0）
    alt_u8 txBuf[TX_BUF_SIZE];
    volatile int txBufCount;
    int txBufPut;
    int txBufTake;
} UartBuffer_t;

// 各一套（BASE 與 DBG）
static UartBuffer_t gUartBuffer;      // BASE
static UartBuffer_t gUartBuffer_dbg;  // DBG

// ---------------- BASE 的 ISR（保持你原本邏輯） ----------------
static void uartISR(void *context)
{
    int b;
    UartBuffer_t *pUartBuffer = (UartBuffer_t*)context;

    // RX ready
    if (IORD_ALTERA_AVALON_UART_STATUS(UART_BASE) & ALTERA_AVALON_UART_STATUS_RRDY_MSK) {
        b = (int)IORD_ALTERA_AVALON_UART_RXDATA(UART_BASE);
        pUartBuffer->rxBuf[pUartBuffer->rxBufPut] = (alt_u8)b;
        pUartBuffer->rxBufPut = (pUartBuffer->rxBufPut + 1) & RX_BUF_SIZE_MASK;
        if (pUartBuffer->rxBufCount < RX_BUF_SIZE) pUartBuffer->rxBufCount++;
    }

    // TX ready（如有使用 TX ring）
    if (IORD_ALTERA_AVALON_UART_STATUS(UART_BASE) & ALTERA_AVALON_UART_STATUS_TRDY_MSK) {
        if (pUartBuffer->txBufCount) {
            IOWR_ALTERA_AVALON_UART_TXDATA(UART_BASE, (int)pUartBuffer->txBuf[pUartBuffer->txBufTake]);
            pUartBuffer->txBufTake = (pUartBuffer->txBufTake + 1) & TX_BUF_SIZE_MASK;
            pUartBuffer->txBufCount--;
            if (!pUartBuffer->txBufCount) TX_INTERRUPT_OFF_BASE();
        } else {
            TX_INTERRUPT_OFF_BASE();
        }
    }
}

// ---------------- DBG 的 ISR（與上面完全對應） ----------------
static void uartISR_dbg(void *context)
{
    int b;
    UartBuffer_t *pUartBuffer = (UartBuffer_t*)context;

    if (IORD_ALTERA_AVALON_UART_STATUS(UART_DBG_BASE) & ALTERA_AVALON_UART_STATUS_RRDY_MSK) {
        b = (int)IORD_ALTERA_AVALON_UART_RXDATA(UART_DBG_BASE);
        pUartBuffer->rxBuf[pUartBuffer->rxBufPut] = (alt_u8)b;
        pUartBuffer->rxBufPut = (pUartBuffer->rxBufPut + 1) & RX_BUF_SIZE_MASK;
        if (pUartBuffer->rxBufCount < RX_BUF_SIZE) pUartBuffer->rxBufCount++;
    }

    if (IORD_ALTERA_AVALON_UART_STATUS(UART_DBG_BASE) & ALTERA_AVALON_UART_STATUS_TRDY_MSK) {
        if (pUartBuffer->txBufCount) {
            IOWR_ALTERA_AVALON_UART_TXDATA(UART_DBG_BASE, (int)pUartBuffer->txBuf[pUartBuffer->txBufTake]);
            pUartBuffer->txBufTake = (pUartBuffer->txBufTake + 1) & TX_BUF_SIZE_MASK;
            pUartBuffer->txBufCount--;
            if (!pUartBuffer->txBufCount) TX_INTERRUPT_OFF_DBG();
        } else {
            TX_INTERRUPT_OFF_DBG();
        }
    }
}

// ---------------- 初始化：同時掛兩個 ISR、開兩邊 RX 中斷 ----------------
void uartInit(void)
{
    // 清 buffer
    memset(&gUartBuffer, 0, sizeof(gUartBuffer));
    memset(&gUartBuffer_dbg, 0, sizeof(gUartBuffer_dbg));

    // 關中斷
    IOWR_ALTERA_AVALON_UART_CONTROL(UART_BASE, 0);
    IOWR_ALTERA_AVALON_UART_CONTROL(UART_DBG_BASE, 0);

    // 註冊 ISR：BASE
    alt_ic_isr_register(UART_IRQ_INTERRUPT_CONTROLLER_ID,
                        UART_IRQ,
                        uartISR,
                        &gUartBuffer,
                        NULL);

    // 註冊 ISR：DBG
    alt_ic_isr_register(UART_DBG_IRQ_INTERRUPT_CONTROLLER_ID,
                        UART_DBG_IRQ,
                        uartISR_dbg,
                        &gUartBuffer_dbg,
                        NULL);

    // 開 RX 中斷
    RX_INTERRUPT_ON_BASE();
    RX_INTERRUPT_ON_DBG();
}

// ---------------- 相容 API（服務 UART_BASE） ----------------
int uartAvailable(void)               { return gUartBuffer.rxBufCount; }

int uartGetByte(void)
{
    int b;
    if (gUartBuffer.rxBufCount == 0) return -1;

    b = (int)gUartBuffer.rxBuf[gUartBuffer.rxBufTake];
    gUartBuffer.rxBufTake = (gUartBuffer.rxBufTake + 1) & RX_BUF_SIZE_MASK;

    RX_INTERRUPT_OFF_BASE();
    gUartBuffer.rxBufCount--;
    RX_INTERRUPT_ON_BASE();

    return b;
}

int uartGetc(void)
{
    int b;
    for (;;) {
        b = uartGetByte();
        if (b != -1) return b;
    }
}

void uartAck(alt_u8 data)
{
    while (!(IORD_ALTERA_AVALON_UART_STATUS(UART_BASE) & ALTERA_AVALON_UART_STATUS_TRDY_MSK));
    IOWR_ALTERA_AVALON_UART_TXDATA(UART_BASE, data);
}

// ---------------- DBG API（服務 UART_DBG_BASE） ----------------
int uartAvailable_dbg(void)           { return gUartBuffer_dbg.rxBufCount; }

int uartGetByte_dbg(void)
{
    int b;
    if (gUartBuffer_dbg.rxBufCount == 0) return -1;

    b = (int)gUartBuffer_dbg.rxBuf[gUartBuffer_dbg.rxBufTake];
    gUartBuffer_dbg.rxBufTake = (gUartBuffer_dbg.rxBufTake + 1) & RX_BUF_SIZE_MASK;

    RX_INTERRUPT_OFF_DBG();
    gUartBuffer_dbg.rxBufCount--;
    RX_INTERRUPT_ON_DBG();

    return b;
}

int uartGetc_dbg(void)
{
    int b;
    for (;;) {
        b = uartGetByte_dbg();
        if (b != -1) return b;
    }
}

void uartAck_dbg(alt_u8 data)
{
    while (!(IORD_ALTERA_AVALON_UART_STATUS(UART_DBG_BASE) & ALTERA_AVALON_UART_STATUS_TRDY_MSK));
    IOWR_ALTERA_AVALON_UART_TXDATA(UART_DBG_BASE, data);
}

// ---------------- 你的封包解析（BASE 與 DBG 各一套） ----------------
// 跟你原本一致的常數
#define HEADER1_SIZE  2
#define HEADER2_SIZE  2
#define HEADER3_SIZE  2
#define TRAILER1_SIZE 2
#define TRAILER2_SIZE 2
#define TRAILER3_SIZE 2
#define DATA1_SIZE    6
#define DATA2_SIZE    13
#define DATA3_SIZE    6
#define MAX_DATA_SIZE 13
#define BUFFER_SIZE   (MAX_DATA_SIZE + 1)

static const alt_u8 HEADER1[]  = {0xAB, 0xBA};
static const alt_u8 TRAILER1[] = {0x55, 0x56};
static const alt_u8 HEADER2[]  = {0xCD, 0xDC};
static const alt_u8 TRAILER2[] = {0x57, 0x58};
static const alt_u8 HEADER3[]  = {0xEF, 0xFE};
static const alt_u8 TRAILER3[] = {0x53, 0x54};

typedef enum {
    EXPECTING_HEADER,
    EXPECTING_PAYLOAD,
    EXPECTING_TRAILER
} State;

// -------- BASE 版本（與你原本行為相同）--------
alt_u8* readDataDynamic(alt_u16* try_cnt)
{
    static alt_u8 buffer[BUFFER_SIZE];
    static alt_u8 bytes_received = 0;
    static State state = EXPECTING_HEADER;
    static alt_u8 condition = 0;
    static alt_u8 data_size_expected = 0;
    static const alt_u8* expected_trailer = NULL;
    static alt_u8 trailer_size = 0;

    if (uartAvailable() == 0) return NULL;
    int data = uartGetByte();

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
            buffer[bytes_received + 1] = (alt_u8)data;
            bytes_received++;
            if (bytes_received >= data_size_expected) {
                state = EXPECTING_TRAILER;
                bytes_received = 0;
            }
            break;

        case EXPECTING_TRAILER:
            if ((alt_u8)data != expected_trailer[bytes_received]) {
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

// -------- DBG 版本（僅把 uartAvailable/GetByte 換成 *_dbg）--------
alt_u8* readDataDynamic_dbg(alt_u16* try_cnt)
{
    static alt_u8 buffer[BUFFER_SIZE];
    static alt_u8 bytes_received = 0;
    static State state = EXPECTING_HEADER;
    static alt_u8 condition = 0;
    static alt_u8 data_size_expected = 0;
    static const alt_u8* expected_trailer = NULL;
    static alt_u8 trailer_size = 0;

    if (uartAvailable_dbg() == 0) return NULL;
    int data = uartGetByte_dbg();

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
            buffer[bytes_received + 1] = (alt_u8)data;
            bytes_received++;
            if (bytes_received >= data_size_expected) {
                state = EXPECTING_TRAILER;
                bytes_received = 0;
            }
            break;

        case EXPECTING_TRAILER:
            if ((alt_u8)data != expected_trailer[bytes_received]) {
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