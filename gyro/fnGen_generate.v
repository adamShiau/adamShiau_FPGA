module fnGen_generate 
(
input clk,
input rst_n,
output reg signed [14:0] out
);

//total point : 16384
localparam MPI = 16'he000;
localparam PI = 16'h2000;

`define f_6k 16'h1
`define f_12k 16'h2
`define f_24k 16'h4
`define f_48k 16'h8
`define f_96k 16'h10
`define f_192k 16'h20
`define f_384k 16'h40
`define f_768k 16'h80

reg [15:0] phase;
wire data_valid;
wire signed [14:0] dout;

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) phase <= MPI;
	else begin
		if(phase == PI) phase <= MPI;
		else phase <= phase + `f_192k;
	end
end

always@(posedge clk) begin
	if(dout > $signed(15'd8191)) out <= $signed(15'd8191);
	else if(dout < $signed(-15'd8192)) out <= $signed(-15'd8192);
	else out <= dout;
	
end

cordic fn1 (
  .aclk(clk),                                // input wire aclk
  .s_axis_phase_tvalid(1'b1),  // input wire s_axis_phase_tvalid
  .s_axis_phase_tdata(phase),    // input wire [15 : 0] s_axis_phase_tdata
  .m_axis_dout_tvalid(data_valid),    // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(dout)      // output wire [31 : 0] m_axis_dout_tdata
);

endmodule