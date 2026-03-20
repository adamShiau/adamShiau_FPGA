#include "asm330lhhx.h"
#define VARSET_BASE VARSET_1_BASE

/******** I2C device address*********/
#define I2C_DEV_ADDR	0x6A

/******** I2C lock rate definition*********/
#define CLK_97K 	 0
#define CLK_195K 	 1
#define CLK_390K 	 2
#define CLK_781K 	 3
#define CLK_1562K 	 4
#define CLK_3125K 	 5


/******** VAR Register*********/
#define	O_VAR_DEV_ADDR		var_i2c_IMU_dev_addr
#define O_VAR_W_DATA		var_i2c_IMU_w_data
#define O_VAR_I2C_CTRL		var_i2c_IMU_ctrl
#define O_VAR_REG_ADDR		var_i2c_IMU_reg_addr
#define O_VAR_I2C_STATUS	i_var_i2c_IMU_status
#define O_VAR_I2C_RDATA_1	i_var_i2c_IMU_rdata_1
#define O_VAR_I2C_RDATA_2	i_var_i2c_IMU_rdata_2
#define O_VAR_I2C_RDATA_3	i_var_i2c_IMU_rdata_3
#define O_VAR_I2C_RDATA_4	i_var_i2c_IMU_rdata_4
#define O_VAR_I2C_RDATA_5	i_var_i2c_IMU_rdata_5
#define O_VAR_I2C_RDATA_6	i_var_i2c_IMU_rdata_6
#define O_VAR_I2C_RDATA_7	i_var_i2c_IMU_rdata_7


#define I2C_READ			0x1
#define I2C_WRITE			0x0

/**** CTRL ******/
#define ctrl_en_pos			0
// #define ctrl_rw_reg_pos		1
#define ctrl_op_mode_pos 	1
#define ctrl_clk_rate_pos	4
#define ctrl_finish_clear_pos	7
#define ctrl_sm_reset_pos 8

/**** STATUS ******/
#define status_ready_pos	0
#define status_finish_pos	1
#define status_state_pos	9

/**** Scale Factor ******/
#define SF_ACCL_2G	0.061e-3
#define SF_ACCL_4G	0.122e-3
#define SF_ACCL_8G	0.244e-3
#define SF_ACCL_16G	0.488e-3

#define SF_GYRO_125DPS	4.37e-3
#define SF_GYRO_250DPS	8.75e-3
#define SF_GYRO_500DPS	17.5e-3
#define SF_GYRO_1000DPS	35e-3
#define SF_GYRO_2000DPS	70e-3
#define SF_GYRO_4000DPS	140e-3

#define SF_TEMP 0.00390625

/***-------Setup register*/
/*** Setup Register: COUNTER_BDR_REG1  */
#define COUNTER_BDR_REG1 0x0B

/*** Enables pulsed data-ready mode  */
#define DATAREADY_PULSED (1<<7)

#define X_OFS_USR 0x73
#define Y_OFS_USR 0x74
#define Z_OFS_USR 0x75

/*** Setup Register: INT1_CTRL  */
#define INT1_CTRL 0x0D

#define INT1_DRDY_XL 	0
#define INT1_DRDY_G 	(1<<1)

/*** Setup Register: INT2_CTRL  */
#define INT2_CTRL 0x0E

#define INT2_DRDY_TEMP 	(1<<2)


/***-------Configuraiton register*/
/*** Control Register: CTRL1_XL  */
#define CTRL1_XL	0x10
// CTRL1_XL parameters
/***Accelerometer high-resolution selection  */
#define LPF2_XL_EN 	(1<<1)
/***Accelerometer full-scale selection  */
#define ACCL_FS_2G 	0
#define ACCL_FS_16G (1<<2)
#define ACCL_FS_4G 	(2<<2)
#define ACCL_FS_8G 	(3<<2)
/***Accelerometer ODR selection  */
#define ACCL_ODR_416HZ	(6<<4)
#define ACCL_ODR_833HZ	(7<<4)
#define ACCL_ODR_1667HZ	(8<<4)
#define ACCL_ODR_3333HZ	(9<<4)
#define ACCL_ODR_6667HZ	(10<<4)
/*** End of CTRL1_XL  */

/*** Control Register: CTRL2_G  */
#define CTRL2_G		0x11
// CTRL2_G parameters
/***Gyroscope full-scale selection  */
#define GYRO_FS_250DPS	0
#define GYRO_FS_500DPS	(1<<2)
#define GYRO_FS_1000DPS	(2<<2)
#define GYRO_FS_2000DPS	(3<<2)
/***Gyroscope ODR selection  */
#define GYRO_ODR_416HZ	(6<<4)
#define GYRO_ODR_833HZ	(7<<4)
#define GYRO_ODR_1667HZ	(8<<4)
#define GYRO_ODR_3333HZ	(9<<4)
#define GYRO_ODR_6667HZ	(10<<4)
/*** End of CTRL2_G  */

/*** Control Register: CTRL3_C  */
#define CTRL3_C		0x12

/***Block data update  */
#define BDU (1<<6)
/***Register address automatically incremented during a multiple byte access with a serial interface  */
#define IF_INC (1<<2)
/*** End of CTRL3_C  */

/*** Control Register: CTRL4_C  */
#define CTRL4_C		0x13

/***Enables all interrupt signals available on the INT1 pin  */
#define INT2_ON_INT1 (1<<5)

/***Enables gyroscope digital LPF1; the bandwidth can be selected through FTYPE[2:0] in CTRL6_C   */
#define LPF1_SEL_G (1<<1)

/*** End of CTRL4_C  */

/*** Control Register: CTRL5_C  */
#define CTRL5_C		0x14
/*** End of CTRL5_C  */

/*** Control Register: CTRL6_C  */
#define CTRL6_C		0x15

/*** Gyroscope low-pass filter (LPF1) bandwidth selection  */
#define LPF1_FTYPE_0 0
#define LPF1_FTYPE_1 1
#define LPF1_FTYPE_2 2
#define LPF1_FTYPE_3 3
#define LPF1_FTYPE_4 4
#define LPF1_FTYPE_5 5
#define LPF1_FTYPE_6 6
#define LPF1_FTYPE_7 7

/*** End of CTRL6_C  */

/*** Control Register: CTRL7_G  */
#define CTRL7_G		0x16
/*** End of CTRL7_G  */

/*** Control Register: CTRL8_XL  */
#define CTRL8_XL	0x17
/*** Accelerometer LPF2 and HP filter configuration and cutoff setting  */
#define HPCF_XL_0 0			// LPF = ODR/4
#define HPCF_XL_1 (1<<5)	// LPF = ODR/10
#define HPCF_XL_2 (2<<5)	// LPF = ODR/20
#define HPCF_XL_3 (3<<5)	// LPF = ODR/45
#define HPCF_XL_4 (4<<5)	// LPF = ODR/100
#define HPCF_XL_5 (5<<5)	// LPF = ODR/200
#define HPCF_XL_6 (6<<5)	// LPF = ODR/400
#define HPCF_XL_7 (7<<5)	// LPF = ODR/800
/*** End of CTRL8_XL  */

#define CTRL9_XL	0x18
#define CTRL10_C	0x19

/*** Who am I Register  */
#define WHO_AM_I	0x0F



/***-------End of configuraiton register 1 */


/*** OP mode***/
#define CPU_WREG	0
#define CPU_RREG	1
#define HW		    2

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
void init_ASM330LHHX()
{
    DEBUG_PRINT("\n==============================================\n");
    DEBUG_PRINT("     ASM330LHHX Sensor Initialization         \n");
    DEBUG_PRINT("==============================================\n");

    // 設定 I2C 頻率
	alt_u8 I2C_CLK_rate = CLK_97K;

    I2C_clock_rate_sel_ASM330LHHX(I2C_CLK_rate);

	DEBUG_PRINT("[ INFO ] I2C Clock Rate set to: %s (Val: %d)\n", 
                get_i2c_freq_name(I2C_CLK_rate), I2C_CLK_rate);

    I2C_sm_force_reset_ASM330LHHX();
    usleep(5000); // 給 5ms 讓從機穩定

    // 1. 物理層檢查：確認 ID
    alt_u8 who_am_i = I2C_read_ASM330LHHX_register(WHO_AM_I, 0);
    if(who_am_i != 0x6B) {
        DEBUG_PRINT("[CRITICAL] Device NOT Found! Expected 0x6B, Got: 0x%02X\n", who_am_i);
        return;
    }
    DEBUG_PRINT("[  OK  ] Communication established. (ID: 0x6B)\n");

    // 2. 定義配置清單 (方便後續維護)
    struct {
        alt_u8 addr;
        alt_u8 val;
        const char* label;
    } configs[] = {
        {CTRL1_XL, ACCL_FS_16G | ACCL_ODR_416HZ | LPF2_XL_EN, "[CTRL1_XL] Accl Config: 16G, 416Hz, LPF2 ON"},
		{CTRL8_XL, HPCF_XL_2,                                 "[CTRL8_XL] Accl LPF2 Cutoff: ODR/20"},
        {CTRL2_G,  GYRO_FS_1000DPS | GYRO_ODR_416HZ,          "[CTRL2_G] Gyro Config: 1000DPS, 416Hz"},
        {CTRL3_C,  BDU | IF_INC,                              "[CTRL3_C] System (BDU, Auto-Inc)"},
        {CTRL4_C,  INT2_ON_INT1 | LPF1_SEL_G,                 "[CTRL4_C] Routing INT2 on INT1. Gyro LPF1 ON)"},
        {CTRL6_C,  LPF1_FTYPE_6,                              "[CTRL6_C] Gyro LPF1 Bandwidth: 24.6 Hz"},
        {COUNTER_BDR_REG1, DATAREADY_PULSED,                  "DataReady Pulsed Mode"},
        {INT1_CTRL, INT1_DRDY_XL | INT1_DRDY_G,               "Interrupt 1 Map (A+G)"},
        {INT2_CTRL, INT2_DRDY_TEMP,                           "Interrupt 2 Map (Temp)"},
        {X_OFS_USR, 0x00,                                     "Accl X offset set to 0"},
        {Y_OFS_USR, 0x00,                                     "Accl Y offset set to 0"},
        {Z_OFS_USR, 0x00,                                     "Accl Z offset set to 0"}
    };

    // 3. 執行配置並印出結果
    int i;
    int fail_count = 0;
    int total_configs = sizeof(configs) / sizeof(configs[0]);

    for(i = 0; i < total_configs; i++) {
        if(I2C_write_verify_ASM330LHHX(configs[i].addr, configs[i].val) == 0) {
            DEBUG_PRINT("[  OK  ] %-25s | Reg: 0x%02X | Val: 0x%02X\n", 
                        configs[i].label, configs[i].addr, configs[i].val);
        } else {
            DEBUG_PRINT("[FAILED] %-25s | Reg: 0x%02X | Expected: 0x%02X\n", 
                        configs[i].label, configs[i].addr, configs[i].val);
            fail_count++;
        }
    }

    // 4. 最後確認與切換模式
    if(fail_count == 0) {
        usleep(2000); // 等待數位濾波器穩定
        I2C_op_mode_sel_ASM330LHHX(HW); // 切換至硬體自動讀取模式
        I2C_set_device_addr_ASM330LHHX(I2C_DEV_ADDR);
        DEBUG_PRINT("----------------------------------------------\n");
        DEBUG_PRINT("Status: ALL SUCCESS. Hardware mode active.\n");
    } else {
        DEBUG_PRINT("----------------------------------------------\n");
        DEBUG_PRINT("Status: INIT FAILED with %d errors.\n", fail_count);
    }
    DEBUG_PRINT("==============================================\n\n");
}

/**
 * @brief 帶有詳細偵錯訊息的暫存器寫入校驗
 * @return 0: 成功, -1: 失敗
 */
int I2C_write_verify_ASM330LHHX(alt_u8 reg_addr, alt_u8 data) {
    int retry = 3;
    alt_u8 read_val;
    int has_error = 0; // 紀錄通訊過程中是否曾發生錯誤

    while(retry--) {
        I2C_write_ASM330LHHX_register(reg_addr, data, 0); // 執行寫入
        usleep(250); // 給予硬體處理與 I2C 匯流排穩定時間
        read_val = I2C_read_ASM330LHHX_register(reg_addr, 0); // 讀回比對
        
        if(read_val == data) {
            // 如果曾經報錯，成功後補一個換行讓版面整潔
            if (has_error) DEBUG_PRINT("\n"); 
            return 0; 
        }

        has_error = 1;
        DEBUG_PRINT("\n    [INFO] Mismatch @ Reg 0x%02X (Retry %d)", reg_addr, 3-retry);
        DEBUG_PRINT("\n    [INFO] Expected: 0x%02X, Actual: 0x%02X", data, read_val);
        DEBUG_PRINT("\n    [INFO] Triggering Bus Recovery Sequence...\n");

        I2C_sm_force_reset_ASM330LHHX(); 
        usleep(1000);
    }
    
    // 最終失敗：印出最關鍵的錯誤訊息
    DEBUG_PRINT("\n[FAILED] !!! Reg 0x%02X Verify Final Failure !!!\n", reg_addr);
    
    return -1;
}


void test_ASM330LHHX()
{
	DEBUG_PRINT("testing_ASM330LHHX\n");
	while(number-- != 0 ) {
		while(dly_cnt++ < DELAY_NUM) {} // delay control
		dly_cnt = 0;
		read_ASM330LHHX();
	}

	
}

void read_ASM330LHHX()
{
	float gx, gy, gz, ax, ay, az, temp;

	// setting mode 
	I2C_op_mode_sel_ASM330LHHX(HW);
	// Set I2C device address
	I2C_set_device_addr_ASM330LHHX(I2C_DEV_ADDR);

	gx = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_1) * SF_GYRO_1000DPS;
	gy = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_2) * SF_GYRO_1000DPS;
	gz = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_3) * SF_GYRO_1000DPS;
	ax = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_4) * SF_ACCL_16G;
	ay = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_5) * SF_ACCL_16G;
	az = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_6) * SF_ACCL_16G;
	temp = (float)IORD(VARSET_BASE, O_VAR_I2C_RDATA_7) * SF_TEMP + 25.0;

	// printf("%f, %f, %f, %f, %f, %f, %f\n", gx, gy, gz, ax, ay, az, temp);
	DEBUG_PRINT("%f, %f, %f, %f, %f, %f, %f\n", gx, gy, gz, ax, ay, az, temp);
}

/**
 * @brief 讀取 I2C 控制器目前的狀態機狀態 (State Machine Status)
 * @return 狀態機當前的狀態碼 (如 IDLE, START, ADDRESS 等)
 */
alt_u8 get_ASM330LHHX_SM_status(void)
{
    alt_u32 status_reg;
    alt_u8 sm_state;

    // 1. 從 Avalon 介面讀取完整的 32-bit 狀態暫存器 [cite: 22, 32]
    status_reg = IORD(VARSET_BASE, O_VAR_I2C_STATUS);

    // 2. 提取 bit[9:2] 的狀態碼 
    // 根據 Verilog 定義：o_status[9:2] = state
    sm_state = (alt_u8)((status_reg >> 2) & 0xFF); 

    return sm_state;
}

void print_ASM330LHHX_SM_status()
{
    alt_u8 current_sm;

    current_sm = get_ASM330LHHX_SM_status();

    DEBUG_PRINT("SM: %d\n", current_sm);
}

/**
 * @brief 強制重置 I2C 狀態機並執行 Bus Recovery
 * 配合 Verilog V4：執行 9 個時鐘脈衝並發送 STOP Condition
 */
void I2C_sm_force_reset_ASM330LHHX() {
    // 拉高 SM_Reset 
    alt_u32 ctrl = IORD(VARSET_BASE, O_VAR_I2C_CTRL);
    IOWR(VARSET_BASE, O_VAR_I2C_CTRL, ctrl | (1 << ctrl_sm_reset_pos));

    // 短暫延遲，確保硬體時鐘（i2c_clk）有抓到這個電位
    usleep(10); 
    
    //  設定成 CPU_WREG 模式
    I2C_op_mode_sel_ASM330LHHX(CPU_WREG);

    // 拉低 SM_Reset 
    ctrl = IORD(VARSET_BASE, O_VAR_I2C_CTRL);
    IOWR(VARSET_BASE, O_VAR_I2C_CTRL, (ctrl & ~(1 << ctrl_sm_reset_pos)));
    
    // 強制清除 Finish 旗標
    I2C_sm_set_finish_clear_pulse_ASM330LHHX();
}


/**
 * @brief 動態設定陀螺儀 LPF1 頻寬 (FTYPE)
 */
void set_ASM330LHHX_Gyro_LPF1(alt_u8 ftype) {

    int timeout = 10000;

    // 防呆：若目前參數已正確，直接 return 以免中斷數據流
    static alt_u8 last_ftype = 0xFF;
    if (ftype == last_ftype) return;

    DEBUG_PRINT("\n[SETTER] ASM330LHHX Gyro LPF1: Index %d\n", ftype);

    // 1. 先強制切換模式到 CPU_WREG，關閉 HW 模式
    // I2C_op_mode_sel_ASM330LHHX(CPU_WREG);

    // 2. 執行物理重置
    I2C_sm_force_reset_ASM330LHHX();

    // 3. 等待 SM 回到 IDLE (0)
    while(get_ASM330LHHX_SM_status() != 0 && timeout-- > 0);

    if(timeout <= 0) {
        DEBUG_PRINT("\n    [ERROR] SM NOT IDLE before write! State: %d\n", get_ASM330LHHX_SM_status());
        return;
    }

    // 4. 修改 CTRL6_C (0x15) 並驗證
    // alt_u8 current_ctrl6 = I2C_read_ASM330LHHX_register(CTRL6_C, 0); 
    // alt_u8 next_ctrl6 = (current_ctrl6 & 0xF8) | (ftype & 0x07);
    alt_u8 next_ctrl6 = ftype & 0x07;

    if (I2C_write_verify_ASM330LHHX(CTRL6_C, next_ctrl6) == 0) {
        last_ftype = ftype;
    }

    // 5. 確保 LPF1_SEL_G 已啟用
    // alt_u8 c4 = I2C_read_ASM330LHHX_register(CTRL4_C, 0);
    // I2C_write_verify_ASM330LHHX(CTRL4_C, c4 | LPF1_SEL_G);

    // 6. 恢復硬體自動讀取模式
    I2C_op_mode_sel_ASM330LHHX(HW); 

    usleep(100000);

    DEBUG_PRINT("\n--- [DONE] ASM330LHHX Gyro LPF1 HW Mode Active ---\n");
}

/**
 * @brief 動態設定加速度計 LPF2 頻寬 (HPCF_XL)
 */
void set_ASM330LHHX_Accl_LPF2(alt_u8 cutoff_bw) {
    int timeout = 10000;
    static alt_u8 last_cutoff = 0xFF;

    if (cutoff_bw == last_cutoff) return;

    DEBUG_PRINT("\n[SETTER] ASM330LHHX Accl LPF2: Index %d\n", cutoff_bw);

    // 1. 強制進入 CPU 模式，避免 HW 模式競爭
    // I2C_op_mode_sel_ASM330LHHX(CPU_WREG);

    // 2. 執行 9-pulse Recovery 並等待 IDLE
    I2C_sm_force_reset_ASM330LHHX();
    while(get_ASM330LHHX_SM_status() != 0 && timeout-- > 0);

    if(timeout <= 0) {
        DEBUG_PRINT("\n    [ERROR] SM NOT IDLE before write! State: %d\n", get_ASM330LHHX_SM_status());
        return;
    }

    // 3. 修改 CTRL8_XL (0x17) 
    // alt_u8 cur8 = I2C_read_ASM330LHHX_register(CTRL8_XL, 0); 
    // alt_u8 next8 = (cur8 & 0x1F) | ((cutoff_bw << 5) & 0xE0);
    alt_u8 next8 = (cutoff_bw << 5);
    
    if (I2C_write_verify_ASM330LHHX(CTRL8_XL, next8) == 0) {
        last_cutoff = cutoff_bw;
    }

    // 4. 確保 CTRL1_XL (0x10) 已開啟 LPF2_XL_EN (bit 1) 
    // alt_u8 cur1 = I2C_read_ASM330LHHX_register(CTRL1_XL, 0);
    // I2C_write_verify_ASM330LHHX(CTRL1_XL, cur1 | LPF2_XL_EN);

    // 5. 回到 HW 模式 
    I2C_op_mode_sel_ASM330LHHX(HW);

    usleep(100000);
    
    DEBUG_PRINT("\n--- [DONE] ASM330LHHX Accl LPF2 HW Mode Active ---\n");}

/***********mid level definition */

void I2C_sm_start_ASM330LHHX()
{
	alt_u8 dly = 100;

	I2C_sm_set_enable_ASM330LHHX();
	while(dly--){}
	I2C_sm_set_disable_ASM330LHHX();
}

void I2C_op_mode_sel_ASM330LHHX(alt_u8 mode)
{
	alt_32 old = IORD(VARSET_BASE, O_VAR_I2C_CTRL);

	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, (old & 0xFFFFFFF1) | (mode<<ctrl_op_mode_pos));
}

void I2C_clock_rate_sel_ASM330LHHX(alt_u8 rate)
{
	alt_32 old = IORD(VARSET_BASE, O_VAR_I2C_CTRL);

	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, (old & 0xFFFFFF8F) | (rate<<ctrl_clk_rate_pos));
}

void I2C_write_ASM330LHHX_register(alt_u8 reg_addr, alt_u8 data, alt_u8 print)
{

	// setting mode to cpu write register
	I2C_op_mode_sel_ASM330LHHX(CPU_WREG);
	// Set I2C device address
	I2C_set_device_addr_ASM330LHHX(I2C_DEV_ADDR);
	// Set the target register address for read or write operations
	IOWR(VARSET_BASE, O_VAR_REG_ADDR, reg_addr);

	// Set the data value to be written to the target register
	IOWR(VARSET_BASE, O_VAR_W_DATA, data);
	// start the I2C SM 
	I2C_sm_start_ASM330LHHX();

	// Wait for the I2C SM to complete the operation
	int timeout = 50000;
	while( !I2C_sm_read_finish_ASM330LHHX() && timeout-- > 0 );
	if (timeout <= 0) {
        DEBUG_PRINT("[ ERROR ] Write Timeout! Reg: 0x%02X\n", reg_addr);
        return;
    }
	I2C_sm_set_finish_clear_pulse_ASM330LHHX();
	if(print) printf("write reg:0x%x, value:0x%x\n", reg_addr, data);
}

alt_u8 I2C_read_ASM330LHHX_register(alt_u8 reg_addr, alt_u8 print)
{
	alt_u8 rt;
	int timeout = 50000;

	// setting mode to cpu read register
	I2C_op_mode_sel_ASM330LHHX(CPU_RREG);
	// Set I2C device address
	I2C_set_device_addr_ASM330LHHX(I2C_DEV_ADDR);
	// Set the target register address for read or write operations
	IOWR(VARSET_BASE, O_VAR_REG_ADDR, reg_addr);

	// start the I2C SM 
	I2C_sm_start_ASM330LHHX();

	// Wait for the I2C SM to complete the operation
	// while( !I2C_sm_read_finish_ASM330LHHX()){}
	while( !I2C_sm_read_finish_ASM330LHHX() && timeout-- > 0 );
	if(timeout <= 0) {
        alt_u32 status = IORD(VARSET_BASE, O_VAR_I2C_STATUS);
        DEBUG_PRINT("[ ERROR ] Read Timeout! Reg: 0x%02X, SM Status: 0x%08X\n", reg_addr, (unsigned int)status);
        return 0;
    }

	// Retrieve the data read from the specified register
	rt = IORD(VARSET_BASE, O_VAR_I2C_RDATA_1);

	I2C_sm_set_finish_clear_pulse_ASM330LHHX();

	// Print the register address and its read value if 'print' is enabled
	if(print) DEBUG_PRINT("reg:0x%x, value:0x%x\n", reg_addr, rt);

	return rt;
}

void I2C_set_device_addr_ASM330LHHX(alt_u8 dev)
{
	IOWR(VARSET_BASE, O_VAR_DEV_ADDR, dev);
}

/***********low level definition */

/*** Set the bit value at the spcified position without altering the values at other positions. */
 alt_u32 set_bit_safe_ASM330LHHX(alt_u32 old_addr,  alt_u8 pos)
{
	// First, read the register value.
	alt_u32 old = IORD(VARSET_BASE, old_addr);

	// Returns the register value with the bit set at the specified position.
	return (old | (alt_32)(1<<pos)); 
}

/*** Clear the bit value at the spcified position without altering the values at other positions. */
 alt_u32 clear_bit_safe_ASM330LHHX(alt_u32 old_addr,  alt_u8 pos)
{
	// First, read the register value.
	alt_u32 old = IORD(VARSET_BASE, old_addr);

	// Returns the register value with the bit cleared at the specified position.
	return (old & ~((alt_32)(1<<pos))); 
}

/*** Starts the state machine when it is in the IDLE state. */
 void I2C_sm_set_enable_ASM330LHHX()
{
	IOWR(VARSET_BASE, O_VAR_I2C_CTRL,  set_bit_safe_ASM330LHHX(O_VAR_I2C_CTRL, ctrl_en_pos));
}

 void I2C_sm_set_disable_ASM330LHHX()
{
	IOWR(VARSET_BASE, O_VAR_I2C_CTRL, clear_bit_safe_ASM330LHHX(O_VAR_I2C_CTRL, ctrl_en_pos) );
}

void I2C_sm_set_finish_clear_pulse_ASM330LHHX() 
{
	IOWR(VARSET_BASE, O_VAR_I2C_CTRL,  set_bit_safe_ASM330LHHX(O_VAR_I2C_CTRL, ctrl_finish_clear_pos));
	usleep(1);
	IOWR(VARSET_BASE, O_VAR_I2C_CTRL,  clear_bit_safe_ASM330LHHX(O_VAR_I2C_CTRL, ctrl_finish_clear_pos));
}


/*** Returns High when the state machine has finished. */
 alt_u8 I2C_sm_read_finish_ASM330LHHX()
{
	alt_u8 finish=0;

	finish = (alt_u8)(IORD(VARSET_BASE, O_VAR_I2C_STATUS)>>status_finish_pos) & 0x01;

	return finish;
}
