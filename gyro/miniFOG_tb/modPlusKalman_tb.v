`timescale 1ns / 100ps

module modPlusKalman_tb();

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

reg [31:0] kal_Q, kal_R;
wire signed [31:0] p_est, x_est;

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

Kalman_filter ukal
(
.i_clk	(clk),
.i_rst_n(rst_n),
.i_meas	(mod_out[13:0]),	//input [13:0]
.i_kal_Q(kal_Q),	//input [31:0]
.i_kal_R(kal_R),	//input [31:0]
.x_est	(x_est), 	//output [31:0];
.p_est	(p_est) 		//output [31:0]
);

reg [10:0] cnt = 0;

initial begin
clk = 0;
rst_n = 0;
freq_cnt = 32'd100;
ramp_trig_cnt = 32'd0;
amp = 16'd8000;
kal_Q = 5;
kal_R = 10;
#50;
rst_n = 1;
repeat(10) begin
	@(posedge stepTrig);
	
end

$stop;
end

always#5 clk = ~clk;

endmodule