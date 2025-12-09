/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'nios2' in SOPC Builder design 'CPU'
 * SOPC Builder design path: ../../CPU.sopcinfo
 *
 * Generated: Tue Dec 09 22:42:44 CST 2025
 */

/*
 * DO NOT MODIFY THIS FILE
 *
 * Changing this file will have subtle consequences
 * which will almost certainly lead to a nonfunctioning
 * system. If you do modify this file, be aware that your
 * changes will be overwritten and lost when this file
 * is generated again.
 *
 * DO NOT MODIFY THIS FILE
 */

/*
 * License Agreement
 *
 * Copyright (c) 2008
 * Altera Corporation, San Jose, California, USA.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This agreement shall be governed in all respects by the laws of the State
 * of California and by the laws of the United States of America.
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* Include definitions from linker script generator */
#include "linker.h"


/*
 * CPU configuration
 *
 */

#define ALT_CPU_ARCHITECTURE "altera_nios2_gen2"
#define ALT_CPU_BIG_ENDIAN 0
#define ALT_CPU_BREAK_ADDR 0x02001820
#define ALT_CPU_CPU_ARCH_NIOS2_R1
#define ALT_CPU_CPU_FREQ 100000000u
#define ALT_CPU_CPU_ID_SIZE 1
#define ALT_CPU_CPU_ID_VALUE 0x00000000
#define ALT_CPU_CPU_IMPLEMENTATION "tiny"
#define ALT_CPU_DATA_ADDR_WIDTH 0x1a
#define ALT_CPU_DCACHE_LINE_SIZE 0
#define ALT_CPU_DCACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_DCACHE_SIZE 0
#define ALT_CPU_EXCEPTION_ADDR 0x01000020
#define ALT_CPU_FLASH_ACCELERATOR_LINES 0
#define ALT_CPU_FLASH_ACCELERATOR_LINE_SIZE 0
#define ALT_CPU_FLUSHDA_SUPPORTED
#define ALT_CPU_FREQ 100000000
#define ALT_CPU_HARDWARE_DIVIDE_PRESENT 0
#define ALT_CPU_HARDWARE_MULTIPLY_PRESENT 0
#define ALT_CPU_HARDWARE_MULX_PRESENT 0
#define ALT_CPU_HAS_DEBUG_CORE 1
#define ALT_CPU_HAS_DEBUG_STUB
#define ALT_CPU_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define ALT_CPU_HAS_JMPI_INSTRUCTION
#define ALT_CPU_ICACHE_LINE_SIZE 0
#define ALT_CPU_ICACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_ICACHE_SIZE 0
#define ALT_CPU_INST_ADDR_WIDTH 0x1a
#define ALT_CPU_NAME "nios2"
#define ALT_CPU_OCI_VERSION 1
#define ALT_CPU_RESET_ADDR 0x02001000


/*
 * CPU configuration (with legacy prefix - don't use these anymore)
 *
 */

#define NIOS2_BIG_ENDIAN 0
#define NIOS2_BREAK_ADDR 0x02001820
#define NIOS2_CPU_ARCH_NIOS2_R1
#define NIOS2_CPU_FREQ 100000000u
#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0x00000000
#define NIOS2_CPU_IMPLEMENTATION "tiny"
#define NIOS2_DATA_ADDR_WIDTH 0x1a
#define NIOS2_DCACHE_LINE_SIZE 0
#define NIOS2_DCACHE_LINE_SIZE_LOG2 0
#define NIOS2_DCACHE_SIZE 0
#define NIOS2_EXCEPTION_ADDR 0x01000020
#define NIOS2_FLASH_ACCELERATOR_LINES 0
#define NIOS2_FLASH_ACCELERATOR_LINE_SIZE 0
#define NIOS2_FLUSHDA_SUPPORTED
#define NIOS2_HARDWARE_DIVIDE_PRESENT 0
#define NIOS2_HARDWARE_MULTIPLY_PRESENT 0
#define NIOS2_HARDWARE_MULX_PRESENT 0
#define NIOS2_HAS_DEBUG_CORE 1
#define NIOS2_HAS_DEBUG_STUB
#define NIOS2_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define NIOS2_HAS_JMPI_INSTRUCTION
#define NIOS2_ICACHE_LINE_SIZE 0
#define NIOS2_ICACHE_LINE_SIZE_LOG2 0
#define NIOS2_ICACHE_SIZE 0
#define NIOS2_INST_ADDR_WIDTH 0x1a
#define NIOS2_OCI_VERSION 1
#define NIOS2_RESET_ADDR 0x02001000


/*
 * DAC_RST configuration
 *
 */

#define ALT_MODULE_CLASS_DAC_RST altera_avalon_pio
#define DAC_RST_BASE 0x2002280
#define DAC_RST_BIT_CLEARING_EDGE_REGISTER 0
#define DAC_RST_BIT_MODIFYING_OUTPUT_REGISTER 0
#define DAC_RST_CAPTURE 0
#define DAC_RST_DATA_WIDTH 1
#define DAC_RST_DO_TEST_BENCH_WIRING 0
#define DAC_RST_DRIVEN_SIM_VALUE 0
#define DAC_RST_EDGE_TYPE "NONE"
#define DAC_RST_FREQ 100000000
#define DAC_RST_HAS_IN 0
#define DAC_RST_HAS_OUT 1
#define DAC_RST_HAS_TRI 0
#define DAC_RST_IRQ -1
#define DAC_RST_IRQ_INTERRUPT_CONTROLLER_ID -1
#define DAC_RST_IRQ_TYPE "NONE"
#define DAC_RST_NAME "/dev/DAC_RST"
#define DAC_RST_RESET_VALUE 1
#define DAC_RST_SPAN 16
#define DAC_RST_TYPE "altera_avalon_pio"


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_EPCS_FLASH_CONTROLLER
#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_NEW_SDRAM_CONTROLLER
#define __ALTERA_AVALON_PIO
#define __ALTERA_AVALON_SPI
#define __ALTERA_AVALON_SYSID_QSYS
#define __ALTERA_AVALON_UART
#define __ALTERA_NIOS2_GEN2
#define __VARSET_60REG_2018P1


/*
 * System configuration
 *
 */

#define ALT_DEVICE_FAMILY "Cyclone IV E"
#define ALT_ENHANCED_INTERRUPT_API_PRESENT
#define ALT_IRQ_BASE NULL
#define ALT_LOG_PORT "/dev/null"
#define ALT_LOG_PORT_BASE 0x0
#define ALT_LOG_PORT_DEV null
#define ALT_LOG_PORT_TYPE ""
#define ALT_NUM_EXTERNAL_INTERRUPT_CONTROLLERS 0
#define ALT_NUM_INTERNAL_INTERRUPT_CONTROLLERS 1
#define ALT_NUM_INTERRUPT_CONTROLLERS 1
#define ALT_STDERR "/dev/jtag_uart"
#define ALT_STDERR_BASE 0x20022a8
#define ALT_STDERR_DEV jtag_uart
#define ALT_STDERR_IS_JTAG_UART
#define ALT_STDERR_PRESENT
#define ALT_STDERR_TYPE "altera_avalon_jtag_uart"
#define ALT_STDIN "/dev/jtag_uart"
#define ALT_STDIN_BASE 0x20022a8
#define ALT_STDIN_DEV jtag_uart
#define ALT_STDIN_IS_JTAG_UART
#define ALT_STDIN_PRESENT
#define ALT_STDIN_TYPE "altera_avalon_jtag_uart"
#define ALT_STDOUT "/dev/jtag_uart"
#define ALT_STDOUT_BASE 0x20022a8
#define ALT_STDOUT_DEV jtag_uart
#define ALT_STDOUT_IS_JTAG_UART
#define ALT_STDOUT_PRESENT
#define ALT_STDOUT_TYPE "altera_avalon_jtag_uart"
#define ALT_SYSTEM_NAME "CPU"


/*
 * VarSet_1 configuration
 *
 */

#define ALT_MODULE_CLASS_VarSet_1 VarSet_60reg_2018p1
#define VARSET_1_BASE 0x2002000
#define VARSET_1_IRQ -1
#define VARSET_1_IRQ_INTERRUPT_CONTROLLER_ID -1
#define VARSET_1_NAME "/dev/VarSet_1"
#define VARSET_1_SPAN 512
#define VARSET_1_TYPE "VarSet_60reg_2018p1"


/*
 * epcs configuration
 *
 */

#define ALT_MODULE_CLASS_epcs altera_avalon_epcs_flash_controller
#define EPCS_BASE 0x2001000
#define EPCS_IRQ 3
#define EPCS_IRQ_INTERRUPT_CONTROLLER_ID 0
#define EPCS_NAME "/dev/epcs"
#define EPCS_REGISTER_OFFSET 1024
#define EPCS_SPAN 2048
#define EPCS_TYPE "altera_avalon_epcs_flash_controller"


/*
 * hal configuration
 *
 */

#define ALT_INCLUDE_INSTRUCTION_RELATED_EXCEPTION_API
#define ALT_MAX_FD 32
#define ALT_SYS_CLK none
#define ALT_TIMESTAMP_CLK none


/*
 * jtag_uart configuration
 *
 */

#define ALT_MODULE_CLASS_jtag_uart altera_avalon_jtag_uart
#define JTAG_UART_BASE 0x20022a8
#define JTAG_UART_IRQ 1
#define JTAG_UART_IRQ_INTERRUPT_CONTROLLER_ID 0
#define JTAG_UART_NAME "/dev/jtag_uart"
#define JTAG_UART_READ_DEPTH 64
#define JTAG_UART_READ_THRESHOLD 8
#define JTAG_UART_SPAN 8
#define JTAG_UART_TYPE "altera_avalon_jtag_uart"
#define JTAG_UART_WRITE_DEPTH 64
#define JTAG_UART_WRITE_THRESHOLD 8


/*
 * sdram configuration
 *
 */

#define ALT_MODULE_CLASS_sdram altera_avalon_new_sdram_controller
#define SDRAM_BASE 0x1000000
#define SDRAM_CAS_LATENCY 3
#define SDRAM_CONTENTS_INFO
#define SDRAM_INIT_NOP_DELAY 0.0
#define SDRAM_INIT_REFRESH_COMMANDS 2
#define SDRAM_IRQ -1
#define SDRAM_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SDRAM_IS_INITIALIZED 1
#define SDRAM_NAME "/dev/sdram"
#define SDRAM_POWERUP_DELAY 100.0
#define SDRAM_REFRESH_PERIOD 15.625
#define SDRAM_REGISTER_DATA_IN 1
#define SDRAM_SDRAM_ADDR_WIDTH 0x17
#define SDRAM_SDRAM_BANK_WIDTH 2
#define SDRAM_SDRAM_COL_WIDTH 9
#define SDRAM_SDRAM_DATA_WIDTH 16
#define SDRAM_SDRAM_NUM_BANKS 4
#define SDRAM_SDRAM_NUM_CHIPSELECTS 1
#define SDRAM_SDRAM_ROW_WIDTH 12
#define SDRAM_SHARED_DATA 0
#define SDRAM_SIM_MODEL_BASE 0
#define SDRAM_SPAN 16777216
#define SDRAM_STARVATION_INDICATOR 0
#define SDRAM_TRISTATE_BRIDGE_SLAVE ""
#define SDRAM_TYPE "altera_avalon_new_sdram_controller"
#define SDRAM_T_AC 5.4
#define SDRAM_T_MRD 3
#define SDRAM_T_RCD 18.0
#define SDRAM_T_RFC 60.0
#define SDRAM_T_RP 18.0
#define SDRAM_T_WR 14.0


/*
 * spi_ADC configuration
 *
 */

#define ALT_MODULE_CLASS_spi_ADC altera_avalon_spi
#define SPI_ADC_BASE 0x2002220
#define SPI_ADC_CLOCKMULT 1
#define SPI_ADC_CLOCKPHASE 0
#define SPI_ADC_CLOCKPOLARITY 0
#define SPI_ADC_CLOCKUNITS "Hz"
#define SPI_ADC_DATABITS 16
#define SPI_ADC_DATAWIDTH 16
#define SPI_ADC_DELAYMULT "1.0E-9"
#define SPI_ADC_DELAYUNITS "ns"
#define SPI_ADC_EXTRADELAY 0
#define SPI_ADC_INSERT_SYNC 0
#define SPI_ADC_IRQ 2
#define SPI_ADC_IRQ_INTERRUPT_CONTROLLER_ID 0
#define SPI_ADC_ISMASTER 1
#define SPI_ADC_LSBFIRST 0
#define SPI_ADC_NAME "/dev/spi_ADC"
#define SPI_ADC_NUMSLAVES 1
#define SPI_ADC_PREFIX "spi_"
#define SPI_ADC_SPAN 32
#define SPI_ADC_SYNC_REG_DEPTH 2
#define SPI_ADC_TARGETCLOCK 1000000u
#define SPI_ADC_TARGETSSDELAY "0.0"
#define SPI_ADC_TYPE "altera_avalon_spi"


/*
 * spi_DAC configuration
 *
 */

#define ALT_MODULE_CLASS_spi_DAC altera_avalon_spi
#define SPI_DAC_BASE 0x2002200
#define SPI_DAC_CLOCKMULT 1
#define SPI_DAC_CLOCKPHASE 0
#define SPI_DAC_CLOCKPOLARITY 0
#define SPI_DAC_CLOCKUNITS "Hz"
#define SPI_DAC_DATABITS 16
#define SPI_DAC_DATAWIDTH 16
#define SPI_DAC_DELAYMULT "1.0E-9"
#define SPI_DAC_DELAYUNITS "ns"
#define SPI_DAC_EXTRADELAY 0
#define SPI_DAC_INSERT_SYNC 0
#define SPI_DAC_IRQ 6
#define SPI_DAC_IRQ_INTERRUPT_CONTROLLER_ID 0
#define SPI_DAC_ISMASTER 1
#define SPI_DAC_LSBFIRST 0
#define SPI_DAC_NAME "/dev/spi_DAC"
#define SPI_DAC_NUMSLAVES 1
#define SPI_DAC_PREFIX "spi_"
#define SPI_DAC_SPAN 32
#define SPI_DAC_SYNC_REG_DEPTH 2
#define SPI_DAC_TARGETCLOCK 1000000u
#define SPI_DAC_TARGETSSDELAY "0.0"
#define SPI_DAC_TYPE "altera_avalon_spi"


/*
 * sync_in configuration
 *
 */

#define ALT_MODULE_CLASS_sync_in altera_avalon_pio
#define SYNC_IN_BASE 0x2002290
#define SYNC_IN_BIT_CLEARING_EDGE_REGISTER 1
#define SYNC_IN_BIT_MODIFYING_OUTPUT_REGISTER 0
#define SYNC_IN_CAPTURE 1
#define SYNC_IN_DATA_WIDTH 1
#define SYNC_IN_DO_TEST_BENCH_WIRING 0
#define SYNC_IN_DRIVEN_SIM_VALUE 0
#define SYNC_IN_EDGE_TYPE "RISING"
#define SYNC_IN_FREQ 100000000
#define SYNC_IN_HAS_IN 1
#define SYNC_IN_HAS_OUT 0
#define SYNC_IN_HAS_TRI 0
#define SYNC_IN_IRQ 0
#define SYNC_IN_IRQ_INTERRUPT_CONTROLLER_ID 0
#define SYNC_IN_IRQ_TYPE "EDGE"
#define SYNC_IN_NAME "/dev/sync_in"
#define SYNC_IN_RESET_VALUE 0
#define SYNC_IN_SPAN 16
#define SYNC_IN_TYPE "altera_avalon_pio"


/*
 * sysid configuration
 *
 */

#define ALT_MODULE_CLASS_sysid altera_avalon_sysid_qsys
#define SYSID_BASE 0x20022a0
#define SYSID_ID 16777216
#define SYSID_IRQ -1
#define SYSID_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SYSID_NAME "/dev/sysid"
#define SYSID_SPAN 8
#define SYSID_TIMESTAMP 1765291210
#define SYSID_TYPE "altera_avalon_sysid_qsys"


/*
 * uart configuration
 *
 */

#define ALT_MODULE_CLASS_uart altera_avalon_uart
#define UART_BASE 0x2002260
#define UART_BAUD 115200
#define UART_DATA_BITS 8
#define UART_FIXED_BAUD 1
#define UART_FREQ 100000000
#define UART_IRQ 4
#define UART_IRQ_INTERRUPT_CONTROLLER_ID 0
#define UART_NAME "/dev/uart"
#define UART_PARITY 'N'
#define UART_SIM_CHAR_STREAM ""
#define UART_SIM_TRUE_BAUD 0
#define UART_SPAN 32
#define UART_STOP_BITS 1
#define UART_SYNC_REG_DEPTH 2
#define UART_TYPE "altera_avalon_uart"
#define UART_USE_CTS_RTS 0
#define UART_USE_EOP_REGISTER 0


/*
 * uart_dbg configuration
 *
 */

#define ALT_MODULE_CLASS_uart_dbg altera_avalon_uart
#define UART_DBG_BASE 0x2002240
#define UART_DBG_BAUD 115200
#define UART_DBG_DATA_BITS 8
#define UART_DBG_FIXED_BAUD 1
#define UART_DBG_FREQ 100000000
#define UART_DBG_IRQ 5
#define UART_DBG_IRQ_INTERRUPT_CONTROLLER_ID 0
#define UART_DBG_NAME "/dev/uart_dbg"
#define UART_DBG_PARITY 'N'
#define UART_DBG_SIM_CHAR_STREAM ""
#define UART_DBG_SIM_TRUE_BAUD 0
#define UART_DBG_SPAN 32
#define UART_DBG_STOP_BITS 1
#define UART_DBG_SYNC_REG_DEPTH 2
#define UART_DBG_TYPE "altera_avalon_uart"
#define UART_DBG_USE_CTS_RTS 0
#define UART_DBG_USE_EOP_REGISTER 0

#endif /* __SYSTEM_H_ */
