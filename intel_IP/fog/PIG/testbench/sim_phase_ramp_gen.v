

module sim_phase_ramp_gen
(
input i_clk,
input i_rst_n,
// modulation_gen_v2
input [32-1:0] i_amp_H,
input [32-1:0] i_amp_L, 
output [32-1:0] o_mod_out,
output  o_status,
output  o_stepTrig,

//err_signal_gen_v2
input i_polarity,
input  [31:0] i_err_offset,
input  [14-1:0] i_adc_data,
output  [31:0] o_err,
output  o_step_sync,
output  o_step_sync_dly,
output  o_rate_sync,
output  o_ramp_sync,

//phase_ramp_gen_v2
input [31:0] i_fb_ON,
input [31:0] i_gain_sel,
input [31:0] i_step,
// output o_change,
output [31:0]  o_phaseRamp_pre,
output [31:0]  o_phaseRamp,
output [31:0] o_gain_sel

);

modulation_gen_v2 mod_gen_inst(
	.i_amp_H(i_amp_H),
	.i_amp_L(i_amp_L),
	.i_clk(i_clk),
	.i_freq_cnt(100),
	.i_rst_n(i_rst_n),
	.o_mod_out(o_mod_out),
	.o_status(o_status),
	.o_stepTrig(o_stepTrig),
	.o_SM()

);

err_signal_gen_v2 err_signal_gen_inst(
	.i_clk(i_clk),
	.i_rst_n(i_rst_n),
	.i_status(o_status),
	.i_polarity(i_polarity),
	.i_trig(o_stepTrig),
	.i_freq_cnt(100),
	.i_err_offset(i_err_offset),
	.i_adc_data(i_adc_data),
	.o_err(o_err),
	.o_step_sync(o_step_sync),
	.o_step_sync_dly(o_step_sync_dly),
	.o_rate_sync(o_rate_sync),
	.o_ramp_sync(o_ramp_sync),
	.o_adc(),
	.o_adc_old(),
	.o_adc_new(),
	.o_adc_sum(),
	.o_pol_change(),
	.o_flip_flag(),
	.o_cstate(), 
	.o_nstate(),
	.o_stable_cnt()
);


phase_ramp_gen_v2 phase_ramp_gen_inst(
	.i_clk(i_clk),
	.i_fb_ON(i_fb_ON),
	.i_gain_sel(i_gain_sel),
	.i_mod(o_mod_out),
	.i_rst_n(i_rst_n),
	.i_step(i_step),
	.i_rate_trig(o_rate_sync),
	.i_ramp_trig(o_ramp_sync),
	.i_mod_trig(o_stepTrig),
	.o_change(),
	.o_gain_sel(o_gain_sel),
	.o_gain_sel2(),
	.o_status(),
	.o_phaseRamp_pre(o_phaseRamp_pre),
	.o_phaseRamp(o_phaseRamp),
	.o_ramp_init()
	
);


endmodule