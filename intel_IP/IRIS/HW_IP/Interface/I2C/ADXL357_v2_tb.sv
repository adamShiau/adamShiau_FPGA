`timescale 1ns/100ps

module ADXL357_v2_tb;
    reg i_clk;
    reg i_rst_n;
    reg [6:0] i_dev_addr;
    reg [7:0] i_w_data;
    reg [7:0] i_reg_addr;
    reg [31:0] i_ctrl;
    reg i_drdy;
    
    wire signed [31:0] o_ACCX;
    wire signed [31:0] o_ACCY;
    wire signed [31:0] o_ACCZ;
    wire signed [31:0] o_TEMP;
    wire [31:0] o_status;
    wire o_w_enable;
    wire i2c_clk_out;
    wire i2c_scl;
    wire i2c_sda;
    
    // Instantiate the DUT (Device Under Test)
    i2c_controller_pullup_ADXL357_v2 dut (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_dev_addr(i_dev_addr),
        .i_w_data(i_w_data),
        .i_reg_addr(i_reg_addr),
        .i_ctrl(i_ctrl),
        .i_drdy(i_drdy),
        .o_ACCX(o_ACCX),
        .o_ACCY(o_ACCY),
        .o_ACCZ(o_ACCZ),
        .o_TEMP(o_TEMP),
        .o_status(o_status),
        .o_w_enable(o_w_enable),
        .i2c_clk_out(i2c_clk_out),
        .i2c_scl(i2c_scl),
        .i2c_sda(i2c_sda)
    );
    
    // Clock generation (100MHz -> 10ns period)
    always #5 i_clk = ~i_clk;
    
    initial begin
        // Initialize signals
        i_clk = 0;
        i_rst_n = 0;
        i_dev_addr = 7'h1D;
        i_w_data = 8'h00;
        i_reg_addr = 8'h00;
        i_ctrl = 32'h7C;
        i_drdy = 0;
        
        // Apply reset
        #100;
        i_rst_n = 1;
        
        // Generate i_drdy pulses (10 pulses, every 10ms, pulse width = 100us)
        repeat (3) begin

            #9999000 i_drdy = 1; // 10ms - 100us
            #100000 i_drdy = 0; // Pulse width 100us
        end
        
        // Finish simulation
        #200;
        $stop;
    end
    
endmodule
