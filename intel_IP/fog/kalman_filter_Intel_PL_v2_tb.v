`timescale 1ns / 100ps

module kalman_filter_Intel_PL_v2_tb();

reg clk;
reg rst_n;
reg [31:0] kal_Q, kal_R;
reg signed [13:0] i_meas; // Signed to represent sine wave with 14-bit amplitude
wire signed [31:0] p_out, x_out;

real omega = 2 * 3.141592653589 / 100;

Kalman_filter_Intel_PL_v2 ukal (
    .i_clk (clk),
    .i_rst_n (rst_n),
    .i_meas (i_meas),
    .i_kal_Q (kal_Q),
    .i_kal_R (kal_R),
    .x_out (x_out),
    .p_out (p_out)
);

integer i;
initial begin
    clk = 0;
    rst_n = 0;
    kal_Q = 1;
    kal_R = 1000;
    #50;
    rst_n = 1;

    // Simulate for 100000 ns

    for (i = 0; i < 1000; i = i + 1) begin
        // Generate simplified sine wave with 14-bit amplitude
        i_meas = $rtoi((2**13 - 1) * $sin(omega * i)); // Generate sine wave with 14-bit amplitude
        #408.2; // update rate
    end

    $stop; // Stop simulation
end

// Toggle clk every 5 ns
always #20 clk = ~clk;

endmodule
