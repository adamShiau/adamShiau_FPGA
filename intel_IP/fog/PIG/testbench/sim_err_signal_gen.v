

module sim_err_signal_gen
(
input i_clk,
input i_rst_n,
input [31:0] i_freq_cnt,
input [32-1:0] i_amp_H,
input [32-1:0] i_amp_L, 
output [32-1:0] o_mod_out,
output  o_status,
output  o_stepTrig,
/*** simulation***/
output o_SM,


//input i_status,
input i_polarity,
//input i_trig,
//input [31:0] i_freq_cnt,
input  [31:0] i_err_offset,
input  [14-1:0] i_adc_data,
input [31:0] i_avg_sel, 
output  [31:0] o_err,
output o_sync,


/*** for simulation ***/
output  [31:0] o_adc,
output  [31:0] o_adc_old,
output  [31:0] o_adc_new,
output  [31:0] o_adc_sum,
output o_change,
output o_flip_flag,
output [3:0] o_cstate, o_nstate
);

modulation_gen i1 (
// port map - connection between master ports and signals/registers   
	.i_amp_H(i_amp_H),
	.i_amp_L(i_amp_L),
	.i_clk(i_clk),
	.i_freq_cnt(i_freq_cnt),
	.i_rst_n(i_rst_n),
	.o_SM(o_SM),
	.o_mod_out(o_mod_out),
	.o_status(o_status),
	.o_stepTrig(o_stepTrig)
);

err_signal_gen i2 (
// port map - connection between master ports and signals/registers   
	.i_adc_data(i_adc_data),
	.i_avg_sel(i_avg_sel),
	.i_clk(i_clk),
	.i_err_offset(i_err_offset),
	.i_freq_cnt(i_freq_cnt),
	.i_polarity(i_polarity),
	.i_rst_n(i_rst_n),
	.i_status(o_status),
	.i_trig(o_stepTrig),
	.o_adc(o_adc),
	.o_adc_sum(o_adc_sum),
	.o_change(o_change),
	.o_cstate(o_cstate),
	.o_err(o_err),
	.o_adc_new(o_adc_new),
	.o_flip_flag(o_flip_flag),
	.o_nstate(o_nstate),
	.o_sync(o_sync),
	.o_adc_old(o_adc_old)
);

endmodule