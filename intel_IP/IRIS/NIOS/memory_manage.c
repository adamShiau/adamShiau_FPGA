#include "memory_manage.h"


void initialize_fog_params(fog_parameter_t *fog_params) {
    // 設定序號
    strncpy(fog_params->sn, "NewParameter", sizeof(fog_params->sn) - 1);
    fog_params->sn[sizeof(fog_params->sn) - 1] = '\0'; // 確保結尾有空字符

    // 初始化 paramX, paramY, paramZ
    for (int i = 0; i < MEN_LEN; i++) {
        fog_params->paramX[i].data.int_val = fog_parameter_init[i].data.int_val;
        fog_params->paramY[i].data.int_val = fog_parameter_init[i].data.int_val;
        fog_params->paramZ[i].data.int_val = fog_parameter_init[i].data.int_val;

        fog_params->paramX[i].type = fog_parameter_init[i].type;
        fog_params->paramY[i].type = fog_parameter_init[i].type;
        fog_params->paramZ[i].type = fog_parameter_init[i].type;
    }
}

