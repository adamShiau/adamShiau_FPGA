#ifndef __IRIS1_V1_H
#define __IRIS1_V1_H

/******** NIOS II Variable IP address definition*******/
#include "nios2_var_addr.h"

#define VARSET_BASE VARSET_1_BASE
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
#include "adxl357.h"
#include "ads122c04_se.h"



#endif // __IRIS_V1_H





