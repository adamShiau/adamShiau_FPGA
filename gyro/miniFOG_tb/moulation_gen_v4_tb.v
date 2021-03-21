`timescale 1ns / 100ps

module modulation_gen_v4_tb();

reg clk;
reg rst_n;
reg [31:0] freq_cnt;
reg [31:0] ramp_trig_cnt;
wire [31:0] sim_ramp_trig_cnt;
reg [15:0] amp;
wire [15:0] mod_out;
wire status;
wire stepTrig;
wire SM;



modulation_gen_v4 
#(.OUTPUT_BIT(16))
u1
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
.o_SM(SM),
.sim_ramp_trig_cnt(sim_ramp_trig_cnt)
);

initial begin
clk = 0;
rst_n = 0;
freq_cnt = 32'd100;
ramp_trig_cnt = 32'd0;
amp = 16'd16383;
#50;
rst_n = 1;
repeat(5) begin
	@(posedge stepTrig);
end
ramp_trig_cnt = 32'd1;
repeat(5) begin
	@(posedge stepTrig);
end
ramp_trig_cnt = 32'd2;
repeat(5) begin
	@(posedge stepTrig);
end
ramp_trig_cnt = 32'd3;
repeat(5) begin
	@(posedge stepTrig);
end
ramp_trig_cnt = 32'd4;
repeat(5) begin
	@(posedge stepTrig);
end

$stop;
end

always#5 clk = ~clk;

endmodule