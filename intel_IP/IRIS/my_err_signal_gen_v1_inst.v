    // Instantiating the err_signal_gen module with ADC_BIT parameter
    my_err_signal_gen_v1 #(
        .ADC_BIT(ADC_BIT)  // ADC_BIT specifies the width of the ADC input data, typically 14 bits.
    ) u_my_err_signal_gen_v1
     (
        .i_clk(i_clk),                      // Clock signal (1 bit)
        .i_rst_n(i_rst_n),                  // Active low reset signal (1 bit)
        .i_status(i_status),                // Status signal (1 bit) indicating the current status
        .i_polarity(i_polarity),            // Polarity signal (1 bit) used to adjust signal polarity
        .i_trig(i_trig),                    // Trigger signal (1 bit) used to initiate error generation
        .i_wait_cnt(i_wait_cnt),            // Wait counter (32 bits) for delay purposes unti signal stable 
        .i_err_offset(i_err_offset),        // Error offset (32 bits) used to introduce error adjustments
        .i_adc_data(i_adc_data),            // ADC data input (ADC_BIT bits, typically 14 bits)
        .i_avg_sel(i_avg_sel),              // Average selection signal (32 bits) to select averaging mode
        .o_step_sync(o_step_sync),          // Output one clock trigger to feedback step gen.i_trig 
        .o_step_sync_dly(o_step_sync_dly),  // Output one clock trigger to feedback step gen.i_trig_dly 
        .o_rate_sync(o_rate_sync),          // Output one clock trigger to phase ramp gen.i_rate_trig 
        .o_ramp_sync(o_ramp_sync),          // Output one clock trigger to phase ramp gen.i_ramp_trig 
        .o_err(o_err)                // Output error signal (32 bits) representing the computed error
    );
