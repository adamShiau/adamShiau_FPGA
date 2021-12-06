`timescale 1ns / 100ps

module kalman_filter_Intel_PL_tb();

reg clk;
reg rst_n;
reg [31:0] kal_Q, kal_R;
reg [13:0] i_meas;
wire signed [31:0] p_out, x_out;


Kalman_filter_Intel_PL_v2 ukal
(
.i_clk	(clk),
.i_rst_n(rst_n),
.i_meas	(i_meas),	//input [13:0]
.i_kal_Q(kal_Q),	//input [31:0]
.i_kal_R(kal_R),	//input [31:0]
.x_out	(x_out), 	//output [31:0];
.p_out	(p_out) 		//output [31:0]
);

reg [10:0] cnt = 0;
reg [31:0] i = 0;

initial begin
clk = 0;
rst_n = 0;
i_meas = 14'd0;
kal_Q = 1;
kal_R = 100;
#50;
rst_n = 1;
// #1000;
// i_meas = -14'd1000;
// #1000;
// i_meas = 14'd1000;
// #1000;
// i_meas = -14'd1000;
// #1000;
// i_meas = 14'd1000;
// #1000;

for (i=0; i<100000; i=i+1) begin
	i_meas = i_meas + 10;
	#10;
end

$stop;
end

// always meas = out;

always#5 clk = ~clk;

endmodule