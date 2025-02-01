
module VarSet_60 (
	address,
	chipselect,
	rst_n,
	write_n,
	writedata,
	o_reg59,
	i_var59,
	clk);	

	input	[6:0]	address;
	input		chipselect;
	input		rst_n;
	input		write_n;
	input	[31:0]	writedata;
	output	[31:0]	o_reg59;
	input	[31:0]	i_var59;
	input		clk;
endmodule
