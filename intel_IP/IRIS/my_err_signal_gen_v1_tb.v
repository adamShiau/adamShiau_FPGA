`timescale 1ns / 100ps

module my_err_signal_gen_v1_tb;

    // Parameters
    parameter ADC_BIT = 14;
    parameter CLK_PERIOD = 10;

    // Signals for err_signal_gen_ut
    reg i_clk;
    reg i_rst_n;
    reg i_status;
    reg i_polarity;
    reg i_trig;
    reg [31:0] i_wait_cnt;
    reg signed [31:0] i_err_offset;
    reg signed [ADC_BIT-1:0] i_adc_data;
    reg [31:0] i_avg_sel;
    wire signed [31:0] o_err;
    wire signed [31:0] o_adc_sum;
    wire signed [31:0] o_low_avg;
    wire signed [31:0] o_high_avg;
    wire [3:0] o_cstate;
    wire [3:0] o_nstate;

    // Instantiate err_signal_gen_ut
    my_err_signal_gen_v1 #(.ADC_BIT(ADC_BIT)) uut (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_status(i_status),
        .i_polarity(i_polarity),
        .i_trig(i_trig),
        .i_wait_cnt(i_wait_cnt),
        .i_err_offset(i_err_offset),
        .i_adc_data(i_adc_data),
        .i_avg_sel(i_avg_sel),
        .o_err(o_err)
        ,.o_adc_sum(o_adc_sum)
        ,.o_low_avg(o_low_avg)
        ,.o_high_avg(o_high_avg)
        ,.o_cstate(o_cstate)
        ,.o_nstate(o_nstate)
    );

    // Clock generation
    initial begin
        i_clk = 0;
    end


    // Testbench initialization
    initial begin
        // Initialize signals
        i_clk = 0;
        i_rst_n = 0;
        i_status = 0;
        i_polarity = 1;
        i_trig = 0;
        i_wait_cnt = 32'd10;
        i_err_offset = 32'd50;
        i_adc_data = 14'sd100;
        i_avg_sel = 4; // Average over 16 samples (2^4)

        // Reset the system
        #20 i_rst_n = 1;
        $display("Running testbench"); 
        // Generate i_trig pulse every 100 clocks

        repeat (10) begin
            repeat (100) @(posedge i_clk); // Wait 100 clock cycles
            i_status = ~i_status;
            i_trig = 1; // Generate 1-clock pulse
            @(posedge i_clk);
            i_trig = 0;

            // Increment ADC value on each i_trig
            // @(posedge i_trig); // Wait for i_trig pulse
            // i_adc_data = i_adc_data - 14'sd100;
        end

        repeat (10) begin
            i_adc_data = -14'sd500;
            repeat (100) @(posedge i_clk); // Wait 100 clock cycles
            i_status = ~i_status;
            i_trig = 1; // Generate 1-clock pulse
            @(posedge i_clk);
            i_trig = 0;

            // Increment ADC value on each i_trig
            // @(posedge i_trig); // Wait for i_trig pulse
            // i_adc_data = i_adc_data - 14'sd100;
        end
        #500
        $stop;
    end

    always #(CLK_PERIOD / 2) i_clk = ~i_clk;



endmodule
