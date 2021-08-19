`timescale 1 ns/ 1 ns
module fog_top_tb();

/*** global ***/
reg i_clk;
reg i_rst_n;
/*** timer***/
reg i_timer_rst;
wire [31:0] o_timer;
/*** modulation ***/
reg [31:0] i_freq_cnt;
reg [16-1:0] i_amp_H;
reg [16-1:0] i_amp_L; 
wire o_status;
wire [16-1:0] o_mod_out;
reg [31:0] i_ramp_trig_cnt;
wire o_stepTrig;
/*** err_signal_gen ***/
reg [14-1:0] i_adc_data;
reg i_polarity;
reg [31:0] i_wait_cnt;
reg [31:0] i_err_offset;
reg [2:0] i_avg_sel;
reg [31:0] i_err_th;
wire [31:0] o_err;
wire o_err_done;
/*** feedback_step_gen***/
reg [3:0] i_gain_sel;
wire o_fb_ON;
wire [15:0] o_step;
wire [31:0] o_step_mon;
/*** phase_ramp_gen***/
wire [15:0] o_ladderWave;
wire [15:0] o_phaseRamp;
	
fog_top
#(
.TIMER_COUNTER_NUM(20),
.DAC_BIT(16),
.ADC_BIT(14)
)
ufog_top (
	.i_clk(i_clk),
	.i_rst_n(i_rst_n),
	/*** timer ***/
	.i_timer_rst(i_timer_rst),
	.o_timer(o_timer),
	/*** modulation ***/
	.i_freq_cnt(i_freq_cnt),
	.i_amp_H(i_amp_H),
	.i_amp_L(i_amp_L), 
	.i_ramp_trig_cnt(i_ramp_trig_cnt),
	.o_mod_out(o_mod_out),
	.o_status(o_status),
	.o_stepTrig(o_stepTrig),
	/*** err_signal_gen ***/
	.i_adc_data(i_adc_data),
	.i_polarity(i_polarity),
	.i_wait_cnt(i_wait_cnt),
	.i_err_offset(i_err_offset),
	.i_avg_sel(i_avg_sel),
	.i_err_th(i_err_th),
	.o_err(o_err),
	.o_err_done(o_err_done),
	/*** feedback_step_gen***/
	.i_gain_sel(i_gain_sel),
	.o_fb_ON(o_fb_ON),
	.o_step(o_step),
	.o_step_mon(o_step_mon),
	/*** phase_ramp_gen***/
	.o_ladderWave(o_ladderWave),
	.o_phaseRamp(o_phaseRamp)
);



initial begin                                                  
	i_clk = 0;
	i_rst_n = 0;
	// timer //
	i_timer_rst = 0;
	// mod //
	i_freq_cnt = 32'd100;
	i_amp_H = 16'd1000;
	i_amp_L = -16'd1000;
	// err signal gen//
	i_adc_data = 14'd0;
	i_polarity = 1'b0;
	i_wait_cnt = 32'd10;
	i_err_offset = 32'd10;
	i_avg_sel = 3'd0;
	i_err_th = 32'd0;
	// feedback_step_gen //
	i_gain_sel = 4'd0;
	#50;
	i_rst_n = 1;
	#10;
	i_ramp_trig_cnt = 32'd0;
	// repeat(5) begin
		// @(posedge o_stepTrig);
		// i_err_offset = i_err_offset + 32'd10;
	// end
	// i_ramp_trig_cnt = 32'd1;
	// repeat(5) begin
		// @(posedge o_stepTrig);
		// i_err_offset = i_err_offset - 32'd50;
	// end
	#500000
   $stop;
end     
                                               
always#5
	i_clk = ~i_clk;
	
endmodule

