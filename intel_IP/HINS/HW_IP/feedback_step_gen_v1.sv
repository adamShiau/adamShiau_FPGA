// =========================================================================
// 檔案: feedback_step_gen_v1.sv
// 目的: 修正後的 Feedback Step Generator (符合 SystemVerilog 風格)
// =========================================================================

module feedback_step_gen_v1 (
    input logic i_clk,
    input logic i_rst_n,      // 系統同步重置 (Active Low)
    input logic i_trig,       // 來自 my_err_signal_gen_v1 的 o_step_sync
    input logic i_trig_dly,   // 來自 my_err_signal_gen_v1 的 o_step_sync_dly
    input signed [31:0] i_err,          // 誤差輸入 (來自 o_err_DAC)
    input [31:0] i_gain_sel,            // 增益控制輸入
    input [31:0] i_fb_ON,               // 回饋啟用控制
    input signed [31:0] i_const_step,   // 常數步進值
    
    output signed [31:0] o_step
    
    // For simulation only (使用 logic 代替 reg, 修正輸出連接)
    `ifdef SIMULATION
    , output logic [31:0] o_fb_ON_q
    , output logic signed [31:0] o_step_pre_q
    , output logic [31:0] o_gain_sel_q
    , output logic [31:0] o_gain_sel2_q
    , output logic [1:0] o_status_q
    , output logic o_change
    , output logic signed [31:0] o_step_init_q
    `endif
);

// -------------------------------------------------------------------------
// 內部訊號宣告 (使用 logic 替代 reg)
// -------------------------------------------------------------------------
logic [31:0] reg_gain_sel, reg_gain_sel2;
logic [31:0] reg_fb_ON;
logic reg_trig;
logic [1:0] r_status;
logic signed [31:0] reg_err;
logic signed [31:0] reg_step;
logic signed [32:0] reg_step_pre; 

// -------------------------------------------------------------------------
// 組合邏輯 (Derived parameters)
// -------------------------------------------------------------------------
wire [4:0] shift_amt = reg_gain_sel[4:0]; // 限制 shift 範圍

// 輸出訊號連接
assign o_step = reg_step;

`ifdef SIMULATION
    // 將內部暫存器輸出連接到 Port (使用 logic 確保 SystemVerilog 兼容)
    assign o_gain_sel_q = reg_gain_sel;
    assign o_gain_sel2_q = reg_gain_sel2;
    assign o_status_q = r_status;
    assign o_fb_ON_q = reg_fb_ON;
    assign o_step_pre_q = reg_step_pre;
    assign o_change = |(reg_gain_sel2[3:0] ^ reg_gain_sel[3:0]);
    assign o_step_init_q = reg_step; // 簡化 o_step_init 的設計
`endif


// =========================================================================
// 時序邏輯 (合併所有暫存器更新到單一 always_ff 區塊)
// =========================================================================

always_ff @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin // 修正為 SystemVerilog 的 Active Low reset 檢查
        // 1. 數據輸入暫存器重置
        reg_err <= 32'd0;
        reg_gain_sel <= 32'd5;
        reg_fb_ON <= 32'd0;
        reg_trig <= 1'b0; // 原始程式碼的 reg_trig
        r_status <= 2'd0;
        reg_gain_sel2 <= 32'd5;

        // 2. 步進暫存器重置
        reg_step <= 32'd0; 
        reg_step_pre <= 32'd0; 

    end else begin
        // ------------------------------------
        // 1. 數據輸入暫存器更新 (第一組邏輯)
        // ------------------------------------
        reg_err <= i_err;         // 延遲一週期採集 i_err
        reg_gain_sel <= i_gain_sel;
        reg_fb_ON <= i_fb_ON;
        reg_trig <= i_trig;       // 延遲一週期採集 i_trig

        // ------------------------------------
        // 2. 步進計算邏輯 (第二組邏輯)
        // ------------------------------------
        case (reg_fb_ON[1:0])
                2'd0: begin // Disabled
                reg_step <= 32'd0;
                reg_step_pre <= 32'd0;
            end
            
                2'd1: begin // 積分模式 (Integration Mode)
                if (i_trig) begin
                    // 執行累加 (在 i_trig 週期)
                    reg_step_pre <= $signed({1'b0, reg_step_pre}) + $signed(reg_err);
                end else if (i_trig_dly) begin
                    // 執行輸出與增益調整 (在 i_trig_dly 週期)
                    reg_step <= reg_step_pre >>> shift_amt;
                end
            end
            
                2'd2: begin // 常數步進模式 (Constant Step Mode)
                if (i_trig) begin
                    reg_step <= i_const_step;
                end
            end
            
            default: begin // 預設安全重置
                reg_step <= 32'd0;
                reg_step_pre <= 32'd0;
            end
        endcase
    end
end

endmodule