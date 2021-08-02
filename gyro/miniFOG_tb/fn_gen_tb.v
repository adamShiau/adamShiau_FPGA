`timescale 1ns / 100ps

module fnGen_tb();

reg clk;
reg rst_n;
wire [14:0] out;


fnGen_generate fg (
.clk(clk),
.rst_n(rst_n),
.out(out)
);


initial begin
clk = 0;
rst_n = 0;
#50;
rst_n = 1;
#170000;
$stop;
end

always#5 clk = ~clk;

endmodule