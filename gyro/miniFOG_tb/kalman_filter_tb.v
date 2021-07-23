`timescale 1ns / 100ps

module kalman_filter_tb();

reg clk;
reg rst_n;
reg signed [13:0] meas;
reg [31:0] kal_Q, kal_R;
wire signed [31:0] p_est, x_est;

Kalman_filter ukal
(
.i_clk	(clk),
.i_rst_n(rst_n),
.i_meas	(meas),	//input [13:0]
.i_kal_Q(kal_Q),	//input [31:0]
.i_kal_R(kal_R),	//input [31:0]
.x_est	(x_est), 	//output [31:0];
.p_est	(p_est) 		//output [31:0]
);

reg [10:0] cnt = 0;

initial begin
clk = 0;
rst_n = 0;
meas = 200;
kal_Q = 5;
kal_R = 10;
#50;
rst_n = 1;
repeat(50) begin
	cnt = cnt + 10'd1;
	if((cnt%10) < 5) 
		meas = 14'd200;
	else 
		meas = -14'd200;
	#400;
	// @(posedge clk) begin
		// cnt = cnt + 10'd1;
		// if((cnt%10) < 5) 
			// meas = 14'd200;
		// else 
			// meas = 14'd100;
	// end
end
$stop;
end

always#5 clk = ~clk;

endmodule