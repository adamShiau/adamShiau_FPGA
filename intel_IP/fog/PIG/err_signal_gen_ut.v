module err_signal_gen_ut (
    input i_clk,
    input i_rst_n,
    input i_status,
    input i_polarity,
    input i_trig,
    input [31:0] i_wait_cnt,
    input signed [13:0] i_adc_data,  // ADC数据输入
    input [31:0] i_avg_sel,          // 平均选择
    output reg signed [31:0] o_err  // 输出误差
);

    // 寄存器定义
    reg [31:0] wait_cnt;
    reg [31:0] sample_cnt;
    reg signed [31:0] adc_sum;
    reg signed [31:0] adc_avg_pos;
    reg signed [31:0] adc_avg_neg;
    reg signed [31:0] adc_value;
    reg [31:0] avg_count;

    reg signed [31:0] pos_avg; // 正半周期平均值
    reg signed [31:0] neg_avg; // 负半周期平均值

    reg capturing;

    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            wait_cnt <= 0;
            sample_cnt <= 0;
            adc_sum <= 0;
            pos_avg <= 0;
            neg_avg <= 0;
            o_err <= 0;
            capturing <= 0;
        end else begin
            if (i_trig) begin
                // 触发信号到来，初始化等待
                wait_cnt <= i_wait_cnt;
                sample_cnt <= 0;
                adc_sum <= 0;
                avg_count <= (1 << i_avg_sel); // 计算平均数量
                capturing <= 0;
            end else if (wait_cnt > 0) begin
                // 等待周期
                wait_cnt <= wait_cnt - 1;
            end else if (sample_cnt < avg_count) begin
                // 收集ADC数据
                adc_sum <= adc_sum + i_adc_data;
                sample_cnt <= sample_cnt + 1;
                capturing <= 1;
            end else if (capturing) begin
                // 平均计算完成
                adc_value <= adc_sum / avg_count;
                capturing <= 0;
                if (i_status) begin
                    // 正半周期
                    pos_avg <= adc_value;
                end else begin
                    // 负半周期
                    neg_avg <= adc_value;
                end
            end

            if (!i_trig && !capturing && sample_cnt >= avg_count) begin
                // 计算误差
                if (i_polarity) begin
                    o_err <= pos_avg - neg_avg;
                end else begin
                    o_err <= neg_avg - pos_avg;
                end
            end
        end
    end

endmodule
