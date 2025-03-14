module fir_filter_v4 #(
    parameter N = 16,               // 濾波器階數
    parameter WIDTH = 14,          // ADC數據位寬
    parameter M = 4                // 每段累加大小
)(
    input clk,
    input n_rst,
    input signed [WIDTH-1:0] din,  // 輸入數據
    output reg signed [WIDTH+15:0] dout // 濾波後數據
);
    reg signed [WIDTH-1:0] shift_reg [0:N-1]; // 移位寄存器
    reg signed [WIDTH+15:0] mult [0:N-1];    // 乘法結果


    const logic signed [15:0] coeff [0:N-1] = '{
        112, 243, 618, 1293, 2217, 3225, 4089, 4587, 
        4587, 4089, 3225, 2217, 1293, 618, 243, 112

    };

    // input value    
    genvar k;
    generate
        for (k = 0; k < N; k = k + 1) begin : gen_shift_reg
            if (k == 0) begin
                always @(posedge clk or negedge n_rst) begin
                    if (!n_rst) begin
                        shift_reg[k] <= 0;
                    end else begin
                        shift_reg[k] <= din;
                    end
                end
            end else begin
                always @(posedge clk or negedge n_rst) begin
                    if (!n_rst) begin
                        shift_reg[k] <= 0;
                    end else begin
                        shift_reg[k] <= shift_reg[k-1];
                    end
                end
            end
        end
    endgenerate

    // 乘法運算
    genvar l;
    generate
        for (l = 0; l < N; l = l + 1) begin : mult_gen
            always @(posedge clk or negedge n_rst) begin
                if (!n_rst) begin
                    mult[l] <= 0;  // 復位時設置為 0
                end else begin
                    mult[l] <= shift_reg[l] * coeff[l];  // 在時鐘邊沿進行乘法運算
                end
            end
        end
    endgenerate

    // 累加器, 計算輸出數據
    reg signed [WIDTH+15:0] partial_sum [0:(N+M-1)/M-1]; // 局部累加結果
    reg signed [WIDTH+15:0] dout_next;                  // 中間變量，用於計算最終結果

    // 部分累加
    always @(posedge clk or negedge n_rst) begin
        integer i, p;
        if (!n_rst) begin
            for (i = 0; i < (N+M-1)/M; i = i + 1) begin
                partial_sum[i] <= 0;
            end
        end else begin
            for (i = 0; i < (N+M-1)/M; i = i + 1) begin
                partial_sum[i] <= 0; // 初始化該段累加值
                for (p = 0; p < M; p = p + 1) begin
                    if (M*i + p < N) begin
                        partial_sum[i] <= partial_sum[i] + mult[M*i + p];
                    end
                end
            end
        end
    end

    // 最終累加與輸出
    always @(posedge clk or negedge n_rst) begin
        integer j;
        if (!n_rst) begin
            dout <= 0;
        end else begin
            dout_next = 0; // 初始化累加變量
            for (j = 0; j < (N+M-1)/M; j = j + 1) begin
                dout_next = dout_next + partial_sum[j]; // 累加所有 partial_sum
            end
            dout <= dout_next; // 更新輸出結果
        end
    end

endmodule
