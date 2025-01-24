#ifndef __MEMORY_MANAGE_H
#define __MEMORY_MANAGE_H

#define MEN_LEN 40 // 定義陣列大小



typedef struct {
    char sn[12];      // serial number，12 words
    alt_32 paramX[MEN_LEN];    // 參數X，大小由LEN決定
    alt_32 paramY[MEN_LEN];    // 參數Y，大小由LEN決定
    alt_32 paramZ[MEN_LEN];    // 參數Y，大小由LEN決定
} fog_parameter_t;

// fog_parameter_t fog_params;

#define INIT_MOD_FREQ           100
#define INIT_WAIT_CNT           20
#define INIT_ERR_AVG            5
#define INIT_MOD_AMP_H          3000 
#define INIT_MOD_AMP_L          -3000
#define INIT_ERR_OFFSET         0  
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

// struct fog_parameter_init{
//     const alt_32 INIT_MOD_FREQ        ;
//     const alt_32 INIT_WAIT_CNT        ;
//     const alt_32 INIT_ERR_AVG        ;
//     const alt_32 INIT_MOD_AMP_H        ;
//     const alt_32 INIT_MOD_AMP_L       ;
//     const alt_32 INIT_ERR_OFFSET        ;
//     const alt_32 INIT_POLARITY       ;
//     const alt_32 INIT_CONST_STEP        ;
//     const alt_32 INIT_GAIN1       ;
//     const alt_32 INIT_GAIN2     ;
//     const alt_32 INIT_FB_ON       ;
//     const alt_32 INIT_DAC_GAIN      ;
//     const alt_32 INIT_CUT_OFF        ;
//     const alt_32 INIT_SF_COMP_T1       ;
//     const alt_32 INIT_SF_COMP_T2        ;
//     const alt_32 INIT_SF_1_SLOPE        ;
//     const alt_32 INIT_SF_1_OFFSET        ;
//     const alt_32 INIT_SF_2_SLOPE        ;
//     const alt_32 INIT_SF_2_OFFSET        ;
//     const alt_32 INIT_SF_3_SLOPE        ;
//     const alt_32 INIT_SF_3_OFFSET        ;
//     const alt_32 INIT_BIAS_COMP_T1      ;
//     const alt_32 INIT_BIAS_COMP_T2        ;
//     const alt_32 INIT_BIAS_1_SLOPE        ;
//     const alt_32 INIT_BIAS_1_OFFSET      ;
//     const alt_32 INIT_BIAS_2_SLOPE        ;
//     const alt_32 INIT_BIAS_2_OFFSET      ;
//     const alt_32 INIT_BIAS_3_SLOPE        ;
//     const alt_32 INIT_BIAS_3_OFFSET      ;
// }

// void initialize_fog_params(fog_parameter_t *fog_params) {
//     // 設定序號
//     strncpy(fog_params->sn, "NewParameter", sizeof(fog_params->sn) - 1);
//     fog_params->sn[sizeof(fog_params->sn) - 1] = '\0'; // 確保結尾有空字符

//     // 定義初始化陣列
//     alt_32 init_values[MEN_LEN] = {
//         INIT_MOD_FREQ, INIT_WAIT_CNT, INIT_ERR_AVG, INIT_MOD_AMP_H, INIT_MOD_AMP_L,
//         INIT_ERR_OFFSET, INIT_POLARITY, INIT_CONST_STEP, INIT_GAIN1, INIT_GAIN2,
//         INIT_FB_ON, INIT_DAC_GAIN, INIT_CUT_OFF, INIT_SF_COMP_T1, INIT_SF_COMP_T2,
//         INIT_SF_1_SLOPE, INIT_SF_1_OFFSET, INIT_SF_2_SLOPE, INIT_SF_2_OFFSET,
//         INIT_SF_3_SLOPE, INIT_SF_3_OFFSET, INIT_BIAS_COMP_T1, INIT_BIAS_COMP_T2,
//         INIT_BIAS_1_SLOPE, INIT_BIAS_1_OFFSET, INIT_BIAS_2_SLOPE, INIT_BIAS_2_OFFSET,
//         INIT_BIAS_3_SLOPE, INIT_BIAS_3_OFFSET
//     };

//     // 初始化 paramX, paramY, paramZ
//     for (int i = 0; i < MEN_LEN; i++) {
//         fog_params->paramX[i] = init_values[i];
//         fog_params->paramY[i] = init_values[i];
//         fog_params->paramZ[i] = init_values[i];
//     }
// }

void initialize_fog_params(fog_parameter_t *fog_params);

extern fog_parameter_t fog_params; // 全域變數宣告

/*** inst. fog oarameter  */
// fog_parameter_t fog_params;

// 初始化名稱
// snprintf(fog_params.sn, sizeof(fog_params.sn), "NewParameter");
// initialize_fog_params(&fog_params);

#endif/* __MEMORY_MANAGE_H */