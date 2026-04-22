module fir_filter #(
    parameter N = 16,               // 濾波器階數
    parameter WIDTH = 14           // ADC數據位寬
)(
    input clk,
    input n_rst,
    input signed [WIDTH-1:0] din,  // 輸入數據
    output reg signed [WIDTH+15:0] dout // 濾波後數據
);

    reg signed [WIDTH-1:0] shift_reg [0:N-1]; // 移位寄存器
    reg signed [WIDTH+16:0] mult [0:N-1];     // 乘法結果緩存
    reg signed [WIDTH+16:0] acc;              // 累加暫存器
    integer i;

    // FIR 係數（靜態初始化）
    const logic signed [15:0] coeff [0:N-1] = '{
        311, 469, 917, 1582, 2352, 3091, 3671, 3990, 
        3990, 3671, 3091, 2352, 1582, 917, 469, 311
    };

    // 移位寄存器
    always @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            for (i = 0; i < N; i = i + 1)
                shift_reg[i] <= 0;
        end else begin
            shift_reg[0] <= din;
            for (i = 1; i < N; i = i + 1)
                shift_reg[i] <= shift_reg[i-1];
        end
    end

    // 乘法運算
    always @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            for (i = 0; i < N; i = i + 1)
                mult[i] <= 0;
        end else begin
            for (i = 0; i < N; i = i + 1)
                mult[i] <= shift_reg[i] * coeff[i];
        end
    end

    // 加法累加
    always @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            acc <= 0;
        end else begin
            acc <= mult[0];
            for (i = 1; i < N; i = i + 1)
                acc <= acc + mult[i];
        end
    end

    // 最終輸出
    always @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            dout <= 0;
        end else begin
            dout <= acc; // 將累加結果寄存
        end
    end

endmodule
