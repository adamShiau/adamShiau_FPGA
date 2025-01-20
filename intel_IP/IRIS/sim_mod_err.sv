module sim_mod_err
#(
    parameter ADC_BIT = 14 // Parameter for ADC bit width
)
(
    // Signals for modulation_gen_ut
    input logic i_clk,
    input logic i_rst_n,
    input logic [31:0] i_freq_cnt,
    input logic signed [31:0] i_amp_H,
    input logic signed [31:0] i_amp_L,
    output logic signed [31:0] o_mod_out,
    output logic o_status,
    output logic o_stepTrig,

    // Signals for err_signal_gen_ut
    input logic i_polarity,
    input logic [31:0] i_wait_cnt,
    input logic signed [31:0] i_err_offset,
    input logic signed [ADC_BIT-1:0] i_adc_data,
    input logic [31:0] i_avg_sel,
    output logic signed [31:0] o_err
);

    // Instantiate modulation_gen_ut
    modulation_gen_ut mod_inst (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_freq_cnt(i_freq_cnt),
        .i_amp_H(i_amp_H),
        .i_amp_L(i_amp_L),
        .o_mod_out(o_mod_out),
        .o_status(o_status),
        .o_stepTrig(o_stepTrig)
    );

    // Instantiate err_signal_gen_ut
    err_signal_gen_ut #(.ADC_BIT(ADC_BIT)) err_inst (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_status(o_status),
        .i_polarity(i_polarity),
        .i_trig(o_stepTrig),
        .i_wait_cnt(i_wait_cnt),
        .i_err_offset(i_err_offset),
        .i_adc_data(i_adc_data),
        .i_avg_sel(i_avg_sel),
        .o_err(o_err)
    );

endmodule
