module myMV_filter_gate #(
    parameter WINDOW = 8192,  // 預設窗口大小 (2^13)
    parameter DIV_FACTOR = 4,       // 觸發訊號分頻因子 (可設定為1)
    parameter ADDR_WIDTH = (WINDOW > 1) ? $clog2(WINDOW) : 1
)(
    input clk,
    input n_rst,
    input trig,
    input signed [31:0] din,
    output reg signed [31:0] dout,
    output reg signed [31:0] monitor_sum,  // 監視 sum
    output reg signed [31:0] monitor_buffer // 監視 buffer[index]
);

    reg [5:0] trig_counter;  // 計數器 (根據 DIV_FACTOR 調整位寬)
    reg slow_trig;           // 產生較慢的觸發訊號

    // 計數器邏輯：對 `i_trig` 進行分頻 (當 DIV_FACTOR >= 2)
    always_ff @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            trig_counter <= 0;
            slow_trig   <= 0;
        end 
        else if (trig) begin
            if (DIV_FACTOR <= 1) begin
                // 直接使用 i_trig 當 slow_trig
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

    reg signed [31:0] buffer [0:WINDOW-1]; // FIFO 緩衝
    reg [ADDR_WIDTH-1:0] index; // 緩衝區索引
    reg signed [47:0] sum;  // 48-bit 累加器，避免溢位

    always @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            dout <= 0;
            sum <= 0;
            index <= 0;
            monitor_sum <= 0;
            monitor_buffer <= 0;
        end 
        else if(slow_trig) begin
            // 移除最舊值，加入新值
            sum <= sum - buffer[index] + din;
            
            // 更新 FIFO
            buffer[index] <= din;
            
            // **如果 WINDOW = 2^N，使用更快的位運算**
            index <= (index + 1) & (WINDOW - 1);
            
            // 計算平均值 (假設 WINDOW = 2^N，可以用移位代替除法)
            dout <= sum >>> $clog2(WINDOW);
            
            // 更新監視訊號
            monitor_sum <= sum[31:0];
            monitor_buffer <= buffer[index];
        end
    end

endmodule
