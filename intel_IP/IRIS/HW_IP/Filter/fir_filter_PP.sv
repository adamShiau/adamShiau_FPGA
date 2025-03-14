module fir_filter_PP #(
    parameter N = 16,               // 濾波器階數
    parameter WIDTH = 14           // ADC數據位寬
)(
    input clk,
    input n_rst,
    input signed [WIDTH-1:0] din,  // 輸入數據
    output reg signed [WIDTH+15:0] dout // 濾波後數據
);
    reg signed [WIDTH-1:0] shift_reg [0:N-1];      // 移位寄存器
    reg signed [WIDTH+15:0] mult_pipe [0:N-1];    // 管線化乘法結果
    reg signed [WIDTH+15:0] add_pipe [0:N-1];     // 管線化累加結果

    // 濾波器係數
    const logic signed [15:0] coeff [0:N-1] = '{
        // 112, 243, 618, 1293, 2217, 3225, 4089, 4587, 
        // 4587, 4089, 3225, 2217, 1293, 618, 243, 112
        -54, -64, -82, -97, -93, -47, 66, 266, 562, 951, 
        1412, 1909, 2396, 2821, 3136, 3304, 3304, 3136, 
        2821, 2396, 1909, 1412, 951, 562, 266, 66, -47, 
        -93, -97, -82, -64, -54

    };

    // 移位寄存器，用於存儲輸入數據
    always @(posedge clk or negedge n_rst) begin
        integer k;
        if (!n_rst) begin
            for (k = 0; k < N; k = k + 1)
                shift_reg[k] <= 0;
        end else begin
            shift_reg[0] <= din;
            for (k = 1; k < N; k = k + 1)
                shift_reg[k] <= shift_reg[k-1];
        end
    end

    // 管線化乘法器
    always @(posedge clk or negedge n_rst) begin
        integer l;
        if (!n_rst) begin
            for (l = 0; l < N; l = l + 1)
                mult_pipe[l] <= 0;
        end else begin
            for (l = 0; l < N; l = l + 1)
                mult_pipe[l] <= shift_reg[l] * coeff[l];
        end
    end

    // 管線化累加器
    always @(posedge clk or negedge n_rst) begin
        integer m;
        if (!n_rst) begin
            for (m = 0; m < N; m = m + 1)
                add_pipe[m] <= 0;
            dout <= 0;
        end else begin
            // 第一次累加初始化
            add_pipe[0] <= mult_pipe[0];

            // 逐步累加其餘乘法結果
            for (m = 1; m < N; m = m + 1)
                add_pipe[m] <= add_pipe[m-1] + mult_pipe[m];

            // 最終累加結果
            dout <= add_pipe[N-1];
        end
    end

endmodule
