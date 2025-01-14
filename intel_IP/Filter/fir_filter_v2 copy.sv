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
        // 112, 243, 618, 1293, 2217, 3225, 4089, 4587, 
        // 4587, 4089, 3225, 2217, 1293, 618, 243, 112
        311, 469, 917, 1582, 2352, 3091, 3671, 3990, 
        3990, 3671, 3091, 2352, 1582, 917, 469, 311
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

    always @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            dout <= 0;
        end else begin
            // reg signed [WIDTH+15:0] acc; 
            dout = mult[0] + mult[1] + mult[2] + mult[3] + mult[4] + mult[5] + mult[6] + mult[7] + mult[8] + mult[9] + mult[10] + mult[11] + mult[12] + mult[13]
             + mult[14] + mult[15];
            // dout <= acc; 
        end
    end

endmodule
