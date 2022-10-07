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
//output signed [16-1:0] o_step,
output signed [31:0] o_step,
output signed [31:0] o_step_mon,
/*** for simulation***/
output [31:0] o_gain_sel
);


reg [31:0] reg_gain_sel, reg_gain_sel2;
// reg [31:0] reg_shift_idx;
reg reg_trig;
reg [31:0] reg_fb_ON;
reg [1:0] r_status;
reg signed [31:0] reg_err; 
reg signed [31:0] reg_step, reg_step_init, reg_step_pre;
// reg signed [31:0] step_max, step_min;

assign o_gain_sel = reg_gain_sel;
assign o_fb_ON = reg_fb_ON;
assign o_step = reg_step;
assign o_step_mon = reg_step_pre; 

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

// always@(posedge i_clk or negedge i_rst_n ) begin
	// if(~i_rst_n) begin
		// reg_shift_idx <= 32'd5;
	// end
	// else begin
		// case(reg_gain_sel)
			// 32'd0 : reg_shift_idx <= 32'd0;
			// 32'd1 : shift_idx <= 32'd1;
			// 32'd2 : shift_idx <= 32'd2;
			// 32'd3 : shift_idx <= 32'd3;
			// 32'd4 : shift_idx <= 32'd4;
			// 32'd5 : shift_idx <= 4'd5;
			// 32'd6 : shift_idx <= 4'd6;
			// 32'd7 : shift_idx <= 4'd7;
			// 32'd8 : shift_idx <= 4'd8;
			// 32'd9 : shift_idx <= 4'd9;
			// 32'd10: shift_idx <= 4'd10;
			// 32'd11: shift_idx <= 4'd11;
			// 32'd12: shift_idx <= 4'd12;
			// 32'd13: shift_idx <= 4'd13;
			// 32'd14: shift_idx <= 4'd14;
			// 32'd15: shift_idx <= 4'd15;
			// default: shift_idx <= shift_idx;
		// endcase
	// end
// end


always@(posedge i_clk or negedge i_rst_n ) begin
	if(~i_rst_n) begin
		step <= 32'd0;
		reg_step_init <= 32'd0;
		r_status <= 2'd0;
		reg_gain_sel2 <= 32'd5;
	end
	else if(reg_fb_ON == 32'd2) begin
		if(reg_trig) reg_step <= i_const_step;
	end 
	else if(reg_fb_ON == 32'd1) begin
		case(r_status)
			2'd0: begin
				if (reg_gain_sel != reg_gain_sel2) begin
					reg_step_init <= reg_step;
					reg_step_pre <= 32'd0;
				end
				else begin
					reg_step_init <= reg_step_init;
					reg_step_pre <= reg_step_pre;
				end
				r_status <= 2'd1;
			end
			2'd1: begin
				if(reg_trig) begin
					reg_step_pre <= reg_step_pre + reg_err;
					reg_step <= reg_step_init + (reg_step_pre >>> reg_gain_sel);
					r_status <= 2'd0;
				end
			end
		endcase
		
	end 
	else begin
		reg_step <= 32'd0;
		reg_step_pre <= 32'd0;
	end
end

endmodule