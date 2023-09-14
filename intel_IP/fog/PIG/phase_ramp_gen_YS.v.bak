/***
data: 2021-03-21
v3 simplify the phase ramp algorithm, no v2pi and v2piN, use auto reset.
be sure to check device DAC max output 32767 equal to Vpi = 4V， and min output -32768 equal to V(-pi) = -4V 
data: 2021-11-30
v4 add input gain select
***/
module phase_ramp_gen_v5
#(parameter OUTPUT_BIT = 32)
(
input i_clk,
input i_rst_n,
input i_rate_trig,
input i_ramp_trig,
input i_mod_trig,
input signed [31:0] i_step,
input [31:0] i_fb_ON,
input signed [31:0] i_mod,
input [31:0] i_gain_sel,

output signed [OUTPUT_BIT-1:0] o_phaseRamp_pre,
output reg signed [OUTPUT_BIT-1:0] o_phaseRamp,
/*** for simulation***/
//output [3:0] o_shift_idx,
output [31:0] o_gain_sel,
output [31:0] o_gain_sel2,
output [1:0] o_status,
output o_change,
output signed [31:0] o_ramp_init

// output signed [31:0] o_reg_ramp,
// output signed [31:0] o_reg_ramp_pre,
// output signed [31:0] o_reg_phaseRamp_pre,
// output signed [31:0] o_r_reset_flag,
// output o_i_mod
);

localparam GAIN_INIT = 5;

reg [31:0] reg_gain_sel, reg_gain_sel2;
// reg reg_trig;
reg [31:0] reg_fb_ON;
reg [1:0] r_status;
reg signed [31:0] reg_step, r_mod; 
reg signed [31:0] reg_ramp, reg_ramp_init, reg_ramp_pre;
reg signed [31:0] reg_phaseRamp_pre;
reg r_reset_flag;

assign o_gain_sel = reg_gain_sel;
assign o_gain_sel2 = reg_gain_sel2;
assign o_status = r_status;
assign o_fb_ON = reg_fb_ON;
//assign o_phaseRamp = reg_ramp; 
assign o_phaseRamp_pre = reg_ramp_pre; 
assign o_change = |(reg_gain_sel2[3:0] ^ reg_gain_sel[3:0]);
assign o_ramp_init = reg_ramp_init;

/**/
// assign o_reg_ramp = reg_ramp;
// assign o_reg_ramp_pre = reg_ramp_pre;
// assign o_reg_phaseRamp_pre = reg_phaseRamp_pre;
// assign o_r_reset_flag = r_reset_flag;
// assign o_i_mod = i_mod;



/*
	store step, fb_ON, gain_sel to register
*/
always@(posedge i_clk) begin
	if(~i_rst_n) begin
		r_mod <= 32'd0;
		reg_step <= 32'd0;
		reg_gain_sel <= GAIN_INIT;
	end
	else begin
//		r_mod <= i_mod; 	
		reg_step <= i_step;
		reg_fb_ON <= i_fb_ON;
		// reg_trig <= i_trig;
		reg_gain_sel <= i_gain_sel;
	end
end

always @(posedge i_mod_trig or negedge i_clk)begin
	reg_phaseRamp_pre <= (reg_ramp + i_mod);
	if ((reg_phaseRamp_pre) > (32'sh7FFF)) begin
		reg_ramp <= (-32'h8000 + i_mod);
		reg_ramp_pre <= (-32'h8000 + i_mod) <<< reg_gain_sel;
		r_reset_flag = 1'b1;
	end
	else if ((reg_phaseRamp_pre) < (-32'sh8000)) begin
		reg_ramp <= (32'sh7FFF + i_mod);
		reg_ramp_pre <= (32'sh7FFF + i_mod) <<< reg_gain_sel;
		r_reset_flag = 1'b1;
	end
end

always@(posedge i_clk or negedge i_rst_n ) begin
	if(~i_rst_n) begin
		reg_ramp <= 32'd0;
		reg_ramp_pre <= 32'd0;
		o_phaseRamp <= 32'd0;
		r_reset_flag <= 1'b0;
	end
	
	/* turn off feedback */
	else 
		if(reg_fb_ON == 32'd0) begin
			// reg_ramp_init <= 32'd0;
			reg_ramp <= 32'd0;
			reg_ramp_pre <= 32'd0;
			o_phaseRamp <= i_mod;
		end
		
/*

	">>> gain_sel" is for extremly slow rotation
	if phase difference is smaller then DAC's resolution
	need to devide by a gain to wait unitl accumalate to enough phase difference

	if feedback ON
		if rate_trig
			ramp_pre + step
		if ramp_trig
			ramp = ramp_pre / gain_sel
		if mod_trig
			phaseRamp = ramp + mod

	if fb_ON = 2 (test no square wave, only stair wave)
		phaseRamp = phaseRamp + step

*/
		else if(reg_fb_ON == 32'd1) begin
			if(i_rate_trig) begin
				reg_ramp_pre <= reg_ramp_pre + i_step; //step signal accumulator
				r_reset_flag = 1'b0;
			end
			else if(i_ramp_trig) begin
				reg_ramp <= (reg_ramp_pre >>> reg_gain_sel);
			end
			/*
				if reg_ramp + i_mod >= 65535		// when HIGH wave(ramp + amp_H) is overflow 16-bit (>65535)
					o_phaseRamp <= abs(i_mod)*2		// set HIGH wave to center + i_mod
					reg_ramp_pre <= abs(i_mod)		// center at i_mod so let LOW wave(ramp + amp_L) can be exact 0
			*/
			else if(i_mod_trig) begin
				o_phaseRamp = reg_ramp + i_mod;
			end
			else begin
				reg_ramp_pre <= reg_ramp_pre;
				reg_ramp <= reg_ramp;
				o_phaseRamp <= o_phaseRamp;
			end
		end 
		else if(reg_fb_ON == 32'd2) begin
			if(i_mod_trig) o_phaseRamp <= o_phaseRamp + i_step;
			else o_phaseRamp <= o_phaseRamp;
		end
		else begin
			reg_ramp_pre <= reg_ramp_pre;
			reg_ramp <= reg_ramp;
		end
end


endmodule