module Kalman_filter
(
	input i_clk,
	input i_rst_n,
	input signed [13:0] i_meas,
	input [31:0] i_kal_Q, i_kal_R,
	output reg signed [31:0] x_est, p_est
);

reg signed [31:0] r_meas, r1_x_est, r2_x_est, r3_x_est, r4_x_est;
reg [31:0] r_kal_Q, r_kal_R;
reg signed [31:0] r_meas_minus_xest, r1_p_est_plusQ, r2_p_est_plusQ;
wire signed [31:0] one_minus_k, meas_minus_xest;
wire signed [63:0] p_est_cur_scale;
wire signed [63:0] p_est_cur;
wire signed [31:0] x_est_cur;
wire signed [31:0] measurement, p_est_plusQ, p_est_plusQ_plusR;
wire signed [63:0] k_gain, meas_minus_xest_scale, feedback;
wire signed [31:0] k_mon, p_est_cur_mon, feedback_mon;

assign measurement = (i_meas[13] == 1'b1)? {{18{1'b1}} , i_meas} : i_meas;
assign k_mon = k_gain[63:32];
assign p_est_cur_mon = p_est_cur[63:32];
assign feedback_mon = feedback[63:32];

/*** update registers  ***/
always@(posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n) begin
		r_kal_Q <= 32'd0;
		r_kal_R <= 32'd0;
		r_meas <= 32'd0;
	end
	else begin
		r_kal_Q <= i_kal_Q;
		r_kal_R <= i_kal_R;
		r_meas 	<= measurement;
	end
end


/*** step0 initialization  ***/
always@(posedge i_clk or negedge i_rst_n) begin
	// initial guass
	if (!i_rst_n) begin
		p_est <= 32'd10000;
		x_est <= 32'd0;
	end
	else begin
		if(p_est_cur_mon > 32'd0) begin
			p_est <= p_est_cur[63:32];
			x_est <= x_est_cur;
		end
	end
end

always@(posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n) begin
		r1_x_est <= 32'd0;
		r2_x_est <= 32'd0;
		r3_x_est <= 32'd0;
		r4_x_est <= 32'd0;
	end
	else begin
		r1_x_est <= x_est;
		r2_x_est <= r1_x_est;
		r3_x_est <= r2_x_est;
		r4_x_est <= r3_x_est;
	end
end

/*** step2 update   ***/

// calculate Kalman gain
//p_est+Q
adder_32 adder_p_est_plusQ (
	.A(p_est),					// input wire [31 : 0] A
	.B(r_kal_Q),    				// input wire [31 : 0] B
	.CLK(i_clk),    				// input wire CLK
	.SCLR(~i_rst_n), 				// input wire SCLR
	.S(p_est_plusQ)     	// output wire [31 : 0] S
);

always@(posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n) begin
		r1_p_est_plusQ <= 32'd0;
		r2_p_est_plusQ <= 32'd0;
	end
	else begin
		r1_p_est_plusQ <= p_est_plusQ;
		r2_p_est_plusQ <= r1_p_est_plusQ;
	end
end

//p_est+Q+R
adder_32 adder_p_est_plusQ_plusR (
	.A(p_est+r_kal_Q),					// input wire [31 : 0] A
	.B(r_kal_R),    				// input wire [31 : 0] B
	.CLK(i_clk),    				// input wire CLK
	.SCLR(~i_rst_n), 				// input wire SCLR
	.S(p_est_plusQ_plusR)     	// output wire [31 : 0] S
);

// kalman_gain = p_est+Q/(p_est+Q+R)
divider_32 kalman_gain (
  .aclk(i_clk),                                   			// input wire aclk
  .aresetn(i_rst_n),                              			// input wire aresetn
  .s_axis_divisor_tvalid(1'b1),    							// input wire s_axis_divisor_tvalid
  .s_axis_divisor_tdata(p_est_plusQ_plusR),   	// input wire [31 : 0] s_axis_divisor_tdata, denominator
  .s_axis_dividend_tvalid(1'b1),  							// input wire s_axis_dividend_tvalid
  .s_axis_dividend_tdata(p_est_plusQ << 13),	    // input wire [31 : 0] s_axis_dividend_tdata, numerator
  .m_axis_dout_tvalid(),         							// output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(k_gain)            					// output wire [63 : 0] m_axis_dout_tdata
);

//calculate 1-kalman_gain
substractor_32 _1_minus_k (
  .A(1<<13),        	// input wire [31 : 0] A
  .B(k_gain[63:32]),  	// input wire [31 : 0] B
  .CLK(i_clk),    		// input wire CLK
  .SCLR(~i_rst_n),  	// input wire SCLR
  .S(one_minus_k)     	// output wire [31 : 0] S
);

//calculate current estimate uncertainty p_est_cur_scale
//(1-k)*(p_est+Q)
multiplier_32 mul_p_est_cur_scale (
  .CLK(i_clk),    // input wire CLK
  .A(one_minus_k),        // input wire [31 : 0] A
  .B(r2_p_est_plusQ),        // input wire [31 : 0] B
  .SCLR(~i_rst_n),  // input wire SCLR
  .P(p_est_cur_scale)        // output wire [63 : 0] P
);

//re-scale p_est_cur_scale
divider_32 div_p_est_cur (
  .aclk(i_clk),                              	// input wire aclk
  .aresetn(i_rst_n),                           	// input wire aresetn
  .s_axis_divisor_tvalid(1'b1),    				// input wire s_axis_divisor_tvalid
  .s_axis_divisor_tdata(1 << 13),   			// input wire [31 : 0] s_axis_divisor_tdata, denominator
  .s_axis_dividend_tvalid(1'b1),  				// input wire s_axis_dividend_tvalid
  .s_axis_dividend_tdata(p_est_cur_scale[31:0]),	    // input wire [31 : 0] s_axis_dividend_tdata, numerator
  .m_axis_dout_tvalid(),         				// output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(p_est_cur)            		// output wire [63 : 0] m_axis_dout_tdata
);

// measurement - x_est
substractor_32 err (
  .A(r_meas),        	// input wire [31 : 0] A
  .B(x_est),  	// input wire [31 : 0] B
  .CLK(i_clk),    		// input wire CLK
  .SCLR(~i_rst_n),  	// input wire SCLR
  .S(meas_minus_xest)     	// output wire [31 : 0] S
);

// delay meas_minus_xest one clk 
always@(posedge i_clk or negedge i_rst_n) begin
	if(!i_rst_n) r_meas_minus_xest <= 32'd0;
	else r_meas_minus_xest <= meas_minus_xest;
end


//k*(measurement - x_est)
multiplier_32 k_mul_err (
  .CLK(i_clk),    // input wire CLK
  .A(k_gain[63:32]),        // input wire [31 : 0] A
  .B(r_meas_minus_xest),        // input wire [31 : 0] B
  .SCLR(~i_rst_n),  // input wire SCLR
  .P(meas_minus_xest_scale)        // output wire [63 : 0] P
);

//re-scalr k*(measurement - x_est)
divider_32 cal_feedback (
  .aclk(i_clk),                              	// input wire aclk
  .aresetn(i_rst_n),                           	// input wire aresetn
  .s_axis_divisor_tvalid(1'b1),    				// input wire s_axis_divisor_tvalid
  .s_axis_divisor_tdata(1 << 13),   			// input wire [31 : 0] s_axis_divisor_tdata, denominator
  .s_axis_dividend_tvalid(1'b1),  				// input wire s_axis_dividend_tvalid
  .s_axis_dividend_tdata(meas_minus_xest_scale[31:0]),	    // input wire [31 : 0] s_axis_dividend_tdata, numerator
  .m_axis_dout_tvalid(),         				// output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(feedback)            		// output wire [63 : 0] m_axis_dout_tdata
);

//calculate x_est_cur = x_est + k*(z-x_est)
adder_32 adder_x_est_cur (
	.A(r4_x_est),					// input wire [31 : 0] A
	.B(feedback[63:32]),    				// input wire [31 : 0] B
	.CLK(i_clk),    				// input wire CLK
	.SCLR(~i_rst_n), 				// input wire SCLR
	.S(x_est_cur)     	// output wire [31 : 0] S
);


/*** step3 prediction   ***/


endmodule