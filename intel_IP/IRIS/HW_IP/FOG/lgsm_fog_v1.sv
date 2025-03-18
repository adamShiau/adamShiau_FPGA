
module lgsm_fog_v1 (
    // ============================ Common Signals ============================
    input logic CLOCK_ADC,    // ADC clock signal
    input logic CLOCK_DAC,    // DAC clock signal
    input logic locked,       // Global reset signal (active low)

    // ============================ ADC Processing ============================
    input logic [13:0] ADC,   // ADC raw input signal (14-bit)

    // ============================ Modulation Generator ============================
    input logic [31:0] var_freq_cnt, // Frequency control input
    input logic [31:0] var_amp_H,    // Positive amplitude control
    input logic [31:0] var_amp_L,    // Negative amplitude control

    // ============================ Error Signal Processing ============================
    input logic var_polarity,         // Polarity control
    input logic [31:0] var_wait_cnt,  // Wait counter for stabilization
    input logic [31:0] var_err_offset,// Error offset adjustment
    input logic [31:0] var_avg_sel,   // Average selection control

    // ============================ Feedback Control ============================
    input logic [31:0] var_const_step, // Constant step value
    input logic var_fb_ON,             // Feedback enable
    input logic [31:0] var_gainSel_step,// Gain selection for step feedback

    // ============================ Phase Ramp Control ============================
    input logic [31:0] var_gainSel_ramp, // Gain selection for ramp control

    // ============================ Output Signals ============================
    output logic signed [31:0] o_err_DAC,    // Processed error signal output
    output logic signed [31:0] o_err_DAC_FIR,// FIR filtered error signal
    output logic signed [31:0] o_step,       // Feedback step output
    output logic signed [31:0] o_step_MV,    // Filtered step output
    output logic signed [31:0] o_phaseRamp   // Phase ramp output
);

// ============================ Internal Signals ============================
    // ---- ADC Filtering ----
    logic [29:0] adc_fir;             // Filtered ADC signal (14+16 bits)
    logic signed [13:0] reg_adc, reg_adc_sync; // Double registered ADC data

    // ---- Modulation Signals ----
    logic [31:0] mod_out_DAC;         // Modulated output
    logic status_DAC, stepTrig_DAC;   // Modulation status signals

    // ---- Error Processing ----
    logic o_step_sync, o_step_sync_dly;  // Internal synchronization triggers
    logic o_rate_sync, o_ramp_sync;      // Internal synchronization triggers

// ============================ Modulation Generator ============================
modulation_gen_v2 mod_gen_inst(
	.i_amp_H(var_amp_H),
	.i_amp_L(var_amp_L),
	.i_clk(CLOCK_DAC),
	.i_freq_cnt(var_freq_cnt),
	.i_rst_n(locked),
	.o_SM(),
	.o_mod_out(mod_out_DAC),
	.o_status(status_DAC),
	.o_stepTrig(stepTrig_DAC)
);

// ============================ Error Signal Generator ============================
err_signal_gen_v4 err_signal_gen_inst(
	.i_clk(CLOCK_DAC),
	.i_rst_n(locked),
	.i_status(status_DAC),
	.i_polarity(var_polarity),
	.i_trig(stepTrig_DAC), 
	.i_wait_cnt(var_wait_cnt),
	.i_err_offset(var_err_offset),
	.i_adc_data(ADC),
	.i_avg_sel(var_avg_sel),
	.o_err(o_err_DAC),
	.o_step_sync(o_step_sync),
	.o_step_sync_dly(o_step_sync_dly),
	.o_rate_sync(o_rate_sync),
	.o_ramp_sync(o_ramp_sync),
	.o_adc(),
	.o_adc_sum(),
	.o_cstate(),
	.o_nstate()
);

// ============================ Feedback Step Generator ============================
feedback_step_gen_v4 fb_step_gen_inst(
	.i_clk(CLOCK_DAC),
	.i_rst_n(locked),
	.i_const_step(var_const_step),
	.i_err(o_err_DAC),
	// .i_err(o_err_DAC_FIR),
	.i_fb_ON(var_fb_ON),
	.i_gain_sel(var_gainSel_step),
	.i_trig(o_step_sync),
	.i_trig_dly(o_step_sync_dly),
	.o_fb_ON(),
	.o_gain_sel(),
	.o_gain_sel2(),
	.o_step(o_step),
	.o_step_pre(),
	.o_status(),
	.o_change(),
	.o_step_init() 
);

// ============================ Phase Ramp Generator ============================
phase_ramp_gen phase_ramp_gen_inst(
	.i_clk(CLOCK_DAC),
	.i_rst_n(locked),
	.i_fb_ON(var_fb_ON),
	.i_gain_sel(var_gainSel_ramp),
	.i_mod(mod_out_DAC),

	.i_step(o_step),
	.i_rate_trig(o_rate_sync),
	.i_ramp_trig(o_ramp_sync),

	.i_mod_trig(stepTrig_DAC),
	.o_change(),
	.o_gain_sel(),
	.o_gain_sel2(),
	.o_phaseRamp_pre(),
	.o_phaseRamp(o_phaseRamp),
	.o_ramp_init()
);
endmodule