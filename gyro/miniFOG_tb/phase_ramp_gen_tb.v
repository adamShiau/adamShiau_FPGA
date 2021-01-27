`timescale 1ns / 100ps

module phase_ramp_gen_tb();


reg clk;
reg rst_n;

// modulation_gen_v2
reg [31:0] freq_cnt;
reg [15:0] amp;
wire [15:0] mod_out;
wire status;
wire stepTrig;
wire SM;

//phase_ramp_gen
reg [31:0] step;
reg [31:0] v2pi;
reg fb_on;
wire [15:0] phaseRamp;
wire [15:0] ladderWave;

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

phase_ramp_gen 
#(.OUTPUT_BIT(16))
u1(
.i_clk(clk),
.i_rst_n(rst_n),
.i_trig(stepTrig),
.i_step(step), //[31:0] i_step
.i_v2pi(v2pi), //[31:0] i_v2pi,
.i_fb_on(fb_on),
.i_mod(mod_out), //[OUTPUT_BIT-1:0] i_mod
.o_ladderWave(ladderWave), //[OUTPUT_BIT-1:0] o_ladderWave
.o_phaseRamp(phaseRamp) //[OUTPUT_BIT-1:0] o_phaseRamp
);

initial begin
clk = 0;
rst_n = 0;
fb_on = 1;
step =1200;
v2pi = 32'd8000;
freq_cnt = 32'd100;
amp = 16'd500;
#50;
rst_n = 1;
cnt = 0;
repeat(50) begin
	@(posedge stepTrig) begin
		cnt = cnt + 1;
		if(cnt > 25) step = -1200;
	end
end
$stop;
end

always#5 clk = ~clk;

endmodule