module fir_filter_v3 #(
    parameter N = 16,               // 濾波器階數
    parameter WIDTH = 14           // ADC數據位寬
)(
    input clk,
    input n_rst,
    input signed [WIDTH-1:0] din,  // 輸入數據
    output reg signed [WIDTH+15:0] dout // 濾波後數據
);

    typedef logic signed [15:0] coeff_array_t [0:31];  // 假設最大長度為 32

    parameter coeff_array_t N16FC5 = '{
        -54, -64, -82, -97, -93, -47, 66, 266, 562, 951,
        1412, 1909, 2396, 2821, 3136, 3304,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    };

    parameter coeff_array_t N32FC5 = '{
        -54, -64, -82, -97, -93, -47, 66, 266, 562, 951,
        1412, 1909, 2396, 2821, 3136, 3304,
        3304, 3136, 2821, 2396, 1909, 1412, 951, 562, 
        266, 66, -47, -93, -97, -82, -64, -54
    };

    parameter coeff_array_t N32FC2 = '{
        82, 102, 148, 223, 330, 469, 638, 832, 1042, 1261, 
        1476, 1678, 1855, 1998, 2098, 2149, 2149, 2098, 
        1998, 1855, 1678, 1476, 1261, 1042, 832, 638, 469, 
        330, 223, 148, 102, 82
    };

    reg signed [WIDTH-1:0] shift_reg [0:N-1]; // 移位寄存器
    reg signed [WIDTH+15:0] mult [0:N-1];    // 乘法結果


    const logic signed [15:0] coeff [0:N-1] = N32FC2;

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
    reg signed [WIDTH+15:0] partial_sum [0:N/4-1]; // 局部累加結果
    reg signed [WIDTH+15:0] dout_next;            // 中間變量，用於計算最終結果

    // 部分累加
    always @(posedge clk or negedge n_rst) begin
        integer i;
        if (!n_rst) begin
            for (i = 0; i < N/4; i = i + 1) begin
                partial_sum[i] <= 0;
            end
        end else begin
            for (i = 0; i < N/4; i = i + 1) begin
                partial_sum[i] <= mult[4*i] + mult[4*i+1] + mult[4*i+2] + mult[4*i+3];
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
            for (j = 0; j < N/4; j = j + 1) begin
                dout_next = dout_next + partial_sum[j]; // 累加所有 partial_sum
            end
            dout <= dout_next; // 更新輸出結果
        end
    end



endmodule
