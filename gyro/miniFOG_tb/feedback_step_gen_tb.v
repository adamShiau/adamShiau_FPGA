`timescale 1ns / 100ps

module feedback_step_gen_tb();

reg clk;
reg rst_n;
// modulation_gen_v2
reg [31:0] freq_cnt;
reg [15:0] amp;
wire [15:0] mod_out;
wire status;
wire stepTrig;
wire SM;

// feedback_step_gen
reg signed [31:0] err;
reg [3:0] gain_sel;
reg [31:0] i_step_max;
wire fb_on;
wire [31:0] step;
wire [3:0] shift_idx;
wire [31:0] step_max;
wire [31:0] step_min;

reg [31:0] cnt;

modulation_gen_v2 
#(.OUTPUT_BIT(16))
umod
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

feedback_step_gen_v2 ufb
(
.i_clk(clk),
.i_rst_n(rst_n),
.i_trig(stepTrig),
// .i_trig(1),
.i_err(err), //[31:0] i_err
.i_gain_sel(gain_sel),  //[3:0] i_gain_sel
.i_step_max(i_step_max), //[31:0] i_step_max,
.o_fb_ON(fb_on),
.o_step(step), //[31:0] o_step
.o_shift_idx(shift_idx),
.o_step_max(step_max),
.o_step_min(step_min)
);

initial begin
cnt = 0;
clk = 0;
rst_n = 0;
err = 100;
gain_sel = 4'd2;
freq_cnt = 32'd100;
amp = 16'd16383;
i_step_max = 32'd1000;
#50;
rst_n = 1;
repeat(50) begin
	@(posedge stepTrig) begin
		// err = err - step;
		
		cnt = cnt + 1;
		if(cnt<=30) begin
			gain_sel = 4'd2;
			err = 100;
		end
		else if(cnt>30 && cnt<40) gain_sel = 4'd15;
		else begin
			gain_sel = 4'd1;
			err = -100;
		end
	end
end
$stop;
end


always#5 clk = ~clk;

endmodule