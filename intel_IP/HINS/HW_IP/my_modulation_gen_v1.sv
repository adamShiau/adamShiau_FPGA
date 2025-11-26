module my_modulation_gen_v1 (
    input  logic         i_clk,
    input  logic         i_rst_n,
    
    // 參數輸入 (由 CPU 寫入，使用 logic)
    input  logic [31:0]  i_freq_cnt,
    input  logic signed  [31:0] i_amp_H, // 正半週振幅
    input  logic signed  [31:0] i_amp_L, // 負半週振幅
    
    // 輸出 (使用 logic 替代 reg)
    output logic signed  [31:0] o_mod_out,   // 方波輸出 (數據)
    output logic                o_status,    // 當前週期狀態 (HIGH: 正, LOW: 負)
    output logic                o_stepTrig   // 週期切換觸發訊號
);

// -------------------------------------------------------------------------
// 內部訊號宣告 (使用 logic 替代 reg)
// -------------------------------------------------------------------------
logic [31:0] cnt;       // 頻率計數器
logic polarity_q;      // 當前極性狀態 (q: current, next: next state)

// -------------------------------------------------------------------------
// 時序邏輯 (使用 always_ff 代替 always @(posedge...))
// -------------------------------------------------------------------------
always_ff @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        // 異步重置 (Asynchronous Reset)
        cnt          <= 0;
        polarity_q   <= 1'b0;
        o_mod_out    <= 0;
        o_stepTrig   <= 1'b0;
        o_status     <= 1'b0; // LOW
    end else begin
        o_stepTrig <= 1'b0; // 預設：沒有觸發 (必須在非重置區塊的第一行)

        if (cnt < i_freq_cnt) begin
            // increment counter
            cnt <= cnt + 1;
            o_stepTrig <= 1'b0;
        end else begin
            // reset counter and toggle polarity
            cnt <= 0;
            polarity_q <= ~polarity_q; 
            o_stepTrig <= 1'b1;
        end
        
        // 更新輸出和狀態 (基於切換後的 polarity_q)
        if (polarity_q) begin
            // 正半週：輸出 i_amp_H
            o_mod_out <= i_amp_H;
            o_status  <= 1'b1; // HIGH
        end else begin
            // 負半週：輸出 i_amp_L
            o_mod_out <= i_amp_L;
            o_status  <= 1'b0; // LOW
        end
    end
end

endmodule