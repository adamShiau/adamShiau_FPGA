/*** ??ain????old雿???祕撽??ain???????***/

module feedback_step_gen_v4
(
input i_clk,
input i_rst_n,
input i_trig,
input signed [31:0] i_err,
input [3:0] i_gain_sel,  //adc full range : +/- 2.5V, resolution: 5/16384 = 0.3mV/LSB,
							//??身input range +/- 1V => +/- 3333LSB, >>12 撠勗?1鈭? 
							// set i_gain_sel = 4'd15 to disable loop
input [31:0] i_step_max,
output o_fb_ON,
output signed [31:0] o_step,
output signed [31:0] o_step_mon,
/*** for simulation***/
output signed [31:0] step_temp,
output [3:0] o_shift_idx,
output signed [31:0] o_step_max,
output signed [31:0] o_step_min,
output [2:0] o_SM
);

localparam NORMAL = 3'd0;
localparam SAT_P  = 3'd1;
localparam SAT_N  = 3'd2;

reg [3:0] shift_idx;
wire fb_on;
reg signed [31:0] err; //for timing closure
reg signed [31:0] step;
reg signed [31:0] step_max, step_min;
reg [2:0] sat_index;

assign o_shift_idx = shift_idx;
assign fb_ON = (shift_idx==4'd15)? 1'b0 : 1'b1;
assign o_fb_ON = fb_ON;
assign o_step = step >>> shift_idx;
assign o_step_mon = step; 
assign o_step_max = step_max;
assign o_step_min = step_min;
assign step_temp = step;
assign o_SM = sat_index;

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
		step_max <= 32'd5000;
		step_min <= -32'd5000;
	end
	else begin
		step_max <= i_step_max;
		step_min <= $signed(-i_step_max);
	end
end

always@(posedge i_clk or negedge i_rst_n ) begin
	if(~i_rst_n) begin
		step <= 32'd0;
		sat_index = NORMAL;
	end
	else if(fb_ON) begin
		if(i_trig) begin
			case(sat_index)
				NORMAL: begin
					if((step + err) > (step_max <<< shift_idx)) begin
						step <= (step_max <<< shift_idx);
						sat_index <= SAT_P;
					end
					else if((step + err) < (step_min <<< shift_idx)) begin
						step <= (step_min <<< shift_idx);
						sat_index <= SAT_N;
					end
					else step <= step + err;
				end
				SAT_P: begin
					if(err[31]) begin
						sat_index <= NORMAL;
						step <= step + err;
					end
					else step <= (step_max <<< shift_idx);
				end
				SAT_N: begin
					if(!err[31]) begin
						sat_index <= NORMAL;
						step <= step + err;
					end
					else step <= (step_min <<< shift_idx);
				end
			endcase
		end
	end 
	else begin
		step <= 32'd0;
		sat_index <= NORMAL;
	end
end

endmodule