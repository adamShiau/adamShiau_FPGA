`timescale 1ns / 100ps

module dual_da_tb();

reg clk;
reg rst_n;
reg signed [9:0] meas;
wire [31:0] x_out;
// reg [31:0] kal_Q, kal_R;
// wire signed [31:0] p_out, x_out;

// Kalman_filter_SM ukal
// (
// .i_clk	(clk),
// .i_rst_n(rst_n),
// .i_meas	(meas),	//input [13:0]
// .i_kal_Q(kal_Q),	//input [31:0]
// .i_kal_R(kal_R),	//input [31:0]
// .x_out	(x_out), 	//output [31:0];
// .p_out	(p_out) 		//output [31:0]
// );

hs_dual_da u0
(
.sys_clk(clk)     ,  //系统时钟
.sys_rst_n(rst_n)   ,  //系统复位，低电平有效
    
.da_clk()      ,  //DA采样时钟
.da_data()     ,  //DA采样数据
.da_clk1()     ,  //DA采样时钟
.da_data1()    ,  //DA采样数据

	
.ad0_data()     ,   //AD0数据
.ad0_otr()      ,   //输入电压超过量程标志
.ad0_clk()      ,   //AD0采样时钟
.ad0_oe()       ,   //AD0输出使能
     
.ad1_data(meas)     ,   //AD1数据
.ad1_otr()      ,   //输入电压超过量程标志
.ad1_clk()      ,   //AD1采样时钟  
.ad1_oe()           //AD1输出使能	
, .x_out(x_out)
);

reg [10:0] cnt = 0;

initial begin
clk = 0;
rst_n = 0;
meas = 200;
// kal_Q = 5;
// kal_R = 10;
#50;
rst_n = 1;
repeat(50) begin
	cnt = cnt + 10'd1;
	if((cnt%10) < 5) 
		meas = 10'd200;
	else 
		meas = -10'd0;
	#1000;
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

always#10 clk = ~clk;

endmodule