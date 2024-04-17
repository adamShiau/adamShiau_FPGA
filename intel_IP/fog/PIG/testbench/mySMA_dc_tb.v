`timescale 1 ns/ 100 ps
module mySMA_dc_tb();

// test vector input registers
reg i_clk;
reg [31:0] i_data;
reg i_rst_n;
reg i_update_strobe;
reg [31:0] i_window_sel;
// wires                                               
wire [31:0]  o_data;
wire [31:0]  m_count_reg;
wire [63:0]  m_sum_reg;
wire [15:0]  m_N;
wire [31:0] m_data_reg;
wire window_change;

parameter period_pts = 900;
parameter amp = 8191;
parameter frequency = 10e3; //Hz
parameter cycle = 20;
parameter delay_time = 1e9/(period_pts*frequency);
parameter pi = 3.141592653589;
real omega = 2 * pi / period_pts;

// assign statements (if any)                          
SMA_v1 
#(.WINDOW_SIZE(8192))
i1 (
// port map - connection between master ports and signals/registers   
	.i_clk(i_clk),
	.i_data(i_data),
	.i_rst_n(i_rst_n),
	.i_update_strobe(i_update_strobe),
	.i_window_sel(i_window_sel),
	.o_data(o_data),
	.m_count_reg(m_count_reg),
	.m_sum_reg(m_sum_reg),
	.m_N(m_N),
	.m_data_reg(m_data_reg),
	.window_change(window_change)
);

integer t;

initial                                                
begin                                                                                             
$display("Running testbench"); 
i_clk = 0;
i_rst_n = 0;
i_window_sel = 32'd12;
i_update_strobe = 1'b0;
i_data = 100;
#30;
i_rst_n = 1;
#10;

for (t = 0; t < cycle*period_pts; t = t + 1) begin
    // Generate simplified sine wave with 14-bit amplitude
    // i_data = $rtoi( amp*$sin(omega * t)); // Generate sine wave with 14-bit amplitude
	
	// Generate clock pulse for i_update_strobe
	i_update_strobe = 1'b1;
	#10;
	i_update_strobe = 1'b0;

    #(delay_time-10); // update rate
	if(t >= 0.3*cycle*period_pts) i_window_sel = 32'd10;
	if(t >= 0.6*cycle*period_pts) i_window_sel = 32'd8;
	 
	
end

$display("delay_time = %f ns", delay_time);
$stop;   

end    

always #5 i_clk = ~i_clk; // Toggle rdclk every 5 time units (for 100 MHz frequency)

                                             
endmodule

