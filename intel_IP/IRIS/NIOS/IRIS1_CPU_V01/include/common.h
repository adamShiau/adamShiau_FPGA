#ifndef __COMMON_H
#define __COMMON_H

#include "alt_types.h"
#include "system.h"
#include "altera_avalon_uart_regs.h"
#include "memory_manage.h"
#include "nios2_var_addr.h"
#include "adda_config.h"

//  #define DEBUG
//  #define INFO
#define UART_DEBUG

#ifdef DEBUG
    #define DEBUG_PRINT(...) printf(__VA_ARGS__)
#else
    #define DEBUG_PRINT(...)
#endif

#ifdef INFO
    #define INFO_PRINT(...) printf(__VA_ARGS__)
#else
    #define INFO_PRINT(...)
#endif

#ifdef UART_DEBUG
    #define UART_PRINT(...) uart_printf_dbg(__VA_ARGS__)
#else
    #define UART_PRINT(...)
#endif

#define PRINT_1(...)  do { \
    DEBUG_PRINT(__VA_ARGS__); \
    UART_PRINT(__VA_ARGS__);  \
} while (0)

#define VARSET_BASE VARSET_1_BASE

#define WIDTH_32 32
#define TOPBIT_32 (1 << (WIDTH_32 - 1))
#define POLYNOMIAL_32 0x04C11DB7

#define MUX_OUTPUT		    0
#define MUX_PARAMETER	    1
#define MUX_ESCAPE		    2
#define MUX_DEFAULT       3

#define SEL_IDLE      0
#define SEL_RST			  1
#define SEL_FOG 		  2
#define SEL_FOG_2		  3
#define SEL_FOG_3 		4
#define SEL_IMU 		  5
#define SEL_NMEA	 		6
#define SEL_FOG_PARA  7
#define SEL_HP_TEST 	8
#define SEL_ATT_NMEA 	9

#define MODE_RST 	        0
#define MODE_FOG	        1
#define MODE_IMU	        2
#define MODE_FOG_HP_TEST	3
#define MODE_NMEA		    4
#define MODE_ATT_NMEA		5
#define MODE_FOG_PARAMETER  6

/*** ADC convertion coefficient */
#define ADC_CONV_TEMP 0.00004447005 // 2.048/8388608.0*1000.0/5.49
#define ADC_SCALE_INT     4447       // 0.00004447005 × 100,000,000
#define ADC_SCALE_DIV     100000000  // 將結果縮回來
#define TEMP_OFFSET_x1000 273150     // 273.15 × 1000

/*** ADXL357 convertion coefficient */
#define ADXL357_SCALE_SHIFT 20
#define ADXL357_SCALE_INT 41 

// Moving Average structure
typedef struct {
  float *buffer;
  alt_u32 window_size;
  alt_u32 index;
  float sum;
} MovingAverage_t;

typedef union
{
  float float_val;
  alt_u8 bin_val[4];
  alt_32 int_val;
}
my_float_t;

typedef enum {
  RX_CONDITION_INIT,  
  RX_CONDITION_ABBA_5556,
  RX_CONDITION_CDDC_5758,
} rx_condition_t;

/*** cmd control structure delaration */
typedef struct
{
  rx_condition_t condition;
  alt_u8 SN[13];
  alt_u8 complete;
  alt_u8 mux;
  alt_u8 select_fn;
  alt_u8 ch;
  alt_u8 cmd;
  alt_u8 run;
  alt_32 value;
}cmd_ctrl_t;

typedef enum {
  X_AXIS = 1,
  Y_AXIS,
  Z_AXIS,
  MIS_CALI_GYRO,
  MIS_CALI_ACCL
} CH_t;


/*** sensor data structure delaration */
typedef struct {
  my_float_t err; 
  my_float_t step;     
} fog_component_t;

typedef struct {
  fog_component_t fogx;
  fog_component_t fogy;
  fog_component_t fogz;
} fog_t;

typedef struct {
  my_float_t tempx;  
  my_float_t tempy; 
  my_float_t tempz; 
} temp_t;

typedef struct {
  my_float_t time;  
} my_time_t;

typedef struct {
  my_float_t ax;  
  my_float_t ay; 
  my_float_t az; 
  my_float_t temp;
} accl_t;

typedef struct 
{
  my_time_t time;
  fog_t fog;
  temp_t temp;
  accl_t adxl357;
}my_sensor_t;

typedef struct {
  my_float_t x;
  my_float_t y;
  my_float_t z;
} calibrated_data_t;



// typedef struct cmd_ctrl_t cmd_ctrl_t;

/*** auto reset structure delaration */
typedef struct {
  alt_u8 status;
  alt_u8 fn_mode;
} auto_rst_t;


void moving_average_init(MovingAverage_t *, alt_u32); 
float moving_average_update(MovingAverage_t *, float);
void moving_average_free(MovingAverage_t *);

void sendTx(alt_32);
void checkByte(alt_u8);
void checkByte_dbg(alt_u8);
void uart_printf(const char *format, ...);
void uart_printf_dbg(const char *format, ...);
void SerialWrite(alt_u8* buf, alt_u8 num); 
void SerialWrite_dbg(alt_u8* buf, alt_u8 num); 
void SerialWrite_r(alt_u8* buf, alt_u8 num); 
 int IEEE_754_F2INT(float in);
void crc32_init_table();
// void crc_32_bitwise(const alt_u8* message, alt_u8 nBytes, alt_u8* crc);
void crc_32(const alt_u8* message, alt_u8 nBytes, alt_u8* crc);
void print_crc(const char* label, alt_u8* crc);
void Set_Dac_Gain_x(alt_32 gain);
void Set_Dac_Gain_y(alt_32 gain);
void Set_Dac_Gain_z(alt_32 gain);

void get_uart_cmd(alt_u8*, cmd_ctrl_t*);
void cmd_mux(cmd_ctrl_t*);
void fog_parameter(cmd_ctrl_t*, fog_parameter_t*);
void update_fog_parameters_to_HW_REG(alt_u8, fog_parameter_t*);

void dump_fog_param(fog_parameter_t* fog_inst, alt_u8 ch);
void dump_misalignment_param(fog_parameter_t* fog_inst);
void dump_SN(fog_parameter_t* fog_inst);
void send_json_uart(const char* buffer);

void set_MUX_RS422(void);
void set_MUX_RS232(void);
void set_MUX_CAN(void);


float SF_temp_compensation_1st_order_fog(my_sensor_t, fog_parameter_t, CH_t);
float SF_temp_compensation_1st_order_adxl357(my_sensor_t, fog_parameter_t, CH_t);

float BIAS_temp_compensation_1st_order_fog_3T(my_sensor_t, fog_parameter_t, CH_t);
float BIAS_temp_compensation_1st_order_adxl357(my_sensor_t, fog_parameter_t, CH_t);

// misalignment calibration
calibrated_data_t misalignment_calibration(float , float , float , fog_parameter_t , CH_t );

// first order temperature compensation, one T
#define SF_TEMP_COMPENSATION_1ST_ORDER(temp, slope, offset) ((temp) * (slope) + (offset))

// first order temperature compensation, three T
#define BIAS_TEMP_COMPENSATION_1ST_ORDER_3T(temp, T1, T2, s1, o1, s2, o2, s3, o3) \
        (((temp) < (T1)) ? ((temp) * (s1) + (o1)) : \
        ((temp) < (T2)) ? ((temp) * (s2) + (o2)) : \
                        ((temp) * (s3) + (o3)))

#endif /* __COMMON_H */
