`timescale 1ns / 100ps

module moving_average_v1_tb();

reg clk;
reg rst_n;
reg signed [13:0] din;
wire signed [13:0] dout;

Moving_Average 
#(
.AVE_DATA_NUM(5'd8),
.AVE_DATA_BIT(5'd3)
)
u1
(
.i_clk(clk),
.i_rst_n(rst_n),
.din(din), //[13:0] 
.dout(dout) //[13:0] 
);

initial begin
clk = 0;
rst_n = 0;
#50;
rst_n = 1;
din = 14'd5000;
repeat(6) begin
	din = din - 14'd2000;
	#100;
end
$stop;
end

always#5 clk = ~clk;

endmodule