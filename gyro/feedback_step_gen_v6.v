/***
data: 2021-03-21
v5 simplify code, remove step_max, just integrate err signal
data:2021-11-30
v6 add fb_ON register
***/

module feedback_step_gen_v6
(
input i_clk,
input i_rst_n,
input i_trig,
input signed [31:0] i_err,
input [3:0] i_gain_sel,
input i_fb_ON,
output o_fb_ON,
output signed [16-1:0] o_step,
output signed [31:0] o_step_mon,
/*** for simulation***/
output [3:0] o_shift_idx
);


reg [3:0] shift_idx;
reg signed [31:0] err; //for timing closure
reg signed [31:0] step;
reg signed [31:0] step_max, step_min;

assign o_shift_idx = shift_idx;
assign o_fb_ON = i_fb_ON;
assign o_step = step >>> shift_idx;
assign o_step_mon = step; 

always@(posedge i_clk or negedge i_rst_n) begin
	if(~i_rst_n) err <= 32'd0;
	else err <= i_err;
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
	if(~i_rst_n) begin
		step <= 32'd0;
	end
	else if(i_fb_ON) begin
		if(i_trig) step <= step + err;
	end 
	else begin
		step <= 32'd0;
	end
end

endmodule