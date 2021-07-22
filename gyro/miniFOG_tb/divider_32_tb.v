`timescale 1ns / 100ps

module divider_32_tb();

reg clk;
reg rst_n;
reg signed [31:0] dividend, divisor;
wire signed [63:0] data;
wire signed [31:0] quotient, remainder;
wire data_valid;

divider_32 div32 (
  .aclk(clk),                                      // input wire aclk
  .aresetn(rst_n),                                // input wire aresetn
  .s_axis_divisor_tvalid(1'b1),    // input wire s_axis_divisor_tvalid
  .s_axis_divisor_tdata(divisor),      // input wire [31 : 0] s_axis_divisor_tdata
  .s_axis_dividend_tvalid(1'b1),  // input wire s_axis_dividend_tvalid
  .s_axis_dividend_tdata(dividend),    // input wire [31 : 0] s_axis_dividend_tdata
  .m_axis_dout_tvalid(data_valid),          // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(data)            // output wire [63 : 0] m_axis_dout_tdata
);

assign remainder = data[31:0];
assign quotient = data[63:32];

initial begin
clk = 0;
rst_n = 0;
#50;
rst_n = 1;
dividend = 32'd215;
divisor = 32'd2;
repeat(10) begin
	dividend = dividend - 32'd200;
	
	#400;
end
$stop;
end

always#5 clk = ~clk;

endmodule