#ifndef __HINS_H
#define __HINS_H

/******** NIOS II Variable IP address definition*******/
#include "nios2_var_addr.h"

#define TOP_VERSION  "LGSM_TOP_V1"
#define NIOS_VERSION "LGSM_CPU_V1_0"
#define JIC_VERSION  "LGSM_2026-03-13"
#define FPGA_VERSION TOP_VERSION "," NIOS_VERSION "," JIC_VERSION "\n"

#define VARSET_BASE VARSET_1_BASE
#define SYNC_15HZ  3333333
#define SYNC_50HZ  1e6
#define SYNC_100HZ 5e5
#define SYNC_200HZ 2.5e5

/******** my Library *******/

// commonly used type define and funciotn
#include "common.h"
#include "acq_rst.h"

#include "output_fn.h"

#include "output_mode.h"
// uart
#include "uart_dual.h"
// adda
#include "adda_config.h"
//memory_manage
#include "memory_manage.h"
//eeprom
//#include "eeprom.h"
#include "eeprom_v2.h"

#include "ads122c04_se.h"
#include "asm330lhhx.h"



#endif // __HINS_H





