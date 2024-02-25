module Kalman_filter_Intel_PL_v2
#(parameter ADC_BIT = 14)
(
	input i_clk,
	input i_rst_n,
	input signed [ADC_BIT-1:0] i_meas,
	input [31:0] i_kal_Q, i_kal_R,
	output reg signed [31:0] x_out, p_out
);


`define P_INIT 100000

localparam PL_DELAY = 15;
localparam P_OUT_INIT_CNT = PL_DELAY + 4;
localparam X_PRE_DLY_NUM = PL_DELAY + 4;
localparam P_PRE_DLY_NUM = PL_DELAY + 3;
localparam MEAS_DLY_NUM = PL_DELAY + 1;

reg [31:0] r_kal_Q, r_kal_R;
reg signed [31:0] err, FB;
reg signed [31:0] p_plus_R, p_shift;

reg signed [31:0] x_pre[0:X_PRE_DLY_NUM-1];
reg signed [31:0] p_pre[0:P_PRE_DLY_NUM-1];
reg signed [31:0] r_meas[0:MEAS_DLY_NUM-1];
wire signed [31:0] k, p_temp, FB_temp;
reg signed [31:0] one_minus_k;
reg [7:0]ii, kk, jj, p_init_cnt;

// wire signed [31:0] measurement;

// assign measurement = (i_meas[ADC_BIT-1] == 1'b1)? {{32-ADC_BIT{1'b1}} , i_meas} : i_meas;
// assign k = k_gain[63:32];

always@(posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n) begin
		r_kal_Q <= 32'd5;
		r_kal_R <= 32'd10;
	end
	else begin
		r_kal_Q <= i_kal_Q;
		r_kal_R <= i_kal_R;
	end
end

always@(posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n) begin
		for (ii=0; ii<X_PRE_DLY_NUM; ii=ii+1)
			x_pre[ii] <= 32'd0;
			
		for (kk=0; kk<P_PRE_DLY_NUM; kk=kk+1)
			p_pre[kk] <= 32'd0;
			
		for (jj=0; jj<MEAS_DLY_NUM; jj=jj+1)
			r_meas[jj] <= 32'd0;
	end
	else begin
		p_pre[0] <= p_out + r_kal_Q;
		x_pre[0] <= x_out;
		// r_meas[0] <= measurement;
		r_meas[0] <= i_meas;
		
		for (ii=0; ii<X_PRE_DLY_NUM-1; ii=ii+1)
			x_pre[ii+1] <= x_pre[ii];
			
		for (kk=0; kk<P_PRE_DLY_NUM-1; kk=kk+1)
			p_pre[kk+1] <= p_pre[kk];
			
		for (jj=0; jj<MEAS_DLY_NUM-1; jj=jj+1)
			r_meas[jj+1] <= r_meas[jj];
			
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

divider_32	div_k_gain (
	.aclr ( ~i_rst_n ),
	.clock ( i_clk ),
	.denom ( p_plus_R ),
	.numer ( p_shift ),
	.quotient ( k ),
	.remain (  )
	);
always@(posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n) begin
		one_minus_k <= 32'd8192;
	end
	else begin
		one_minus_k <= 32'd8192 - k;
	end
end

multiplier_32	mult_p_temp (
	.aclr ( ~i_rst_n ),
	.clock ( i_clk ),
	.dataa ( one_minus_k ),
	.datab ( p_pre[PL_DELAY+2] ),
	.result ( p_temp )
	);
always@(posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n) begin
		p_init_cnt <= P_OUT_INIT_CNT;
		p_out <= `P_INIT;
		x_out <= 32'd0;
	end
	
	else begin
		if(p_init_cnt!=0) p_init_cnt <= p_init_cnt - 1'b1;
		else begin
			p_out <= p_temp >>> 13;
			x_out <= x_pre[PL_DELAY+3] + FB;
	end
	end
end

always@(posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n) begin
		err <= 32'd0;
		FB <= 32'd0;
	end
	else begin
		err <= r_meas[PL_DELAY] - x_pre[PL_DELAY];
		FB <= (FB_temp >>> 13);
	end
end

multiplier_32	mult_FB_temp (
	.aclr ( ~i_rst_n ),
	.clock ( i_clk ),
	.dataa ( k ),
	.datab ( err ),
	.result ( FB_temp )
	);
endmodule