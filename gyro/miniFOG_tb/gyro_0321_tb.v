`timescale 1ns / 100ps

module gyro_tb();


reg clk;
reg rst_n;

// modulation_gen_v4
reg [31:0] freq_cnt;
reg [31:0] ramp_trig_cnt;
reg [15:0] amp;
wire [15:0] mod_out;
wire status;
wire stepTrig;

// err_signal_gen
reg [13:0] adc;
reg polarity;
reg [31:0] wait_cnt;
reg [31:0] err_offset_H;
reg [2:0] err_avg_sel;
reg [31:0] err_th;
wire [31:0] openLoop;
wire o_err_done;

// feedback_step_gen_v5
reg [3:0] gain_sel;
wire fb_on;
wire [16-1:0] step;
wire [31:0] o_step_mon;
wire [3:0] shift_idx;

//phase_ramp_gen_v3
wire [15:0] ladderWave;
wire [15:0] phaseRamp;


reg [13:0] cnt;

initial begin
clk = 0;
rst_n = 0;
cnt = 0;
adc = 14'd0;
ramp_trig_cnt = 0;
/*** modulation_gen_v2 ***/
freq_cnt = 32'd100;
amp = 16'd5800; // v(pi/4)
/*** err_signal_gen ***/
polarity = 0;
wait_cnt = 32'd50;
err_offset_H = 32'd10;
err_avg_sel = 3'd4;
err_th = 32'd0;
/*** feedback_step_gen ***/
gain_sel = 4'd1;
/*** phase_ramp_gen ***/
#50;
rst_n = 1;

repeat(2000) begin
	@(posedge stepTrig) begin
		// err_offset_H = err_offset_H + step;
		cnt = cnt + 1;
		if(cnt==800) begin
			polarity = 0;
			// err_offset_H = 0;
			ramp_trig_cnt = 1;
		end
		// else if(cnt==950) gain_sel = 4'd15;
		else if(cnt==1100) ramp_trig_cnt = 2;
	end
end
$stop;

end

always#5 clk = ~clk;

modulation_gen_v4 
#(.OUTPUT_BIT(16))
u_mod
(
.i_clk(clk),
.i_rst_n(rst_n),
.i_freq_cnt(freq_cnt),
.i_amp_H(amp),
.i_amp_L(-amp), 
.i_ramp_trig_cnt(ramp_trig_cnt),
.o_mod_out(mod_out),
.o_status(status),
.o_stepTrig(stepTrig),
.o_SM(),
.sim_ramp_trig_cnt()
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

feedback_step_gen_v5 u_fb
(
.i_clk(clk),
.i_rst_n(rst_n),
.i_trig(stepTrig),
.i_err(openLoop), //[31:0] i_err
.i_gain_sel(gain_sel),  //[3:0] i_gain_sel
.o_fb_ON(fb_on),
.o_step(step), 
.o_step_mon(o_step_mon),
.o_shift_idx(shift_idx)
);

phase_ramp_gen_v3 
#(.OUTPUT_BIT(16))
u_pr(
.i_clk(clk),
.i_rst_n(rst_n),
.i_trig(stepTrig),
.i_step(step), //[15:0] i_step
.i_fb_on(fb_on),
.i_mod(mod_out), //[OUTPUT_BIT-1:0] i_mod
.o_ladderWave(ladderWave), //[OUTPUT_BIT-1:0] o_ladderWave
.o_phaseRamp(phaseRamp) //[OUTPUT_BIT-1:0] o_phaseRamp
);

endmodule