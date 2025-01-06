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
    wire signed [WIDTH+15:0] mult [0:N-1];    // 乘法結果


    const logic signed [15:0] coeff [0:N-1] = '{
        311, 469, 917, 1582, 2352, 3091, 3671, 3990, 
        3990, 3671, 3091, 2352, 1582, 917, 469, 311
    };

    // generate
    //     genvar j;
    //     for (j = 0; j < N; j = j + 1) begin : shift_gen
    //         always @(posedge clk or negedge n_rst) begin
    //             if (!n_rst) begin
    //                 shift_reg[j] <= 0;
    //             end else if (j == 0) begin
    //                 shift_reg[0] <= din;
    //             end else begin
    //                 shift_reg[j] <= shift_reg[j-1];
    //             end
    //         end
    //     end
    // endgenerate

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


    // 乘法運算
    generate
        genvar l;
        for (l = 0; l < N; l = l + 1) begin : mult_gen
            assign mult[l] = shift_reg[l] * coeff[l];
        end
    endgenerate

    always @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            dout <= 0;
        end else begin
            integer i;
            reg signed [WIDTH+15:0] acc; // 臨時累加變量
            acc = mult[0];
            for (i = 1; i < N; i = i + 1)
                acc = acc + mult[i];
            dout <= acc; // 最後一次性賦值給 dout
        end
    end

endmodule
