// =========================================================================
// 檔案: phase_ramp_gen_v1.sv
// 目的: 相位斜坡產生器 (Phase Ramp Generator) - SystemVerilog 最終修正版
//    修正累積器溢位問題 (使用 64 位累積器)
// =========================================================================

module phase_ramp_gen_v1 #(
    parameter OUTPUT_BIT = 32
) (
    // ============================ 時鐘與重置 ============================
    input  logic i_clk,
    input  logic i_rst_n,           // 系統重置 (Active Low)
    
    // ============================ 觸發輸入 (未使用的 Port 已移除) ============================
    input  logic i_mod_trig,        // 積分/累積觸發 (來自 Modulator)
    
    // ============================ 數據與控制輸入 ============================
    input  logic signed [31:0] i_step,       // 步進/增量值 (來自 Feedback Step Gen)
    input  logic [31:0] i_fb_ON,             // 回饋啟用/模式選擇
    input  logic signed [31:0] i_mod,        // 調制方波訊號
    input  logic [31:0] i_gain_sel,          // 增益選擇/右移量

    // ============================ 輸出 ============================
    output logic signed [OUTPUT_BIT-1:0] o_phaseRamp_pre, // 預斜坡輸出
    output logic signed [OUTPUT_BIT-1:0] o_phaseRamp      // 最終相位斜坡輸出

    // ============================ 模擬輸出 (保留) ============================
    `ifdef SIMULATION
    , output logic [31:0] o_gain_sel_q
    , output logic [31:0] o_gain_sel2_q
    , output logic [1:0] o_status_q
    , output logic o_change
    , output logic signed [31:0] o_ramp_init_q
    `endif
);

// Parameters
localparam GAIN_INIT = 5;
localparam ACCUMULATOR_WIDTH = 64; // 擴展累積器位寬以防止溢位

// -------------------------------------------------------------------------
// 內部訊號宣告
// -------------------------------------------------------------------------
logic [31:0] reg_gain_sel, reg_gain_sel2;
logic [31:0] reg_fb_ON;
logic signed [31:0] reg_step;

// 修正：使用擴展位寬的累積器
logic signed [ACCUMULATOR_WIDTH-1:0] reg_ramp_pre_ext; 

// 修正：reg_ramp 保持 32 位輸出，o_phaseRamp_pre 保持 32 位
logic signed [OUTPUT_BIT-1:0] reg_ramp; 

// -------------------------------------------------------------------------
// 組合邏輯 (Outputs)
// -------------------------------------------------------------------------
assign o_phaseRamp_pre = reg_ramp_pre_ext[OUTPUT_BIT-1:0]; // 取累積器的低 32 位作為預覽

`ifdef SIMULATION
    // ... (模擬輸出邏輯保持不變) ...
    assign o_gain_sel_q = reg_gain_sel;
    assign o_gain_sel2_q = reg_gain_sel2;
    assign o_status_q = 2'd0; 
    assign o_change = |(reg_gain_sel2[3:0] ^ reg_gain_sel[3:0]);
    assign o_ramp_init_q = reg_ramp;
`endif


// =========================================================================
// 時序邏輯 (使用 always_ff)
// =========================================================================

always_ff @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin 
        // 1. 輸入暫存器重置
        reg_gain_sel <= GAIN_INIT;
        reg_gain_sel2 <= GAIN_INIT;
        reg_fb_ON <= 32'd0;
        reg_step <= 32'd0;
        
        // 2. 斜坡暫存器重置 (修正)
        reg_ramp_pre_ext <= 64'd0; // 重置擴展累積器
        reg_ramp <= 32'd0;
        o_phaseRamp <= 32'd0;

    end else begin
        
        // A. 輸入暫存器更新 (確保參數穩定)
        reg_gain_sel <= i_gain_sel;
        reg_gain_sel2 <= reg_gain_sel; 
        reg_fb_ON <= i_fb_ON;
        reg_step <= i_step;             
        
        // B. 斜坡邏輯 (Ramp Logic)
        case (reg_fb_ON)
            32'd0: begin // Disabled: 輸出調制訊號
                reg_ramp_pre_ext <= 64'd0;
                reg_ramp <= 32'd0;
                o_phaseRamp <= i_mod;
            end
            
            32'd1: begin // 積分模式 1 (Accumulation and Gain)
                if (i_mod_trig) begin
                    // 修正：執行 64 位累積。將 32 位 i_step 進行符號擴展到 64 位
                    reg_ramp_pre_ext <= reg_ramp_pre_ext + $signed({{32{reg_step[31]}}, reg_step}); 
                    
                    // 增益調整與輸出：將 64 位累積器右移，取低 32 位
                    reg_ramp <= reg_ramp_pre_ext >>> reg_gain_sel[4:0]; 
                    o_phaseRamp <= reg_ramp + i_mod;
                end
            end
            
            32'd2: begin // 積分模式 2 (Simple Accumulation)
                if (i_mod_trig) begin
                    // 執行 32 位累積 (存在溢位風險，但保持原設計意圖)
                    o_phaseRamp <= o_phaseRamp + reg_step;
                end
            end
            
            default: begin // 保持當前狀態 (確保時序一致性)
                reg_ramp_pre_ext <= reg_ramp_pre_ext;
                reg_ramp <= reg_ramp;
                o_phaseRamp <= o_phaseRamp;
            end
        endcase
        
    end
end

endmodule