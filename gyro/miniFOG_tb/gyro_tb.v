`timescale 1ns / 100ps

module gyro_tb();


reg clk;
reg rst_n;

// modulation_gen_v2
reg [31:0] freq_cnt;
reg [15:0] amp;
wire [15:0] mod_out;
wire status;
wire stepTrig;
wire SM;

// err_signal_gen
reg [13:0] adc;
reg polarity;
reg [31:0] wait_cnt;
reg [31:0] err_offset_H;
reg [2:0] err_avg_sel;
reg [31:0] err_th;
wire [31:0] openLoop;
wire o_err_done;

// feedback_step_gen
reg [3:0] gain_sel;
reg [31:0] i_step_max;
wire fb_on;
wire [31:0] step;
wire [3:0] shift_idx;
wire [31:0] step_max;
wire [31:0] step_min;

//phase_ramp_gen
reg [31:0] v2pi;
wire [15:0] phaseRamp;

reg [13:0] cnt;

initial begin
clk = 0;
rst_n = 0;
cnt = 0;
adc = 14'd0;
/*** modulation_gen_v2 ***/
freq_cnt = 32'd100;
amp = 16'd16383;
/*** err_signal_gen ***/
polarity = 0;
wait_cnt = 32'd0;
err_offset_H = 32'd0;
err_avg_sel = 3'd0;
err_th = 32'd0;
/*** feedback_step_gen ***/
gain_sel = 4'd0;
i_step_max = 32'd3000;
/*** phase_ramp_gen ***/
v2pi = 32'd8000;
#50;
rst_n = 1;
err_offset_H = 32'd100;

repeat(50) begin
	@(posedge stepTrig) begin
		cnt = cnt + 1;
	end
end
$stop;

end

always#5 clk = ~clk;

modulation_gen_v2 
#(.OUTPUT_BIT(16))
u_mod
(
.i_clk(clk),
.i_rst_n(rst_n),
.i_freq_cnt(freq_cnt), //[31:0] i_freq_cnt
.i_amp_H(amp), //[OUTPUT_BIT-1:0] i_amp_H
.i_amp_L(-amp), //[OUTPUT_BIT-1:0] i_amp_L
.o_mod_out(mod_out), //[OUTPUT_BIT-1:0] o_mod_out
.o_status(status),
.o_stepTrig(stepTrig),
.o_SM(SM)
);

err_signal_gen u_err
(
.i_clk(clk),
.i_rst_n(rst_n),
.i_adc_data(adc),			//[13:0]
/*** modulation H/L status for input signal acquisition***/
.i_status(status),
/*** err = H-L if polarity = 1, otherwise L-H ***/
.i_polarity(polarity),
/*** latch input data after wait cnt ***/
.i_wait_cnt(wait_cnt), 			//[31:0]
.i_err_offset_H(err_offset_H),		//[31:0]
/*** 0~6 for avg times 1~64 ***/
.i_avg_sel(err_avg_sel), 			//[2:0]
/*** error signal vth ***/
.i_err_th(err_th), 			//[31:0]
.o_errsignal(), 		//[31:0]
.o_errsignal_w_th(openLoop), 	//[31:0]
/*** error signal ready flag ***/
.o_err_done(o_err_done),

/*** for simulation ***/
.o_mv_cnt(), 			//[31:0]
.o_adc_reg_H(adc_reg_H), 		//[31:0]
.o_adc_reg_L(adc_reg_L), 		//[31:0]
.o_adc_H_sum(), 		//[31:0]
.o_adc_L_sum() 			//[31:0]
);

feedback_step_gen_v2 u_fb
(
.i_clk(clk),
.i_rst_n(rst_n),
.i_trig(stepTrig),
// .i_trig(1),
.i_err(openLoop), //[31:0] i_err
.i_gain_sel(gain_sel),  //[3:0] i_gain_sel
.i_step_max(i_step_max), //[31:0] i_step_max,
.o_fb_ON(fb_on),
.o_step(step), //[31:0] o_step
.o_shift_idx(shift_idx),
.o_step_max(step_max),
.o_step_min(step_min)
);

phase_ramp_gen 
#(.OUTPUT_BIT(16))
u_pr(
.i_clk(clk),
.i_rst_n(rst_n),
.i_trig(stepTrig),
.i_step(step), //[31:0] i_step
.i_v2pi(v2pi), //[31:0] i_v2pi,
.i_fb_on(fb_on),
.o_phaseRamp(phaseRamp) //[OUTPUT_BIT-1:0] o_phaseRamp
);

endmodule