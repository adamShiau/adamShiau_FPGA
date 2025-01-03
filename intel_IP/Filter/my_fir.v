module fir_filter #(
    parameter N = 64,               // 濾波器階數
    parameter WIDTH = 14           // ADC數據位寬
)(
    input clk,
    input rst,
    input signed [WIDTH-1:0] din,  // 輸入數據
    output reg signed [WIDTH+15:0] dout // 濾波後數據
);
    reg signed [WIDTH-1:0] shift_reg [0:N-1]; // 移位寄存器
    wire signed [WIDTH+15:0] mult [0:N-1];    // 乘法結果
    integer i;

    // FIR係數（需要根據工具生成的數據填充）
    localparam signed [15:0] coeff [0:N-1] = '{/* 插入係數 */};

    // 移位寄存器
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < N; i = i + 1)
                shift_reg[i] <= 0;
        end else begin
            shift_reg[0] <= din;
            for (i = 1; i < N; i = i + 1)
                shift_reg[i] <= shift_reg[i-1];
        end
    end

    // 乘法運算
    genvar j;
    generate
        for (j = 0; j < N; j = j + 1) begin : mult_gen
            assign mult[j] = shift_reg[j] * coeff[j];
        end
    endgenerate

    // 加法器
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dout <= 0;
        end else begin
            dout <= mult[0];
            for (i = 1; i < N; i = i + 1)
                dout <= dout + mult[i];
        end
    end
endmodule
