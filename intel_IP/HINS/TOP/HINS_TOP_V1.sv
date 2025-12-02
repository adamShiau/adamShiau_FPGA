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


CPU u0 (
        .clk_clk          (),          //      clk.clk
        .dac_rst_export   (),          //  dac_rst.export
        .epcs_dclk        (),          //     epcs.dclk
        .epcs_sce         (),          //         .sce
        .epcs_sdo         (),          //         .sdo
        .epcs_data0       (),          //         .data0
        .reset_reset_n    (),          //    reset.reset_n
        .sdram_addr       (),          //    sdram.addr
        .sdram_ba         (),          //         .ba
        .sdram_cas_n      (),          //         .cas_n
        .sdram_cke        (),          //         .cke
        .sdram_cs_n       (),          //         .cs_n
        .sdram_dq         (),          //         .dq
        .sdram_dqm        (),          //         .dqm
        .sdram_ras_n      (),          //         .ras_n
        .sdram_we_n       (),          //         .we_n
        .spi_adc_MISO     (),          //  spi_adc.MISO
        .spi_adc_MOSI     (),          //         .MOSI
        .spi_adc_SCLK     (),          //         .SCLK
        .spi_adc_SS_n     (),          //         .SS_n
        .spi_dac_MISO     (),          //  spi_dac.MISO
        .spi_dac_MOSI     (),          //         .MOSI
        .spi_dac_SCLK     (),          //         .SCLK
        .spi_dac_SS_n     (),          //         .SS_n
        .sync_in_export   (),          //  sync_in.export
        .uart_rxd         (),          //     uart.rxd
        .uart_txd         (),          //         .txd
        .uart_dbg_rxd     (),          // uart_dbg.rxd
        .uart_dbg_txd     (),          //         .txd
        .varset_1_i_var0  (),          // varset_1.i_var0
        .varset_1_i_var1  (),          //         .i_var1
        .varset_1_i_var2  (),          //         .i_var2
        .varset_1_i_var3  (),          //         .i_var3
        .varset_1_i_var4  (),          //         .i_var4
        .varset_1_i_var5  (),          //         .i_var5
        .varset_1_i_var6  (),          //         .i_var6
        .varset_1_i_var7  (),          //         .i_var7
        .varset_1_i_var8  (),          //         .i_var8
        .varset_1_i_var9  (),          //         .i_var9
        .varset_1_i_var10 (),          //         .i_var10
        .varset_1_i_var11 (),          //         .i_var11
        .varset_1_i_var12 (),          //         .i_var12
        .varset_1_i_var13 (),          //         .i_var13
        .varset_1_i_var14 (),          //         .i_var14
        .varset_1_i_var15 (),          //         .i_var15
        .varset_1_i_var16 (),          //         .i_var16
        .varset_1_i_var17 (),          //         .i_var17
        .varset_1_i_var18 (),          //         .i_var18
        .varset_1_i_var19 (),          //         .i_var19
        .varset_1_i_var20 (),          //         .i_var20
        .varset_1_i_var21 (),          //         .i_var21
        .varset_1_i_var22 (),          //         .i_var22
        .varset_1_i_var23 (),          //         .i_var23
        .varset_1_i_var24 (),          //         .i_var24
        .varset_1_i_var25 (),          //         .i_var25
        .varset_1_i_var26 (),          //         .i_var26
        .varset_1_i_var27 (),          //         .i_var27
        .varset_1_i_var28 (),          //         .i_var28
        .varset_1_i_var29 (),          //         .i_var29
        .varset_1_i_var30 (),          //         .i_var30
        .varset_1_i_var31 (),          //         .i_var31
        .varset_1_i_var32 (),          //         .i_var32
        .varset_1_i_var33 (),          //         .i_var33
        .varset_1_i_var34 (),          //         .i_var34
        .varset_1_i_var35 (),          //         .i_var35
        .varset_1_i_var36 (),          //         .i_var36
        .varset_1_i_var37 (),          //         .i_var37
        .varset_1_i_var38 (),          //         .i_var38
        .varset_1_i_var39 (),          //         .i_var39
        .varset_1_i_var40 (),          //         .i_var40
        .varset_1_i_var41 (),          //         .i_var41
        .varset_1_i_var42 (),          //         .i_var42
        .varset_1_i_var43 (),          //         .i_var43
        .varset_1_i_var44 (),          //         .i_var44
        .varset_1_i_var45 (),          //         .i_var45
        .varset_1_i_var46 (),          //         .i_var46
        .varset_1_i_var47 (),          //         .i_var47
        .varset_1_i_var48 (),          //         .i_var48
        .varset_1_i_var49 (),          //         .i_var49
        .varset_1_i_var50 (),          //         .i_var50
        .varset_1_i_var51 (),          //         .i_var51
        .varset_1_i_var52 (),          //         .i_var52
        .varset_1_i_var53 (),          //         .i_var53
        .varset_1_i_var54 (),          //         .i_var54
        .varset_1_i_var55 (),          //         .i_var55
        .varset_1_i_var56 (),          //         .i_var56
        .varset_1_i_var57 (),          //         .i_var57
        .varset_1_i_var58 (),          //         .i_var58
        .varset_1_i_var59 (),          //         .i_var59
        .varset_1_o_reg0  (),          //         .o_reg0
        .varset_1_o_reg1  (),          //         .o_reg1
        .varset_1_o_reg2  (),          //         .o_reg2
        .varset_1_o_reg3  (),          //         .o_reg3
        .varset_1_o_reg4  (),          //         .o_reg4
        .varset_1_o_reg5  (),          //         .o_reg5
        .varset_1_o_reg6  (),          //         .o_reg6
        .varset_1_o_reg7  (),          //         .o_reg7
        .varset_1_o_reg8  (),          //         .o_reg8
        .varset_1_o_reg9  (),          //         .o_reg9
        .varset_1_o_reg10 (),          //         .o_reg10
        .varset_1_o_reg11 (),          //         .o_reg11
        .varset_1_o_reg12 (),          //         .o_reg12
        .varset_1_o_reg13 (),          //         .o_reg13
        .varset_1_o_reg14 (),          //         .o_reg14
        .varset_1_o_reg15 (),          //         .o_reg15
        .varset_1_o_reg16 (),          //         .o_reg16
        .varset_1_o_reg17 (),          //         .o_reg17
        .varset_1_o_reg18 (),          //         .o_reg18
        .varset_1_o_reg19 (),          //         .o_reg19
        .varset_1_o_reg20 (),          //         .o_reg20
        .varset_1_o_reg21 (),          //         .o_reg21
        .varset_1_o_reg22 (),          //         .o_reg22
        .varset_1_o_reg23 (),          //         .o_reg23
        .varset_1_o_reg24 (),          //         .o_reg24
        .varset_1_o_reg25 (),          //         .o_reg25
        .varset_1_o_reg26 (),          //         .o_reg26
        .varset_1_o_reg27 (),          //         .o_reg27
        .varset_1_o_reg28 (),          //         .o_reg28
        .varset_1_o_reg29 (),          //         .o_reg29
        .varset_1_o_reg30 (),          //         .o_reg30
        .varset_1_o_reg31 (),          //         .o_reg31
        .varset_1_o_reg32 (),          //         .o_reg32
        .varset_1_o_reg33 (),          //         .o_reg33
        .varset_1_o_reg34 (),          //         .o_reg34
        .varset_1_o_reg35 (),          //         .o_reg35
        .varset_1_o_reg36 (),          //         .o_reg36
        .varset_1_o_reg37 (),          //         .o_reg37
        .varset_1_o_reg38 (),          //         .o_reg38
        .varset_1_o_reg39 (),          //         .o_reg39
        .varset_1_o_reg40 (),          //         .o_reg40
        .varset_1_o_reg41 (),          //         .o_reg41
        .varset_1_o_reg42 (),          //         .o_reg42
        .varset_1_o_reg43 (),          //         .o_reg43
        .varset_1_o_reg44 (),          //         .o_reg44
        .varset_1_o_reg45 (),          //         .o_reg45
        .varset_1_o_reg46 (),          //         .o_reg46
        .varset_1_o_reg47 (),          //         .o_reg47
        .varset_1_o_reg48 (),          //         .o_reg48
        .varset_1_o_reg49 (),          //         .o_reg49
        .varset_1_o_reg50 (),          //         .o_reg50
        .varset_1_o_reg51 (),          //         .o_reg51
        .varset_1_o_reg52 (),          //         .o_reg52
        .varset_1_o_reg53 (),          //         .o_reg53
        .varset_1_o_reg54 (),          //         .o_reg54
        .varset_1_o_reg55 (),          //         .o_reg55
        .varset_1_o_reg56 (),          //         .o_reg56
        .varset_1_o_reg57 (),          //         .o_reg57
        .varset_1_o_reg58 (),          //         .o_reg58
        .varset_1_o_reg59 ()           //         .o_reg59
    );


 
 
endmodule
