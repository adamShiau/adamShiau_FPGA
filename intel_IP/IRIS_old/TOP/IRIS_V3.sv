module IRIS_V3(

	//////////// CLOCK INPUT //////////
	CLOCK_50M, 
	CLOCK_ADC_1, //CLOCK_ADC_1ch
	CLOCK_ADC_2, //CLOCK_ADC_2ch
	//////////// PLL CLOCK //////////
	CLOCK_DAC_1,
	CLOCK_DAC_2,
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

	/////////// UART ////////// 
	SER_TX_WRONG,
	SER_TX,
	SER_RX,
	
	//////////// DAC //////////
	DAC_1,
	DAC_2,
	DAC_3,
	DAC_RST,
	//////////// ADC //////////
	ADC_1, //2CH_AIN1, J8
	ADC_2, //2CH_AIN2, J9
	ADC_3, //1CH_AIN1
	//////////// ADDA SPI CFG //////////
	MISO_CFG,
	MOSI_CFG,
	SCLK_CFG,
	CS_ADC_1, //2CH_ADC
	CS_ADC_2, //1CH_ADC
	CS_DAC_1, //2CH_DAC
	CS_DAC_2, //1CH_DAC

	//////////// EPCS //////////
	EPCS_ASDO,
	EPCS_DATA0,
	EPCS_DCLK,
	EPCS_NCSO,
	
	//////////// LED //////////
	LED_FPGA,
	
	//////////// SYNC //////////
	EXT_SYNC_IN,
	EXT_SYNC2,
//	PIO_C21,
	
	//////////// ADXL357 I2C //////////
	SDA_357,
	SCL_357,
	DRDY_357,

	/////////// EEPROM I2C //////////
	SDA_EEPROM,
	SCL_EEPROM,

	/////////// 24-bit Serial ADC I2C //////////
	SDA_ADC_TEMP, 
	SCL_ADC_TEMP,
	DRDY_ADC_TEMP,
	SDA_ADC_PD, 
	SCL_ADC_PD,
	DRDY_ADC_PD

);
//////////// CLOCK //////////
input					CLOCK_50M;
input 				CLOCK_ADC_1;
input 				CLOCK_ADC_2;

//////////// PLL CLOCK //////////
output 				CLOCK_DAC_1;
output 				CLOCK_DAC_2;
output 				CLOCK_SDRAM;

//////////// SPI-CFG //////////
input 				MISO_CFG;
output				MOSI_CFG;
output				SCLK_CFG;


//////////// SDRAM //////////
output	[13-1:0]	SDRAM_ADDR;
output	[ 2-1:0]	SDRAM_BA;
output				SDRAM_CAS_N;
output				SDRAM_CKE;
output				SDRAM_CS_N;
inout		[16-1:0]	SDRAM_DQ;
output	[ 2-1:0]	SDRAM_DQM;
output				SDRAM_RAS_N;
output				SDRAM_WE_N;

/////////// UART //////////
input				SER_TX_WRONG;
output				SER_TX;
input				SER_RX;

//////////// DAC //////////
output	[15:0] DAC_1;
output	[15:0] DAC_2;
output	[15:0] DAC_3;
output 			 CS_DAC_1;
output 			 CS_DAC_2;
output 			 DAC_RST;

//////////// ADC //////////
input	[13:0] 		 ADC_1;
input	[13:0] 		 ADC_2;
input signed	[13:0]		 ADC_3;
output 				 CS_ADC_1;
output 				 CS_ADC_2;

//////////// EPCS //////////
output				EPCS_ASDO;
input 				EPCS_DATA0;
output				EPCS_DCLK;
output				EPCS_NCSO;

//////////// LED //////////
output 				LED_FPGA;

//////////// SYNC //////////
input				EXT_SYNC_IN;
output				EXT_SYNC2;
//output 				PIO_C21;

//////////// ADXL357 //////////
inout				SDA_357;
inout				SCL_357;
input				DRDY_357;

/////////// EEPROM I2C //////////
inout				SDA_EEPROM;
inout				SCL_EEPROM;

	/////////// 24-bit Serial ADC I2C //////////
inout				SDA_ADC_TEMP;
inout				SCL_ADC_TEMP;
input				DRDY_ADC_TEMP;

inout				SDA_ADC_PD;
inout				SCL_ADC_PD;
input   			DRDY_ADC_PD;


/*** ADC loop back test ***/
// reg signed [13:0] reg_adc3;
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

assign EXT_SYNC2 = sync_out;
//assign PIO_C21 = sync_out;

	

`define cnt_us 100
`define cnt_10us 1250
`define cnt_ms 125000
`define cnt_10ms 1250000
`define cnt_1000ms 125000000




wire CPU_CLK;
wire locked_0,locked_1, locked_2;
wire [3:0] ADDA_SS; 

assign CS_DAC_1 = ADDA_SS[0]; //DAC_2CH
assign CS_DAC_2 = ADDA_SS[1]; //DAC_1CH
assign CS_ADC_1 = ADDA_SS[2];	//ADC_2CH
assign CS_ADC_2 = ADDA_SS[3]; //ADC_1CH


/**********MOD gen*********/
// NUM1
wire [31:0] o_var_freq_1, o_var_amp_H_1, o_var_amp_L_1, o_mod_out_1;
wire o_status_1, o_stepTrig_1;
// NUM2
wire [31:0] o_var_freq_2, o_var_amp_H_2, o_var_amp_L_2, o_mod_out_2;
wire o_status_2, o_stepTrig_2;
// NUM3
wire [31:0] o_var_freq_3, o_var_amp_H_3, o_var_amp_L_3, o_mod_out_3;
wire o_status_3, o_stepTrig_3;

reg	[31:0] CLK_COUNT = 0; 	//clock

reg[15:0] reg_dac1_sync, reg_dac2_sync, reg_dac3_sync;
reg[15:0] reg_dac1, reg_dac2, reg_dac3;
reg reg_dacrst;

reg[13:0] reg_adc1, reg_adc1_sync;
reg[13:0] reg_adc2, reg_adc2_sync;
reg signed [13:0] reg_adc3, reg_adc3_sync, reg_adc3_mon;

/////////// MIOC Modulation parameter //////////
wire [31:0] var_freq_cnt_3, var_amp_H_3, var_amp_L_3;
wire [31:0] mod_out_DAC3;
wire status_DAC3, stepTrig_DAC3;

/////////// MIOC Err Gen parameter //////////
wire [31:0] var_polarity_3, var_wait_cnt_3, var_avg_sel_3, var_err_offset_3;
logic signed [31:0] o_err_DAC3, o_err_DAC3_FIR, o_err_DAC3_MV;
wire o_step_sync_3, o_step_sync_dly_3, o_rate_sync_3, o_ramp_sync_3;

/////////// FB Step Gen parameter //////////
logic signed [31:0] o_step_3, o_step_3_MV, i_var_step_3, i_var_err_3;
wire [31:0] var_gainSel_step_3, var_const_step_3, var_fb_ON_3;

/////////// Phase Ramp Gen parameter //////////
wire [31:0] var_gainSel_ramp_3, o_phaseRamp_3;

/////////// Timer Gen parameter //////////
wire [31:0] i_var_timer, var_timer_rst;

// assign DAC_1 =  o_phaseRamp_1[15:0];
// assign DAC_2 =  o_phaseRamp_2[15:0];
assign DAC_3 =  o_phaseRamp_3[15:0];

assign DAC_1 =  0;
assign DAC_2 =  0;

// assign i_var_step_3 = o_step_3;
assign i_var_step_3 = o_step_3_MV;
// assign i_var_err_3 = o_err_DAC3;
assign i_var_err_3 = o_err_DAC3_FIR;


assign DAC_RST = reg_dacrst;



PLL0	PLL0_inst (
	.inclk0 ( CLOCK_50M ),
	.c0 ( CLOCK_SDRAM ),
	.c1 ( CPU_CLK ),
	.locked ( locked_0 )
	);

PLL1	PLL1_inst (
	.inclk0 ( CLOCK_ADC_1 ),
	.c0 ( CLOCK_DAC_1 ),
	.locked ( locked_1 )
	);
	
PLL2	PLL2_inst (
	.inclk0 ( CLOCK_ADC_2 ),
	.c0 ( CLOCK_DAC_2 ),
	.locked ( locked_2 )
	);
	

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

wire sync_out;
wire [31:0] var_sync_count;
my_sync_gen sync_gen_inst
(
    .i_clk(CPU_CLK),
    .i_rst_n(locked_0),
   .i_sync_count(var_sync_count),
    .o_sync_out(sync_out)
);

my_timer
#(.COUNTER_NUM(10000))
timer_inst
(
    .i_clk(CPU_CLK),
    .i_rst_n(locked_0),
    .i_timer_rst(var_timer_rst),
    .o_timer(i_var_timer)
);

myfir_filter #(
	.N(32), 
	.WIDTH(14),
	.COEFF_SET(N32FC2)
) ADC3_fir_inst 
(
	.clk(CLOCK_ADC_1),
	.n_rst(locked_1),
	.din(ADC_3),  // ADC input, [WIDTH-1:0] 
	.dout(adc3_fir) // filtered ADC data [WIDTH+15:0]
);

myfir_filter #(
	.N(32), 
	.WIDTH(14),
	.COEFF_SET(N32FC2)
) ADC1_fir_inst 
(
	.clk(CLOCK_ADC_2),
	.n_rst(locked_2),
	.din(ADC_1),
	.dout(adc1_fir)
);

myfir_filter #(
	.N(32), 
	.WIDTH(14),
	.COEFF_SET(N32FC2)
) ADC2_fir_inst 
(
	.clk(CLOCK_ADC_2),
	.n_rst(locked_2),
	.din(ADC_2),
	.dout(adc2_fir)
);

// double register adc signal from CLOCK_ADC_1 to CLOCK_DAC_1
always @(posedge CLOCK_DAC_1) begin
	reg_adc3 <= (adc3_fir >>> 16);
	reg_adc3_sync <= reg_adc3;
end

// double register adc signal from CLOCK_ADC_2 to CLOCK_DAC_2
always @(posedge CLOCK_DAC_2) begin
	reg_adc1 <= (adc1_fir >>> 16);
	reg_adc1_sync <= reg_adc1;

	reg_adc2 <= (adc2_fir >>> 16);
	reg_adc2_sync <= reg_adc2;
end

 my_modulation_gen_v1 inst_my_modulation_gen_ch3 (
	.i_clk(CLOCK_DAC_1),                // System clock 
	.i_rst_n(locked_1),            // Active-low reset 
	.i_freq_cnt(var_freq_cnt_3),      // Frequency control input (32-bit unsigned)
	.i_amp_H(var_amp_H_3),            // Positive amplitude input (32-bit signed)
	.i_amp_L(var_amp_L_3),            // Negative amplitude input (32-bit signed)
	.o_mod_out(mod_out_DAC3),        // Modulated output signal (32-bit signed)
	.o_status(status_DAC3),          // Cycle status output (1-bit)
	.o_stepTrig(stepTrig_DAC3)       // Switching trigger output (1-bit)
);

 my_err_signal_gen_v2 #(
        .ADC_BIT(14)  // ADC_BIT specifies the width of the ADC input data, typically 14 bits.
    ) u_my_err_signal_gen_ch3
     (
        .i_clk(CLOCK_DAC_1),               // Clock signal (1 bit)
        .i_rst_n(locked_1),           // Active low reset signal (1 bit)
        .i_status(status_DAC3),         // Status signal (1 bit) indicating the current status
        .i_polarity(var_polarity_3),     // Polarity signal (1 bit) used to adjust signal polarity
        .i_trig(stepTrig_DAC3),             // Trigger signal (1 bit) used to initiate error generation
        .i_wait_cnt(var_wait_cnt_3),     // Wait counter (32 bits) for delay purposes unti signal stable 
        .i_err_offset(var_err_offset_3), // Error offset (32 bits) used to introduce error adjustments
        .i_adc_data(reg_adc3_sync),     // ADC data input (ADC_BIT bits, typically 14 bits)
		// .i_adc_data(ADC_3),
        .i_avg_sel(var_avg_sel_3),       // Average selection signal (32 bits) to select averaging mode
		.o_step_sync(o_step_sync_3),          // Output one clock trigger to feedback step gen.i_trig 
        .o_step_sync_dly(o_step_sync_dly_3),  // Output one clock trigger to feedback step gen.i_trig_dly 
        .o_rate_sync(o_rate_sync_3),          // Output one clock trigger to phase ramp gen.i_rate_trig 
        .o_ramp_sync(o_ramp_sync_3),          // Output one clock trigger to phase ramp gen.i_ramp_trig 
        .o_err(o_err_DAC3)                // Output error signal (32 bits) representing the computed error
		,.o_low_avg()
    	,.o_high_avg()
    );

//filter err signal before step gen
// fc ~ freq. of i_trig * 0.05 = 300KHz * 0.05 = 15KHz
myfir_filter_gate #(
	.N(32), 
	.WIDTH(14),
	.COEFF_SET(N32FC2)
) fir_gate_ch3_inst 
(
	.clk(CLOCK_DAC_1),
	.n_rst(locked_1),
	.i_trig(o_step_sync_3),
	.din(o_err_DAC3[13:0]),  // 14 bit
	.dout(o_err_DAC3_FIR) // 32 bit
);

feedback_step_gen_v4 fb_step_gen_ch3(
	.i_clk(CLOCK_DAC_1),
	.i_rst_n(locked_1),
	.i_const_step(var_const_step_3),
	// .i_err(o_err_DAC3),
	.i_err(o_err_DAC3_FIR),
	.i_fb_ON(var_fb_ON_3),
	.i_gain_sel(var_gainSel_step_3),
	.i_trig(o_step_sync_3),
	.i_trig_dly(o_step_sync_dly_3),
	.o_fb_ON(),
	.o_gain_sel(),
	.o_gain_sel2(),
	.o_step(o_step_3),
	.o_step_pre(),
	.o_status(),
	.o_change(),
	.o_step_init() 
);

//filter step output signal before send to CPU
// fs = frequency of trig/DIV_FACTOR
// fc ~ 0.5* fs / N  = 0.5 * (300/6) / 512 KHz = 48.8 Hz  
myMV_filter_gate_v1 #(
	.WINDOW(512),
	.DIV_FACTOR(6) // trigger devider
)
 u_myMV_filter_ch3
(
	.clk(CLOCK_DAC_1), 
    .n_rst(locked_1),
	.trig(o_step_sync_3),
    .din(o_step_3),
    .dout(o_step_3_MV)
);

phase_ramp_gen phase_ramp_gen_ch3(
	.i_clk(CLOCK_DAC_1),
	.i_rst_n(locked_1),
	.i_fb_ON(var_fb_ON_3),
	.i_gain_sel(var_gainSel_ramp_3),
	.i_mod(mod_out_DAC3),

	.i_step(o_step_3),
	.i_rate_trig(o_rate_sync_3),
	.i_ramp_trig(o_ramp_sync_3),

	.i_mod_trig(stepTrig_DAC3),
	.o_change(),
	.o_gain_sel(),
	.o_gain_sel2(),
	.o_phaseRamp_pre(),
	.o_phaseRamp(o_phaseRamp_3),
	.o_ramp_init()
);

i2c_controller_pullup_ADS122C04_SE
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
	.o_w_enable()
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


//--- err sig gen---//
// NUM1
wire [31:0] o_err_1;
wire o_step_sync_1, o_step_sync_dly_1, o_rate_sync_1, o_ramp_sync_1;
wire [31:0] o_var_polarity_1, o_var_waitCnt_1, o_var_offset_1, o_var_errAvg_1;
// NUM2
wire [31:0] o_err_2;
wire o_step_sync_2, o_step_sync_dly_2, o_rate_sync_2, o_ramp_sync_2;
wire [31:0] o_var_polarity_2, o_var_waitCnt_2, o_var_offset_2, o_var_errAvg_2;



//--- feedback step gen---//
// NUM1
wire [31:0] o_var_gainSel_step_1, o_var_const_step_1, o_var_fb_ON_1, o_step_1;
// NUM2
wire [31:0] o_var_gainSel_step_2, o_var_const_step_2, o_var_fb_ON_2, o_step_2;


//--- phase ramp gen---//
// NUM1
wire [31:0] o_var_gainSel_ramp_1, o_phaseRamp_1;
// NUM2
wire [31:0] o_var_gainSel_ramp_2, o_phaseRamp_2;


CPU u0 (
	.clk_clk        (CPU_CLK),        //      clk.clk
	.reset_reset_n  (locked_0),  //    reset.reset_n
	
	.spi_adda_MISO  (MISO_CFG),  // spi_adda.MISO
	.spi_adda_MOSI  (MOSI_CFG),  //         .MOSI
	.spi_adda_SCLK  (SCLK_CFG),  //         .SCLK
	.spi_adda_SS_n  (ADDA_SS),  //         .SS_n
	
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
	
	.uart_rxd          (SER_RX),          //       uart.rxd
	.uart_txd          (SER_TX),          //           .txd

	.varset_1_o_reg0     (var_i2c_357_dev_addr),     //           .o_reg0
	.varset_1_o_reg1     (var_i2c_357_w_data),     //     varset_1.o_reg1
	.varset_1_o_reg2     (var_i2c_357_ctrl),     //           .o_reg2
	.varset_1_o_reg3     (),     //           .o_reg3
	.varset_1_o_reg4     (var_i2c_357_reg_addr),     //           .o_reg4
	.varset_1_o_reg5     (var_i2c_EEPROM_dev_addr),     //           .o_reg5
	.varset_1_o_reg6     (var_i2c_EEPROM_w_data),     //           .o_reg6
	.varset_1_o_reg7     (var_i2c_EEPROM_ctrl),     //           .o_reg7
	.varset_1_o_reg8     (var_i2c_EEPROM_reg_addr),     //           .o_reg8
	.varset_1_o_reg9     (var_freq_cnt_3),     //           .o_reg9
	.varset_1_o_reg10    (var_amp_H_3),    //           .o_reg10
	.varset_1_o_reg11    (var_amp_L_3),    //           .o_reg11
	.varset_1_o_reg12    (var_polarity_3),    //           .o_reg12
	.varset_1_o_reg13    (var_wait_cnt_3),    //           .o_reg13
	.varset_1_o_reg14    (var_avg_sel_3),    //           .o_reg14
	.varset_1_o_reg15  	 (var_gainSel_step_3),  //           .o_reg15
	.varset_1_o_reg16  	 (var_const_step_3),  //           .o_reg16
	.varset_1_o_reg17  	 (var_fb_ON_3),  //           .o_reg17
	.varset_1_o_reg18  	 (var_gainSel_ramp_3),  //           .o_reg18
	.varset_1_o_reg19  	 (var_err_offset_3),  //           .o_reg19
	.varset_1_o_reg20  	 (),  //           .o_reg20
	.varset_1_o_reg21  (),  //           .o_reg21
	.varset_1_o_reg22  (),  //           .o_reg22
	.varset_1_o_reg23  (),  //           .o_reg23
	.varset_1_o_reg24  (),  //           .o_reg24
	.varset_1_o_reg25  (),  
	.varset_1_o_reg26  (),  
	.varset_1_o_reg27  (),  
	.varset_1_o_reg28  (),  
	.varset_1_o_reg29  (),  
	.varset_1_o_reg30  (),  
	.varset_1_o_reg31  (),  
	.varset_1_o_reg32  (),  
	.varset_1_o_reg33  (),  
	.varset_1_o_reg34  (),  
	.varset_1_o_reg35  (),  
	.varset_1_o_reg36  (),  
	.varset_1_o_reg37  (),  
	.varset_1_o_reg38  (),  
	.varset_1_o_reg39  (),  
	.varset_1_o_reg40  (),  
	.varset_1_o_reg41  (),  
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
	.varset_1_i_var30  (i_var_step_3),  
	.varset_1_i_var31  (i_var_err_3),  
	.varset_1_i_var32  (i_var_timer),  
	.varset_1_i_var33  (),  
	.varset_1_i_var34  (),  
	.varset_1_i_var35  (),  
	.varset_1_i_var36  (),  
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
