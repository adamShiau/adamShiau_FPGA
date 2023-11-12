

module sim_err_signal_gen_v4
#(parameter OUTPUT_BIT = 32,
 parameter ADC_BIT = 14)
(
	input i_clk,
    input i_rst_n,
    input [31:0] i_freq_cnt,
    input [OUTPUT_BIT-1:0] i_amp_H,
    input [OUTPUT_BIT-1:0] i_amp_L, 
    output [OUTPUT_BIT-1:0] o_mod_out,
    output [OUTPUT_BIT-1:0] o_mod_out_dly1,
    output [OUTPUT_BIT-1:0] o_mod_out_dly2,
    output  o_status,
	output  o_stepTrig,
    output  o_stepTrig_dly1,
    output  o_stepTrig_dly2,
	/*** simulation***/
	output o_SM,


	// input i_status,
	input i_polarity,
	// input i_trig,
	input [31:0] i_wait_cnt,
	input  [31:0] i_err_offset,
	input  [ADC_BIT-1:0] i_adc_data,
	input [31:0] i_avg_sel, 
	output  [31:0] o_err,
	output  o_step_sync,
	output  o_step_sync_dly,
	output  o_rate_sync,
	output  o_ramp_sync,

	/*** for simulation ***/
	//output reg [31:0] o_r_mv_cnt,
	output signed [31:0] o_adc,
	// output signed [31:0] o_adc_old,
	// output signed [31:0] o_adc_new,
	output signed [31:0] o_adc_sum,
	// output o_pol_change,
	// output o_flip_flag,
	output [3:0] o_cstate, o_nstate,
	output [31:0] o_stable_cnt
);

modulation_gen_v3 i1 (
// port map - connection between master ports and signals/registers   
	.i_amp_H(i_amp_H),
	.i_amp_L(i_amp_L),
	.i_clk(i_clk),
	.i_freq_cnt(i_freq_cnt),
	.i_rst_n(i_rst_n),
	// .o_SM(o_SM),
	.o_mod_out(o_mod_out),
	.o_mod_out_dly1(o_mod_out_dly1),
	.o_mod_out_dly2(o_mod_out_dly2),
	.o_status(o_status),
	.o_stepTrig(o_stepTrig),
	.o_stepTrig_dly1(o_stepTrig_dly1),
	.o_stepTrig_dly2(o_stepTrig_dly2)
);

err_signal_gen_v4 i2 (
// port map - connection between master ports and signals/registers   
	.i_adc_data(i_adc_data),
	.i_avg_sel(i_avg_sel),
	.i_clk(i_clk),
	.i_err_offset(i_err_offset),
	.i_polarity(i_polarity),
	.i_rst_n(i_rst_n),
	.i_status(o_status),
	.i_trig(o_stepTrig),
	.i_wait_cnt(i_wait_cnt),
	.o_adc(o_adc),
	.o_adc_sum(o_adc_sum),
	.o_cstate(o_cstate),
	.o_err(o_err),
	.o_nstate(o_nstate),
	.o_ramp_sync(o_ramp_sync),
	.o_rate_sync(o_rate_sync),
	.o_stable_cnt(o_stable_cnt),
	.o_step_sync(o_step_sync),
	.o_step_sync_dly(o_step_sync_dly)
);

endmodule