`timescale 1ns / 100ps

module i2c_controller_tb;

	// Inputs
	reg clk;
	reg rst;
	reg [6:0] addr;
	reg [7:0] data_in;
	reg enable;
	reg rw;

	// Outputs
	wire [7:0] data_out;
	wire ready;
	wire w_enable;
	wire [7:0] sm;

	// Bidirs
	wire i2c_sda;
	wire i2c_scl;
	wire i2c_clk_out;

	// Instantiate the Unit Under Test (UUT)
	i2c_controller i2c_controller_inst (
		.clk(clk), 
		.rst(rst), 
		.addr(addr), 
		.data_in(data_in), 
		.enable(enable), 
		.rw(rw), 
		.data_out(data_out), 
		.ready(ready), 
		.w_enable(w_enable),
		.sm(sm),
		.i2c_sda(i2c_sda), 
		.i2c_scl(i2c_scl),
		.i2c_clk_out(i2c_clk_out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		enable = 1;
		rst = 0;		
		addr = 7'h1D;
		data_in = 8'h00;
		rw = 0;	
		
		repeat(100) @(posedge i2c_clk_out)
			
		
		$display("Finished 100 posedges of i2c_clk_out.");	
		#50
		$stop;
		
	end     

	always #1 clk = ~clk; // Toggle rdclk every 5 time units (for 100 MHz frequency)

endmodule