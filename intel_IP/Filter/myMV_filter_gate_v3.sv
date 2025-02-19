module myMV_filter_gate_v3 #(
    parameter WINDOW = 8192,  // Default window size (2^13)
    parameter DIV_FACTOR = 4, // Trigger signal division factor (can be set to 1)
    parameter ADDR_WIDTH = (WINDOW > 1) ? $clog2(WINDOW) : 1
)(
    input clk,
    input n_rst,
    input trig,
    input signed [31:0] din,
    output reg signed [31:0] dout,
    output reg signed [31:0] monitor_sum_high, monitor_sum_low,  // Monitor sum
    output reg signed [31:0] monitor_buffer // Monitor buffer[index]
);

    reg [5:0] trig_counter;  // Counter (adjust bit-width based on DIV_FACTOR)
    reg slow_trig;           // Slower trigger signal

    // Counter logic: Divide `trig` signal (when DIV_FACTOR >= 2)
    always_ff @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            trig_counter <= 0;
            slow_trig   <= 0;
        end 
        else if (trig) begin
            if (DIV_FACTOR <= 1) begin
                // Directly use `trig` as slow_trig
                slow_trig <= 1'b1;
            end
            else if (trig_counter == DIV_FACTOR - 1) begin
                slow_trig   <= 1'b1;
                trig_counter <= 0;
            end
            else begin
                slow_trig   <= 1'b0;
                trig_counter <= trig_counter + 1;
            end
        end
        else begin
            slow_trig <= 1'b0;
        end
    end

    reg signed [31:0] buffer [0:WINDOW-1]; // FIFO buffer
    reg [ADDR_WIDTH-1:0] index; // Buffer index
    reg signed [47:0] sum;  // 48-bit accumulator to prevent overflow
    reg signed [47:0] sum_reg; // Sum register for monitoring

    // **Initialization control variables**
    reg [ADDR_WIDTH:0] clr_index; // Used for clearing buffer[] step by step
    reg clr_done; // Flag indicating buffer[] has been fully cleared

    always_ff @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            dout <= 0;
            sum <= 0;
            sum_reg <= 0;
            index <= 0;
            monitor_sum_high <= 0;
            monitor_sum_low <= 0;
            monitor_buffer <= 0;
            clr_index <= 0;
            clr_done <= 0;
        end 
        else if (!clr_done) begin
            // **Clear buffer[] step by step**
            buffer[clr_index] <= 0;
            
            // **Once all buffer[] entries are cleared, set clr_done**
            if (clr_index == (WINDOW - 1)) begin
                clr_done <= 1;
            end
            else begin
                clr_index <= clr_index + 1;
            end
        end
        else if (slow_trig) begin
            // **Only execute moving average after clearing is complete**
            sum <= sum - buffer[index] + din;
            buffer[index] <= din;
            index <= (index + 1) & (WINDOW - 1);
            dout <= sum >>> $clog2(WINDOW);

            // **Monitor signals**
            sum_reg <= sum;
            monitor_sum_high <= sum_reg[47:32];
            monitor_sum_low <= sum_reg[31:0];
            monitor_buffer <= din;
        end
    end

endmodule
