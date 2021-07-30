`timescale 1ns / 100ps

module kalman_filter_SM_tb();

reg clk;
reg rst_n;
reg signed [13:0] meas;
reg [31:0] kal_Q, kal_R;
wire signed [31:0] p_out, x_out;

Kalman_filter_SM_v2 ukal
(
.i_clk	(clk),
.i_rst_n(rst_n),
.i_meas	(meas),	//input [13:0]
.i_kal_Q(kal_Q),	//input [31:0]
.i_kal_R(kal_R),	//input [31:0]
.x_out	(x_out), 	//output [31:0];
.p_out	(p_out) 		//output [31:0]
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
repeat(10) begin
	meas = 14'd1000;
	#1420;
	meas = -14'd1000;
	#2000;
end
$stop;
end

always#5 clk = ~clk;

endmodule