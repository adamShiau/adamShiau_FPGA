module Moving_Average
#(
	parameter AVE_DATA_NUM = 8,
	parameter AVE_DATA_BIT = 3
	// parameter AVE_DATA_BIT = $clog2(AVE_DATA_NUM) 
)
(
	input i_clk,
	input i_rst_n,
	input signed [13:0] din,
	output signed [32-1:0] dout
);

reg signed [13:0] data_reg [AVE_DATA_NUM-1:0];
reg signed [31:0] sum;
reg [15:0]temp_i;


always @ (posedge i_clk or negedge i_rst_n) begin
	if(!i_rst_n)
		for (temp_i=0; temp_i<AVE_DATA_NUM; temp_i=temp_i+1)
			data_reg[temp_i] <= 0;
	else begin
		data_reg[0] <= din;
		for (temp_i=0; temp_i<AVE_DATA_NUM-1; temp_i=temp_i+1)
			data_reg[temp_i+1] <= data_reg[temp_i];
	end
end



always @ (posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n)
		sum <= 0;
	else
		sum <= sum + din - data_reg[AVE_DATA_NUM-1]; //Change the oldest data to the latest input data
end

assign dout = sum >>> AVE_DATA_BIT;  //Shift 3 to the right is equivalent to 8
endmodule