/***
 * uart_V2.h
 * Version: V2.0
 * Date: 2025/07/21
 * Author: ChatGPT for Adam
 *
 * Changelog:
 * - V2.0: 支援第二組 UART（Debug）
 *         並將所有 UART 操作相關 API 整合於此 header 中
 *         改為使用環狀緩衝區並支援格式化輸出與封包解析
 *
 * 使用說明：
 * 
 * 1️ 初始化 UART
 *     void uartInit(void);
 *     - 初始化 Main UART 與 Debug UART
 *     - 建議在 main() 一開始執行： uartInit();
 *
 * 2️ 傳送資料（Main UART）
 *     void uartPutByte(uint8_t data);              // 傳送單一 byte
 *     void uartWrite(uint8_t* buf, uint8_t len);   // 傳送多 byte
 *     void uartWrite_r(uint8_t* buf, uint8_t len); // 反向傳送
 *     void uartPrintf(const char* fmt, ...);       // 格式化輸出
 *
 * 3️ 傳送資料（Debug UART）
 *     void uartPutByte_dbg(uint8_t data);
 *     void uartWrite_dbg(uint8_t* buf, uint8_t len);
 *     void uartWrite_dbg_r(uint8_t* buf, uint8_t len);
 *     void uartPrintf_dbg(const char* fmt, ...);
 *
 * 4️ 接收資料
 *     int uartAvailable(int is_debug);   // RX buffer 可用資料數
 *     int uartGetByte(int is_debug);     // 非阻塞讀取 1 byte（無資料回傳 -1）
 *     int uartGetc(int is_debug);        // 阻塞直到收到 1 byte
 *         ➤ 用法範例：
 *           uint8_t b = uartGetc(0); // 取得主 UART 傳來的下一個 byte
 *
 * 5️ 封包解析（讀取完整封包）
 *     uint8_t* readDataDynamic(int is_debug, uint16_t* try_cnt);
 *     - 傳回指向資料的指標（格式為：type + payload），否則 NULL
 *     - try_cnt 為錯誤次數計數器指標
 *
 *  is_debug 說明：
 *     is_debug = 0 ➜ 操作主 UART（UART_BASE）
 *     is_debug = 1 ➜ 操作 Debug UART（UART_DBG_BASE）
 */


#ifndef __UART_V2_H
#define __UART_V2_H

#include "system.h"
#include "alt_types.h"
#include "altera_avalon_uart_regs.h"
#include "sys/alt_irq.h"
#include <stdint.h>
#include <stdarg.h>

#ifdef __cplusplus
extern "C" {
#endif

// 初始化 Main 與 Debug UART 並註冊中斷服務程式
void uartInit(void);

// Main UART 輸出函數
void uartPutByte(uint8_t data);                      // 傳送 1 byte 資料
void uartWrite(uint8_t* buf, uint8_t len);           // 傳送多 byte 資料
void uartWrite_r(uint8_t* buf, uint8_t len);         // 反向傳送資料
void uartPrintf(const char* fmt, ...);               // 格式化輸出

// Debug UART 輸出函數
void uartPutByte_dbg(uint8_t data);                  // 傳送 1 byte 至 debug UART
void uartWrite_dbg(uint8_t* buf, uint8_t len);       // 傳送多 byte 至 debug UART
void uartWrite_dbg_r(uint8_t* buf, uint8_t len);     // 反向傳送至 debug UART
void uartPrintf_dbg(const char* fmt, ...);           // 格式化輸出至 debug UART

// 接收相關 API（為支援解析資料）
int uartAvailable(int is_debug);                     // 傳回 RX buffer 中可用的 byte 數
int uartGetByte(int is_debug);                       // 取得 1 byte，若無資料傳回 -1
int uartGetc(int is_debug);                          // 等待直到接收到 1 byte

// 特定封包讀取函數（支援三種不同 Header 封包結構）
uint8_t* readDataDynamic(int is_debug, uint16_t* try_cnt);  // 從 Main 或 Debug UART 擷取封包資料

#ifdef __cplusplus
}
#endif

#endif /* __UART_V2_H */
