module HINS_TOP_V1(

	//////////// TCXO EXT CLOCK //////////
	input 	logic CLOCK_100M,

	//////////// UART //////////
	input 	logic FPGA_RX,
	output 	logic FPGA_TX,
	input 	logic DBG_RX,
	output 	logic DBG_TX,

	//////////// EXT SYNC //////////
	input 	logic SYNC_IN,

	//////////// DAC //////////
	output 	logic [15:0] DAC_DATA_OUT,
	output 	logic CLOCK_DAC,
	output 	logic DAC_RST,
	input 	logic DAC_MISO, 
	output 	logic DAC_MOSI,
	output 	logic DAC_SCLK,
	output 	logic DAC_CS,

	//////////// 14-bit parallel ADC (SPI) //////////
	input 	logic [13:0] ADC_DATA_IN,
	output 	logic CLOCK_ADC,
	input 	logic ADC_MISO,
	output 	logic ADC_MOSI,
	output 	logic ADC_SCLK,
	output 	logic ADC_CS,

	//////////// 24-bit serial ADC I2C//////////
	inout	wire		SDA_ADC,
	inout	wire		SCL_ADC,
	input	logic		DRDY_ADC,

	/////////// EEPROM I2C //////////
	inout	wire		SDA_EEPROM,
	inout	wire		SCL_EEPROM,

	//////////// SDRAM //////////
	output	logic  [12:0]	SDRAM_ADDR,
	output	logic  [1:0]	SDRAM_BA,
	output	logic          	SDRAM_CAS_N,
	output	logic        	SDRAM_CKE,
	output	logic         	CLOCK_SDRAM,
	output	logic         	SDRAM_CS_N,
	inout 	wire   [15:0]	SDRAM_DQ,
	output	logic  [1:0]	SDRAM_DQM,
	output	logic         	SDRAM_RAS_N,
	output	logic         	SDRAM_WE_N,

	//////////// MEMS IMU I2C //////////
	inout	wire		SDA_IMU,
	inout	wire		SCL_IMU,
	input	logic		DRDY_IMU,

	//////////// EPCS //////////
	output 	logic          		EPCS_ASDO,
	input	logic 			    EPCS_DATA0,
	output	logic	          	EPCS_DCLK,
	output	logic         		EPCS_NCSO
);

// -----------------------------------------------------------------------
// 頂層訊號連接 (Top-Level Signal Assignments)
// -----------------------------------------------------------------------
// 將 PLL 產生的內部時鐘 wire 連接到外部 output logic ports
assign CLOCK_ADC   = pll_clk_adc_int;
assign CLOCK_DAC   = pll_clk_dac_int;
assign CLOCK_SDRAM = pll_clk_sdram_int;

assign DAC_DATA_OUT = fog_mod_out[15:0];

// *************************************************************************
// * Internal Signals *
// *************************************************************************

// ---- 1. PLL & Reset 訊號 (來自您原始程式碼) ----
wire pll_locked;
wire pll_clk_adc_int;
wire pll_clk_dac_int; 
wire pll_clk_sdram_int;
wire pll_clk_cpu_int;
wire RST_SYNC_N; // 最終同步重置訊號
logic r_locked_sync1, r_locked_sync2;
logic RST_EXT_N = 1'b1; // 假設外部 nCONFIG 處理後為高

// ---- FOG Core 輸出訊號 (保持不變) ----
wire signed [31:0] fog_err_out;
wire signed [31:0] fog_mod_out;
wire signed [31:0] fog_step_out;

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
        r_locked_sync1 <= 1'b0;
        r_locked_sync2 <= 1'b0;
    end else begin
        // 使用 CPU 時鐘同步化 PLL_LOCKED 訊號
        r_locked_sync1 <= pll_locked;
        r_locked_sync2 <= r_locked_sync1;
    end
end

assign RST_SYNC_N = r_locked_sync2; // 最終同步重置訊號

// =========================================================================
// FOG 核心模組例化 (HINS_fog_v1)
// =========================================================================

HINS_fog_v1 u_hins_fog_v1 (
    // 時鐘與重置
    .CLOCK_ADC      (pll_clk_adc_int), 
    .CLOCK_CPU      (pll_clk_cpu_int), 
    .RST_SYNC_N     (RST_SYNC_N),      
    
    // ADC 接口
    .ADC            (ADC_DATA_IN),     
    
    // 參數輸入 (使用常數賦值給所有 NIOS 參數 Port)
    .var_freq_cnt   (32'd1000),     
    .var_amp_H      (32'd5000),     
    .var_amp_L      (32'd5000),     
    .var_polarity   (1'b0),       
    .var_wait_cnt   (32'd50),      
    .var_err_offset (32'd0),       
    .var_avg_sel    (32'd10),      
    .var_gainSel_step (32'd5),      // Step Gen 增益常數
    .var_gainSel_ramp (32'd10),     // Ramp Gen 增益常數
    .var_fb_ON      (32'd1),       
    .var_const_step (32'd100),      
    
    // 輸出訊號
    .o_err_DAC      (fog_err_out), 
    .o_phaseRamp  	(fog_mod_out), 
    .o_step         (fog_step_out)  
);
 
 
endmodule
