module myfir_filter_gate_v2 #(
    parameter N = 32,               // 濾波器階數
    parameter WIDTH = 14,           // ADC數據位寬
    parameter DIV_FACTOR = 4,       // 觸發訊號分頻因子 (可設定為1)
    parameter logic signed [15:0] COEFF_SET [0:31] = '{ // default use coeff. N32FC5
        -54, -64, -82, -97, -93, -47, 66, 266, 562, 951,
        1412, 1909, 2396, 2821, 3136, 3304,
        3304, 3136, 2821, 2396, 1909, 1412, 951, 562, 
        266, 66, -47, -93, -97, -82, -64, -54
    }
)(
    input clk,
    input n_rst,
    input i_trig,                   // 原始觸發訊號
    input signed [WIDTH-1:0] din,    // 輸入數據
    output logic signed [31:0] dout  // 濾波後數據
);

    reg [9:0] trig_counter;  // 計數器 (根據 DIV_FACTOR 調整位寬)
    reg slow_trig;           // 產生較慢的觸發訊號

    // 計數器邏輯：對 `i_trig` 進行分頻 (當 DIV_FACTOR >= 2)
    always_ff @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            trig_counter <= 0;
            slow_trig   <= 0;
        end 
        else if (i_trig) begin
            if (DIV_FACTOR <= 1) begin
                // 直接使用 i_trig 當 slow_trig
                slow_trig <= 1'b1;
            end
            else if (trig_counter == DIV_FACTOR - 1) begin
                slow_trig   <= 1'b1;
                trig_counter <= 0;
            end
            else begin
                slow_trig   <= 1'b0;
                trig_counter <= trig_counter + 1;
            end
        end
        else begin
            slow_trig <= 1'b0;
        end
    end

    // 鎖存數據
    reg signed [WIDTH-1:0] fir_input;
    logic signed [WIDTH+15:0] fir_output;

    always_ff @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            fir_input  <= 0;
        end 
        else if (slow_trig) begin  // 使用 `slow_trig` 來鎖存數據
            fir_input  <= din;
        end
    end

    // FIR 濾波器實例
    myfir_filter #(
        .N(N), 
        .WIDTH(WIDTH),
        .COEFF_SET(COEFF_SET)
    ) ADC3_fir_inst 
    (
        .clk(clk),
        .n_rst(n_rst),
        .din(fir_input),  
        .dout(fir_output) 
    );

    // 輸出處理
    always_ff @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            dout <= 32'b0;
        end 
        else dout <= (fir_output >>> 16);
    end

endmodule
