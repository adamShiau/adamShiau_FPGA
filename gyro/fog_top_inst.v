fog_top 
#(
.TIMER_COUNTER_NUM(10000),
.DAC_BIT(16),
.ADC_BIT(14)
)
u_fog 
(
/*** global ***/
.i_clk(pll_clk),
.i_rst_n(locked),
/*** timer***/
.i_timer_rst(o_var_timer_rst),
.o_timer(i_var_timer), //[31:0]
/*** modulation ***/
.i_freq_cnt(o_var_freq), //[31:0]
.i_amp_H(o_var_amp_H), //[DAC_BIT-1:0]
.i_amp_L(o_var_amp_L), //[DAC_BIT-1:0]
.i_ramp_trig_cnt(o_var_ramp_trig_cnt), // [31:0]
/*** err_signal_gen ***/
.i_adc_data(), //[ADC_BIT-1:0]
.i_polarity(),
.i_wait_cnt(), // [31:0]
.i_err_offset(), //[31:0]
.i_avg_sel(), //[2:0]
.i_err_th(), // [31:0]
.o_err(), // [31:0]
/*** feedback_step_gen***/
.i_gain_sel(), //[3:0]
.o_step_mon(), // [31:0]
/*** phase_ramp_gen***/
.o_ladderWave(), //[DAC_BIT-1:0] 
.o_phaseRamp() //[DAC_BIT-1:0]
);

