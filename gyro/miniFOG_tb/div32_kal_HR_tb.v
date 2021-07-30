`timescale 1ns / 100ps

module div32_kal_HR_tb();

reg clk;
reg rst_n;
reg aclken;
reg signed [31:0] dividend, divisor;
wire signed [31:0] data;
wire divisor_tready, dividend_tready;
// wire signed [31:0] quotient, remainder;
wire data_valid;

div32_kal_HR div32_HR (
  .aclk(clk),                                      // input wire aclk
  .aclken(aclken),                                  // input wire aclken
  .aresetn(rst_n),                                // input wire aresetn
  .s_axis_divisor_tvalid(1'b1),    // input wire s_axis_divisor_tvalid
  .s_axis_divisor_tready(divisor_tready),    // output wire s_axis_divisor_tready
  .s_axis_divisor_tdata(divisor),      // input wire [31 : 0] s_axis_divisor_tdata
  .s_axis_dividend_tvalid(1'b1),  // input wire s_axis_dividend_tvalid
  .s_axis_dividend_tready(dividend_tready),  // output wire s_axis_dividend_tready
  .s_axis_dividend_tdata(dividend),    // input wire [31 : 0] s_axis_dividend_tdata
  .m_axis_dout_tvalid(data_valid),          // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(data)            // output wire [31 : 0] m_axis_dout_tdata
);


// assign remainder = data[31:0];
// assign quotient = data[63:32];

initial begin
clk = 0;
rst_n = 0;
aclken = 0;
#50;
rst_n = 1;
dividend = 32'd215;
divisor = 32'd2;
repeat(10) begin
	aclken = ~aclken;
	dividend = dividend - 32'd200;
	// @(posedge data_valid) begin
		// aclken = 0;
		// dividend = dividend - 32'd200;
		// #10;
	// end
	
	// aclken = ~aclken;
	#100;
end
$stop;
end

always#5 clk = ~clk;

endmodule