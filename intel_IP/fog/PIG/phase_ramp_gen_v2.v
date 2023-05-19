/***
data: 2023-03-16 under test
***/
module phase_ramp_gen_v2
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
);

`define Vp  32'd30000
`define Vn  -32'd30000
`define V2pi  32'd50000

localparam GAIN_INIT = 5;

reg [31:0] reg_gain_sel, reg_gain_sel2;
// reg reg_reach_Vp, reg_reach_Vn;
reg [31:0] reg_fb_ON;
reg [1:0] r_status;
reg signed [31:0] reg_step, r_mod; 
reg signed [31:0] reg_ramp, reg_ramp_init, reg_ramp_pre;


assign o_gain_sel = reg_gain_sel;
assign o_gain_sel2 = reg_gain_sel2;
assign o_status = r_status;
assign o_fb_ON = reg_fb_ON;
//assign o_phaseRamp = reg_ramp; 
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
//		r_mod <= i_mod; 	
		reg_step <= i_step;
		reg_fb_ON <= i_fb_ON;
		// reg_trig <= i_trig;
		reg_gain_sel <= i_gain_sel;
	end
end


always@(posedge i_clk or negedge i_rst_n ) begin
	if(~i_rst_n) begin
		reg_ramp <= 32'd0;
		reg_ramp_pre <= 32'd0;
		o_phaseRamp <= 32'd0;
		// reg_reach_Vp <= 1'b0;
		// reg_reach_Vn <= 1'b0;
		// reg_gain_sel2 <= GAIN_INIT;
	end
	
	else 
		if(reg_fb_ON == 32'd0) begin
			// reg_ramp_init <= 32'd0;
			reg_ramp <= 32'd0;
			reg_ramp_pre <= 32'd0;
			o_phaseRamp <= i_mod;
		end
		
		else if(reg_fb_ON == 32'd1) begin
			if(i_rate_trig) begin
				reg_ramp_pre <= reg_ramp_pre + i_step; //step signal accumulator
			end
			else if(i_ramp_trig) begin
				reg_ramp <= (reg_ramp_pre >>>reg_gain_sel);
			end
			else if(i_mod_trig) begin
				o_phaseRamp <= reg_ramp + i_mod;
//				o_phaseRamp <= i_mod;
				if(i_step >= 0) begin
					// if(o_phaseRamp > 32'd25000) reg_ramp_pre <= (reg_ramp_pre - (32'd50000<<<reg_gain_sel));
					// else reg_ramp_pre <= reg_ramp_pre;
					if(o_phaseRamp > $signed(`Vp)) reg_ramp_pre <= (reg_ramp_pre - (`V2pi<<<reg_gain_sel));
					else reg_ramp_pre <= reg_ramp_pre;

				end
				else if(i_step < 0) begin
					if(o_phaseRamp < $signed(`Vn)) reg_ramp_pre <= (reg_ramp_pre + (`V2pi<<<reg_gain_sel));
					else reg_ramp_pre <= reg_ramp_pre;

				end
				else begin
					reg_ramp_pre <= reg_ramp_pre;
				end
				
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