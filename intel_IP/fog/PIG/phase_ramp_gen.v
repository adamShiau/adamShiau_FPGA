/***
data: 2021-03-21
v3 simplify the phase ramp algorithm, no v2pi and v2piN, use auto reset.
be sure to check device DAC max output 32767 equal to Vpi = 4V， and min output -32768 equal to V(-pi) = -4V 
data: 2021-11-30
v4 add input gain select
***/
module phase_ramp_gen
#(parameter OUTPUT_BIT = 32)
(
input i_clk,
input i_rst_n,
input i_trig,
input signed [31:0] i_step,
input [31:0] i_fb_ON,
input signed [31:0] i_mod,
input [31:0] i_gain_sel,

output signed [OUTPUT_BIT-1:0] o_phaseRamp_pre,
output signed [OUTPUT_BIT-1:0] o_phaseRamp,
/*** for simulation***/
//output [3:0] o_shift_idx,
output [31:0] o_gain_sel,
output [31:0] o_gain_sel2,
output [1:0] o_status,
output o_change,
output signed [31:0] o_ramp_init 
);

localparam GAIN_INIT = 5;

reg [31:0] reg_gain_sel, reg_gain_sel2;
reg reg_trig;
reg [31:0] reg_fb_ON;
reg [1:0] r_status;
reg signed [31:0] reg_step, r_mod; 
reg signed [31:0] reg_ramp, reg_ramp_init, reg_ramp_pre;


assign o_gain_sel = reg_gain_sel;
assign o_gain_sel2 = reg_gain_sel2;
assign o_status = r_status;
assign o_fb_ON = reg_fb_ON;
assign o_phaseRamp = reg_ramp; 
assign o_phaseRamp_pre = reg_ramp_pre; 
assign o_change = |(reg_gain_sel2[3:0] ^ reg_gain_sel[3:0]);
assign o_ramp_init = reg_ramp_init;


always@(posedge i_clk) begin
	if(~i_rst_n) begin
		r_mod <= 32'd0;
		reg_step <= 32'd0;
		reg_gain_sel <= GAIN_INIT;
	end
	else begin
		r_mod <= i_mod; 	
		reg_step <= i_step;
		reg_fb_ON <= i_fb_ON;
		reg_trig <= i_trig;
		reg_gain_sel <= i_gain_sel;
	end
end


always@(posedge i_clk or negedge i_rst_n ) begin
	if(~i_rst_n) begin
		reg_ramp <= 32'd0;
		reg_ramp_pre <= 32'd0;
		reg_ramp_init <= 32'd0;
		r_status <= 2'd0;
		reg_gain_sel2 <= GAIN_INIT;
	end
	
	else if(reg_fb_ON == 0) begin
		reg_ramp_init <= 32'd0;
		reg_ramp <= 32'd0;
		reg_ramp_pre <= 32'd0;
	end
	
	else begin
		if(reg_trig) begin
			reg_ramp_pre <= reg_ramp_pre + reg_step; //step signal accumulator
			reg_ramp <= reg_ramp_init + (reg_ramp_pre >>> reg_gain_sel);
			r_status <= 2'd0;
		end
		reg_gain_sel2 <= reg_gain_sel;
		if(o_change) begin
			reg_ramp_init <= reg_ramp;
			reg_ramp_pre <= 0;
		end
	end 


end


endmodule