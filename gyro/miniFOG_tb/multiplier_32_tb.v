`timescale 1ns / 100ps

module multiplier_32_tb();

reg clk;
reg rst_n;
reg signed [31:0] A, B;
wire signed [63:0] data;

multiplier_32 mul_32 (
  .CLK(clk),    // input wire CLK
  .A(A),        // input wire [31 : 0] A
  .B(B),        // input wire [31 : 0] B
  .SCLR(~rst_n),  // input wire SCLR
  .P(data)        // output wire [63 : 0] P
);

initial begin
clk = 0;
rst_n = 0;
#50;
rst_n = 1;
A = 32'd1000;
B = 32'd1000;
repeat(10) begin
	A = A - 32'd200;
	rst_n = ~rst_n;
	#400;
end
$stop;
end

always#5 clk = ~clk;

endmodule