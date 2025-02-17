module myMV_filter_v1 #(
    parameter WINDOW = 8192,  // 預設窗口大小 (2^13)
    parameter ADDR_WIDTH = (WINDOW > 1) ? $clog2(WINDOW) : 1
)(
    input clk,
    input n_rst,
    input signed [31:0] din,
    output reg signed [31:0] dout
);

    reg signed [31:0] buffer [0:WINDOW-1]; // FIFO 緩衝
    reg [ADDR_WIDTH-1:0] index; // 緩衝區索引
    reg signed [47:0] sum;  // 48-bit 累加器，避免溢位

    // integer i;
    
    // **建議使用 initial 區塊 (僅模擬有效)，避免 for 迴圈在 always 內**
    // initial begin
    //     for (i = 0; i < WINDOW; i = i + 1) begin
    //         buffer[i] = 0;
    //     end
    // end

    always @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            dout <= 0;
            sum <= 0;
            index <= 0;
        end else begin
            // 移除最舊值，加入新值
            sum <= sum - buffer[index] + din;

            // 更新 FIFO
            buffer[index] <= din;

            // **如果 WINDOW = 2^N，使用更快的位運算**
            index <= (index + 1) & (WINDOW - 1);

            // 計算平均值 (假設 WINDOW = 2^N，可以用移位代替除法)
            dout <= sum >>> $clog2(WINDOW);
        end
    end

endmodule
