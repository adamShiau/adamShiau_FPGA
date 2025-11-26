// =========================================================================
// 檔案: HINS_fog_v1.sv
// 目的: 整合調制 (my_modulation_gen_v1)、ADC同步 (adc_sync_buffer) 
//    和解調 (my_err_signal_gen_v1) 核心邏輯
// =========================================================================

module HINS_fog_v1 (
    // ============================ Common/System Signals (假設來自 PLL 輸出) ============================
    input logic CLOCK_ADC,    // 寫入時鐘域 (ADC 採樣時鐘)
    input logic CLOCK_CPU,    // 讀取/計算時鐘域 (NIOS 主頻)
    input logic RST_SYNC_N,   // 系統同步重置 (Active Low, 來自 PLL locked 處理)

    // ============================ ADC 接口 (外部 Port) ============================
    input logic [13:0] ADC,   // ADC raw input signal (14-bit)

    // ============================ Modulator/Control Parameters (來自 NIOS II) ============================
    input logic [31:0] var_freq_cnt, 
    input logic [31:0] var_amp_H,    
    input logic [31:0] var_amp_L,    
    input logic var_polarity,         
    input logic [31:0] var_wait_cnt,  
    input logic [31:0] var_err_offset,
    input logic [31:0] var_avg_sel,   

    // ============================ Output Signals (給 DAC 和後續 Feedback 邏輯) ============================
    output logic signed [31:0] o_err_DAC,    // 解調錯誤訊號 (o_err)
    output logic signed [31:0] o_mod_out_DAC // 調制方波輸出 (給 DAC 數據 Port)
);

// =========================================================================
// 內部訊號宣告 (Internal Signals)
// =========================================================================

// ---- 1. Modulator 輸出訊號 (my_modulation_gen_v1) ----
wire [31:0] mod_out;      // 方波數據輸出
wire mod_status;         // 方波極性狀態 (i_status for error gen)
wire mod_step_trig;      // 極性切換觸發 (i_trig for error gen)

// ---- 2. ADC 同步 FIFO 訊號 (adc_sync_buffer) ----
wire [13:0] adc_synced_data; // 經過 FIFO 同步後，在 CLOCK_CPU 域的 ADC 數據

// ---- 3. Error Generator 輸出訊號 (my_err_signal_gen_v1) ----
wire o_step_sync;
wire o_step_sync_dly;
wire o_rate_sync;
wire o_ramp_sync;

// -------------------------------------------------------------------------
// 頂層訊號連接 (Top-Level Signal Assignments)
// -------------------------------------------------------------------------

// 將調制模組的輸出連接到 DAC Port (這是簡化，稍後會加入混頻)
assign o_mod_out_DAC = mod_out;

// =========================================================================
// 模組例化區 (Module Instantiations)
// =========================================================================


// -------------------------------------------------------------------------
// A. ADC 數據時鐘域同步緩衝區 (CDC)
// -------------------------------------------------------------------------
adc_sync_buffer #(
    .DATA_WIDTH (14)
) u_adc_sync (
    // 寫入端 (ADC 域)
    .i_clk_wr   (CLOCK_ADC),    // ADC 採樣時鐘 (寫入時鐘)
    .i_data_wr   (ADC),       // 外部 ADC 數據 Port
    
    // 讀取端 (CPU 域)
    .i_clk_rd   (CLOCK_CPU),    // CPU/邏輯時鐘 (讀取時鐘)
    .i_rst_n    (RST_SYNC_N),    // 系統同步重置
    
    .o_data_rd   (adc_synced_data)  // 輸出給解調模組
);


// -------------------------------------------------------------------------
// B. 調制訊號產生器 (Modulation Generator)
// -------------------------------------------------------------------------
my_modulation_gen_v1 u_mod_gen (
    .i_clk         ( CLOCK_CPU ),      // 運行在 CPU 邏輯時鐘域
    .i_rst_n       ( RST_SYNC_N ),     // 同步重置
    
    // 參數輸入 (來自頂層/NIOS)
    .i_freq_cnt    ( var_freq_cnt ),   
    .i_amp_H       ( var_amp_H ),      
    .i_amp_L       ( var_amp_L ),      
    
    // 輸出
    .o_mod_out     ( mod_out ),        // 方波數據
    .o_status      ( mod_status ),     // 極性狀態 (給解調用)
    .o_stepTrig    ( mod_step_trig )   // 切換觸發 (給解調用)
);


// -------------------------------------------------------------------------
// C. 錯誤訊號產生器 (解調核心)
// -------------------------------------------------------------------------
my_err_signal_gen_v1 #(
    .ADC_BIT(14)  
) u_err_gen
    (
    .i_clk         ( CLOCK_CPU ),      // 運行在 CPU 邏輯時鐘域
    .i_rst_n       ( RST_SYNC_N ),     // 同步重置
    
    // 來自調制模組的同步訊號
    .i_status      ( mod_status ),     // 方波極性
    .i_trig        ( mod_step_trig ),  // 極性切換觸發
    
    // 來自頂層/NIOS 的參數
    .i_polarity    ( var_polarity ),     
    .i_wait_cnt    ( var_wait_cnt ),     
    .i_err_offset  ( var_err_offset ),   
    .i_avg_sel     ( var_avg_sel ),      

    // 數據輸入
    .i_adc_data    ( adc_synced_data ), // 來自 FIFO 同步後的數據 (安全連接)
    
    // 輸出
    .o_err         ( o_err_DAC ),      // 最終誤差輸出 (給 DAC/Feedback)
    
    // 脈衝輸出 (給後續的 Feedback 模組用)
    .o_step_sync   ( o_step_sync ),     
    .o_step_sync_dly( o_step_sync_dly ),  
    .o_rate_sync   ( o_rate_sync ),      
    .o_ramp_sync   ( o_ramp_sync ),      
    
    // 忽略除錯輸出
    .o_adc_sum     (), 
    .o_low_avg     (),
    .o_high_avg    (),
    .o_cstate      (),
    .o_nstate      ()
);

// =========================================================================
// 待辦事項：
// 1. 後續整合 feedback step gen, phase ramp gen, FIR filter。
// 2. 整合 ADC 數據混頻邏輯 (step_out + mod_out)。
// =========================================================================

endmodule