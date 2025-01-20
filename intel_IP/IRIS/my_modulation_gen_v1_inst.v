    // Instantiate the my_modulation_gen_v1 module
    my_modulation_gen_v1 u_my_modulation_gen_v1 (
        .i_clk(clk),                // System clock 
        .i_rst_n(rst_n),            // Active-low reset 
        .i_freq_cnt(freq_cnt),      // Frequency control input (32-bit unsigned)
        .i_amp_H(amp_H),            // Positive amplitude input (32-bit signed)
        .i_amp_L(amp_L),            // Negative amplitude input (32-bit signed)
        .o_mod_out(mod_out),        // Modulated output signal (32-bit signed)
        .o_status(status),          // Cycle status output (1-bit)
        .o_stepTrig(stepTrig)       // Switching trigger output (1-bit)
    );