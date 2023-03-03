/***
data: 2021-10-05

***/

module feedback_step_gen
(
input i_clk,
input i_rst_n,
input i_trig,
input signed [31:0] i_err,
input [31:0] i_gain_sel,
input [31:0] i_fb_ON,
input signed [31:0] i_const_step,
output [31:0] o_fb_ON,
output signed [31:0] o_step,
//output signed [31:0] o_step_mon,
/*** for simulation***/
output signed [31:0] o_step_pre,
output [31:0] o_gain_sel,
output [31:0] o_gain_sel2,
output [1:0] o_status,
output o_change,
output signed [31:0] o_step_init 
); 


reg [31:0] reg_gain_sel, reg_gain_sel2;
reg reg_trig;
reg [31:0] reg_fb_ON;
reg [1:0] r_status;
reg signed [31:0] reg_err; 
reg signed [31:0] reg_step, reg_step_init, reg_step_pre;


assign o_gain_sel = reg_gain_sel;
assign o_gain_sel2 = reg_gain_sel2;
assign o_status = r_status;
assign o_fb_ON = reg_fb_ON;
assign o_step = reg_step; 
assign o_step_pre = reg_step_pre; 
assign o_change = |(reg_gain_sel2[3:0] ^ reg_gain_sel[3:0]);
assign o_step_init = reg_step_init;

always@(posedge i_clk or negedge i_rst_n) begin
	if(~i_rst_n) begin 
		reg_err <= 32'd0;
		reg_gain_sel <= 32'd5;
	end
	else begin 
		reg_err <= i_err;
		reg_fb_ON <= i_fb_ON;
		reg_trig <= i_trig;
		reg_gain_sel <= i_gain_sel;
	end
end 



always@(posedge i_clk or negedge i_rst_n ) begin
	if(~i_rst_n) begin
		reg_step <= 32'd0;
		reg_step_pre <= 32'd0;
		reg_step_init <= 32'd0;
		r_status <= 2'd0;
		reg_gain_sel2 <= 32'd5;
	end
	
	else if(reg_fb_ON == 32'd1) begin

		if(reg_trig) begin
			reg_step_pre <= reg_step_pre + reg_err; //error signal accumulator
			reg_step <= reg_step_init + (reg_step_pre >>> reg_gain_sel);
			r_status <= 2'd0;
		end
		reg_gain_sel2 <= reg_gain_sel;
		if(o_change) begin
			reg_step_init <= reg_step;
			reg_step_pre <= 0;
		end
	end 
	else if(reg_fb_ON == 32'd2) begin
		if(reg_trig) reg_step <= i_const_step;
		reg_step_init <= 32'd0;
		reg_step_pre <= 32'd0;
	end 
	else if(reg_fb_ON == 32'd0) begin
		reg_step_init <= 32'd0;
		reg_step <= 32'd0;
		reg_step_pre <= 32'd0;
	end
	else begin
	
	end
end

endmodule