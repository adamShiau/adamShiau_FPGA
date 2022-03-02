`timescale 1ns / 100ps

module phase_ramp_gen_v4_tb();


reg clk;
reg rst_n;

// modulation_gen_v2
reg [31:0] freq_cnt;
reg [31:0] amp;
wire [31:0] mod_out;
wire status;
wire stepTrig;
// wire SM;

//phase_ramp_gen
reg [31:0] step;
reg [31:0] fb_on;
reg [3:0] gain_sel;
wire [15:0] phaseRamp;
wire [15:0] ladderWave;

reg [31:0] cnt;


modulation_gen_v4 
#(.OUTPUT_BIT(32))
u1
(
.i_clk(clk),
.i_rst_n(rst_n),
.i_freq_cnt(freq_cnt),
.i_amp_H(0),
.i_amp_L(0), 
.i_ramp_trig_cnt(0),
.o_mod_out(mod_out),
.o_status(status),
.o_stepTrig(stepTrig)
,.o_SM()
,.sim_ramp_trig_cnt()
);

phase_ramp_gen_v4 
#(.OUTPUT_BIT(32))
u2(
.i_clk(clk),
.i_rst_n(rst_n),
.i_trig(stepTrig),
.i_step(step), //[31:0] i_step
.i_fb_on(fb_on),
.i_mod(mod_out), //[OUTPUT_BIT-1:0] i_mod
.i_gain_sel(gain_sel), //[3:0]
.o_ladderWave(ladderWave), //[OUTPUT_BIT-1:0] o_ladderWave
.o_phaseRamp(phaseRamp) //[OUTPUT_BIT-1:0] o_phaseRamp
,.o_shift_idx()
);

initial begin
clk = 0;
rst_n = 0;
fb_on = 1;
step =-100;
freq_cnt = 32'd100;
amp = 32'd0;
gain_sel = 4'd1;
#50;
rst_n = 1;
cnt = 0;
repeat(1500) begin
	@(posedge stepTrig) begin
		// cnt = cnt + 1;
		// if(cnt > 75) step = -1;
	end
end
$stop;
end

always#5 clk = ~clk;

endmodule