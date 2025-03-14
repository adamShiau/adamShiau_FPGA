module fir_filter_v2 #(
    parameter N = 16,               // 濾波器階數
    parameter WIDTH = 14           // ADC數據位寬
)(
    input clk,
    input n_rst,
    input signed [WIDTH-1:0] din,  // 輸入數據
    output reg signed [WIDTH+15:0] dout // 濾波後數據
);
    reg signed [WIDTH-1:0] shift_reg [0:N-1]; // 移位寄存器
    wire signed [WIDTH+15:0] mult [0:N-1];    // 乘法結果


    const logic signed [15:0] coeff [0:N-1] = '{
        661, 2126, 5452, 8144, 8144, 5452, 2126, 661
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
            assign mult[l] = shift_reg[l] * coeff[l];
        end
    endgenerate

    // 計算輸出數據
    always @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            dout <= 0;
        end else begin
            integer i;  // 定義迴圈索引
            reg signed [WIDTH+15:0] sum;  // 暫存累加結果
            sum = 0;  // 初始化累加值
            for (i = 0; i < N; i = i + 1) begin
                sum = sum + mult[i];  // 累加所有乘法結果
            end
            dout <= sum;  // 將累加結果輸出
        end
    end

    // always @(posedge clk or negedge n_rst) begin
    //     if (!n_rst) begin
    //         dout <= 0;
    //     end else begin
    //         // reg signed [WIDTH+15:0] acc; 
    //         dout = mult[0] + mult[1] + mult[2] + mult[3] + mult[4] + mult[5] + mult[6] + mult[7] + mult[8] + mult[9] + mult[10] + mult[11] + mult[12] + mult[13]
    //          + mult[14] + mult[15];
    //         // dout <= acc; 
    //     end
    // end

endmodule
