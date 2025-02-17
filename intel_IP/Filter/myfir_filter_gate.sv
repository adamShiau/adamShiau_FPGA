module myfir_filter_gate #(
    parameter N = 32,               // 濾波器階數
    parameter WIDTH = 14,           // ADC數據位寬
    parameter logic signed [15:0] COEFF_SET [0:31] = '{ // default use coeff. N32FC5
        -54, -64, -82, -97, -93, -47, 66, 266, 562, 951,
        1412, 1909, 2396, 2821, 3136, 3304,
        3304, 3136, 2821, 2396, 1909, 1412, 951, 562, 
        266, 66, -47, -93, -97, -82, -64, -54
    }
)(
    input clk,
    input n_rst,
    input i_trig,
    input signed [WIDTH-1:0] din,  // 輸入數據
    output logic signed [31:0] dout // 濾波後數據
);


    reg fir_enable;
    reg signed [WIDTH-1:0] fir_input;
    logic signed [WIDTH+15:0] fir_output;

    // 鎖存數據
    always_ff @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            fir_enable <= 1'b0;
            fir_input  <= 0;
        end 
        else if (i_trig) begin
            fir_enable <= 1'b1;  // 啟動 FIR 濾波
            fir_input  <= din;   // 鎖存輸入數據
        end 
        else begin
            fir_enable <= 1'b0;
        end
    end

    myfir_filter #(
        .N(N), 
        .WIDTH(WIDTH),
        .COEFF_SET(COEFF_SET)
    ) ADC3_fir_inst 
    (
        .clk(clk),
        .n_rst(n_rst),
        .din(fir_input),  // 輸入數據, [WIDTH-1:0]
        .dout(fir_output) // 濾波後數據, [WIDTH+15:0]
    );

    always_ff @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            dout <= 32'b0;
        end 
        else dout <= (fir_output>>>16);
    end


endmodule
