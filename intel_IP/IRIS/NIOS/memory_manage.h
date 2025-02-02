#ifndef __MEMORY_MANAGE_H
#define __MEMORY_MANAGE_H

#include "alt_types.h"

#define MEN_LEN 40 // 定義陣列大小

typedef union
{
    float	float_val;
    alt_32  int_val;
    alt_u8  bin_val[4];
}mem_unit_t;

typedef struct {
    char sn[12];      // serial number，12 words
    mem_unit_t paramX[MEN_LEN];    // 參數X，大小由LEN決定
    mem_unit_t paramY[MEN_LEN];    // 參數Y，大小由LEN決定
    mem_unit_t paramZ[MEN_LEN];    // 參數Z，大小由LEN決定
} fog_parameter_t;


#define MEM_BASE_X 2
#define MEM_BASE_Y (MEM_BASE_X + MEN_LEN)
#define MEM_BASE_Z (MEM_BASE_Y + MEN_LEN)
// #define MEM_BASE_Y (MEM_BASE_X + MEN_LEN)
// #define MEM_BASE_Z (MEM_BASE_Y + MEN_LEN)

/*** initialization of FOG parameters */
#define INIT_MOD_FREQ          100
#define INIT_WAIT_CNT           20
#define INIT_ERR_AVG            5
#define INIT_MOD_AMP_H          3000 
#define INIT_MOD_AMP_L          -3000
#define INIT_ERR_OFFSET         0  
#define INIT_OUT_TH             0
#define INIT_POLARITY           1
#define INIT_CONST_STEP         5000 
#define INIT_GAIN1              5
#define INIT_GAIN2              4
#define INIT_FB_ON              1
#define INIT_DAC_GAIN           30
#define INIT_CUT_OFF            650
#define INIT_SF_COMP_T1         10 
#define INIT_SF_COMP_T2         50  
#define INIT_SF_1_SLOPE         0  
#define INIT_SF_1_OFFSET        1   
#define INIT_SF_2_SLOPE         0  
#define INIT_SF_2_OFFSET        1   
#define INIT_SF_3_SLOPE         0  
#define INIT_SF_3_OFFSET        1   
#define INIT_BIAS_COMP_T1       5  
#define INIT_BIAS_COMP_T2       40    
#define INIT_BIAS_1_SLOPE       0
#define INIT_BIAS_1_OFFSET      1
#define INIT_BIAS_2_SLOPE       0 
#define INIT_BIAS_2_OFFSET      1 
#define INIT_BIAS_3_SLOPE       0   
#define INIT_BIAS_3_OFFSET      1   

const alt_32 fog_parameter_init[MEN_LEN] = 
{
    INIT_MOD_FREQ           ,        
    INIT_WAIT_CNT           ,       
    INIT_ERR_AVG            ,     
    INIT_MOD_AMP_H          ,      
    INIT_MOD_AMP_L          ,    
    INIT_ERR_OFFSET         ,     
    INIT_OUT_TH             ,   
    INIT_POLARITY           , 
    INIT_CONST_STEP         ,   
    INIT_GAIN1              , 
    INIT_GAIN2              ,
    INIT_FB_ON              , 
    INIT_DAC_GAIN           ,  
    INIT_CUT_OFF            ,  
    INIT_SF_COMP_T1         ,   
    INIT_SF_COMP_T2         ,   
    INIT_SF_1_SLOPE         ,   
    INIT_SF_1_OFFSET        ,  
    INIT_SF_2_SLOPE         , 
    INIT_SF_2_OFFSET        ,  
    INIT_SF_3_SLOPE         , 
    INIT_SF_3_OFFSET        ,  
    INIT_BIAS_COMP_T1       , 
    INIT_BIAS_COMP_T2       ,   
    INIT_BIAS_1_SLOPE       ,   
    INIT_BIAS_1_OFFSET      ,  
    INIT_BIAS_2_SLOPE       ,   
    INIT_BIAS_2_OFFSET      ,  
    INIT_BIAS_3_SLOPE       ,   
    INIT_BIAS_3_OFFSET      
};

enum {
    MOD_FREQ = 8,
    WAIT_CNT,
    ERR_AVG,
    MOD_AMP_H,
    MOD_AMP_L,
    CUT_OFF = 22
};

void initialize_fog_params(fog_parameter_t *fog_params);

extern fog_parameter_t fog_params; // 全域變數宣告

#endif/* __MEMORY_MANAGE_H */