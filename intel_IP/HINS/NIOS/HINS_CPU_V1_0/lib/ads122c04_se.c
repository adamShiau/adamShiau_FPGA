#include "ads122c04_se.h"
#define VARSET_BASE VARSET_1_BASE

/******** I2C device address*********/
#define I2C_DEV_ADDR	0x45 // 100_0101

/******** I2C lock rate definition*********/
#define CLK_97K 	 0
#define CLK_195K 	 1
#define CLK_390K 	 2
#define CLK_781K 	 3
#define CLK_1562K 	 4
#define CLK_3125K 	 5


/******** VAR Register*********/
#define	O_VAR_DEV_ADDR		var_i2c_ads122c04_dev_addr
#define O_VAR_W_DATA		var_i2c_ads122c04_w_data
#define O_VAR_I2C_CTRL		var_i2c_ads122c04_ctrl
#define O_VAR_REG_ADDR		var_i2c_ads122c04_reg_addr
#define O_VAR_I2C_STATUS	i_var_i2c_ads122c04_status
#define O_VAR_I2C_RDATA_1	i_var_i2c_ads122c04_rdata_1
#define O_VAR_I2C_RDATA_2	i_var_i2c_ads122c04_rdata_2
#define O_VAR_I2C_RDATA_3	i_var_i2c_ads122c04_rdata_3
#define O_VAR_I2C_RDATA_4	i_var_i2c_ads122c04_rdata_4


#define I2C_READ			0x1
#define I2C_WRITE			0x0

/**** CTRL ******/
#define ctrl_en_pos			0
// #define ctrl_rw_reg_pos		1
#define ctrl_op_mode_pos 	1
#define ctrl_clk_rate_pos	4
#define ctrl_finish_clear_pos	7

/**** STATUS ******/
#define status_ready_pos	0
#define status_finish_pos	1
#define status_state_pos	9

/**** RESET ******/
#define RESET	0x06

/*** WREG definition    ***/
#define WREG_CONFIG_0  0x40
#define WREG_CONFIG_1  0x44
#define WREG_CONFIG_2  0x48
#define WREG_CONFIG_3  0x4C

/*** RREG definition    ***/
#define RREG_CONFIG_0  0x20
#define RREG_CONFIG_1  0x24
#define RREG_CONFIG_2  0x28
#define RREG_CONFIG_3  0x2C

/***-------Configuraiton register */
// register 0 parameters
/*** MUX  */
#define MUX_AIN0_AVSS 	(8<<4)
/*** GAIN  */
#define GAIN_1		0
#define GAIN_2		(1<<1)
#define GAIN_4		(2<<1)
#define GAIN_8		(3<<1)
#define GAIN_16		(4<<1)
#define GAIN_32		(5<<1)
#define GAIN_64		(6<<1)
#define GAIN_128	(7<<1)
/*** PGA_BYPASS  */
#define PGA_ENABLE	0
#define PGA_DISABLE	1

// register 1 parameters
/*** Data Rate  */
#define DR_20_40		0
#define DR_45_90		(1<<5)
#define DR_90_180		(2<<5)
#define DR_175_350		(3<<5)
#define DR_330_660		(4<<5)
#define DR_600_1200		(5<<5)
#define DR_1000_2000	(6<<5)
/*** Operating mode  */
#define MODE_NORMAL		0
#define MODE_TURBO		(1<<4) 
/*** Conversion mode  */
#define CM_SINGLE_SHOT		0
#define CM_CONTINUOUS		(1<<3) 
/*** Voltage reference selection  */
#define VREF_INTERNAL		0
#define VREF_EXTERNAL		(1<<1) 
#define VREF_ANALOG_SUPPLY  (2<<1) 
/*** Temperature sensor mode  */
#define TS_DISABLE		0
#define TS_ENABLE		1

// register 2 parameters

/***-------End of configuraiton register 1 */


/*** OP mode***/
#define CPU_WREG	0
#define CPU_RREG	1
#define HW		    2
#define CPU_CMD		3

#define True 1
#define False 0

static alt_u32 dly_cnt = 0, number = 5000;
static const DELAY_NUM = 100000;

/***********help fucntion definition */
/******** I2C Clock Rate Lookup Table (Internal Use) *********/
typedef struct {
    alt_u8 reg_val;
    const char* freq_str;
} i2c_clk_map_t;

static const i2c_clk_map_t i2c_clk_table[] = {
	{CLK_97K,   "97 KHz"},
    {CLK_195K,  "195 KHz"},
    {CLK_390K,  "390 KHz"},
    {CLK_781K,  "781 KHz"},
    {CLK_1562K, "1.56 MHz"},
    {CLK_3125K, "3.12 MHz"}
};

static const char* get_i2c_freq_name(alt_u8 rate) {
    int i;
    for (i = 0; i < sizeof(i2c_clk_table)/sizeof(i2c_clk_table[0]); i++) {
        if (i2c_clk_table[i].reg_val == rate) {
            return i2c_clk_table[i].freq_str;
        }
    }
    return "Unknown Speed";
}

/***********high level definition */
// void init_ADS122C04_TEMP()
// {
// 	/*** configure the ADXL355/357 ***/
// 	I2C_clock_rate_sel_ADS122C04_TEMP(CLK_390K);

// 	I2C_sm_set_finish_clear_pulse_ADS122C04_TEMP(); // let finish starts at zero

// 	/*** RESET ***/
// 	I2C_write_ADS122C04_TEMP_cmd(RESET);

// 	/*** set ADS122C04 parameters ***/
// 	I2C_write_ADS122C04_TEMP_register(WREG_CONFIG_0, MUX_AIN0_AVSS|GAIN_1|PGA_DISABLE);
// 	I2C_read_ADS122C04_TEMP_register(RREG_CONFIG_0, 1);
	
// 	I2C_write_ADS122C04_TEMP_register(WREG_CONFIG_1, DR_20_40|MODE_NORMAL|CM_SINGLE_SHOT|VREF_ANALOG_SUPPLY|TS_DISABLE);
// 	I2C_read_ADS122C04_TEMP_register(RREG_CONFIG_1, 1);

// 	I2C_write_ADS122C04_TEMP_register(WREG_CONFIG_2, 0x00);
// 	I2C_read_ADS122C04_TEMP_register(RREG_CONFIG_2, 1);

// 	I2C_write_ADS122C04_TEMP_register(WREG_CONFIG_3, 0x00);
// 	I2C_read_ADS122C04_TEMP_register(RREG_CONFIG_3, 1);

// 	// test_ADS122C04();

// 	// setting mode 
// 	I2C_op_mode_sel_ADS122C04_TEMP(HW);
// 	// Set I2C device address
// 	I2C_set_device_addr_ADS122C04_TEMP(I2C_DEV_ADDR);
// 	// test_ADS122C04();
// }

void init_ADS122C04_TEMP()
{
    DEBUG_PRINT("\n==============================================\n");
    DEBUG_PRINT("     ADS122C04 Sensor Initialization          \n");
    DEBUG_PRINT("==============================================\n");

    // 1. 設定頻率
    alt_u8 I2C_CLK_rate = CLK_390K;
    I2C_clock_rate_sel_ADS122C04_TEMP(I2C_CLK_rate);
	
    DEBUG_PRINT("[ INFO ] I2C Clock Rate set to: %s (Val: %d)\n", 
                get_i2c_freq_name(I2C_CLK_rate), I2C_CLK_rate);

    I2C_sm_set_finish_clear_pulse_ADS122C04_TEMP(); 

    // 2. 執行重置
    I2C_write_ADS122C04_TEMP_cmd(RESET);
    usleep(1000); // 重置後等待穩定
    DEBUG_PRINT("[  OK  ] Global Reset command sent.\n");

    // 3. 定義配置清單 (與 ASM330 風格一致)
    struct {
        alt_u8 write_addr;
        alt_u8 read_addr;
        alt_u8 val;
        const char* label;
    } configs[] = {
        {WREG_CONFIG_0, RREG_CONFIG_0, MUX_AIN0_AVSS | GAIN_1 | PGA_DISABLE, "MUX/Gain Config: Gain 0, PGA disable"},
        {WREG_CONFIG_1, RREG_CONFIG_1, DR_20_40 | MODE_NORMAL | CM_SINGLE_SHOT | VREF_ANALOG_SUPPLY | TS_DISABLE, "DataRate: 20Hz, REF: AVDD"},
        {WREG_CONFIG_2, RREG_CONFIG_2, 0x00, "IDAC Config: OFF"},
        {WREG_CONFIG_3, RREG_CONFIG_3, 0x00, "IDAC MUX Config: disable"}
    };

    // 4. 執行配置並自動校驗
    int fail_count = 0;
    int total_configs = sizeof(configs) / sizeof(configs[0]);

    for(int i = 0; i < total_configs; i++) {
        if(I2C_write_verify_ADS122C04(configs[i].write_addr, configs[i].read_addr, configs[i].val) == 0) {
            DEBUG_PRINT("[  OK  ] %-25s | Val: 0x%02X\n", configs[i].label, configs[i].val);
        } else {
            DEBUG_PRINT("[FAILED] %-25s | Expected: 0x%02X\n", configs[i].label, configs[i].val);
            fail_count++;
        }
    }

    // 5. 模式切換
    if(fail_count == 0) {
        I2C_op_mode_sel_ADS122C04_TEMP(HW);
        I2C_set_device_addr_ADS122C04_TEMP(I2C_DEV_ADDR);
        DEBUG_PRINT("----------------------------------------------\n");
        DEBUG_PRINT("Status: ALL SUCCESS. Hardware mode active.\n");
    } else {
        DEBUG_PRINT("----------------------------------------------\n");
        DEBUG_PRINT("Status: INIT FAILED with %d errors.\n", fail_count);
    }
    DEBUG_PRINT("==============================================\n\n");
}

int I2C_write_verify_ADS122C04(alt_u8 w_addr, alt_u8 r_addr, alt_u8 data) {
    int retry = 3;
    alt_u8 read_val;

    while(retry--) {
        I2C_write_ADS122C04_TEMP_register(w_addr, data);
        usleep(1000);
        read_val = I2C_read_ADS122C04_TEMP_register(r_addr, 0);
        
        if(read_val == data) return 0;
        DEBUG_PRINT("Retry writing reg 0x%02X (Expected: 0x%02X, Got: 0x%02X)\n", w_addr, data, read_val);
    }
    return -1;
}

void test_ADS122C04()
{
	DEBUG_PRINT("testing_ADS122C04\n");
	while(number-- != 0 ) {
		while(dly_cnt++ < DELAY_NUM) {} // delay control
		dly_cnt = 0;
		// printf("pass\n");
		read_ADS122C04_TEMP();
	}

	
}

void read_ADS122C04_TEMP()
{
	float ain0, ain1, ain2, ain3;

	// setting mode 
	// I2C_op_mode_sel_ADS122C04_TEMP(HW);
	// Set I2C device address
	// I2C_set_device_addr_ADS122C04_TEMP(I2C_DEV_ADDR);

	ain0 = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_1)*3.3/8388608.0;
	ain1 = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_2)*3.3/8388608.0;
	ain2 = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_3)*3.3/8388608.0;
	ain3 = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_4)*3.3/8388608.0;

//	printf("%f, %f, %f\n", ax, ay, az);
	// uart_printf("%f\n", ain0);
	// uart_printf("%f, %f\n", ain0, ain1);
	// uart_printf("%f, %f, %f\n", ain0, ain1, ain2);
	DEBUG_PRINT("%f, %f, %f, %f\n", ain0, ain1, ain2, ain3);
	// uart_printf("%f, %f, %f, %f\n", ain0, ain1, ain2, ain3);
}

/***********mid level definition */

void I2C_sm_start_ADS122C04_TEMP()
{
	alt_u8 dly = 25;

	I2C_sm_set_enable_ADS122C04_TEMP();
	while(dly--){}
	I2C_sm_set_disable_ADS122C04_TEMP();
}

void I2C_op_mode_sel_ADS122C04_TEMP(alt_u8 mode)
{
	alt_32 old = IORD(VARSET_BASE, O_VAR_I2C_CTRL);

	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, (old & 0xFFFFFFF1) | (mode<<ctrl_op_mode_pos));
}

void I2C_clock_rate_sel_ADS122C04_TEMP(alt_u8 rate)
{
	alt_32 old = IORD(VARSET_BASE, O_VAR_I2C_CTRL);

	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, (old & 0xFFFFFF8F) | (rate<<ctrl_clk_rate_pos));
}

void I2C_write_ADS122C04_TEMP_cmd(alt_u8 reg_addr)
{
	// printf("Start write cmd\n");
	// setting mode to cpu write register
	I2C_op_mode_sel_ADS122C04_TEMP(CPU_CMD);
	// Set I2C device address
	I2C_set_device_addr_ADS122C04_TEMP(I2C_DEV_ADDR);
	// Set the target register address for read or write operations
	IOWR(VARSET_BASE, O_VAR_REG_ADDR, reg_addr);

	// start the I2C SM 
	I2C_sm_start_ADS122C04_TEMP();
	// Wait for the I2C SM to complete the operation
	int timeout = 100000;
	while( !I2C_sm_read_finish_ADS122C04_TEMP() && timeout-- > 0 );
	if (timeout <= 0) {
        printf("ADS122C04 write timeout!\n");
        return;
    }
	I2C_sm_set_finish_clear_pulse_ADS122C04_TEMP();
	// printf("End write cmd\n");
}

void I2C_write_ADS122C04_TEMP_register(alt_u8 reg_addr, alt_u8 data)
{
	// printf("Start write reg\n");
	// setting mode to cpu write register
	I2C_op_mode_sel_ADS122C04_TEMP(CPU_WREG);
	// Set I2C device address
	I2C_set_device_addr_ADS122C04_TEMP(I2C_DEV_ADDR);
	// Set the target register address for read or write operations
	IOWR(VARSET_BASE, O_VAR_REG_ADDR, reg_addr);

	// Set the data value to be written to the target register
	IOWR(VARSET_BASE, O_VAR_W_DATA, data);
	// start the I2C SM 
	I2C_sm_start_ADS122C04_TEMP();
	// Wait for the I2C SM to complete the operation
	int timeout = 100000;
	while( !I2C_sm_read_finish_ADS122C04_TEMP() && timeout-- > 0 );
	if (timeout <= 0) {
        printf("ADS122C04 write timeout!\n");
        return;
    }
	I2C_sm_set_finish_clear_pulse_ADS122C04_TEMP();
	// printf("End write reg\n");
}

alt_u8 I2C_read_ADS122C04_TEMP_register(alt_u8 reg_addr, alt_u8 print)
{
	alt_u8 rt;

	// setting mode to cpu read register
	I2C_op_mode_sel_ADS122C04_TEMP(CPU_RREG);
	// Set I2C device address
	I2C_set_device_addr_ADS122C04_TEMP(I2C_DEV_ADDR);
	// Set the target register address for read or write operations
	IOWR(VARSET_BASE, O_VAR_REG_ADDR, reg_addr);

	// start the I2C SM 
	I2C_sm_start_ADS122C04_TEMP();
	// Wait for the I2C SM to complete the operation
	while( !I2C_sm_read_finish_ADS122C04_TEMP()){}
	// Retrieve the data read from the specified register
	rt = IORD(VARSET_BASE, O_VAR_I2C_RDATA_1);

	I2C_sm_set_finish_clear_pulse_ADS122C04_TEMP();

	// Print the register address and its read value if 'print' is enabled
	if(print) 	DEBUG_PRINT("reg:%x, value:%x\n", reg_addr, rt);
	if(print) 	printf("reg:%x, value:%x\n", reg_addr, rt);
	

	return rt;
}

void I2C_set_device_addr_ADS122C04_TEMP(alt_u8 dev)
{
	IOWR(VARSET_BASE, O_VAR_DEV_ADDR, dev);
}

/***********low level definition */

/*** Set the bit value at the spcified position without altering the values at other positions. */
 alt_u32 set_bit_safe_ADS122C04_TEMP(alt_u32 old_addr,  alt_u8 pos)
{
	// First, read the register value.
	alt_u32 old = IORD(VARSET_BASE, old_addr);

	// Returns the register value with the bit set at the specified position.
	return (old | (alt_32)(1<<pos)); 
}

/*** Clear the bit value at the spcified position without altering the values at other positions. */
 alt_u32 clear_bit_safe_ADS122C04_TEMP(alt_u32 old_addr,  alt_u8 pos)
{
	// First, read the register value.
	alt_u32 old = IORD(VARSET_BASE, old_addr);

	// Returns the register value with the bit cleared at the specified position.
	return (old & ~((alt_32)(1<<pos))); 
}

/*** Starts the state machine when it is in the IDLE state. */
 void I2C_sm_set_enable_ADS122C04_TEMP()
{
	IOWR(VARSET_BASE, O_VAR_I2C_CTRL,  set_bit_safe_ADS122C04_TEMP(O_VAR_I2C_CTRL, ctrl_en_pos));
}

 void I2C_sm_set_disable_ADS122C04_TEMP()
{
	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, clear_bit_safe_ADS122C04_TEMP(O_VAR_I2C_CTRL, ctrl_en_pos) );
}

void I2C_sm_set_finish_clear_pulse_ADS122C04_TEMP() 
{
	IOWR(VARSET_BASE, O_VAR_I2C_CTRL,  set_bit_safe(O_VAR_I2C_CTRL, ctrl_finish_clear_pos));
	usleep(1);
	IOWR(VARSET_BASE, O_VAR_I2C_CTRL,  clear_bit_safe(O_VAR_I2C_CTRL, ctrl_finish_clear_pos));
}

//  void I2C_set_read_mode_ADS122C04_TEMP()
// {
// 	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, set_bit_safe_ADS122C04_TEMP(O_VAR_I2C_CTRL, ctrl_rw_reg_pos));
// }

//  void I2C_set_write_mode_ADS122C04_TEMP()
// {
// 	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, clear_bit_safe_ADS122C04_TEMP(O_VAR_I2C_CTRL, ctrl_rw_reg_pos));
// }


/*** Returns High when the state machine has finished. */
 alt_u8 I2C_sm_read_finish_ADS122C04_TEMP()
{
	alt_u8 finish=0;

	finish = (alt_u8)(IORD(VARSET_BASE, O_VAR_I2C_STATUS)>>status_finish_pos) & 0x01;

	return finish;
}
