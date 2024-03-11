`timescale 1 ns/ 100 ps
module myFIR_tb();

reg [13:0] data_in = 0; // Initialize data
reg i_clk = 0;
reg sink_valid = 0;
reg i_rstn = 0;

// wires   
wire data_valid;                                            
wire [17:0] data_out;
wire [1:0]  source_err;

parameter period_pts = 500;
parameter amp = 8191;
parameter frequency = 0.01e6; //Hz
parameter cycle = 10;
parameter delay_time = 1e9/(period_pts*frequency);
parameter pi = 3.141592653589;
real omega = 2 * pi / period_pts;


myFIR i1 (

	.data_in(data_in),
	.i_clk(i_clk),
	.i_rstn(i_rstn),
	.sink_valid(sink_valid),
	
	.data_out(data_out),
	.data_valid(data_valid),
	.source_err(source_err)


);



integer t;
initial begin
$display("Running testbench");
// $display("period = %f ns", period_pts*delay_time);

#10;
i_rstn = 1;
sink_valid = 1;
#10;

for (t = 0; t < cycle*period_pts; t = t + 1) begin
    // Generate simplified sine wave with 14-bit amplitude
    data_in = $rtoi( amp*$sin(omega * t)); // Generate sine wave with 14-bit amplitude
    #delay_time; // update rate
end
$display("delay_time = %f ns", delay_time);
$stop;   

end

// Clock generation for rdclk and wrclk
always #5 i_clk = ~i_clk; // Toggle rdclk every 5 time units (for 100 MHz frequency)


endmodule

