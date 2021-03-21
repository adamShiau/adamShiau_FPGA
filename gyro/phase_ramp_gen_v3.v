/***
data: 2021-03-21
v3 simplify the phase ramp algorithm, no v2pi and v2piN, use auto reset.
be sure to check device DAC max output 32767 equal to Vpi = 4V， and min output -32768 equal to V(-pi) = -4V 
***/
module phase_ramp_gen_v3
#(parameter OUTPUT_BIT = 16)
(
input i_clk,
input i_rst_n,
input i_trig,
input signed [OUTPUT_BIT-1:0] i_step,
input i_fb_on,
input signed [OUTPUT_BIT-1:0] i_mod,

output signed [OUTPUT_BIT-1:0] o_ladderWave,
output signed [OUTPUT_BIT-1:0] o_phaseRamp
);

reg signed [OUTPUT_BIT-1:0] ladderWave, phaseRamp;
reg signed [OUTPUT_BIT-1:0] mod;

assign o_phaseRamp = ladderWave + mod;
assign o_ladderWave = ladderWave;


always@(posedge i_clk) begin
	mod <= i_mod; //delay one clock for sync
end

always@(posedge i_clk or negedge i_rst_n ) begin
	if(~i_rst_n) ladderWave <= 32'd0;
	else if(i_fb_on) begin
		if(i_trig) ladderWave <= ladderWave + i_step;
	end
	else ladderWave <= 32'd0;
end


endmodule