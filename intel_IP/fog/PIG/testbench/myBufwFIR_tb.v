`timescale 1 ns/ 100 ps
module myBufwFIR_vlg_tst();

// constants                                           
// general purpose registers
reg eachvec;
// test vector input registers
reg [13:0] data = 0; // Initialize data
reg rdclk = 0;
reg rdreq = 0;
reg rst_n = 0;
reg wrclk = 0;
reg wrreq = 0;

// wires   
wire data_valid;                                            
wire [17:0] q;
wire rdempty;
wire [1:0]  source_err;
wire wrfull;
wire [13:0] monitor_fifout;
// Instance of your FIFO module (myBuf)

reg [31:0] count = 0;

// Generate a 1MHz sine wave for 'data' input

integer counter = 0;
parameter  p = 1000;
reg [13:0] sine_wave [0:p-1]; // Look-up table for a half period of sine wave
integer i;
integer period; // Number of time units for half period (1MHz)
// integer half_period;
// reg [15:0] approx_pi = 3217; // Fixed-point approximation of pi (3.14159 * 2^10)

myBufwFIR i1 (
// port map - connection between master ports and signals/registers   
	.data(data),
	.data_valid(data_valid),
	.q(q),
	.rdclk(rdclk),
	.rdempty(rdempty),
	.rdreq(rdreq),
	.rst_n(rst_n),
	.source_err(source_err),
	.wrclk(wrclk),
	.wrfull(wrfull),
    .monitor_fifout(monitor_fifout),
	.wrreq(wrreq)
);

// Clock generation for rdclk and wrclk
always #5 rdclk = ~rdclk; // Toggle rdclk every 5 time units (for 100 MHz frequency)
always #5 wrclk = ~wrclk; // Toggle wrclk every 5 time units (for 100 MHz frequency)

// Testbench behavior
initial begin
    $display("Running testbench");
    period = p; // Number of time units for half period (1MHz)
    // half_period = period / 2;
    
    #10;
    rst_n = 1;

    // Fill the sine_wave array with precomputed values for a half period of a sine wave
    // initial begin
        
    for (i = 0; i < period; i = i + 1) begin
        sine_wave[i] = $signed(8191 * $sin((i * 2 * 3.1415926) / (period))); // Generating sine wave values
        $display("sine_wave[%0d] = %d", i, sine_wave[i]);
    end
    // end

    // Generate 2000 cycles of a square wave at 1MHz for 'data' input
    repeat (10000) begin
            // Generate a 1MHz sine wave for 'data' input using a look-up table
            data = sine_wave[counter];

            // Set wrreq to 1 when wrfull is 0
            if (wrfull == 0) begin
                wrreq = 1;
            end else begin
                wrreq = 0;
            end

            // Toggle rdreq to 1 when rdempty is 0
            if (rdempty == 0) begin
                rdreq = 1;
            end else begin
                rdreq = 0;
            end
            // #1; // Delay to simulate 1ns

            // Increment count and loop it back to 0 if it reaches 49
            counter = (counter == (period - 1)) ? 0 : (counter + 1);
            #10;

        end
        // count = 0;

    // End simulation
    $stop;
        
    end




endmodule

