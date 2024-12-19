`timescale 1 ns/ 100 ps

module i2c_controller_pullup_tb;

    // Testbench signals
    reg i_clk;
    reg i_rst_n;
    reg [6:0] i_dev_addr;
    reg [7:0] i_w_data;
    reg [7:0] i_reg_addr;
    reg [31:0] i_ctrl;
    reg i_drdy;

    wire [7:0] o_rd_data;
    wire [7:0] o_rd_data_2;
    wire [7:0] o_rd_data_3;
    wire [7:0] o_rd_data_4;
    wire [7:0] o_rd_data_5;
    wire [7:0] o_rd_data_6;
    wire [7:0] o_rd_data_7;
    wire [7:0] o_rd_data_8;
    wire [7:0] o_rd_data_9;
    wire [7:0] o_rd_data_10;
    wire [7:0] o_rd_data_11;

    wire [31:0] o_status;
    wire o_w_enable;
    wire i2c_clk_out;
    tri i2c_scl;
    tri i2c_sda;

    // Signals for driving inout
    reg i2c_scl_drv;
    reg i2c_sda_drv;
    assign i2c_scl = (i2c_scl_drv) ? 1'bz : 0;
    assign i2c_sda = (i2c_sda_drv) ? 1'bz : 0;

    // DUT instance
    i2c_controller_pullup uut (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_dev_addr(i_dev_addr),
        .i_w_data(i_w_data),
        .i_reg_addr(i_reg_addr),
        .i_ctrl(i_ctrl),
        .i_drdy(i_drdy),
        .o_rd_data(o_rd_data),
        .o_rd_data_2(o_rd_data_2),
        .o_rd_data_3(o_rd_data_3),
        .o_rd_data_4(o_rd_data_4),
        .o_rd_data_5(o_rd_data_5),
        .o_rd_data_6(o_rd_data_6),
        .o_rd_data_7(o_rd_data_7),
        .o_rd_data_8(o_rd_data_8),
        .o_rd_data_9(o_rd_data_9),
        .o_rd_data_10(o_rd_data_10),
        .o_rd_data_11(o_rd_data_11),
        .o_status(o_status),
        .o_w_enable(o_w_enable),
        .i2c_clk_out(i2c_clk_out),
        .i2c_scl(i2c_scl),
        .i2c_sda(i2c_sda)
    );

    // Clock generation
    initial i_clk = 0;
    always #10 i_clk = ~i_clk; // 50MHz clock

    // State machine for simulating ADXL357 response
    reg [3:0] response_state;
    always @(negedge i2c_scl or negedge i_rst_n) begin
        if (!i_rst_n) begin
            response_state <= 0;
            i2c_sda_drv <= 1;
        end else begin
            case (response_state)
                0: begin // First ACK for READ_ACK
                    i2c_sda_drv <= 0; // Drive ACK
                    response_state <= 1;
                end
                1: begin // Release SDA
                    i2c_sda_drv <= 1;
                    response_state <= 2;
                end
                2: begin // Second ACK for READ_ACK2
                    i2c_sda_drv <= 0; // Drive ACK
                    response_state <= 3;
                end
                3: begin // Release SDA
                    i2c_sda_drv <= 1;
                    response_state <= 4;
                end
                4: begin // Third ACK for second READ_ACK
                    i2c_sda_drv <= 0; // Drive ACK
                    response_state <= 5;
                end
                5: begin // Release SDA
                    i2c_sda_drv <= 1;
                    response_state <= 6;
                end
                6: begin // Data transfer for READ_DATA ~ READ_DATA11
                    i2c_sda_drv <= 8'hA0 + (response_state - 6); // Provide data byte
                    if (response_state == 17) // After 11 data bytes
                        response_state <= 0;
                    else
                        response_state <= response_state + 1;
                end
                default: response_state <= 0;
            endcase
        end
    end

    // Additional wires for status and control registers
    wire [7:0] sm;
    wire [1:0] op_mode;
    wire [2:0] clk_rate;
    wire i_enable;
    wire rw_reg;
    wire ready;
    wire finish;

    /******* status register********/
    assign ready = o_status[0];
    assign finish = o_status[1];
    assign sm = o_status[9:2];

    /******* control register********/
    assign i_enable = i_ctrl[0];
    assign rw_reg = i_ctrl[1];
    assign op_mode = i_ctrl[3:2];
    assign clk_rate = i_ctrl[6:4];

    // Testbench sequence
    initial begin
        // Initialize signals
        i_rst_n = 0;
        i_drdy = 0;
        i_dev_addr = 7'h1D;
        i_w_data = 8'h00;
        i_reg_addr = 8'h06;
        i_ctrl = 32'h00000000;
        i2c_scl_drv = 1;

        // Reset
        #100;
        i_rst_n = 1;

        // Set HW_11 mode and enable
        i_ctrl[3:2] = 2'b10; // HW_11 mode
        i_ctrl[0] = 1; // Enable
        i_ctrl[1] = 1; // RW enabled
        i_ctrl[6:4] = 3'b110; // CLK_390K

        i_drdy = 1; // Trigger state machine

        // Wait for finish
        wait(o_status[1] == 1);

        // Check read data
        $display("Read Data 1: %h", o_rd_data);
        $display("Read Data 2: %h", o_rd_data_2);
        $display("Read Data 3: %h", o_rd_data_3);
        $display("Read Data 4: %h", o_rd_data_4);
        $display("Read Data 5: %h", o_rd_data_5);
        $display("Read Data 6: %h", o_rd_data_6);
        $display("Read Data 7: %h", o_rd_data_7);
        $display("Read Data 8: %h", o_rd_data_8);
        $display("Read Data 9: %h", o_rd_data_9);
        $display("Read Data 10: %h", o_rd_data_10);
        $display("Read Data 11: %h", o_rd_data_11);

        $stop;
    end

endmodule







