module IRIS1_TOP_V1( //2025-06-29 目前IRIS-1

	//////////// CLOCK INPUT ////////    
	CLOCK_100M, 
	//////////// PLL CLOCK //////////
	CLOCK_ADC,
	CLOCK_DAC,
	CLOCK_SDRAM,

	//////////// SDRAM //////////
	SDRAM_ADDR,
	SDRAM_BA,
	SDRAM_CAS_N,
	SDRAM_CKE,
	SDRAM_CS_N,
	SDRAM_DQ,
	SDRAM_DQM,
	SDRAM_RAS_N,
	SDRAM_WE_N,

	/////////// PIO ////////// 
	WDT_EN,
	WDI,
	MUX_IN2,
	MUX_IN1,
	FPGA_TX,
	FPGA_RX,
	DBG_TX,
	DBG_RX,

	//////////// SYNC //////////
	EXT_SYNC_IN,
	INT_SYNC, //A4
	EXT_SYNC_OUT,

	//////////// XLM550 //////////
	//----SPI_XLM550----
	MISO_XLM550,
	MOSI_XLM550,
	SCLK_XLM550,
	DRDY_SPI_XLM550,
	//----I2C_XLM550----
	SCL_XLM550,
	SDA_XLM550,
	DRDY_I2C_XLM550,

	//////////// ADXL357 I2C //////////
	SDA_357,
	SCL_357,
	DRDY_357,

	/////////// 24-bit Serial ADC I2C //////////
	SDA_ADC_TEMP, 
	SCL_ADC_TEMP,
	DRDY_ADC_TEMP,

	//////////// BMM350 I2C (MAG) //////////
	SDA_BMM350,
	SCL_BMM350,
	DRDY_BMM350,

	//////////// BMM581 I2C (BAR) //////////
	SDA_BMM581,
	SCL_BMM581,
	DRDY_BMM581,

	//////////// GNSS UART //////////
	GNSS_TX,
	GNSS_RX,

	//////////// LED //////////
	LED_SENSOR,
	
	//////////// DAC //////////
	//----BUS----
	DAC_1_1, 
	DAC_2_1,	
	DAC_2_2, 
	//----Serial----
	DAC_RST, //W1
	DAC_CFG_MISO, //R5
	DAC_CFG_MOSI, //P5
	DAC_CFG_SCLK, //T5
	CS_DAC_1, //V1
	CS_DAC_2, //V2

	//////////// ADC //////////
	//----BUS----
	ADC_1_1, 
	ADC_2_1, 
	ADC_2_2,
	//----Serial----
	ADC_CFG_MISO, //V16
	ADC_CFG_MOSI, //R19
	ADC_CFG_SCLK, //R20
	CS_ADC_1, //U20
	CS_ADC_2, //U19

	//////////// EPCS //////////
	EPCS_ASDO,
	EPCS_DATA0,
	EPCS_DCLK,
	EPCS_NCSO,
	
	/////////// EEPROM I2C //////////
	SDA_EEPROM,
	SCL_EEPROM,



);
//////////// CLOCK //////////
input				CLOCK_100M;

//////////// PLL CLOCK //////////
output 				CLOCK_ADC;
output 				CLOCK_DAC;
output 				CLOCK_SDRAM;

//////////// SDRAM //////////
output	[13-1:0]	SDRAM_ADDR;
output	[ 2-1:0]	SDRAM_BA;
output				SDRAM_CAS_N;
output				SDRAM_CKE;
output				SDRAM_CS_N;
inout	[16-1:0]	SDRAM_DQ;
output	[ 2-1:0]	SDRAM_DQM;
output				SDRAM_RAS_N;
output				SDRAM_WE_N;

/////////// PIO //////////
output				FPGA_TX;
input				FPGA_RX;
output				DBG_TX;
input				DBG_RX;
output				WDT_EN;
output				WDI;
output				MUX_IN2;
output				MUX_IN1;

//////////// SYNC //////////
input				EXT_SYNC_IN;
output				INT_SYNC; //A4
output 				EXT_SYNC_OUT;

//////////// XLM550 //////////
//----SPI_XLM550----
input				MISO_XLM550;
output				MOSI_XLM550;
output				SCLK_XLM550;
input				DRDY_SPI_XLM550;
//----I2C_XLM550----
output				SCL_XLM550;
output				SDA_XLM550;
input				DRDY_I2C_XLM550;

//////////// ADXL357 //////////
inout				SDA_357;
inout				SCL_357;
input				DRDY_357;

/////////// 24-bit Serial ADC I2C //////////
inout				SDA_ADC_TEMP;
inout				SCL_ADC_TEMP;
input				DRDY_ADC_TEMP;

//////////// BMM350 I2C (MAG) //////////
inout				SDA_BMM350;
inout				SCL_BMM350;
input				DRDY_BMM350;

//////////// BMM581 I2C (BAR) //////////
inout				SDA_BMM581;
inout				SCL_BMM581;
input				DRDY_BMM581;

//////////// GNSS UART //////////
output				GNSS_TX;
input				GNSS_RX;

//////////// LED //////////
output 				LED_SENSOR;

//////////// DAC //////////
output	[15:0] 	DAC_1_1;
output	[15:0] 	DAC_2_1;
output	[15:0] 	DAC_2_2;
output 			CS_DAC_1;
output 			CS_DAC_2;
output 			DAC_RST;
input			DAC_CFG_MISO;
output			DAC_CFG_MOSI;
output			DAC_CFG_SCLK;

//////////// ADC //////////
input	[13:0] 		 ADC_1_1;
input	[13:0] 		 ADC_2_1;
input 	[13:0]		 ADC_2_2;
output 				 CS_ADC_1;
output 				 CS_ADC_2;
input				 ADC_CFG_MISO;
output				 ADC_CFG_MOSI;
output				 ADC_CFG_SCLK;

//////////// EPCS //////////
output				EPCS_ASDO;
input 				EPCS_DATA0;
output				EPCS_DCLK;
output				EPCS_NCSO;

/////////// EEPROM I2C //////////
inout				SDA_EEPROM;
inout				SCL_EEPROM;


/*** ADC loop back test ***/
wire [29:0] adc1_fir, adc2_fir, adc3_fir;

/*** I2C 24 bit ADC ads122c04 temp Var definition***/
wire [31:0] var_i2c_ads122c04_temp_dev_addr, var_i2c_ads122c04_temp_reg_addr, var_i2c_ads122c04_temp_w_data;
wire signed [31:0] var_i2c_ads122c04_temp_rdata_1, var_i2c_ads122c04_temp_rdata_2, var_i2c_ads122c04_temp_rdata_3, var_i2c_ads122c04_temp_rdata_4;
wire [31:0] var_i2c_ads122c04_temp_ctrl, var_i2c_ads122c04_temp_status;

/////////// I2C ADXL357 Var definition //////////
wire [31:0] var_i2c_357_dev_addr, var_i2c_357_reg_addr, var_i2c_357_w_data;
wire signed [31:0] var_i2c_357_rdata_1, var_i2c_357_rdata_2, var_i2c_357_rdata_3, var_i2c_357_rdata_4;
wire [31:0] var_i2c_357_ctrl, var_i2c_357_status;

/////////// I2C EEPROM Var definition //////////
wire [31:0] var_i2c_EEPROM_dev_addr, var_i2c_EEPROM_reg_addr, var_i2c_EEPROM_w_data, var_i2c_EEPROM_rdata_1, var_i2c_EEPROM_rdata_2, var_i2c_EEPROM_rdata_3;
wire [31:0] var_i2c_EEPROM_rdata_4;
wire [31:0] var_i2c_EEPROM_ctrl, var_i2c_EEPROM_status;

assign INT_SYNC = sync_out;

	

`define cnt_us 100
`define cnt_10us 1250
`define cnt_ms 125000
`define cnt_10ms 1250000
`define cnt_1000ms 125000000


wire [1:0] ADC_CFG_SS; 
wire [1:0] DAC_CFG_SS; 

assign CS_DAC_1 = DAC_CFG_SS[0];
assign CS_DAC_2 = DAC_CFG_SS[1];
assign CS_ADC_1 = ADC_CFG_SS[0];
assign CS_ADC_2 = ADC_CFG_SS[1];


/**********MOD gen*********/
reg reg_dacrst;

/////////// MIOC Modulation parameter //////////
wire [31:0] var_freq_cnt_3, var_amp_H_3, var_amp_L_3;
wire [31:0] var_freq_cnt_2, var_amp_H_2, var_amp_L_2;
wire [31:0] var_freq_cnt_1, var_amp_H_1, var_amp_L_1;


/////////// MIOC Err Gen parameter //////////
wire [31:0] var_polarity_3, var_wait_cnt_3, var_avg_sel_3, var_err_offset_3;
wire [31:0] var_polarity_2, var_wait_cnt_2, var_avg_sel_2, var_err_offset_2;
wire [31:0] var_polarity_1, var_wait_cnt_1, var_avg_sel_1, var_err_offset_1;
logic signed [31:0] o_err_DAC3, o_err_DAC3_FIR, o_err_DAC3_MV;
logic signed [31:0] o_err_DAC2, o_err_DAC2_FIR, o_err_DAC2_MV;
logic signed [31:0] o_err_DAC1, o_err_DAC1_FIR, o_err_DAC1_MV;

/////////// FB Step Gen parameter //////////
logic signed [31:0] o_step_3, o_step_3_MV, i_var_step_3, i_var_err_3;
logic signed [31:0] o_step_2, o_step_2_MV, i_var_step_2, i_var_err_2;
logic signed [31:0] o_step_1, o_step_1_MV, i_var_step_1, i_var_err_1;
wire [31:0] var_gainSel_step_3, var_const_step_3, var_fb_ON_3;
wire [31:0] var_gainSel_step_2, var_const_step_2, var_fb_ON_2;
wire [31:0] var_gainSel_step_1, var_const_step_1, var_fb_ON_1;

/////////// Phase Ramp Gen parameter //////////
wire [31:0] var_gainSel_ramp_3, o_phaseRamp_3;
wire [31:0] var_gainSel_ramp_2, o_phaseRamp_2;
wire [31:0] var_gainSel_ramp_1, o_phaseRamp_1;


assign DAC_1_1 =  o_phaseRamp_1[15:0];
assign DAC_2_1 =  o_phaseRamp_2[15:0];
assign DAC_2_2 =  o_phaseRamp_3[15:0];


assign i_var_step_3 = o_step_3;
assign i_var_err_3 = o_err_DAC3_FIR; 

assign i_var_step_2 = o_step_2_MV;
assign i_var_err_2 = o_err_DAC2_FIR; 

 assign i_var_step_1 = o_step_1_MV;
assign i_var_err_1 = o_err_DAC1_FIR; 

assign DAC_RST = reg_dacrst;

/******** PLL setup********/
wire CPU_CLK;
wire locked_0;

PLL0	PLL0_inst (
	.inclk0 ( CLOCK_100M ),
	.c0 ( CLOCK_ADC ),
	.c1 ( CLOCK_DAC ),
	.c2 ( CLOCK_SDRAM ),
	.c3 ( CLOCK_CPU ),
	.locked ( locked_0 )
	);
/********End of PLL setup********/
	
/******* sync setup *******/
wire sync_out;
wire [31:0] var_sync_count;
my_sync_gen sync_gen_inst
(
    .i_clk(CPU_CLK),
    .i_rst_n(locked_0),
 	.i_sync_count(var_sync_count),
    .o_sync_out(sync_out)
);
/******* End of sync setup *******/

/******* timer setup *******/	
wire [31:0] i_var_timer, var_timer_rst;

my_timer
#(.COUNTER_NUM(10000))
timer_inst
(
    .i_clk(CPU_CLK),
    .i_rst_n(locked_0),
    .i_timer_rst(var_timer_rst),
    .o_timer(i_var_timer)
);
/******* End of timer setup *******/	

/******* FIR parameter define*******/
typedef logic signed [15:0] coeff_array_t [0:31];  // 假設最大長度為 32

parameter coeff_array_t N8FC2 = '{
	661, 2126, 5452, 8144, 8144, 5452, 2126, 661
	,0,0,0,0,0,0,0,0,0,0,0,0
	,0,0,0,0,0,0,0,0,0,0,0,0
};

parameter coeff_array_t N16FC5 = '{
	-54, -64, -82, -97, -93, -47, 66, 266, 562, 951,
	1412, 1909, 2396, 2821, 3136, 3304,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
};

parameter coeff_array_t N32FC5 = '{
	-54, -64, -82, -97, -93, -47, 66, 266, 562, 951,
	1412, 1909, 2396, 2821, 3136, 3304,
	3304, 3136, 2821, 2396, 1909, 1412, 951, 562, 
	266, 66, -47, -93, -97, -82, -64, -54
};

parameter coeff_array_t N32FC2 = '{
	82, 102, 148, 223, 330, 469, 638, 832, 1042, 1261, 
	1476, 1678, 1855, 1998, 2098, 2149, 2149, 2098, 
	1998, 1855, 1678, 1476, 1261, 1042, 832, 638, 469, 
	330, 223, 148, 102, 82
};


my_fog_v1 #( // x axis
   .COEFF_SET(N32FC2) // Default coefficient set N32FC5
) my_fog_ch1_inst (
   // ============================ Common Signals ============================
   .CLOCK_ADC(CLOCK_ADC), // ADC clock (1-bit)
   .CLOCK_DAC(CLOCK_DAC), // DAC clock (1-bit)
   .locked(locked_0),    // Global reset signal, active low (1-bit)

   // ============================ ADC Processing ============================
   .ADC(ADC_1_1), // Raw ADC input signal (14-bit)

   // ============================ Modulation Generator ============================
   .var_freq_cnt(var_freq_cnt_1), // Frequency control input (32-bit)
   .var_amp_H(var_amp_H_1),    // Positive amplitude control (32-bit)
   .var_amp_L(var_amp_L_1),    // Negative amplitude control (32-bit)

   // ============================ Error Signal Processing ============================
   .var_polarity(var_polarity_1),     // Polarity control (1-bit)
   .var_wait_cnt(var_wait_cnt_1),     // Wait counter for stabilization (32-bit)
   .var_err_offset(var_err_offset_1),   // Error offset adjustment (32-bit)
   .var_avg_sel(var_avg_sel_1),      // Average selection control (32-bit)

   // ============================ Feedback Control ============================
   .var_const_step(var_const_step_1),    // Constant step value (32-bit)
   .var_fb_ON(var_fb_ON_1),         // Feedback enable (1-bit)
   .var_gainSel_step(var_gainSel_step_1),  // Gain selection for step feedback (32-bit)

   // ============================ Phase Ramp Control ============================
   .var_gainSel_ramp(var_gainSel_ramp_1), // Gain selection for ramp control (32-bit)

   // ============================ Output Signals ============================
   .o_err_DAC(o_err_DAC1),       // Processed error signal output (32-bit, signed)
   .o_err_DAC_FIR(o_err_DAC1_FIR),   // FIR filtered error signal (32-bit, signed)
   .o_step(o_step_1),          // Feedback step output (32-bit, signed)
   .o_step_MV(o_step_1_MV),       // Filtered step output (32-bit, signed)
   .o_phaseRamp(o_phaseRamp_1)      // Phase ramp output (32-bit, signed)
);

my_fog_v1 #(	//y axis
    .COEFF_SET(N32FC2) // Default coefficient set N32FC5
) my_fog_ch2_inst (
    // ============================ Common Signals ============================
    .CLOCK_ADC(CLOCK_ADC), // ADC clock (1-bit)
    .CLOCK_DAC(CLOCK_DAC), // DAC clock (1-bit)
    .locked(locked_0),    // Global reset signal, active low (1-bit)

    // ============================ ADC Processing ============================
    .ADC(ADC_2_1), // Raw ADC input signal (14-bit)

    // ============================ Modulation Generator ============================
    .var_freq_cnt(var_freq_cnt_2), // Frequency control input (32-bit)
    .var_amp_H(var_amp_H_2),    // Positive amplitude control (32-bit)
    .var_amp_L(var_amp_L_2),    // Negative amplitude control (32-bit)

    // ============================ Error Signal Processing ============================
    .var_polarity(var_polarity_2),     // Polarity control (1-bit)
    .var_wait_cnt(var_wait_cnt_2),     // Wait counter for stabilization (32-bit)
    .var_err_offset(var_err_offset_2),   // Error offset adjustment (32-bit)
    .var_avg_sel(var_avg_sel_2),      // Average selection control (32-bit)

    // ============================ Feedback Control ============================
    .var_const_step(var_const_step_2),    // Constant step value (32-bit)
    .var_fb_ON(var_fb_ON_2),         // Feedback enable (1-bit)
    .var_gainSel_step(var_gainSel_step_2),  // Gain selection for step feedback (32-bit)

    // ============================ Phase Ramp Control ============================
    .var_gainSel_ramp(var_gainSel_ramp_2), // Gain selection for ramp control (32-bit)

    // ============================ Output Signals ============================
    .o_err_DAC(o_err_DAC2),       // Processed error signal output (32-bit, signed)
    .o_err_DAC_FIR(o_err_DAC2_FIR),   // FIR filtered error signal (32-bit, signed)
    .o_step(o_step_2),          // Feedback step output (32-bit, signed)
    .o_step_MV(o_step_2_MV),       // Filtered step output (32-bit, signed)
    .o_phaseRamp(o_phaseRamp_2)      // Phase ramp output (32-bit, signed)
);

my_fog_v2 #(  // z axis
   .COEFF_SET(N32FC2) // Default coefficient set N32FC5
) my_fog_ch3_inst (
   // ============================ Common Signals ============================
   .CLOCK_ADC(CLOCK_ADC), // ADC clock (1-bit)
   .CLOCK_DAC(CLOCK_DAC), // DAC clock (1-bit)
   .locked(locked_0),    // Global reset signal, active low (1-bit)

   // ============================ ADC Processing ============================
   .ADC(ADC_2_2), // Raw ADC input signal (14-bit)

   // ============================ Modulation Generator ============================
   .var_freq_cnt(var_freq_cnt_3), // Frequency control input (32-bit)
   .var_amp_H(var_amp_H_3),    // Positive amplitude control (32-bit)
   .var_amp_L(var_amp_L_3),    // Negative amplitude control (32-bit)

   // ============================ Error Signal Processing ============================
   .var_polarity(var_polarity_3),     // Polarity control (1-bit)
   .var_wait_cnt(var_wait_cnt_3),     // Wait counter for stabilization (32-bit)
   .var_err_offset(var_err_offset_3),   // Error offset adjustment (32-bit)
   .var_avg_sel(var_avg_sel_3),      // Average selection control (32-bit)

   // ============================ Feedback Control ============================
   .var_const_step(var_const_step_3),    // Constant step value (32-bit)
   .var_fb_ON(var_fb_ON_3),         // Feedback enable (1-bit)
   .var_gainSel_step(var_gainSel_step_3),  // Gain selection for step feedback (32-bit)

   // ============================ Phase Ramp Control ============================
   .var_gainSel_ramp(var_gainSel_ramp_3), // Gain selection for ramp control (32-bit)

   // ============================ Output Signals ============================
   .o_err_DAC(o_err_DAC3),       // Processed error signal output (32-bit, signed)
   .o_err_DAC_FIR(o_err_DAC3_FIR),   // FIR filtered error signal (32-bit, signed)
   .o_step(o_step_3),          // Feedback step output (32-bit, signed)
   .o_step_MV(o_step_3_MV),       // Filtered step output (32-bit, signed)
   .o_phaseRamp(o_phaseRamp_3)      // Phase ramp output (32-bit, signed)
);

i2c_controller_pullup_ADS122C04_SE_V2
inst_i2c_ADS122C04_temp (
	.i_clk(CPU_CLK),
	.i_rst_n(locked_0),
	.i2c_scl(SCL_ADC_TEMP),
	.i2c_sda(SDA_ADC_TEMP),
	.i2c_clk_out(),
	.i_dev_addr(var_i2c_ads122c04_temp_dev_addr),
	.i_reg_addr(var_i2c_ads122c04_temp_reg_addr),
	.i_w_data(var_i2c_ads122c04_temp_w_data),  
	
	.i_ctrl(var_i2c_ads122c04_temp_ctrl),
	.i_drdy(DRDY_ADC_TEMP),

	.o_status(var_i2c_ads122c04_temp_status),
	.o_AIN0(var_i2c_ads122c04_temp_rdata_1),
	.o_AIN1(var_i2c_ads122c04_temp_rdata_2),
	.o_AIN2(var_i2c_ads122c04_temp_rdata_3),
	.o_AIN3(var_i2c_ads122c04_temp_rdata_4),
	.o_w_enable(),
	.o_cnt()
);

/**** ADXL 357****/
i2c_controller_pullup_ADXL357
inst_i2c_adxl357 (
	.i_clk(CPU_CLK),
	.i_rst_n(locked_0),
	.i2c_scl(SCL_357),
	.i2c_sda(SDA_357),
	.i2c_clk_out(),
	.i_dev_addr(var_i2c_357_dev_addr),
	.i_reg_addr(var_i2c_357_reg_addr),
	.i_w_data(var_i2c_357_w_data),  
	
	.i_ctrl(var_i2c_357_ctrl),
	.i_drdy(DRDY_357),

	.o_status(var_i2c_357_status),
	.o_ACCX(var_i2c_357_rdata_1),
	.o_ACCY(var_i2c_357_rdata_2),
	.o_ACCZ(var_i2c_357_rdata_3),
	.o_TEMP(var_i2c_357_rdata_4),
	.o_w_enable()
);
	
/**** I2C EEPROM****/
i2c_controller_pullup_eeprom
inst_i2c_eeprom (
	.i_clk(CPU_CLK),
	.i_rst_n(locked_0),
	.i2c_scl(SCL_EEPROM),
	.i2c_sda(SDA_EEPROM),
	.i2c_clk_out(),
	.i_dev_addr(var_i2c_EEPROM_dev_addr),
	.i_reg_addr(var_i2c_EEPROM_reg_addr),
	.i_w_data(var_i2c_EEPROM_w_data),  
	
	.i_ctrl(var_i2c_EEPROM_ctrl),
	.i_drdy(),

	.o_status(var_i2c_EEPROM_status),
	.o_rd_data(var_i2c_EEPROM_rdata_1),
	.o_rd_data_2(var_i2c_EEPROM_rdata_2),
	.o_rd_data_3(var_i2c_EEPROM_rdata_3),
	.o_rd_data_4(var_i2c_EEPROM_rdata_4),
	.o_w_enable()
);


CPU u0 (
	.clk_clk        (CPU_CLK),        //      clk.clk 
	.reset_reset_n  (locked_0),  //    reset.reset_n

	.spi_adc_MISO      (ADC_CFG_MISO),      //    spi_adc.MISO
	.spi_adc_MOSI      (ADC_CFG_MOSI),      //           .MOSI
	.spi_adc_SCLK      (ADC_CFG_SCLK),      //           .SCLK
	.spi_adc_SS_n      (ADC_CFG_SS),      //           .SS_n

	.spi_dac_MISO      (DAC_CFG_MISO),      //    spi_dac.MISO
	.spi_dac_MOSI      (DAC_CFG_MOSI),      //           .MOSI
	.spi_dac_SCLK      (DAC_CFG_SCLK),      //           .SCLK
	.spi_dac_SS_n      (DAC_CFG_SS),      //           .SS_n
	
	.epcs_dclk     (EPCS_DCLK),     //     epcs.dclk
	.epcs_sce      (EPCS_NCSO),      //         .sce
	.epcs_sdo      (EPCS_ASDO),      //         .sdo
	.epcs_data0    (EPCS_DATA0),     //         .data0
	
	.sdram_addr    (SDRAM_ADDR),    //    sdram.addr
	.sdram_ba      (SDRAM_BA),      //         .ba
	.sdram_cas_n   (SDRAM_CAS_N),   //         .cas_n
	.sdram_cke     (SDRAM_CKE),     //         .cke
	.sdram_cs_n    (SDRAM_CS_N),    //         .cs_n
	.sdram_dq      (SDRAM_DQ),      //         .dq
	.sdram_dqm     (SDRAM_DQM),     //         .dqm
	.sdram_ras_n   (SDRAM_RAS_N),   //         .ras_n
	.sdram_we_n    (SDRAM_WE_N),     //         .we_n
	
	.trigger_in_export (sync_out), 				// trigger_in.export
	
	.uart_rxd          (FPGA_RX),          //       uart.rxd
	.uart_txd          (FPGA_TX),          //           .txd
	.uart_dbg_rxd      (DBG_RX),      //   uart_dbg.rxd
    .uart_dbg_txd      (DBG_TX),      //           .txd

	.wdt_export			(),

	.varset_1_o_reg0     (var_i2c_357_dev_addr),     
	.varset_1_o_reg1     (var_i2c_357_w_data),     
	.varset_1_o_reg2     (var_i2c_357_ctrl),     
	.varset_1_o_reg3     (),     
	.varset_1_o_reg4     (var_i2c_357_reg_addr),     
	.varset_1_o_reg5     (var_i2c_EEPROM_dev_addr),     
	.varset_1_o_reg6     (var_i2c_EEPROM_w_data),     
	.varset_1_o_reg7     (var_i2c_EEPROM_ctrl),    
	.varset_1_o_reg8     (var_i2c_EEPROM_reg_addr),    
	.varset_1_o_reg9     (var_freq_cnt_1),    
	.varset_1_o_reg10    (var_amp_H_1),   
	.varset_1_o_reg11    (var_amp_L_1),    
	.varset_1_o_reg12    (var_polarity_1),    
	.varset_1_o_reg13    (var_wait_cnt_1),    
	.varset_1_o_reg14    (var_avg_sel_1),    
	.varset_1_o_reg15  	 (var_gainSel_step_1),  
	.varset_1_o_reg16  	 (var_const_step_1),  
	.varset_1_o_reg17  	 (var_fb_ON_1),  
	.varset_1_o_reg18  	 (var_gainSel_ramp_1),  
	.varset_1_o_reg19  	 (var_err_offset_1),  
	.varset_1_o_reg20  (var_freq_cnt_2),  
	.varset_1_o_reg21  (var_amp_H_2),  
	.varset_1_o_reg22  (var_amp_L_2),  
	.varset_1_o_reg23  (var_polarity_2),  
	.varset_1_o_reg24  (var_wait_cnt_2),  
	.varset_1_o_reg25  (var_avg_sel_2),  
	.varset_1_o_reg26  (var_gainSel_step_2),  
	.varset_1_o_reg27  (var_const_step_2),  
	.varset_1_o_reg28  (var_fb_ON_2),  
	.varset_1_o_reg29  (var_gainSel_ramp_2),  
	.varset_1_o_reg30  (var_err_offset_2), 
	.varset_1_o_reg31  (var_freq_cnt_3),	
	.varset_1_o_reg32  (var_amp_H_3),  
	.varset_1_o_reg33  (var_amp_L_3),  
	.varset_1_o_reg34  (var_polarity_3),  
	.varset_1_o_reg35  (var_wait_cnt_3),  
	.varset_1_o_reg36  (var_avg_sel_3),  
	.varset_1_o_reg37  (var_gainSel_step_3),  
	.varset_1_o_reg38  (var_const_step_3),  
	.varset_1_o_reg39  (var_fb_ON_3),  
	.varset_1_o_reg40  (var_gainSel_ramp_3),  
	.varset_1_o_reg41  (var_err_offset_3),  
	.varset_1_o_reg42  (var_i2c_ads122c04_temp_dev_addr),  
	.varset_1_o_reg43  (var_i2c_ads122c04_temp_w_data),  
	.varset_1_o_reg44  (var_i2c_ads122c04_temp_ctrl),  
	.varset_1_o_reg45  (var_i2c_ads122c04_temp_reg_addr),  
	.varset_1_o_reg46  (),  
	.varset_1_o_reg47  (),  
	.varset_1_o_reg48  (),  
	.varset_1_o_reg49  (),  
	.varset_1_o_reg50  (),  
	.varset_1_o_reg51  (),  
	.varset_1_o_reg52  (),  
	.varset_1_o_reg53  (),  
	.varset_1_o_reg54  (),  
	.varset_1_o_reg55  (),  
	.varset_1_o_reg56  (),  
	.varset_1_o_reg57  (),  
	.varset_1_o_reg58  (var_timer_rst),  
	.varset_1_o_reg59  (var_sync_count), 

	.varset_1_i_var0     (var_i2c_357_status),     //           .i_var0
	.varset_1_i_var1     (var_i2c_357_rdata_1),     //           accl_x
	.varset_1_i_var2     (var_i2c_357_rdata_2),     //           accl_y
	.varset_1_i_var3     (var_i2c_357_rdata_3),     //           accl_z
	.varset_1_i_var4     (var_i2c_357_rdata_4),     //           temp
	.varset_1_i_var5     (),     //           .i_var5
	.varset_1_i_var6     (),     //           .i_var6
	.varset_1_i_var7     (),     //           .i_var7
	.varset_1_i_var8     (),     //           .i_var8
	.varset_1_i_var9     (),     //           .i_var9
	.varset_1_i_var10    (),    //           .i_var10
	.varset_1_i_var11    (),    //           .i_var11
	.varset_1_i_var12    (var_i2c_EEPROM_status),    //           .i_var12
	.varset_1_i_var13    (var_i2c_EEPROM_rdata_1),    //           .i_var13
	.varset_1_i_var14    (var_i2c_EEPROM_rdata_2),    //           .i_var14
	.varset_1_i_var15    (var_i2c_EEPROM_rdata_3),    //           .i_var15
	.varset_1_i_var16    (var_i2c_EEPROM_rdata_4),    //           .i_var16
	.varset_1_i_var17    (var_i2c_ads122c04_temp_status),    //           .i_var17
	.varset_1_i_var18    (var_i2c_ads122c04_temp_rdata_1),  //           .i_var18
	.varset_1_i_var19    (var_i2c_ads122c04_temp_rdata_2),  //           .i_var19
	.varset_1_i_var20    (var_i2c_ads122c04_temp_rdata_3),  //           .i_var20
	.varset_1_i_var21    (var_i2c_ads122c04_temp_rdata_4),  //           .i_var21
	.varset_1_i_var22  (),  //           .i_var22
	.varset_1_i_var23  (),  //           .i_var23
	.varset_1_i_var24  (),  //           .i_var24
	.varset_1_i_var25  (),  
	.varset_1_i_var26  (),  
	.varset_1_i_var27  (),  
	.varset_1_i_var28  (),  
	.varset_1_i_var29  (),  
	.varset_1_i_var30  (i_var_step_3),  // z axis
	.varset_1_i_var31  (i_var_err_3),  
	.varset_1_i_var32  (i_var_timer),  
	.varset_1_i_var33  (i_var_step_2),  // y axis
	.varset_1_i_var34  (i_var_err_2),  
	.varset_1_i_var35  (i_var_step_1),  // x axis
	.varset_1_i_var36  (i_var_err_1),  
	.varset_1_i_var37  (),  
	.varset_1_i_var38  (),  
	.varset_1_i_var39  (),  
	.varset_1_i_var40  (),  
	.varset_1_i_var41  (),  
	.varset_1_i_var42  (),  
	.varset_1_i_var43  (),  
	.varset_1_i_var44  (),  
	.varset_1_i_var45  (),  
	.varset_1_i_var46  (),  
	.varset_1_i_var47  (),  
	.varset_1_i_var48  (),  
	.varset_1_i_var49  (),  
	.varset_1_i_var50  (),  
	.varset_1_i_var51  (),  
	.varset_1_i_var52  (),  
	.varset_1_i_var53  (),  
	.varset_1_i_var54  (),  
	.varset_1_i_var55  (),  
	.varset_1_i_var56  (),  
	.varset_1_i_var57  (),  
	.varset_1_i_var58  (),  
	.varset_1_i_var59  () 
);


endmodule
