/***
data: 2021-03-21
v3 simplify the phase ramp algorithm, no v2pi and v2piN, use auto reset.
be sure to check device DAC max output 32767 equal to Vpi = 4V， and min output -32768 equal to V(-pi) = -4V 
data: 2021-11-30
v4 add input gain select
***/
module phase_ramp_gen_v4
#(parameter OUTPUT_BIT = 16)
(
input i_clk,
input i_rst_n,
input i_trig,
input signed [OUTPUT_BIT-1:0] i_step,
input i_fb_on,
input signed [OUTPUT_BIT-1:0] i_mod,
input [3:0] i_gain_sel,

output signed [OUTPUT_BIT-1:0] o_ladderWave,
output signed [OUTPUT_BIT-1:0] o_phaseRamp
/*** for simulation***/
, output [3:0] o_shift_idx
);

reg signed [OUTPUT_BIT-1:0] ladderWave, phaseRamp;
reg signed [OUTPUT_BIT-1:0] mod;
reg [3:0] shift_idx;

assign o_phaseRamp = (ladderWave >>> shift_idx) + mod;
assign o_ladderWave = ladderWave >>> shift_idx;
assign o_shift_idx = shift_idx;

always@(posedge i_clk) begin
	mod <= i_mod; //delay one clock for sync
end

always@(posedge i_clk or negedge i_rst_n ) begin
	if(~i_rst_n) begin
		shift_idx <= 4'd5;
	end
	else begin
		case(i_gain_sel)
			4'd0 : shift_idx <= 4'd0;
			4'd1 : shift_idx <= 4'd1;
			4'd2 : shift_idx <= 4'd2;
			4'd3 : shift_idx <= 4'd3;
			4'd4 : shift_idx <= 4'd4;
			4'd5 : shift_idx <= 4'd5;
			4'd6 : shift_idx <= 4'd6;
			4'd7 : shift_idx <= 4'd7;
			4'd8 : shift_idx <= 4'd8;
			4'd9 : shift_idx <= 4'd9;
			4'd10: shift_idx <= 4'd10;
			4'd11: shift_idx <= 4'd11;
			4'd12: shift_idx <= 4'd12;
			4'd13: shift_idx <= 4'd13;
			4'd14: shift_idx <= 4'd14;
			4'd15: shift_idx <= 4'd15;
			default: shift_idx <= shift_idx;
		endcase
	end
end

always@(posedge i_clk or negedge i_rst_n ) begin
	if(~i_rst_n) ladderWave <= 32'd0;
	else if(i_fb_on) begin
		if(i_trig) ladderWave <= ladderWave + i_step;
	end
	else ladderWave <= 32'd0;
end


endmodule