

module sim_phase_ramp_gen
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


input [31:0] i_fb_ON,
input [31:0] i_gain_sel,
input [31:0] i_mod,
//reg i_rst_n;
input [31:0] i_step,
//reg i_trig;
// wires                                               
output o_change,
output [31:0]  o_gain_sel,
output [31:0]  o_gain_sel2,
output [31:0]  o_phaseRamp_pre,
output [31:0]  o_phaseRamp,
output [31:0]  o_ramp_init
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

phase_ramp_gen i2 (
// port map - connection between master ports and signals/registers   
	.i_clk(i_clk),
	.i_fb_ON(i_fb_ON),
	.i_gain_sel(i_gain_sel),
	.i_mod(i_mod),
	.i_rst_n(i_rst_n),
	.i_step(i_step),
	.i_trig(o_stepTrig),
	.o_change(o_change),
	.o_gain_sel(o_gain_sel),
	.o_gain_sel2(o_gain_sel2),
	.o_phaseRamp_pre(o_phaseRamp_pre),
	.o_phaseRamp(o_phaseRamp),
	.o_ramp_init(o_ramp_init)
);

endmodule