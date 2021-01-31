
module phase_ramp_gen
#(parameter OUTPUT_BIT = 16)
(
input i_clk,
input i_rst_n,
input i_trig,
input signed [31:0] i_step,
input [31:0] i_v2pi,
input i_fb_on,
input signed [OUTPUT_BIT-1:0] i_mod,

output signed [OUTPUT_BIT-1:0] o_ladderWave,
output signed [OUTPUT_BIT-1:0] o_phaseRamp
// ,output [OUTPUT_BIT-1:0] o_mod
);

reg signed [31:0] ladderWave, phaseRamp;
reg signed [31:0] v2pi_p, v2pi_n;
// reg signed [31:0] mod;
wire signed [31:0] mod_32;

assign o_phaseRamp = phaseRamp[OUTPUT_BIT-1:0];
assign o_ladderWave = ladderWave[OUTPUT_BIT-1:0];
// assign o_mod = mod[OUTPUT_BIT-1:0];

/*** convert 16 bit i_mod to 32 bit format***/
assign mod_32 = (i_mod[OUTPUT_BIT-1] == 1'b1)? {{32-OUTPUT_BIT{1'b1}} , i_mod} : i_mod;

// always@(posedge i_clk) begin
	// mod <= mod_32; //delay one clock for sync
// end

always@(posedge i_clk or negedge i_rst_n ) begin
	if(~i_rst_n) ladderWave <= 32'd0;
	else if(i_fb_on) begin
		if(i_step > 0) begin
			if(i_trig) begin
				if((ladderWave + i_step) >= v2pi_p) ladderWave <= ladderWave + i_step - i_v2pi - i_v2pi;
				else ladderWave <= ladderWave + i_step;
			end
			else ladderWave <= ladderWave;
		end
		else if(i_step < 0) begin
			if(i_trig) begin
				if((ladderWave + i_step) <= v2pi_n) ladderWave <= ladderWave + i_step + i_v2pi + i_v2pi;
				else ladderWave <= ladderWave + i_step;
			end
			else ladderWave <= ladderWave;
		end
		else ladderWave <= ladderWave;
	end
	else ladderWave <= 32'd0;
end

always@(posedge i_clk or negedge i_rst_n ) begin
	if(~i_rst_n) phaseRamp <= 32'd0;
	else if(i_fb_on) begin
		if(i_step > 0) begin
			if(i_trig) begin
				if((ladderWave + mod_32) > v2pi_p) phaseRamp <= ladderWave + mod_32 - i_v2pi - i_v2pi;
				else phaseRamp <= ladderWave + mod_32;
			end
			else phaseRamp <= phaseRamp;
		end
		else if(i_step < 0) begin
			if(i_trig) begin
				if((ladderWave + mod_32) < v2pi_n) phaseRamp <= ladderWave + mod_32 + i_v2pi + i_v2pi;
				else phaseRamp <= ladderWave + mod_32;
			end
			else phaseRamp <= phaseRamp;
		end
		else phaseRamp <= phaseRamp;
	end
	else phaseRamp <= mod_32;
end

always@(posedge i_clk or negedge i_rst_n ) begin
	if(~i_rst_n) begin
		v2pi_p <= 32'd5000;
		v2pi_n <= -32'd5000;
	end
	else begin
		v2pi_p <= i_v2pi;
		v2pi_n <= $signed(-i_v2pi);
	end
end

endmodule