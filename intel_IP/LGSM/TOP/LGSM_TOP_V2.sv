module LGSM_TOP_V2(

	//////////// CLOCK //////////
	input 	logic CLOCK_50M,

	//////////// UART //////////
	input	logic FPGA_RX,
	output	logic FPGA_TX,
    input 	logic DBG_RX,
	output 	logic DBG_TX,

	//////////// EXT SYNC //////////
	input	logic SYNC_IN, 

	//////////// DAC //////////
	output	logic [15:0]	DAC1,
	output	logic [15:0]	DAC2,
	output 	logic 			DAC_CLK,
	output	logic 			DAC_RST,

	//////////// ADC //////////
	input	logic [14-1:0]	ADC_D1,
	input	logic 			ADC_OF1,
	output	logic 			ADC_CLK,

	//////////// SPI-ADDA //////////
	input	logic MISO,
	output	logic MOSI,
	output	logic SCLK,					
	output	logic CS_ADC,
	output	logic CS_DAC,

	////////////Temp. Semsor I2C //////////
	output 	wire	SCL,
	inout 	wire	SDA,

	//////////// LED //////////
	output	logic LED1,
	output	logic LED2,

	//////////// PROBE //////////
	output	logic P_K5,
	
	//////////// SDRAM //////////
	output	logic    [12:0]		SDRAM_ADDR,
	output	logic	 [1:0]		SDRAM_BA,
	output	logic	          	SDRAM_CAS_N,
	output	logic	          	SDRAM_CKE,
	output	logic	          	SDRAM_CLK,
	output	logic	          	SDRAM_CS_N,
	inout 	wire	 [15:0]		SDRAM_DQ,
	output	logic	 [1:0]		SDRAM_DQM,
	output	logic	          	SDRAM_RAS_N,
	output	logic	          	SDRAM_WE_N,

	//////////// EPCS //////////
	output	logic          		EPCS_ASDO,
	input 	logic         		EPCS_DATA0,
	output	logic     			EPCS_DCLK,
	output	logic	          	EPCS_NCSO
);

// -----------------------------------------------------------------------
// 頂層訊號連接 (Top-Level Signal Assignments)
// -----------------------------------------------------------------------
// 將 PLL 產生的內部時鐘 wire 連接到外部 output logic ports
assign ADC_CLK 		= pll_clk_adc_int;
assign DAC_CLK 		= pll_clk_dac_int;
assign SDRAM_CLK	= pll_clk_sdram_int;

// ADC, DAC
assign CS_DAC = SS[0];
assign CS_ADC = SS[1];
assign DAC_RST = var_dac_rst[0];

// MIOC Modulation
assign DAC1 = fog_ramp_out[15:0]; 

// FOG data
assign i_var_err = fog_err_out;
assign i_var_step = fog_step_out;
assign i_var_accu_step_H = fog_accu_step_H;
assign i_var_accu_step_L = fog_accu_step_L;
assign i_var_accu_step_cnt = fog_accu_step_cnt;


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
// wire sync_out;
wire r_sync_in;

// ---- FOG Core 輸出訊號 ---- //
wire signed [31:0] fog_err_out;
wire signed [31:0] fog_step_out;
wire signed [31:0] fog_ramp_out;
wire signed [31:0] fog_accu_step_L;
wire signed [31:0] fog_accu_step_H;
wire signed [31:0] fog_accu_step_cnt;
wire o_step_sync;

// ---- SPI CS to ADC and DAC ---- //
wire [1:0] SS;


// ---- Nios2 連接訊號 ---- //
/***  DAC Reset 訊號 ***/
wire [31:0] var_dac_rst;

/*** Timer ***/
wire [31:0] var_timer_rst, i_var_timer;

/*** Sync ***/
wire [31:0] var_sync_count;

/*** MIOC Modulation parameter ***/
wire [31:0] var_freq_cnt, var_amp_H, var_amp_L;

/*** MIOC Err Gen parameter ***/
wire [31:0] var_polarity, var_wait_cnt, var_avg_sel, var_err_offset;
logic signed [31:0] i_var_err;

/*** FB Step Gen parameter ***/
wire [31:0] var_gainSel_step, var_const_step, var_fb_ON;
logic signed [31:0] i_var_step;

/*** Phase Ramp Gen parameter ***/
wire [31:0] var_gainSel_ramp;

/*** Step accumulator var ***/
logic signed [31:0] i_var_accu_step_L, i_var_accu_step_H, i_var_accu_step_cnt;

// -----------------------------------------------------------------------
// PLL Block
// -----------------------------------------------------------------------
pll	pll_inst (
	.inclk0 ( CLOCK_50M ),
	.c0 ( pll_clk_dac_int ),
	.c1 ( pll_clk_sdram_int ),
	.c2 ( pll_clk_cpu_int ),
	.c3 ( pll_clk_adc_int ),
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

// my_sync_gen sync_gen_inst
// (
//     .i_clk(pll_clk_cpu_int),
//     .i_rst_n(RST_SYNC_N),
//  	.i_sync_count(var_sync_count),
//     .o_sync_out(sync_out)
// );

always @(posedge pll_clk_cpu_int or negedge RST_EXT_N) begin 
    if (!RST_EXT_N) begin
        r_sync_in = 1'b0;
    end else begin
        // 使用 CPU 時鐘同步化 SYNC_IN 訊號
        r_sync_in = SYNC_IN;
    end
end

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
// FOG 核心模組例化 (HINS_fog_v1)
// =========================================================================

HINS_fog_v2 u_hins_fog (
    // 時鐘與重置
    .CLOCK_ADC      (pll_clk_adc_int), 
    .CLOCK_CPU      (pll_clk_cpu_int), 
    .RST_SYNC_N     (RST_SYNC_N),      
    // ADC 接口
    .ADC            (ADC_D1),     
    // 參數輸入 (使用常數賦值給所有 NIOS 參數 Port)
    .var_freq_cnt   (var_freq_cnt),     
    .var_amp_H      (var_amp_H),     
    .var_amp_L      (var_amp_L),     
    .var_polarity   (var_polarity),       
    .var_wait_cnt   (var_wait_cnt),      
    .var_err_offset (var_err_offset),       
    .var_avg_sel    (var_avg_sel),      
    .var_gainSel_step (var_gainSel_step),      // Step Gen 增益常數
    .var_gainSel_ramp (var_gainSel_ramp),     // Ramp Gen 增益常數
    .var_fb_ON      (var_fb_ON),       
    .var_const_step (var_const_step),      
    // 輸出訊號
    .o_err_DAC      (fog_err_out), 
    .o_phaseRamp  	(fog_ramp_out), 
    .o_step         (fog_step_out), 
    .step_sync_out  (o_step_sync),

    // 測試reg
    .o_reg_1_err_signal_gen (),
    .o_reg_1_Feedback_control()
);

// =========================================================================
// FOG Step 累加器
// =========================================================================
step_accumulator u_step_acc (
    .i_clk           (pll_clk_cpu_int),
    .i_rst_n         (RST_SYNC_N),
    .i_step_sync     (o_step_sync),    // 您需要從 HINS_fog_v1 拉出此訊號
    .i_step          (fog_step_out),     // 已定義在 top 
    .i_sync_out      (r_sync_in),       // 外部同步訊號輸入
    .o_acc_step_low  (fog_accu_step_L),
    .o_acc_step_high (fog_accu_step_H),
    .o_acc_count     (fog_accu_step_cnt)
);


// =========================================================================
// NIOS2 CPU
// =========================================================================

    CPU u0 (
        .clk_clk                  (pll_clk_cpu_int),            //      clk.clk
		.reset_reset_n            (RST_SYNC_N),                 //    reset.reset_n
		.dac_rst_export           (var_dac_rst),                //  dac_rst.export
        .epcs_dclk                (EPCS_DCLK),                  //     epcs.dclk
        .epcs_sce                 (EPCS_NCSO),                  //          .sce
        .epcs_sdo                 (EPCS_ASDO),                  //          .sdo
        .epcs_data0               (EPCS_DATA0),                 //          .data0
        .i2c_scl_export           (SCL),                        //  i2c_scl.export
        .i2c_sda_export           (SDA),                        //  i2c_sda.export
       	.sdram_addr       		  (SDRAM_ADDR),                 //    sdram.addr
        .sdram_ba         		  (SDRAM_BA),                   //         .ba
        .sdram_cas_n      		  (SDRAM_CAS_N),                //         .cas_n
        .sdram_cke        		  (SDRAM_CKE),                  //         .cke
        .sdram_cs_n       		  (SDRAM_CS_N),                 //         .cs_n
        .sdram_dq         		  (SDRAM_DQ),                   //         .dq
        .sdram_dqm        		  (SDRAM_DQM),                  //         .dqm
        .sdram_ras_n      		  (SDRAM_RAS_N),                //         .ras_n
        .sdram_we_n       		  (SDRAM_WE_N),                 //         .we_n
       	.spi_adda_MISO 			  (MISO),                       // spi_adda.MISO
		.spi_adda_MOSI 			  (MOSI),                       //         .MOSI
		.spi_adda_SCLK 			  (SCLK),                       //         .SCLK
		.spi_adda_SS_n 			  (SS),                         //         .SS_n
        // .sync_in_export           (sync_out),                   //  sync_in.export
        .sync_in_export           (r_sync_in),                   //  sync_in.export
        .uart_rxd                 (FPGA_RX),                    //     uart.rxd
        .uart_txd                 (FPGA_TX),                    //          .txd
		  .uart_dbg_rxd             (),             // uart_dbg.rxd
        .uart_dbg_txd             (),             //         .txd

        .varset_1_o_latch_trigger (),                           //         .o_latch_trigger
        .varset_1_o_reg0  (var_freq_cnt),              // varset_1.o_reg0
        .varset_1_o_reg1  (var_amp_H),                 //         .o_reg1
        .varset_1_o_reg2  (var_amp_L),                 //         .o_reg2
        .varset_1_o_reg3  (var_polarity),              //         .o_reg3
        .varset_1_o_reg4  (var_wait_cnt),              //         .o_reg4
        .varset_1_o_reg5  (var_avg_sel),               //         .o_reg5
        .varset_1_o_reg6  (var_gainSel_step),            //         .o_reg6
        .varset_1_o_reg7  (var_const_step),            //         .o_reg7
        .varset_1_o_reg8  (var_fb_ON),                 //         .o_reg8
        .varset_1_o_reg9  (var_gainSel_ramp),          //         .o_reg9
        .varset_1_o_reg10 (var_err_offset),          //         .o_reg10
        .varset_1_o_reg11 (),            //         .o_reg11
        .varset_1_o_reg12 (),             //         .o_reg12
        .varset_1_o_reg13 (),//         .o_reg13
        .varset_1_o_reg14 (),//         .o_reg14
        .varset_1_o_reg15 (),  //         .o_reg15
        .varset_1_o_reg16 (),    //         .o_reg16
        .varset_1_o_reg17 (),   //         .o_reg17
        .varset_1_o_reg18 (),   //         .o_reg18
        .varset_1_o_reg19 (),     //         .o_reg19
        .varset_1_o_reg20 (),       //         .o_reg20
        .varset_1_o_reg21 (),      //         .o_reg21
        .varset_1_o_reg22 (),      //         .o_reg22
        .varset_1_o_reg23 (),        //         .o_reg23
        .varset_1_o_reg24 (),          //         .o_reg24
        .varset_1_o_reg25 (),                          //         .o_reg25
        .varset_1_o_reg26 (),                          //         .o_reg26
        .varset_1_o_reg27 (),                          //         .o_reg27
        .varset_1_o_reg28 (),                          //         .o_reg28
        .varset_1_o_reg29 (),                          //         .o_reg29
        .varset_1_o_reg30 (),                          //         .o_reg30
        .varset_1_o_reg31 (),                          //         .o_reg31
        .varset_1_o_reg32 (),                          //         .o_reg32
        .varset_1_o_reg33 (var_sync_count),            //         .o_reg11
        .varset_1_o_reg34 (var_timer_rst),             //         .o_reg12
        .varset_1_o_reg35 (),//         .o_reg13
        .varset_1_o_reg36 (),//         .o_reg14
        .varset_1_o_reg37 (),  //         .o_reg15
        .varset_1_o_reg38 (),    //         .o_reg16
        .varset_1_o_reg39 (),   //         .o_reg17
        .varset_1_o_reg40 (),   //         .o_reg18
        .varset_1_o_reg41 (),     //         .o_reg19
        .varset_1_o_reg42 (),       //         .o_reg20
        .varset_1_o_reg43 (),      //         .o_reg21
        .varset_1_o_reg44 (),      //         .o_reg22
        .varset_1_o_reg45 (),        //         .o_reg23
        .varset_1_o_reg46 (),          //         .o_reg24
        .varset_1_o_reg47 (),                          //         .o_reg47
        .varset_1_o_reg48 (),                          //         .o_reg48
        .varset_1_o_reg49 (),                          //         .o_reg49
        .varset_1_o_reg50 (),                          //         .o_reg50
        .varset_1_o_reg51 (),                          //         .o_reg51
        .varset_1_o_reg52 (),                          //         .o_reg52
        .varset_1_o_reg53 (),                          //         .o_reg53
        .varset_1_o_reg54 (),                          //         .o_reg54
        .varset_1_o_reg55 (),                          //         .o_reg55
        .varset_1_o_reg56 (),                          //         .o_reg56
        .varset_1_o_reg57 (),                          //         .o_reg57
        .varset_1_o_reg58 (),                          //         .o_reg58
        .varset_1_o_reg59 (),                          //         .o_reg59

        .varset_1_i_var0  (),//         .i_var0
        .varset_1_i_var1  (),//         .i_var1
        .varset_1_i_var2  (),//         .i_var2
        .varset_1_i_var3  (),//         .i_var3
        .varset_1_i_var4  (),//         .i_var4
        .varset_1_i_var5  (),   //         .i_var5
        .varset_1_i_var6  (),  //         .i_var6
        .varset_1_i_var7  (),  //         .i_var7
        .varset_1_i_var8  (),  //         .i_var8 
        .varset_1_i_var9  (),      //         .i_var9
        .varset_1_i_var10 (),     //         .i_var10
        .varset_1_i_var11 (),     //         .i_var11
        .varset_1_i_var12 (),     //         .i_var12
        .varset_1_i_var13 (),     //         .i_var13
        .varset_1_i_var14 (),     //         .i_var14
        .varset_1_i_var15 (),     //         .i_var15
        .varset_1_i_var16 (),     //         .i_var16
        .varset_1_i_var17 (),     //         .i_var17
        .varset_1_i_var18 (i_var_err),                 //         .i_var18
        .varset_1_i_var19 (i_var_step),                //         .i_var19
        .varset_1_i_var20 (i_var_timer),               //         .i_var20
        .varset_1_i_var21 (i_var_accu_step_L),                          //         .i_var21
        .varset_1_i_var22 (i_var_accu_step_H),                          //         .i_var22
        .varset_1_i_var23 (i_var_accu_step_cnt),                          //         .i_var23
        .varset_1_i_var24 (),                          //         .i_var24
        .varset_1_i_var25 (),                          //         .i_var25
        .varset_1_i_var26 (),                          //         .i_var26
        .varset_1_i_var27 (),                          //         .i_var27
        .varset_1_i_var28 (),                          //         .i_var28
        .varset_1_i_var29 (),                          //         .i_var29
        .varset_1_i_var30 (),                          //         .i_var30
        .varset_1_i_var31 (),                          //         .i_var31
        .varset_1_i_var32 (),                          //         .i_var32
        .varset_1_i_var33 (),                          //         .i_var33
        .varset_1_i_var34 (),                          //         .i_var34
        .varset_1_i_var35 (),                          //         .i_var35
        .varset_1_i_var36 (),                          //         .i_var36
        .varset_1_i_var37 (),                          //         .i_var37
        .varset_1_i_var38 (),                          //         .i_var38
        .varset_1_i_var39 (),                          //         .i_var39
        .varset_1_i_var40 (),                          //         .i_var40
        .varset_1_i_var41 (),                          //         .i_var41
        .varset_1_i_var42 (),                          //         .i_var42
        .varset_1_i_var43 (),                          //         .i_var43
        .varset_1_i_var44 (),                          //         .i_var44
        .varset_1_i_var45 (),                          //         .i_var45
        .varset_1_i_var46 (),                          //         .i_var46
        .varset_1_i_var47 (),                          //         .i_var47
        .varset_1_i_var48 (),                          //         .i_var48
        .varset_1_i_var49 (),                          //         .i_var49
        .varset_1_i_var50 (),                          //         .i_var50
        .varset_1_i_var51 (),                          //         .i_var51
        .varset_1_i_var52 (),                          //         .i_var52
        .varset_1_i_var53 (),                          //         .i_var53
        .varset_1_i_var54 (),                          //         .i_var54
        .varset_1_i_var55 (),                          //         .i_var55
        .varset_1_i_var56 (),                          //         .i_var56
        .varset_1_i_var57 (),                          //         .i_var57
        .varset_1_i_var58 (),                          //         .i_var58
        .varset_1_i_var59 ()                           //         .i_var59
    );
 
endmodule
