`timescale 1ns / 100ps

module moving_average_tb();

reg clk;
reg rst_n;
wire signed [13:0] dout;
wire [14:0] fg_out;

fnGen_generate fg (
.clk(clk),
.rst_n(rst_n),
.out(fg_out)
);

Moving_Average 
#(
.AVE_DATA_NUM(128),
.AVE_DATA_BIT(7)
)
MV
(
.i_clk(clk),
.i_rst_n(rst_n),
.din(fg_out), //[13:0] 
.dout(dout) //[13:0] 
);

initial begin
clk = 0;
rst_n = 0;
#50;
rst_n = 1;
#50000;
$stop;
end

always#5 clk = ~clk;

endmodule