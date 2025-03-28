`timescale 1ns / 100ps

module iir_filter_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // 100MHz clock (10ns period)
    parameter integer BIT_WIDTH = 14; // 14-bit signed data
    parameter real FREQUENCY = 2e6; // Default frequency = 1 MHz
    parameter real SAMPLE_RATE = 1e8; // Sampling rate = 100 MHz

    // Inputs
    reg clk;
    reg reset;

    // Outputs
    wire signed [BIT_WIDTH+31:0] dout;

    // Sine wave generation variables
    reg signed [BIT_WIDTH-1:0] din;
    wire signed [BIT_WIDTH-1:0] x0, x1, x2;
    wire signed [BIT_WIDTH+15:0]  y1, y2;
    wire signed [BIT_WIDTH+31:0] mult [0:4];
    


    real sine_value;
    integer sample_count = 0;

    // Instantiate the filter module
    // fir_filter_old #(
    my_iir_filter_v1 #(
        .WIDTH(14)
    ) uut (
        .clk(clk),
        .n_rst(reset),
        .din(din),
        .dout(dout),
        .mult(mult),
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .y1(y1),
        .y2(y2)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Reset generation
    initial begin
        reset = 0;
        #20;
        reset = 1;
    end

    // Generate sine wave input
    always @(posedge clk) begin
        if (reset) begin
            sine_value = $sin(2.0 * 3.14159265359 * FREQUENCY * sample_count / SAMPLE_RATE);
            din = sine_value * ((1 << (BIT_WIDTH-1)) - 1); // Scale to 14-bit signed range
            sample_count = sample_count + 1;
        end else begin
            din = 0;
            sample_count = 0;
        end
    end

    // Print frequency and output amplitude
    always @(posedge clk) begin
        if (reset) begin
            // $display("Time: %0t | Frequency: %0.2f MHz | dout amplitude: %0d", $time, FREQUENCY / 1e6, dout);
            // $display("%0t,%0d,%0d", $time*1e-3, din , dout);
        end
    end

    // Simulation control
    initial begin
        // $dumpfile("iir_filter_tb.vcd");
        // $dumpvars(0, iir_filter_tb);

        #10000; // Run simulation for a specific duration
        $stop;
    end

endmodule
