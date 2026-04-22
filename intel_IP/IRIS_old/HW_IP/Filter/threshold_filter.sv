module threshold_filter #(
    parameter DATA_WIDTH = 14  // 預設資料寬度為14位
) (
    input  wire                   i_clk,           // 時鐘訊號
    input  wire                   i_rst_n,         // 低電平有效的復位訊號
    input  wire  [DATA_WIDTH-1:0] i_data,          // 輸入資料，MSB為符號位
    input  wire  [DATA_WIDTH-1:0] i_threshold,     // 閾值輸入（正值）
    output reg   [DATA_WIDTH-1:0] o_filtered       // 濾波後的輸出
);

    // 內部寄存器，用於儲存上一個有效輸出值
    reg [DATA_WIDTH-1:0] prev_data_value;

    // 符號位擴展後的比較值
    wire signed [DATA_WIDTH:0] signed_data;
    wire signed [DATA_WIDTH:0] signed_threshold;
    wire signed [DATA_WIDTH:0] neg_threshold;

    // 將輸入轉換為有符號數
    assign signed_data      = {i_data[DATA_WIDTH-1], i_data};     // 符號位擴展
    assign signed_threshold = {1'b0, i_threshold};                // 正閾值
    assign neg_threshold    = -signed_threshold;                  // 負閾值

    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            // 復位時清零
            o_filtered      <= {DATA_WIDTH{1'b0}};
            prev_data_value <= {DATA_WIDTH{1'b0}};
        end
        else begin
            // 檢查輸入值是否在閾值範圍內
            if (signed_data > signed_threshold || signed_data < neg_threshold) begin
                // 超過閾值時，保持上一個值
                o_filtered <= prev_data_value;
            end
            else begin
                // 在閾值範圍內，更新輸出並儲存當前值
                o_filtered      <= i_data;
                prev_data_value <= i_data;
            end
        end
    end

endmodule