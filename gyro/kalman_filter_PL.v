module Kalman_filter_PL
#(parameter BIT = 14)
(
	input i_clk,
	input i_rst_n,
	input signed [BIT-1:0] i_meas,
	input [31:0] i_kal_Q, i_kal_R,
	output reg signed [31:0] x_out, p_out
);

localparam X_PRE_DLY_NUM = 19;
localparam P_PRE_DLY_NUM = 18;
`define P_INIT 100000
`define P_OUT_INIT_CNT 19

reg [31:0] r_kal_Q, r_kal_R;
reg signed [31:0] r_meas, err, FB;
reg signed [31:0] p_plus_R, p_shift;

reg signed [31:0] x_pre[0:X_PRE_DLY_NUM-1];
reg signed [31:0] p_pre[0:P_PRE_DLY_NUM-1];
wire [63:0] k_gain;
wire signed [31:0] k, p_temp, FB_temp;
reg signed [31:0] one_minus_k;
reg [7:0]ii, kk, p_init_cnt;

wire signed [31:0] measurement;

assign measurement = (i_meas[BIT-1] == 1'b1)? {{32-BIT{1'b1}} , i_meas} : i_meas;
assign k = k_gain[63:32];

always@(posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n) begin
		r_kal_Q <= 32'd5;
		r_kal_R <= 32'd10;
		r_meas <= 32'd0;
	end
	else begin
		r_kal_Q <= i_kal_Q;
		r_kal_R <= i_kal_R;
		r_meas 	<= measurement;
	end
end

always@(posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n) begin
		for (ii=0; ii<X_PRE_DLY_NUM; ii=ii+1)
			x_pre[ii] <= 32'd0;
			
		for (kk=0; kk<P_PRE_DLY_NUM; kk=kk+1)
			p_pre[kk] <= 32'd0;
	end
	else begin
		p_pre[0] <= p_out + r_kal_Q;
		x_pre[0] <= x_out;
		
		for (ii=0; ii<X_PRE_DLY_NUM-1; ii=ii+1)
			x_pre[ii+1] <= x_pre[ii];
			
		for (kk=0; kk<P_PRE_DLY_NUM-1; kk=kk+1)
			p_pre[kk+1] <= p_pre[kk];
			
	end
end

always@(posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n) begin
		// p_plus_R <= p_pre + r_kal_R;
		// p_shift <= p_pre[0]<<<13;
	end
	else begin
		p_plus_R <= p_pre[0] + r_kal_R;
		p_shift <= p_pre[0]<<<13;
	end
end

divider_32 div_k_gain (
  .aclk(i_clk),                                   			// input wire aclk
  .aresetn(i_rst_n),                              			// input wire aresetn
  .s_axis_divisor_tvalid(1'b1),    							// input wire s_axis_divisor_tvalid
  .s_axis_divisor_tdata(p_plus_R),   	// input wire [31 : 0] s_axis_divisor_tdata, denominator
  .s_axis_dividend_tvalid(1'b1),  							// input wire s_axis_dividend_tvalid
  .s_axis_dividend_tdata(p_shift),	    // input wire [31 : 0] s_axis_dividend_tdata, numerator
  .m_axis_dout_tvalid(),         							// output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(k_gain)            					// output wire [63 : 0] m_axis_dout_tdata
);

always@(posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n) begin
		one_minus_k <= 32'd8192;
	end
	else begin
		one_minus_k <= 32'd8192 - k;
	end
end

multiplier_32 mult_p_temp (
  .CLK(i_clk),    // input wire CLK
  .A(one_minus_k),        // input wire [31 : 0] A
  .B(p_pre[17]),        // input wire [31 : 0] B
  .SCLR(~i_rst_n),  // input wire SCLR
  .P(p_temp)        // output wire [63 : 0] P
);

always@(posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n) begin
		p_init_cnt <= `P_OUT_INIT_CNT;
		p_out <= `P_INIT;
		x_out <= 32'd0;
	end
	
	else begin
		if(p_init_cnt!=0) p_init_cnt <= p_init_cnt - 1'b1;
		else begin
			p_out <= p_temp >> 13;
			x_out <= x_pre[18] + FB;
	end
	end
end

always@(posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n) begin
		err <= 32'd0;
		FB <= 32'd0;
	end
	else begin
		err <= r_meas - x_pre[15];
		FB <= (FB_temp >>> 13);
	end
end

multiplier_32 mult_FB_temp (
  .CLK(i_clk),    // input wire CLK
  .A(k),        // input wire [31 : 0] A
  .B(err),        // input wire [31 : 0] B
  .SCLR(~i_rst_n),  // input wire SCLR
  .P(FB_temp)        // output wire [63 : 0] P
);

endmodule