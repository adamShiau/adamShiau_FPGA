#include "memory_manage.h"

const mem_unit_t fog_parameter_init[PAR_LEN] = {
    { .data.int_val = INIT_MOD_FREQ,         .type = TYPE_INT }, //0
    { .data.int_val = INIT_MOD_AMP_H,        .type = TYPE_INT }, //1
    { .data.int_val = INIT_MOD_AMP_L,        .type = TYPE_INT }, //2
    { .data.int_val = INIT_POLARITY,         .type = TYPE_INT }, //3
    { .data.int_val = INIT_WAIT_CNT,         .type = TYPE_INT }, //4
    { .data.int_val = INIT_ERR_AVG,          .type = TYPE_INT }, //5
    { .data.int_val = INIT_GAIN1,            .type = TYPE_INT }, //6
    { .data.int_val = INIT_CONST_STEP,       .type = TYPE_INT }, //7
    { .data.int_val = INIT_FB_ON,            .type = TYPE_INT }, //8
    { .data.int_val = INIT_GAIN2,            .type = TYPE_INT }, //9
    { .data.int_val = INIT_ERR_OFFSET,       .type = TYPE_INT }, //10
    { .data.int_val = INIT_DAC_GAIN,         .type = TYPE_INT }, //11
    { .data.int_val = INIT_CUT_OFF,        .type = TYPE_FLOAT }, //12
    { .data.int_val = INIT_OUT_TH,           .type = TYPE_INT }, //13
    { .data.int_val = INIT_OUT_TH_EN,        .type = TYPE_INT }, //14
    { .data.int_val = INIT_SF_COMP_T1,     .type = TYPE_FLOAT }, //15
    { .data.int_val = INIT_SF_COMP_T2,     .type = TYPE_FLOAT }, //16
    { .data.int_val = INIT_SF_1_SLOPE,     .type = TYPE_FLOAT }, //17
    { .data.int_val = INIT_SF_1_OFFSET,    .type = TYPE_FLOAT }, //18
    { .data.int_val = INIT_SF_2_SLOPE,     .type = TYPE_FLOAT }, //19
    { .data.int_val = INIT_SF_2_OFFSET,    .type = TYPE_FLOAT }, //20
    { .data.int_val = INIT_SF_3_SLOPE,     .type = TYPE_FLOAT }, //21
    { .data.int_val = INIT_SF_3_OFFSET,    .type = TYPE_FLOAT }, //22
    { .data.int_val = INIT_BIAS_COMP_T1,   .type = TYPE_FLOAT }, //23
    { .data.int_val = INIT_BIAS_COMP_T2,   .type = TYPE_FLOAT }, //24
    { .data.int_val = INIT_BIAS_1_SLOPE,   .type = TYPE_FLOAT }, //25
    { .data.int_val = INIT_BIAS_1_OFFSET,  .type = TYPE_FLOAT }, //26
    { .data.int_val = INIT_BIAS_2_SLOPE,   .type = TYPE_FLOAT }, //27
    { .data.int_val = INIT_BIAS_2_OFFSET,  .type = TYPE_FLOAT }, //28
    { .data.int_val = INIT_BIAS_3_SLOPE,   .type = TYPE_FLOAT }, //29
    { .data.int_val = INIT_BIAS_3_OFFSET,  .type = TYPE_FLOAT }  //30
};

void initialize_fog_params(fog_parameter_t *fog_params) {
    // 設定序號
    strncpy(fog_params->sn, "NewParameter", sizeof(fog_params->sn) - 1);
    fog_params->sn[sizeof(fog_params->sn) - 1] = '\0'; // 確保結尾有空字符

    // 初始化 paramX, paramY, paramZ
    for (int i = 0; i < PAR_LEN; i++) {
        fog_params->paramX[i].data.int_val = fog_parameter_init[i].data.int_val;
        fog_params->paramY[i].data.int_val = fog_parameter_init[i].data.int_val;
        fog_params->paramZ[i].data.int_val = fog_parameter_init[i].data.int_val;

        fog_params->paramX[i].type = fog_parameter_init[i].type;
        fog_params->paramY[i].type = fog_parameter_init[i].type;
        fog_params->paramZ[i].type = fog_parameter_init[i].type;
    }
}

