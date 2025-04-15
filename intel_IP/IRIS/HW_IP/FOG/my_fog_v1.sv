
module my_fog_v1 #(
parameter logic signed [15:0] COEFF_SET [0:31] = '{ // default use coeff. N32FC5
        -54, -64, -82, -97, -93, -47, 66, 266, 562, 951,
        1412, 1909, 2396, 2821, 3136, 3304,
        3304, 3136, 2821, 2396, 1909, 1412, 951, 562, 
        266, 66, -47, -93, -97, -82, -64, -54
    }
)(
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
    input logic [31:0] var_fb_ON,             // Feedback enable
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


// ============================ FIR Filter for ADC ============================
myfir_filter #(
	.N(32), 
	.WIDTH(14),
	.COEFF_SET(COEFF_SET)
) ADC_fir_inst 
(
	.clk(CLOCK_ADC),
	.n_rst(locked),
	.din(ADC),  // ADC input, [WIDTH-1:0] 
	.dout(adc_fir) // filtered ADC data [WIDTH+15:0]
);

// ============================ ADC Signal Register ============================
// double register adc signal from CLOCK_ADC_1 to CLOCK_DAC_1
always @(posedge CLOCK_DAC) begin
	reg_adc <= (adc_fir >>> 16);
	reg_adc_sync <= reg_adc;
end

// ============================ Modulation Generator ============================
 my_modulation_gen_v1 inst_my_modulation_gen (
	.i_clk(CLOCK_DAC),                // System clock 
	.i_rst_n(locked),            // Active-low reset 
	.i_freq_cnt(var_freq_cnt),      // Frequency control input (32-bit unsigned)
	.i_amp_H(var_amp_H),            // Positive amplitude input (32-bit signed)
	.i_amp_L(var_amp_L),            // Negative amplitude input (32-bit signed)
	.o_mod_out(mod_out_DAC),        // Modulated output signal (32-bit signed)
	.o_status(status_DAC),          // Cycle status output (1-bit)
	.o_stepTrig(stepTrig_DAC)       // Switching trigger output (1-bit)
);

// ============================ Error Signal Generator ============================
wire signed [31:0] output_err_raw;

my_err_signal_gen_v2 #(
    .ADC_BIT(14)  // ADC_BIT specifies the width of the ADC input data, typically 14 bits.
) u_my_err_signal_gen
    (
    .i_clk(CLOCK_DAC),               // Clock signal (1 bit)
    .i_rst_n(locked),           // Active low reset signal (1 bit)
    .i_status(status_DAC),         // Status signal (1 bit) indicating the current status
    .i_polarity(var_polarity),     // Polarity signal (1 bit) used to adjust signal polarity
    .i_trig(stepTrig_DAC),             // Trigger signal (1 bit) used to initiate error generation
    .i_wait_cnt(var_wait_cnt),     // Wait counter (32 bits) for delay purposes unti signal stable 
    .i_err_offset(var_err_offset), // Error offset (32 bits) used to introduce error adjustments
    .i_adc_data(reg_adc_sync),     // ADC data input (ADC_BIT bits, typically 14 bits)
    // .i_adc_data(ADC),
    .i_avg_sel(var_avg_sel),       // Average selection signal (32 bits) to select averaging mode
    .o_step_sync(o_step_sync),          // Output one clock trigger to feedback step gen.i_trig 
    .o_step_sync_dly(o_step_sync_dly),  // Output one clock trigger to feedback step gen.i_trig_dly 
    .o_rate_sync(o_rate_sync),          // Output one clock trigger to phase ramp gen.i_rate_trig 
    .o_ramp_sync(o_ramp_sync),          // Output one clock trigger to phase ramp gen.i_ramp_trig 
    .o_err(o_err_DAC)                // Output error signal (32 bits) representing the computed error
    // .o_err(output_err_raw)                // Output error signal (32 bits) representing the computed error
    ,.o_low_avg()
    ,.o_high_avg()
);

// ============================ Threshold Filter for Err output ============================

// threshold_filter #(
//     .DATA_WIDTH(32)
// ) u_threshold_filter (
//     .i_clk(CLOCK_ADC),
//     .i_rst_n(locked),
//     .i_data(output_err_raw),
//     .i_threshold(32'd1000),
//     .o_filtered(o_err_DAC)
// );

// ============================ FIR Filter for Error Signal ============================
myfir_filter_gate #(
	.N(32), 
	.WIDTH(14),
	.COEFF_SET(COEFF_SET)
) fir_gate_inst 
(
	.clk(CLOCK_DAC),
	.n_rst(locked),
	.i_trig(o_step_sync),
	.din(o_err_DAC[13:0]),  // 14 bit
	.dout(o_err_DAC_FIR) // 32 bit
);

// ============================ Feedback Step Generator ============================
feedback_step_gen_v4 fb_step_gen_inst(
	.i_clk(CLOCK_DAC),
	.i_rst_n(locked),
	.i_const_step(var_const_step),
	// .i_err(o_err_DAC),
	.i_err(o_err_DAC_FIR),
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

// ============================ Step Filtering Before CPU ============================
//filter step output signal before send to CPU
// fs = frequency of trig/DIV_FACTOR
// fc ~ 0.5* fs / N  = 0.5 * (300/6) / 512 KHz = 48.8 Hz  

// myMV_filter_gate_v1 #(
// 	.WINDOW(512),
// 	.DIV_FACTOR(6) // trigger devider
// )
//  u_myMV_filter
// (
// 	.clk(CLOCK_DAC), 
//     .n_rst(locked),
// 	.trig(o_step_sync),
//     .din(o_step),
//     .dout(o_step_MV)
// );

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