`timescale 1ns / 100ps

module modulation_err_signal_tb;

    // Parameters
    parameter ADC_BIT = 14;
    parameter CLK_PERIOD = 10;

    // Signals
    logic i_clk;
    logic i_rst_n;
    logic [31:0] i_freq_cnt;
    logic signed [31:0] i_amp_H;
    logic signed [31:0] i_amp_L;
    logic i_polarity;
    logic [31:0] i_wait_cnt;
    logic signed [31:0] i_err_offset;
    logic signed [ADC_BIT-1:0] i_adc_data;
    logic [31:0] i_avg_sel;
    logic signed [31:0] o_err;
    logic signed [31:0] o_mod_out;
    logic o_status;
    logic o_stepTrig;

    // Instantiate sim_mod_err
    sim_mod_err #(.ADC_BIT(ADC_BIT)) sim_inst (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_freq_cnt(i_freq_cnt),
        .i_amp_H(i_amp_H),
        .i_amp_L(i_amp_L),
        .o_mod_out(o_mod_out),
        .o_status(o_status),
        .o_stepTrig(o_stepTrig),
        .i_polarity(i_polarity),
        .i_wait_cnt(i_wait_cnt),
        .i_err_offset(i_err_offset),
        .i_adc_data(i_adc_data),
        .i_avg_sel(i_avg_sel),
        .o_err(o_err)
    );

    // Clock generation
    initial begin
        i_clk = 0;
        forever #(CLK_PERIOD / 2) i_clk = ~i_clk;
    end

    // Testbench initialization
    initial begin
        // Initialize signals
        i_rst_n = 0;
        i_freq_cnt = 50;
        i_amp_H = 32'd1000;
        i_amp_L = -32'd1000;
        i_polarity = 1'b0;
        i_wait_cnt = 10;
        i_err_offset = 32'd50;
        i_adc_data = 14'sd100;
        i_avg_sel = 4; // Average over 16 samples (2^4)

        // Reset the system
        #20 i_rst_n = 1;

        // Simulate ADC data updates using a finite loop
        repeat (50) begin
            #100 i_adc_data = i_adc_data + 1; // Increment ADC value
        end

        // Run simulation
        #5000 $stop;
    end

endmodule
