module clock_divider(
  input clk,
  input i_rst_n,
  output reg [15:0] divided_clk
);

reg [16:0] count;

always @(posedge clk or negedge i_rst_n) begin
	if(~i_rst_n) begin
		divided_clk <= 16'd4000;
	end
	else if (count == 197) begin
		divided_clk <= ~divided_clk;
		count <= 0;
	end else begin
		count <= count + 1;
	end
end

endmodule