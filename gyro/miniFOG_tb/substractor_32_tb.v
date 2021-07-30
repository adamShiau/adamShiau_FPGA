`timescale 1ns / 100ps

module substractor_32_tb();

reg clk;
reg rst_n;
reg signed [31:0] A, B;
wire signed [31:0] data;

substractor_32 sub_32 (
  .A(A),        // input wire [31 : 0] A
  .B(B),        // input wire [31 : 0] B
  .CLK(clk),    // input wire CLK
  .SCLR(~rst_n),  // input wire SCLR
  .S(data)        // output wire [31 : 0] S
);
initial begin
clk = 0;
rst_n = 0;
#50;
rst_n = 1;
A = 32'd4000;
B = 32'd0;
repeat(10) begin
	A = A - 32'd200;
	// rst_n = ~rst_n;
	#400;
end
$stop;
end

always#5 clk = ~clk;

endmodule