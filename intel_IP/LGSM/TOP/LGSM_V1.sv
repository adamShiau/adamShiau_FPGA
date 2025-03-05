module LGSM_V1(

	//////////// CLOCK //////////
	CLOCK_50,

	//////////// LED //////////
	LED1,
	LED2,
	//////////// PROBE //////////
	P_K5, 
	//////////// DAC //////////
	DAC1,
	DAC2,
	DAC_CLK,
	DAC_RST,
	//////////// ADC //////////
	ADC_D1,
	ADC_CLK,
	ADC_OF1,
	//////////// SPI-ADDA //////////
	MISO,
	MOSI,
	SCLK,
	CS_DAC,
	CS_ADC,
	//////////// TRIGGER //////////
	TRIG_IN,
	//////////// I2C //////////
	SCL,
	SDA,
	//////////// SDRAM //////////
	SDRAM_ADDR,
	SDRAM_BA,
	SDRAM_CAS_N,
	SDRAM_CKE,
	SDRAM_CLK,
	SDRAM_CS_N,
	SDRAM_DQ,
	SDRAM_DQM,
	SDRAM_RAS_N,
	SDRAM_WE_N,

	//////////// EPCS //////////
	EPCS_ASDO,
	EPCS_DATA0,
	EPCS_DCLK,
	EPCS_NCSO,
	//////////// UART //////////
	UART_RX,
	UART_TX
	
);

//=======================================================
//  PARAMETER declarations
//=======================================================
// `define cnt_us 100
// `define cnt_10us 1250
// `define cnt_ms 125000
// `define cnt_10ms 1250000
// `define cnt_1000ms 125000000

//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK //////////
input 		          		CLOCK_50;

//////////// LED //////////
output		     		LED1;
output		     		LED2;
//////////// PROBE //////////
output							P_K5;
//////////// DAC //////////
output		    [16-1:0]	DAC1;
output		    [16-1:0]	DAC2;
output 						DAC_CLK;
output						DAC_RST;
//////////// ADC //////////
input				 [14-1:0]	ADC_D1;
input								ADC_OF1;
output							ADC_CLK;
//////////// SPI ADDA //////////
input							MISO;
output						MOSI;
output						SCLK;					
output						CS_ADC;
output						CS_DAC;
//////////// TRIGGER //////////
input							TRIG_IN;
//////////// I2C //////////
output 						SCL;
inout 						SDA;
//////////// SDRAM //////////
output		    [12:0]		SDRAM_ADDR;
output		     [1:0]		SDRAM_BA;
output		          		SDRAM_CAS_N;
output		          		SDRAM_CKE;
output		          		SDRAM_CLK;
output		          		SDRAM_CS_N;
inout 		    [15:0]		SDRAM_DQ;
output		     [1:0]		SDRAM_DQM;
output		          		SDRAM_RAS_N;
output		          		SDRAM_WE_N;

//////////// EPCS //////////
output		          		EPCS_ASDO;
input 		          		EPCS_DATA0;
output		          		EPCS_DCLK;
output		          		EPCS_NCSO;
//////////// UART //////////
input								UART_RX;
output							UART_TX;

//=======================================================
//  REG/WIRE declarations
//=======================================================

// reg [31:0] cnt = `cnt_1000ms, cnt_dac = `cnt_us ;
reg [1:0] r_led = {1'b1, 1'b0};
reg [15:0] r_dac_cnt = 16'd0;
wire locked;
wire [1:0] SS;
wire CPU_CLK;

wire [31:0] o_var_timer_rst, o_var_freq, o_var_amp_H, o_var_amp_L, o_var_fb_ON;
wire [31:0] o_var_polarity, o_var_waitCnt, o_var_offset, o_var_errAvg, o_var_errTh;
wire [31:0] o_var_gainSel_step, o_var_gainSel_ramp, o_var_const_step, o_var_kal_Q, o_var_kal_R;
wire [31:0] o_var_Vp, o_var_Vn, o_var_LED1;
wire [15:0] ladder_wave, phase_ramp;
wire [31:0] i_var_timer, i_var_step, i_var_err, i_var_fb_on;
wire signed [31:0] adc_kal;
//--- rstn gen---//
wire ext_rst_n;
//--- mod gen---//
wire [31:0] o_mod_out;
wire o_status, o_stepTrig;
//--- err sig gen---//
logic signed [31:0] o_err, o_err_FIR;
wire [3:0] o_cstate, o_nstate;
wire o_step_sync, o_step_sync_dly, o_rate_sync, o_ramp_sync;
//--- fb step gen---//
logic signed [31:0] o_step, o_step_MV;
//--- phase ramp gen---//
wire [31:0] o_phaseRamp;
reg [31:0] r_phaseRamp;

wire[15:0] chat_gpt_clk;

reg signed [31:0] r_ramp;

reg signed [31:0] r_mod;


assign DAC1 =  o_phaseRamp[15:0];



assign DAC_RST = 1'b0;

assign i_var_err = o_err;
assign i_var_step = o_step_MV;
// assign i_var_step = o_step;

assign CS_DAC = SS[0];
assign CS_ADC = SS[1];

assign LED1 = 1'b1;

typedef logic signed [15:0] coeff_array_t [0:31]; 

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

pll	pll_inst (
	.inclk0 ( CLOCK_50 ),
	.c0 ( DAC_CLK ),
	.c1 ( SDRAM_CLK ),
	.c2 ( CPU_CLK ),
	.c3 ( ADC_CLK ),
	.locked ( locked )
	);


my_timer
#(.COUNTER_NUM(10000))
timer_inst
(
    .i_clk(DAC_CLK),
    .i_rst_n(locked),
    .i_timer_rst(o_var_timer_rst),
    .o_timer(i_var_timer)
);

 my_modulation_gen_v1 inst_my_modulation_gen_ch3 (
	.i_clk(DAC_CLK),                // System clock 
	.i_rst_n(locked),            // Active-low reset 
	.i_freq_cnt(o_var_freq),      // Frequency control input (32-bit unsigned)
	.i_amp_H(o_var_amp_H),            // Positive amplitude input (32-bit signed)
	.i_amp_L(o_var_amp_L),            // Negative amplitude input (32-bit signed)
	.o_mod_out(o_mod_out),        // Modulated output signal (32-bit signed)
	.o_status(o_status),          // Cycle status output (1-bit)
	.o_stepTrig(o_stepTrig)       // Switching trigger output (1-bit)
);

reg signed [13:0] reg_adc, reg_adc_sync;
wire signed [29:0] adc_fir;

myfir_filter #(
	.N(32), 
	.WIDTH(14),
	.COEFF_SET(N32FC2)
) ADC3_fir_inst 
(
	.clk(ADC_CLK),
	.n_rst(locked),
	.din(ADC_D1),  // 輸入數據, [WIDTH-1:0]
	.dout(adc_fir) // 濾波後數據, [WIDTH+15:0]
);

// double register adc signal from CLOCK_ADC to CLOCK_DAC
always @(posedge DAC_CLK) begin
	reg_adc <= (adc_fir >>> 16);
	reg_adc_sync <= reg_adc;
end

my_err_signal_gen_v2 #(
	.ADC_BIT(14)  // ADC_BIT specifies the width of the ADC input data, typically 14 bits.
) u_my_err_signal_gen_ch3
	(
	.i_clk(DAC_CLK),               // Clock signal (1 bit)
	.i_rst_n(locked),           // Active low reset signal (1 bit)
	.i_status(o_status),         // Status signal (1 bit) indicating the current status
	.i_polarity(o_var_polarity),     // Polarity signal (1 bit) used to adjust signal polarity
	.i_trig(o_stepTrig),             // Trigger signal (1 bit) used to initiate error generation
	.i_wait_cnt(o_var_waitCnt),     // Wait counter (32 bits) for delay purposes unti signal stable 
	.i_err_offset(o_var_offset), // Error offset (32 bits) used to introduce error adjustments
	.i_adc_data(reg_adc_sync),     // ADC data input (ADC_BIT bits, typically 14 bits)
	// .i_adc_data(ADC_D1),
	.i_avg_sel(o_var_errAvg),       // Average selection signal (32 bits) to select averaging mode
	.o_step_sync(o_step_sync),          // Output one clock trigger to feedback step gen.i_trig 
	.o_step_sync_dly(o_step_sync_dly),  // Output one clock trigger to feedback step gen.i_trig_dly 
	.o_rate_sync(o_rate_sync),          // Output one clock trigger to phase ramp gen.i_rate_trig 
	.o_ramp_sync(o_ramp_sync),          // Output one clock trigger to phase ramp gen.i_ramp_trig 
	.o_err(o_err)                // Output error signal (32 bits) representing the computed error
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
	.clk(DAC_CLK),
	.n_rst(locked),
	.i_trig(o_step_sync),
	.din(o_err[13:0]),  // 14 bit
	.dout(o_err_FIR) // 32 bit
);


feedback_step_gen_v4 fb_step_gen_inst(
	.i_clk(DAC_CLK),
	.i_const_step(o_var_const_step),
	// .i_err(o_err),
	.i_err(o_err_FIR),
	.i_fb_ON(o_var_fb_ON),
	.i_gain_sel(o_var_gainSel_step),
	.i_rst_n(locked),
	.i_trig(o_step_sync),
	.i_trig_dly(o_step_sync_dly),
	.o_fb_ON(i_var_fb_on),
	.o_gain_sel(),
	.o_gain_sel2(),
	.o_step(o_step),
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
	.clk(DAC_CLK), 
    .n_rst(locked),
	.trig(o_step_sync),
    .din(o_step),
    .dout(o_step_MV)
);

phase_ramp_gen phase_ramp_gen_inst(
	.i_clk(DAC_CLK),
	.i_fb_ON(o_var_fb_ON),
	.i_gain_sel(o_var_gainSel_ramp),
	.i_mod(o_mod_out),
	.i_rst_n(locked),
	.i_step(o_step),
	.i_rate_trig(o_rate_sync),
	.i_ramp_trig(o_ramp_sync),
	.i_mod_trig(o_stepTrig),
	.o_change(),
	.o_gain_sel(),
	.o_gain_sel2(),
	.o_phaseRamp_pre(),
	.o_phaseRamp(o_phaseRamp),
	.o_ramp_init()
);


 CPU u0 (
	.clk_clk       (CPU_CLK),       //      clk.clk
	.reset_reset_n (locked), //    reset.reset_n
	.spi_adda_MISO (MISO), // spi_adda.MISO
	.spi_adda_MOSI (MOSI), //         .MOSI
	.spi_adda_SCLK (SCLK), //         .SCLK
	.spi_adda_SS_n (SS),  //         .SS_n
	.sdram_addr    (SDRAM_ADDR),    //    sdram.addr
	.sdram_ba      (SDRAM_BA),      //         .ba
	.sdram_cas_n   (SDRAM_CAS_N),   //         .cas_n
	.sdram_cke     (SDRAM_CKE),     //         .cke
	.sdram_cs_n    (SDRAM_CS_N),    //         .cs_n
	.sdram_dq      (SDRAM_DQ),      //         .dq
	.sdram_dqm     (SDRAM_DQM),     //         .dqm
	.sdram_ras_n   (SDRAM_RAS_N),   //         .ras_n
	.sdram_we_n    (SDRAM_WE_N),     //         .we_n
	.epcs_dclk     (EPCS_DCLK),     //     epcs.dclk
	.epcs_sce      (EPCS_NCSO),      //         .sce
	.epcs_sdo      (EPCS_ASDO),      //         .sdo
	.epcs_data0    (EPCS_DATA0),     //         .data0
	.varset_o_reg0  (o_var_freq),  //   varset.o_reg1
	.varset_o_reg1  (o_var_amp_H),  //         .o_reg2
	.varset_o_reg2  (o_var_amp_L),  //         .o_reg3
	.varset_o_reg3  (o_var_offset),  //         .o_reg6
	.varset_o_reg4  (o_var_polarity),  //         .o_reg4
	.varset_o_reg5  (o_var_waitCnt),  //         .o_reg5
	.varset_o_reg6  (o_var_errTh),  //         .o_reg8
	.varset_o_reg7  (o_var_errAvg),  //         .o_reg7
	.varset_o_reg8  (o_var_timer_rst),  //         .o_reg0
	.varset_o_reg9  (o_var_gainSel_step),  //         .o_reg9
	.varset_o_reg10 (o_var_gainSel_ramp), //         .o_reg10
	.varset_o_reg11 (o_var_fb_ON), //         .o_reg11
	.varset_o_reg12 (o_var_const_step), //         .o_reg12
	.varset_o_reg13 (o_var_kal_Q), //         .o_reg13
	.varset_o_reg14 (o_var_kal_R), //         .o_reg14
	.varset_o_reg15 (o_var_LED1), //         .o_reg15
	.varset_o_reg16 (), //         .o_reg16
	.varset_o_reg17 (), //         .o_reg17
	.varset_o_reg18 (), //         .o_reg18
	.varset_o_reg19 (), //         .o_reg19
	.varset_o_reg20 (), //         .o_reg20
	.varset_o_reg21 (), //         .o_reg21
	.varset_o_reg22 (), //         .o_reg22
	.varset_o_reg23 (), //         .o_reg23
	.varset_o_reg24 (), //         .o_reg24
	.varset_i_var0  (i_var_timer),  //         .i_var0
	.varset_i_var1  (i_var_step),  //         .i_var1
	.varset_i_var2  (o_var_amp_H),  //         .i_var2
	.varset_i_var3  (o_var_amp_L),  //         .i_var3
	.varset_i_var4  (i_var_err),  //         .i_var4
	.varset_i_var5  (o_var_offset),  //         .i_var5
	.varset_i_var6  (),  //         .i_var6
	.varset_i_var7  (i_var_fb_on),  //         .i_var7
	.varset_i_var8  (o_nstate),  //         .i_var8
	.varset_i_var9  (o_cstate),  //         .i_var9
	.varset_i_var10 (), //         .i_var10
	.varset_i_var11 (), //         .i_var11
	.varset_i_var12 (), //         .i_var12
	.varset_i_var13 (), //         .i_var13
	.varset_i_var14 (), //         .i_var14
	.varset_i_var15 (), //         .i_var15
	.varset_i_var16 (), //         .i_var16
	.varset_i_var17 (), //         .i_var17
	.varset_i_var18 (), //         .i_var18
	.varset_i_var19 (), //         .i_var19
	.varset_i_var20 (), //         .i_var20
	.varset_i_var21 (), //         .i_var21
	.varset_i_var22 (), //         .i_var22
	.varset_i_var23 (), //         .i_var23
	.varset_i_var24 (),  //        .i_var24
	.uart_rxd(UART_RX),       //     uart.rxd
	.uart_txd(UART_TX),        //        .txd
	.i2c_scl_export (SCL), //  i2c_scl.export
	.i2c_sda_export (SDA),  //  i2c_sda.export
	.trigger_in_export (TRIG_IN) 
 );
 
 
endmodule
