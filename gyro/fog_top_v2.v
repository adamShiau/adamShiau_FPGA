/***
data:2021-11-30
IP: feedback_step_gen_v6
***/
module fog_top_v2 
#(
parameter TIMER_COUNTER_NUM = 20, // timer counter
parameter DAC_BIT 			= 16, //DAC  bit
parameter ADC_BIT			= 14  //ADC bit
)
(
	/*** global ***/
	input i_clk,
	input i_rst_n,
	/*** timer***/
	input i_timer_rst,
	output [31:0] o_timer,
	/*** modulation ***/
	input [31:0] i_freq_cnt,
	input [DAC_BIT-1:0] i_amp_H,
	input [DAC_BIT-1:0] i_amp_L, 
	input [31:0] i_ramp_trig_cnt,
	output signed [DAC_BIT-1:0] o_mod_out,
	output o_status,
	output o_stepTrig,
	/*** err_signal_gen ***/
	input [ADC_BIT-1:0] i_adc_data,
	input i_polarity,
	input [31:0] i_wait_cnt,
	input [31:0] i_err_offset,
	input [2:0]i_avg_sel,
	input [31:0] i_err_th,
	output [31:0] o_err,
	output o_err_done,
	/*** feedback_step_gen***/
	input [3:0] i_gain_sel_step,
	input i_fb_ON,
	output o_fb_ON,			//o_fb_ON = 1 if i_gain_sel != 15 
	output [15:0] o_step,
	output [31:0] o_step_mon,
	/*** phase_ramp_gen***/
	input [3:0] i_gain_sel_ramp, 
	output [DAC_BIT-1:0] o_ladderWave,
	output [DAC_BIT-1:0] o_phaseRamp,
	output [3:0] o_shift_idx_ramp
);


timer
#(.COUNTER_NUM(TIMER_COUNTER_NUM))
u_timer (
// port map - connection between master ports and signals/registers   
	.i_clk(i_clk),
	.i_rst_n(i_rst_n),
	.i_timer_rst(i_timer_rst),
	.o_timer(o_timer)
);

modulation_gen_v4 
#(.OUTPUT_BIT(DAC_BIT))
u_mod
(
.i_clk(i_clk),
.i_rst_n(i_rst_n),
.i_freq_cnt(i_freq_cnt),
.i_amp_H(i_amp_H), //[OUTPUT_BIT-1:0]
.i_amp_L(i_amp_L), //[OUTPUT_BIT-1:0]
.i_ramp_trig_cnt(i_ramp_trig_cnt),
.o_mod_out(o_mod_out), //[OUTPUT_BIT-1:0]
.o_status(o_status),
.o_stepTrig(o_stepTrig)
);

err_signal_gen_v3 
#(.ADC_BIT(ADC_BIT))
u_err
(
.i_clk(i_clk),
.i_rst_n(i_rst_n),
.i_adc_data(i_adc_data),			//[13:0]
// .i_adc_data(kf_out[13:0]),			//[13:0]
/*** modulation H/L status for input signal acquisition***/
.i_status(o_status),
/*** err = H-L if polarity = 1, otherwise L-H ***/
.i_polarity(i_polarity),
/*** latch input data after wait cnt ***/
.i_wait_cnt(i_wait_cnt), 			//[31:0]
.i_err_offset_H(i_err_offset),		//[31:0]
/*** 0~6 for avg times 1~64 ***/
.i_avg_sel(i_avg_sel), 			//[2:0]
/*** error signal vth ***/
.i_err_th(i_err_th), 			//[31:0]
.o_errsignal(), 		//[31:0]
.o_errsignal_w_th(o_err), 	//[31:0]
/*** error signal ready flag ***/
.o_err_done(o_err_done)

/*** for simulation ***/
,.o_mv_cnt(), 			//[31:0]
.o_adc_reg_H(), 		//[31:0]
.o_adc_reg_L(), 		//[31:0]
.o_adc_H_sum(), 		//[31:0]
.o_adc_L_sum(), 		//[31:0]
.o_cstate()
);

feedback_step_gen_v6 u_fb
(
.i_clk(i_clk),
.i_rst_n(i_rst_n),
.i_trig(o_stepTrig),
.i_err(o_err), //[31:0] i_err
.i_gain_sel(i_gain_sel_step),  //[3:0] i_gain_sel_step
.i_fb_ON(i_fb_ON),
.o_fb_ON(o_fb_ON),
.o_step(o_step), 
.o_step_mon(o_step_mon),
.o_shift_idx()
);

/*** phase_ramp_gen***/
phase_ramp_gen_v4 
#(.OUTPUT_BIT(DAC_BIT))
u_phaseRamp(
.i_clk(i_clk),
.i_rst_n(i_rst_n),
.i_trig(o_stepTrig),
.i_step(o_step), //[15:0] i_step
.i_fb_on(o_fb_ON),
.i_mod(o_mod_out), //[OUTPUT_BIT-1:0] i_mod
.i_gain_sel(i_gain_sel_ramp), //[3:0] i_gain_sel_ramp
.o_ladderWave(o_ladderWave), //[OUTPUT_BIT-1:0] o_ladderWave
.o_phaseRamp(o_phaseRamp), //[OUTPUT_BIT-1:0] o_phaseRamp
.o_shift_idx(o_shift_idx_ramp)
);

endmodule