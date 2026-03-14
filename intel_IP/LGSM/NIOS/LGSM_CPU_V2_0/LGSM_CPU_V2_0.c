#include <stdio.h>
#include <stdlib.h>  // malloc(), free()
#include <string.h>  // memcpy()
#include "sys/alt_irq.h"
#include "system.h"
#include "altera_avalon_uart_regs.h"
#include "HINS.h"

#define COE_TIMER 0.0001

void TRIGGER_IRQ_init(void);
void IRQ_TRIGGER_ISR(void *context);
void update_HINS_config_to_HW_REG(void);
void update_sensor_data(my_sensor_t *data); 
void monitor_reg(void);
void dbg_mems(my_sensor_t *data);
static float convert_PDtemp2f(alt_16 PD_temp);


const alt_u8 cmd_header[2] = {0xAB, 0xBA};
const alt_u8 cmd_trailer[2] = {0x55, 0x56};
static alt_u16 try_cnt;

volatile alt_u8 trigger_sig = 0;

my_float_t my_f;


static const float SF_ACCL_2G	= 0.061e-3F;
static const float SF_ACCL_4G	=0.122e-3F;
static const float SF_ACCL_8G	=0.244e-3F;
static const float SF_ACCL_16G	=0.488e-3F;

static const float SF_GYRO_125DPS	=4.37e-3F;
static const float SF_GYRO_250DPS	=8.75e-3F;
static const float SF_GYRO_500DPS	=17.5e-3F;
static const float SF_GYRO_1000DPS	=35e-3F;
static const float SF_GYRO_2000DPS	=70e-3F;
static const float SF_GYRO_4000DPS	=140e-3F;
static const float SF_TEMP =0.00390625F;
static const float COE_TEMP_AD590 = 0.00007165585;

// Definition and initialization of my_cmd, structure type is defined in common.h
cmd_ctrl_t my_cmd = {
	.condition = RX_CONDITION_INIT,
	.SN = {0},
    .complete = 0,
    .mux = MUX_ESCAPE,
    .select_fn = SEL_IDLE,
    .ch = 0,
    .cmd = 0,
	.run = 0,
    .value = 0,
	.sync_mode = 0
};

// Definition and initialization of auto_rst, structure type is defined in common.h
auto_rst_t auto_rst = {
	.status = 0,
	.fn_mode = MODE_RST
};

// Definition of a function pointer for output processing.  
// Initialized to NULL to prevent undefined behavior.  
// The assigned function will be implemented in output_fn.c.  
fn_ptr output_fn = acq_rst;

// Definition and initialization of sensor, structure type is defined in common.h
my_sensor_t sensor_data = {
    .fog = {
        .fogz = { .err = { .int_val = 0 }, .step = { .int_val = 0 }}
    },
	.time = {.time.float_val = 0},
    .PD_temp = 0,
	.ads122c04 = {
        .ain0.float_val = 0,    //FOG Temp
		.ain1.float_val = 0,    //VIN_MON
		.ain2.float_val = 0,    //TACT_MON
		.ain3.float_val = 0     //PUMP_PD0
	},
	.asm330lhhx = {
        .wx.float_val = 0,
		.wy.float_val = 0,
		.wz.float_val = 0,
		.ax.float_val = 0,
		.ay.float_val = 0,
		.az.float_val = 0,
		.temp.float_val = 0
	}
};

static const unsigned char HD_ABBA[2] = {0xAB, 0xBA};
int main(void)
{

    fog_parameter_t fog_params;	 //parameter container
    memset(&fog_params, 0, sizeof(fog_parameter_t));

    DEBUG_PRINT("Running IRIS CPU!\n");
	// printf("Running IRIS CPU!\n");
    

    DEBUG_PRINT("TRIGGER_IRQ_init\n");
	crc32_init_table();
	TRIGGER_IRQ_init();
	// printf("uartInit\n");
    DEBUG_PRINT("uartInit\n");
	uartInit(); //interrupt method of uart defined in uart.c not main()
	// printf("init_ADDA\n");
	DEBUG_PRINT("init_ADDA\n");
    set_DAC_reset();
	usleep(50);
	clear_DAC_reset();
	init_ADDA();
	// printf("init_EEPROM\n");
    DEBUG_PRINT("init_EEPROM\n");
	init_EEPROM();
	// printf("init_ADS122C04_TEMP\n");
    DEBUG_PRINT("init_ADS122C04_TEMP\n");
	init_ADS122C04_TEMP();
    init_ASM330LHHX();
    DEBUG_PRINT("initialize_fog_params_type\n");
	// initialize_fog_params_type(&fog_params);

    // LOAD_FOG_PARAMETER(&fog_params);
	// LOAD_FOG_MISALIGNMENT(&fog_params);
    // LOAD_CONFIG(&fog_params);
	// LOAD_FOG_SN(&fog_params);
	
	// update_fog_parameters_to_HW_REG(MEM_BASE_X, &fog_params); 

    // update_config_to_HW_REG(&fog_params); 

    // IOWR(VARSET_BASE, var_timer_rst, 1);
    // for(int i=0; i<100; i++) {} 
    // IOWR(VARSET_BASE, var_timer_rst, 0);
    
	DEBUG_PRINT("init all done\n");

    uint8_t cnt=0;
    while(1)
    {
		
        // monitor_reg();
        get_uart_cmd(readDataDynamic(&try_cnt), &my_cmd);
        // get_uart_cmd(readDataDynamic_dbg(&try_cnt), &my_cmd);
        cmd_mux(&my_cmd);
        fog_parameter_legacy(&my_cmd, &fog_params);
        output_mode_setting(&my_cmd, &output_fn, &auto_rst);
        if (trigger_sig == 1) 
        {
            // DEBUG_PRINT("TEST SYNC: %d\n", cnt++);
            update_sensor_data(&sensor_data);
            output_fn(&my_cmd, sensor_data, fog_params);
            trigger_sig = 0;
        }

    }

    return 0;
}

void monitor_reg()
{
    static alt_u32 dly_cnt = 0;
    static const DELAY_NUM = 5000;

    if(dly_cnt++ > DELAY_NUM) {
        dly_cnt = 0;
        // DEBUG_PRINT("i_err: %d, ", IORD(VARSET_BASE, i_var_err));
        // DEBUG_PRINT("step: %d\n", IORD(VARSET_BASE, i_var_step));
        DEBUG_PRINT("time: %d\n", IORD(VARSET_BASE, i_var_timer));
        // DEBUG_PRINT("AIN0: %d\n",(float)IORD(VARSET_BASE, i_var_i2c_ads122c04_rdata_1)*3.3/8388608.0);
        // DEBUG_PRINT("AIN1: %d\n",(float)IORD(VARSET_BASE, i_var_i2c_ads122c04_rdata_2)*3.3/8388608.0);
        // DEBUG_PRINT("AIN2: %d\n",(float)IORD(VARSET_BASE, i_var_i2c_ads122c04_rdata_3)*3.3/8388608.0);
        // DEBUG_PRINT("AIN3: %d\n",(float)IORD(VARSET_BASE, i_var_i2c_ads122c04_rdata_4)*3.3/8388608.0);
    }
}

void dbg_mems(my_sensor_t *data)
{
    static alt_u32 dly_cnt = 0;
    static const DELAY_NUM = 100;

    if(dly_cnt++ > DELAY_NUM) {
        dly_cnt = 0;
        float mems_wx = (float)data->asm330lhhx.wx.int_val * SF_GYRO_1000DPS;
        float mems_wy = (float)data->asm330lhhx.wy.int_val * SF_GYRO_1000DPS;
        float mems_wz = (float)data->asm330lhhx.wz.int_val * SF_GYRO_1000DPS;
        float mems_ax = (float)data->asm330lhhx.ax.int_val * SF_ACCL_16G;
        float mems_ay = (float)data->asm330lhhx.ay.int_val * SF_ACCL_16G;
        float mems_az = (float)data->asm330lhhx.az.int_val * SF_ACCL_16G;
        float mems_temp = (float)data->asm330lhhx.temp.int_val * SF_TEMP + 25.0;
        float fog_temp = (float)data->ads122c04.ain0.int_val * COE_TEMP_AD590 - 273.15; 

        DEBUG_PRINT("%f,%f,%f,%f,%f,%f,%f,%f\n", 
            mems_wx, mems_wy, mems_wz,
            mems_ax, mems_ay, mems_az,
            mems_temp, fog_temp
        );
    }
}

void update_sensor_data(my_sensor_t *data) {
    /***---timer--- */
    // data->time.time.float_val = (float)IORD(VARSET_BASE, i_var_timer) * COE_TIMER;
    data->time.time.int_val = IORD(VARSET_BASE, i_var_timer);
    // DEBUG_PRINT("time: %d\n", data->time.time.int_val);

    /***---PD_temp--- */
    data->PD_temp = ds1775_9B_readTemp_d();
    // float PD_temp_f = convert_PDtemp2f(data->PD_temp);
    // DEBUG_PRINT("PD_temp: %f\n", PD_temp_f);

    /***---fog z axis--- */
    data->fog.fogz.err.int_val = IORD(VARSET_BASE, i_var_err); 
    data->fog.fogz.step.int_val = IORD(VARSET_BASE, i_var_step);
    data->fog.fogz.step_H.int_val = IORD(VARSET_BASE, i_var_accu_step_H);
    data->fog.fogz.step_L.int_val = IORD(VARSET_BASE, i_var_accu_step_L);
    data->fog.fogz.step_cnt.int_val = IORD(VARSET_BASE, i_var_accu_step_cnt);
    // DEBUG_PRINT("%d, %d, %d\n", IORD(VARSET_BASE, i_var_accu_step_L), IORD(VARSET_BASE, i_var_accu_step_H), IORD(VARSET_BASE, i_var_accu_step_cnt));
}



// void update_HINS_config_to_HW_REG()
// {
// 	// IOWR(VARSET_BASE, var_sync_count, SYNC_100HZ); // set sync data rate
//     IOWR(VARSET_BASE, var_timer_rst, 1);
//     for(int i=0; i<100; i++) {} 
//     IOWR(VARSET_BASE, var_timer_rst, 0);
// }

void TRIGGER_IRQ_init()
{
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(SYNC_IN_BASE, 1); //clear edge capture register
	IOWR_ALTERA_AVALON_PIO_IRQ_MASK(SYNC_IN_BASE, 1); //enable irq mask
	alt_ic_isr_register(
	SYNC_IN_IRQ_INTERRUPT_CONTROLLER_ID,
	SYNC_IN_IRQ,
	IRQ_TRIGGER_ISR,
	0x0,
	0x0);
}

void IRQ_TRIGGER_ISR(void *context)
{
	(void) context;
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(SYNC_IN_BASE, 1); //clear edge capture register
	trigger_sig = 1;
}

static float convert_PDtemp2f(alt_16 PD_temp)
{
	alt_u8 Hbyte = PD_temp>>8;
	alt_u8 Lbyte = PD_temp;

	if(Hbyte>>7) {
		return (float)Hbyte - 256.0 + (float)(Lbyte>>7)*0.5;
	}
	else return (float)Hbyte + (float)(Lbyte>>7)*0.5;
}
