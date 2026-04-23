// Make data: 04-23-2026
module IRIS_TOP_V1(

	//////////// CLOCK  ////////    
	input 	logic 	CLOCK_100M, 

	//////////// UART //////////
	input	logic 	FPGA_RX,
	output	logic 	FPGA_TX,
    input 	logic 	DBG_RX, // dbg pin located in Micro-D15 conn.
	output 	logic 	DBG_TX,

	//////////// EXT SYNC //////////
	input	logic 	EXT_SYNC_IN,
	output	logic	EXT_SYNC_OUT,

	//////////// INT SYNC //////////
	output	logic	INT_SYNC, // internal sync signal to ICs

	//////////// DAC ///////////////
	//----CLOCK----
	output 	logic	CLOCK_DAC,
	//----BUS----
	output	logic [15:0]	DAC_1_1, 
	output	logic [15:0]	DAC_2_1,	
	output	logic [15:0]	DAC_2_2, 
	//----Config----
	output	logic	DAC_RST,
	input	logic	DAC_CFG_MISO, 
	output	logic	DAC_CFG_MOSI, 
	output	logic	DAC_CFG_SCLK, 
	output	logic	CS_DAC_1, 
	output	logic	CS_DAC_2, 

	//////////// ADC //////////
	//----CLOCK----
	output 	logic	CLOCK_ADC,
	//----BUS----
	input	logic [13:0]	ADC_1_1, 
	input	logic [13:0]	ADC_2_1, 
	input	logic [13:0]	ADC_2_2,
	//----Serial----
	input	logic	ADC_CFG_MISO, 
	output	logic	ADC_CFG_MOSI, 
	output	logic	ADC_CFG_SCLK, 
	output	logic	CS_ADC_1, 
	output	logic	CS_ADC_2, 

	//////////// SDRAM //////////
	output	logic    [12:0]		SDRAM_ADDR,
	output	logic	 [1:0]		SDRAM_BA,
	output	logic	          	SDRAM_CAS_N,
	output	logic	          	SDRAM_CKE,
	output	logic	          	CLOCK_SDRAM,
	output	logic	          	SDRAM_CS_N,
	inout 	wire	 [15:0]		SDRAM_DQ,
	output	logic	 [1:0]		SDRAM_DQM,
	output	logic	          	SDRAM_RAS_N,
	output	logic	          	SDRAM_WE_N,

	/////////// PIO ////////// 
	output logic	WDT_EN,
	output logic	WDI,
	output logic	MUX_IN2,
	output logic	MUX_IN1,

	//////////// XLM550 //////////
	//----SPI_XLM550----
	input	logic	MISO_XLM550,
	output 	logic	MOSI_XLM550,
	output 	logic	SCLK_XLM550,
	input 	logic	DRDY_SPI_XLM550,
	//----I2C_XLM550----
	inout	wire	SCL_XLM550,
	inout	wire	SDA_XLM550,
	input 	logic	DRDY_I2C_XLM550,


	//////////// ADXL357 I2C //////////
	inout	wire	SDA_357,
	inout	wire	SCL_357,
	input 	logic	DRDY_357,

	/////////// 24-bit Serial ADC I2C //////////
	inout	wire	SDA_ADC_TEMP, 
	inout	wire	SCL_ADC_TEMP,
	input 	logic	DRDY_ADC_TEMP,

	//////////// BMM350 I2C (MAG) //////////
	inout	wire	SDA_BMM350,
	inout	wire	SCL_BMM350,
	input 	logic	DRDY_BMM350,

	//////////// BMM581 I2C (BAR) //////////
	inout	wire	SDA_BMM581,
	inout	wire	SCL_BMM581,
	input 	logic	DRDY_BMM581,

	//////////// GNSS UART //////////
	output	logic 	GNSS_TX,
	input	logic 	GNSS_RX,

	//////////// LED //////////
	output	logic 	LED_SENSOR,

	//////////// EPCS //////////
	output	logic   EPCS_ASDO,
	input 	logic   EPCS_DATA0,
	output	logic   EPCS_DCLK,
	output	logic	EPCS_NCSO,
	
	/////////// EEPROM I2C //////////
	inout	wire	SDA_EEPROM,
	inout	wire	SCL_EEPROM
);

// -----------------------------------------------------------------------
// 頂層訊號連接 (Top-Level Signal Assignments)
// -----------------------------------------------------------------------

// 將 PLL 產生的內部時鐘 wire 連接到外部 output logic ports
assign CLOCK_ADC 		= pll_clk_adc_int;
assign CLOCK_DAC 		= pll_clk_dac_int;
assign CLOCK_SDRAM		= pll_clk_sdram_int;

// sync 訊號連接
assign INT_SYNC 	= sync_out;
assign EXT_SYNC_OUT = sync_out;

// ADC, DAC CS
assign CS_DAC_1 = DAC_CFG_SS[0];
assign CS_DAC_2 = DAC_CFG_SS[1];
assign CS_ADC_1 = ADC_CFG_SS[0];
assign CS_ADC_2 = ADC_CFG_SS[1];

// MIOC Modulation
assign DAC_1_1 =  o_phaseRamp_1[15:0];
assign DAC_2_1 =  o_phaseRamp_2[15:0];
assign DAC_2_2 =  o_phaseRamp_3[15:0];

assign i_var_step_1 = o_step_1;
assign i_var_err_1 = o_err_DAC1;
assign i_var_accu_step_H_1 	 = fog_accu_step_H_1;
assign i_var_accu_step_L_1 	 = fog_accu_step_L_1;
assign i_var_accu_step_cnt_1 = fog_accu_step_cnt_1; 

assign i_var_step_2 = o_step_2;
assign i_var_err_2 = o_err_DAC2; 
assign i_var_accu_step_H_2 	 = fog_accu_step_H_2;
assign i_var_accu_step_L_2 	 = fog_accu_step_L_2;
assign i_var_accu_step_cnt_2 = fog_accu_step_cnt_2; 

assign i_var_step_3 = o_step_3;
assign i_var_err_3 = o_err_DAC3; 
assign i_var_accu_step_H_3 	 = fog_accu_step_H_3;
assign i_var_accu_step_L_3 	 = fog_accu_step_L_3;
assign i_var_accu_step_cnt_3 = fog_accu_step_cnt_3; 

assign DAC_RST = var_dac_rst;
assign MUX_IN1 = var_mux_sel[0];
assign MUX_IN2 = var_mux_sel[1];


// *************************************************************************
// * Internal Signals *
// *************************************************************************

// ---- PLL & Reset 訊號 ---- //
wire pll_locked;
wire pll_clk_adc_int;
wire pll_clk_dac_int; 
wire pll_clk_sdram_int;
wire pll_clk_cpu_int;
wire RST_SYNC_N; 
logic r_locked_sync1, r_locked_sync2;
logic RST_EXT_N = 1'b1;

// ---- Sync ---- //
wire sync_out;

// ---- Nios2 連接訊號 ---- //
wire [1:0] ADC_CFG_SS; 
wire [1:0] DAC_CFG_SS; 

/******* sync setup *******/
wire [31:0] var_sync_count;

/******* timer setup *******/	
wire [31:0] i_var_timer, var_timer_rst;

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

/////////// PIO //////////
wire [31:0] var_mux_sel, var_dac_rst;

/////////// MIOC Modulation parameter //////////
wire [31:0] var_freq_cnt_3, var_amp_H_3, var_amp_L_3;
wire [31:0] var_freq_cnt_2, var_amp_H_2, var_amp_L_2;
wire [31:0] var_freq_cnt_1, var_amp_H_1, var_amp_L_1;

// ---- FOG Core & 累加器 訊號 ---- //
// #1
logic signed [31:0] o_err_DAC1, o_step_1, o_phaseRamp_1;
logic signed [31:0] fog_accu_step_H_1, fog_accu_step_L_1, fog_accu_step_cnt_1;
logic [31:0] var_polarity_1, var_wait_cnt_1, var_avg_sel_1, var_err_offset_1;
logic [31:0] var_gainSel_ramp_1, var_gainSel_step_1, var_const_step_1, var_fb_ON_1;
logic o_step_sync_1;
// #2
logic signed [31:0] o_err_DAC2, o_step_2, o_phaseRamp_2;
logic signed [31:0] fog_accu_step_H_2, fog_accu_step_L_2, fog_accu_step_cnt_2;
logic [31:0] var_polarity_2, var_wait_cnt_2, var_avg_sel_2, var_err_offset_2;
logic [31:0] var_gainSel_ramp_2, var_gainSel_step_2, var_const_step_2, var_fb_ON_2;
logic o_step_sync_2;
// #3
logic signed [31:0] o_err_DAC3, o_step_3, o_phaseRamp_3;
logic signed [31:0] fog_accu_step_H_3, fog_accu_step_L_3, fog_accu_step_cnt_3;
logic [31:0] var_polarity_3, var_wait_cnt_3, var_avg_sel_3, var_err_offset_3;
logic [31:0] var_gainSel_ramp_3, var_gainSel_step_3, var_const_step_3, var_fb_ON_3;
logic o_step_sync_3;

/////////// Nios input  //////////
logic signed [31:0] i_var_step_3, i_var_err_3;
logic signed [31:0] i_var_step_2, i_var_err_2;
logic signed [31:0] i_var_step_1, i_var_err_1;

/*** Step accumulator var ***/
logic signed [31:0] i_var_accu_step_L_1, i_var_accu_step_H_1, i_var_accu_step_cnt_1;
logic signed [31:0] i_var_accu_step_L_2, i_var_accu_step_H_2, i_var_accu_step_cnt_2;
logic signed [31:0] i_var_accu_step_L_3, i_var_accu_step_H_3, i_var_accu_step_cnt_3;


// -----------------------------------------------------------------------
// PLL Block
// -----------------------------------------------------------------------
pll	pll_inst (
	.inclk0 ( CLOCK_100M ),
	.c0 ( pll_clk_adc_int ),
	.c1 ( pll_clk_dac_int ),
	.c2 ( pll_clk_sdram_int ),
	.c3 ( pll_clk_cpu_int ),
	.locked ( pll_locked )
	);

// =========================================================================
// 同步重置邏輯 (Reset Synchronization Logic)
// =========================================================================

always @(posedge pll_clk_cpu_int or negedge RST_EXT_N) begin 
    if (!RST_EXT_N) begin
        r_locked_sync1 = 1'b0;
        r_locked_sync2 = 1'b0;
    end else begin
        // 使用 CPU 時鐘同步化 PLL_LOCKED 訊號
        r_locked_sync1 = pll_locked;
        r_locked_sync2 = r_locked_sync1;
    end
end

assign RST_SYNC_N = r_locked_sync2; // 最終同步重置訊號

// =========================================================================
// SYNC setup
// =========================================================================

my_sync_gen sync_gen_inst
(
    .i_clk(pll_clk_cpu_int),
    .i_rst_n(RST_SYNC_N),
 	.i_sync_count(var_sync_count),
    .o_sync_out(sync_out)
);

// =========================================================================
// timer setup
// =========================================================================

my_timer
#(.COUNTER_NUM(10000))
timer_inst
(
    .i_clk(pll_clk_cpu_int),
    .i_rst_n(RST_SYNC_N),
    .i_timer_rst(var_timer_rst),
    .o_timer(i_var_timer)
);

// =========================================================================
// FOG 核心模組例化
// =========================================================================
HINS_fog_v2 u_hins_fog_1 (
    // 時鐘與重置
    .CLOCK_ADC      (pll_clk_adc_int), 
    .CLOCK_CPU      (pll_clk_cpu_int), 
    .RST_SYNC_N     (RST_SYNC_N),      
    // ADC 接口
    .ADC            (ADC_1_1),     
    // 參數輸入 (使用常數賦值給所有 NIOS 參數 Port)
    .var_freq_cnt   (var_freq_cnt_1),     
    .var_amp_H      (var_amp_H_1),     
    .var_amp_L      (var_amp_L_1),     
    .var_polarity   (var_polarity_1),       
    .var_wait_cnt   (var_wait_cnt_1),      
    .var_err_offset (var_err_offset_1),       
    .var_avg_sel    (var_avg_sel_1),      
    .var_gainSel_step (var_gainSel_step_1),      // Step Gen 增益常數
    .var_gainSel_ramp (var_gainSel_ramp_1),     // Ramp Gen 增益常數
    .var_fb_ON      (var_fb_ON_1),       
    .var_const_step (var_const_step_1),      
    // 輸出訊號
    .o_err_DAC      (o_err_DAC1), 
    .o_phaseRamp  	(o_phaseRamp_1), 
    .o_step         (o_step_1), 
    .step_sync_out  (o_step_sync_1),

    // 測試reg
    .o_reg_1_err_signal_gen (),
    .o_reg_1_Feedback_control()
);

HINS_fog_v2 u_hins_fog_2 (
    // 時鐘與重置
    .CLOCK_ADC      (pll_clk_adc_int), 
    .CLOCK_CPU      (pll_clk_cpu_int), 
    .RST_SYNC_N     (RST_SYNC_N),      
    // ADC 接口
    .ADC            (ADC_2_1),     
    // 參數輸入 (使用常數賦值給所有 NIOS 參數 Port)
    .var_freq_cnt   (var_freq_cnt_2),     
    .var_amp_H      (var_amp_H_2),     
    .var_amp_L      (var_amp_L_2),     
    .var_polarity   (var_polarity_2),       
    .var_wait_cnt   (var_wait_cnt_2),      
    .var_err_offset (var_err_offset_2),       
    .var_avg_sel    (var_avg_sel_2),      
    .var_gainSel_step (var_gainSel_step_2),      // Step Gen 增益常數
    .var_gainSel_ramp (var_gainSel_ramp_2),     // Ramp Gen 增益常數
    .var_fb_ON      (var_fb_ON_2),       
    .var_const_step (var_const_step_2),      
    // 輸出訊號
    .o_err_DAC      (o_err_DAC2), 
    .o_phaseRamp  	(o_phaseRamp_2), 
    .o_step         (o_step_2), 
    .step_sync_out  (o_step_sync_2),

    // 測試reg
    .o_reg_1_err_signal_gen (),
    .o_reg_1_Feedback_control()
);

HINS_fog_v2 u_hins_fog_3 (
    // 時鐘與重置
    .CLOCK_ADC      (pll_clk_adc_int), 
    .CLOCK_CPU      (pll_clk_cpu_int), 
    .RST_SYNC_N     (RST_SYNC_N),      
    // ADC 接口
    .ADC            (ADC_2_2),     
    // 參數輸入 (使用常數賦值給所有 NIOS 參數 Port)
    .var_freq_cnt   (var_freq_cnt_3),     
    .var_amp_H      (var_amp_H_3),     
    .var_amp_L      (var_amp_L_3),     
    .var_polarity   (var_polarity_3),       
    .var_wait_cnt   (var_wait_cnt_3),      
    .var_err_offset (var_err_offset_3),       
    .var_avg_sel    (var_avg_sel_3),      
    .var_gainSel_step (var_gainSel_step_3),      // Step Gen 增益常數
    .var_gainSel_ramp (var_gainSel_ramp_3),     // Ramp Gen 增益常數
    .var_fb_ON      (var_fb_ON_3),       
    .var_const_step (var_const_step_3),      
    // 輸出訊號
    .o_err_DAC      (o_err_DAC3), 
    .o_phaseRamp  	(o_phaseRamp_3), 
    .o_step         (o_step_3), 
    .step_sync_out  (o_step_sync_3),

    // 測試reg
    .o_reg_1_err_signal_gen (),
    .o_reg_1_Feedback_control()
);

// =========================================================================
// FOG Step 累加器
// =========================================================================
step_accumulator u_step_accu_1 (
    .i_clk           (pll_clk_cpu_int),
    .i_rst_n         (RST_SYNC_N),
    .i_step_sync     (o_step_sync_1),   
    .i_step          (o_step_1),     // 已定義在 top 
    .i_sync_out      (sync_out),       // 外部同步訊號輸入
    .o_acc_step_low  (fog_accu_step_L_1),
    .o_acc_step_high (fog_accu_step_H_1),
    .o_acc_count     (fog_accu_step_cnt_1)
);

step_accumulator u_step_accu_2 (
    .i_clk           (pll_clk_cpu_int),
    .i_rst_n         (RST_SYNC_N),
    .i_step_sync     (o_step_sync_2),   
    .i_step          (o_step_2),     // 已定義在 top 
    .i_sync_out      (sync_out),       // 外部同步訊號輸入
    .o_acc_step_low  (fog_accu_step_L_2),
    .o_acc_step_high (fog_accu_step_H_2),
    .o_acc_count     (fog_accu_step_cnt_2)
);

step_accumulator u_step_accu_3 (
    .i_clk           (pll_clk_cpu_int),
    .i_rst_n         (RST_SYNC_N),
    .i_step_sync     (o_step_sync_3),   
    .i_step          (o_step_3),     // 已定義在 top 
    .i_sync_out      (sync_out),       // 外部同步訊號輸入
    .o_acc_step_low  (fog_accu_step_L_3),
    .o_acc_step_high (fog_accu_step_H_3),
    .o_acc_count     (fog_accu_step_cnt_3)
);

// =========================================================================
// EEPROM
// =========================================================================
 i2c_controller_eeprom
 inst_i2c_eeprom (
 	.i_clk(pll_clk_cpu_int),
 	.i_rst_n(RST_SYNC_N),
 	.i2c_scl(SCL_EEPROM),
 	.i2c_sda(SDA_EEPROM),
 	.i_dev_addr(var_i2c_EEPROM_dev_addr),
 	.i_reg_addr(var_i2c_EEPROM_reg_addr),
 	.i_w_data(var_i2c_EEPROM_w_data),  
 	.i_ctrl(var_i2c_EEPROM_ctrl),
 	.i_drdy(),

 	.o_status(var_i2c_EEPROM_status),
 	.o_rd_data(var_i2c_EEPROM_rdata_1),
 	.o_rd_data_2(var_i2c_EEPROM_rdata_2),
 	.o_rd_data_3(var_i2c_EEPROM_rdata_3),
 	.o_rd_data_4(var_i2c_EEPROM_rdata_4)
 );
	
// =========================================================================
// ADC ADS122C04
// =========================================================================

i2c_controller_ADS122C04
inst_i2c_ADS122C04 (
	.i_clk(pll_clk_cpu_int),
	.i_rst_n(RST_SYNC_N),
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

// =========================================================================
// MEMS Accl ADXL357
// =========================================================================
  i2c_controller_pullup_ADXL357
  inst_i2c_adxl357 (
  	.i_clk(pll_clk_cpu_int),
  	.i_rst_n(RST_SYNC_N),
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

	

CPU u0 (
	.clk_clk        (pll_clk_cpu_int),        //      clk.clk 
	.reset_reset_n  (RST_SYNC_N),  //    reset.reset_n

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
	.dac_rst_export     (var_dac_rst),    //    dac_rst.export
	.mux_in_export      (var_mux_sel),     //     mux_in.export

	.varset_1_o_latch_trigger (), //           .o_latch_trigger
	.varset_1_o_reg0    (var_freq_cnt_1),    
	.varset_1_o_reg1   	(var_amp_H_1),   
	.varset_1_o_reg2   	(var_amp_L_1),    
	.varset_1_o_reg3   	(var_polarity_1),    
	.varset_1_o_reg4   	(var_wait_cnt_1),    
	.varset_1_o_reg5   	(var_avg_sel_1),    
	.varset_1_o_reg6   	(var_gainSel_step_1),  
	.varset_1_o_reg7   	(var_const_step_1),  
	.varset_1_o_reg8   	(var_fb_ON_1),  
	.varset_1_o_reg9   	(var_gainSel_ramp_1),  
	.varset_1_o_reg10  	(var_err_offset_1),  
	.varset_1_o_reg11  	(var_freq_cnt_2),  
	.varset_1_o_reg12  	(var_amp_H_2),  
	.varset_1_o_reg13  	(var_amp_L_2),  
	.varset_1_o_reg14  	(var_polarity_2),  
	.varset_1_o_reg15  	(var_wait_cnt_2),  
	.varset_1_o_reg16  	(var_avg_sel_2),  
	.varset_1_o_reg17  	(var_gainSel_step_2),  
	.varset_1_o_reg18  	(var_const_step_2),  
	.varset_1_o_reg19  	(var_fb_ON_2),  
	.varset_1_o_reg20  	(var_gainSel_ramp_2),  
	.varset_1_o_reg21  	(var_err_offset_2), 
	.varset_1_o_reg22  	(var_freq_cnt_3),	
	.varset_1_o_reg23  	(var_amp_H_3),  
	.varset_1_o_reg24  	(var_amp_L_3),  
	.varset_1_o_reg25  	(var_polarity_3),  
	.varset_1_o_reg26  	(var_wait_cnt_3),  
	.varset_1_o_reg27  	(var_avg_sel_3),  
	.varset_1_o_reg28  	(var_gainSel_step_3),  
	.varset_1_o_reg29  	(var_const_step_3),  
	.varset_1_o_reg30  	(var_fb_ON_3),  
	.varset_1_o_reg31  	(var_gainSel_ramp_3),  
	.varset_1_o_reg32  	(var_err_offset_3), 
	.varset_1_o_reg33	(var_sync_count),           
	.varset_1_o_reg34 	(var_timer_rst),  
	.varset_1_o_reg35 	(var_i2c_ads122c04_temp_dev_addr),
	.varset_1_o_reg36 	(var_i2c_ads122c04_temp_reg_addr),         
	.varset_1_o_reg37 	(var_i2c_ads122c04_temp_w_data),          
	.varset_1_o_reg38 	(var_i2c_ads122c04_temp_ctrl),           
	.varset_1_o_reg39 	(var_i2c_EEPROM_dev_addr),   //        
	.varset_1_o_reg40 	(var_i2c_EEPROM_reg_addr),   //        
	.varset_1_o_reg41 	(var_i2c_EEPROM_w_data),     //         
	.varset_1_o_reg42  	(var_i2c_EEPROM_ctrl),  
	.varset_1_o_reg43  	(),  
	.varset_1_o_reg44  	(),  
	.varset_1_o_reg45  	(),  
	.varset_1_o_reg46  	(),  
	.varset_1_o_reg47  	(var_i2c_357_dev_addr),  
	.varset_1_o_reg48  	(var_i2c_357_reg_addr),  
	.varset_1_o_reg49  	(var_i2c_357_w_data),  
	.varset_1_o_reg50  	(var_i2c_357_ctrl),  
	.varset_1_o_reg51  	(),  
	.varset_1_o_reg52  	(),  
	.varset_1_o_reg53  	(),  
	.varset_1_o_reg54  	(),  
	.varset_1_o_reg55  	(),  
	.varset_1_o_reg56  	(),  
	.varset_1_o_reg57  	(),  
	.varset_1_o_reg58  	(),  
	.varset_1_o_reg59  	(), 

	.varset_1_i_var0    (var_i2c_ads122c04_temp_status),    
	.varset_1_i_var1    (var_i2c_ads122c04_temp_rdata_1),  
	.varset_1_i_var2    (var_i2c_ads122c04_temp_rdata_2),  
	.varset_1_i_var3    (var_i2c_ads122c04_temp_rdata_3),  
	.varset_1_i_var4    (var_i2c_ads122c04_temp_rdata_4),  
	.varset_1_i_var5    (var_i2c_EEPROM_status),    
	.varset_1_i_var6    (var_i2c_EEPROM_rdata_1),    
	.varset_1_i_var7    (var_i2c_EEPROM_rdata_2),    
	.varset_1_i_var8    (var_i2c_EEPROM_rdata_3),    
	.varset_1_i_var9    (var_i2c_EEPROM_rdata_4),    
	.varset_1_i_var10	(var_i2c_357_status),     
	.varset_1_i_var11   (var_i2c_357_rdata_1),     
	.varset_1_i_var12   (var_i2c_357_rdata_2),     
	.varset_1_i_var13   (var_i2c_357_rdata_3),     
	.varset_1_i_var14   (var_i2c_357_rdata_4),     
	.varset_1_i_var15   (i_var_timer),     
	.varset_1_i_var16   (i_var_err_1),     
	.varset_1_i_var17   (i_var_step_1),     
	.varset_1_i_var18   (i_var_accu_step_L_1),     
	.varset_1_i_var19   (i_var_accu_step_H_1),     
	.varset_1_i_var20   (i_var_accu_step_cnt_1),    
	.varset_1_i_var21   (i_var_err_2),    
	.varset_1_i_var22  	(i_var_step_2),  
	.varset_1_i_var23  	(i_var_accu_step_L_2),  
	.varset_1_i_var24  	(i_var_accu_step_H_2),  
	.varset_1_i_var25  	(i_var_accu_step_cnt_2),  
	.varset_1_i_var26  	(i_var_err_3),  
	.varset_1_i_var27  	(i_var_step_3),  
	.varset_1_i_var28  	(i_var_accu_step_L_3),  
	.varset_1_i_var29  	(i_var_accu_step_H_3),  
	.varset_1_i_var30  	(i_var_accu_step_cnt_3),  
	.varset_1_i_var31  	(),  
	.varset_1_i_var32  	(),  
	.varset_1_i_var33  	(),  
	.varset_1_i_var34  	(),  
	.varset_1_i_var35  	(),  
	.varset_1_i_var36  	(),  
	.varset_1_i_var37  	(),  
	.varset_1_i_var38  	(),  
	.varset_1_i_var39  	(),  
	.varset_1_i_var40  	(),  
	.varset_1_i_var41  	(),  
	.varset_1_i_var42  	(),  
	.varset_1_i_var43  	(),  
	.varset_1_i_var44  	(),  
	.varset_1_i_var45  	(),  
	.varset_1_i_var46  	(),  
	.varset_1_i_var47  	(),  
	.varset_1_i_var48  	(),  
	.varset_1_i_var49  	(),  
	.varset_1_i_var50  	(),  
	.varset_1_i_var51  	(),  
	.varset_1_i_var52  	(),  
	.varset_1_i_var53  	(),  
	.varset_1_i_var54  	(),  
	.varset_1_i_var55  	(),  
	.varset_1_i_var56  	(),  
	.varset_1_i_var57  	(),  
	.varset_1_i_var58  	(),  
	.varset_1_i_var59  	() 
);

endmodule
