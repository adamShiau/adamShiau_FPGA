`timescale 1ns / 100ps

module kalman_filter_SM_tb();

reg clk;
reg rst_n;
reg [31:0] kal_Q, kal_R;
wire signed [31:0] p_out, x_out;
wire [14:0] fg_out;

fnGen_generate fg (
.clk(clk),
.rst_n(rst_n),
.out(fg_out)
);

Kalman_filter_SM ukal
(
.i_clk	(clk),
.i_rst_n(rst_n),
.i_meas	(fg_out),	//input [13:0]
.i_kal_Q(kal_Q),	//input [31:0]
.i_kal_R(kal_R),	//input [31:0]
.x_out	(x_out), 	//output [31:0];
.p_out	(p_out) 		//output [31:0]
);


initial begin
clk = 0;
rst_n = 0;
kal_Q = 1;
kal_R = 100;
#50;
rst_n = 1;
#50000;
$stop;
end

always#5 clk = ~clk;

endmodule