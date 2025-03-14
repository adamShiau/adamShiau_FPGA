my_fog_v1 #(
    .COEFF_SET() // Default coefficient set N32FC5
) my_fog_inst (
    // ============================ Common Signals ============================
    .CLOCK_ADC(), // ADC clock (1-bit)
    .CLOCK_DAC(), // DAC clock (1-bit)
    .locked(),    // Global reset signal, active low (1-bit)

    // ============================ ADC Processing ============================
    .ADC(), // Raw ADC input signal (14-bit)

    // ============================ Modulation Generator ============================
    .var_freq_cnt(), // Frequency control input (32-bit)
    .var_amp_H(),    // Positive amplitude control (32-bit)
    .var_amp_L(),    // Negative amplitude control (32-bit)

    // ============================ Error Signal Processing ============================
    .var_polarity(),     // Polarity control (1-bit)
    .var_wait_cnt(),     // Wait counter for stabilization (32-bit)
    .var_err_offset(),   // Error offset adjustment (32-bit)
    .var_avg_sel(),      // Average selection control (32-bit)

    // ============================ Feedback Control ============================
    .var_const_step(),    // Constant step value (32-bit)
    .var_fb_ON(),         // Feedback enable (1-bit)
    .var_gainSel_step(),  // Gain selection for step feedback (32-bit)

    // ============================ Phase Ramp Control ============================
    .var_gainSel_ramp(), // Gain selection for ramp control (32-bit)

    // ============================ Output Signals ============================
    .o_err_DAC(),       // Processed error signal output (32-bit, signed)
    .o_err_DAC_FIR(),   // FIR filtered error signal (32-bit, signed)
    .o_step(),          // Feedback step output (32-bit, signed)
    .o_step_MV(),       // Filtered step output (32-bit, signed)
    .o_phaseRamp()      // Phase ramp output (32-bit, signed)
);
