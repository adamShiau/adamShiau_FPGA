// =========================================================================
// 檔案: HINS_fog_v1.sv
// 目的: 整合調制、ADC同步、解調核心和回饋步進產生器 (Feedback Step Generator)
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

    // ======== 新增回饋控制參數 (來自 NIOS II) ========
    input logic [31:0] var_gain_sel,            // 增益控制輸入 (i_gain_sel)
    input logic [31:0] var_fb_ON,               // 回饋啟用控制 (i_fb_ON)
    input logic signed [31:0] var_const_step,   // 常數步進值 (i_const_step)
    
    // ============================ 輸出 Port ============================
    output logic [31:0] o_DAC_data,   // 給 DAC 的調制訊號輸出
    output logic o_mod_status,        // 調制極性狀態 (給外部監控)
    output logic o_step_sync_out,     // 步進同步訊號 (給外部監控)
    
    // ======== 新增回饋輸出 Port ========
    output logic signed [31:0] o_step           // 最終回饋步進輸出
);

// *************************************************************************
// * Internal Signals Declaration *
// *************************************************************************

// -------------------------------------------------------------------------
// A. 模組間連接線
// -------------------------------------------------------------------------

// 來自調制產生器 (my_modulation_gen_v1)
wire signed [31:0] mod_out_data;   // 調制方波數據
wire mod_status;                   // 調制極性狀態
wire mod_step_trig;                // 週期切換觸發

// 來自 ADC 同步緩衝區 (adc_sync_buffer)
wire [13:0] adc_synced_data;       // 14-bit 跨時鐘域後的 ADC 數據

// 來自錯誤產生器 (my_err_signal_gen_v1)
wire signed [31:0] o_err_DAC;       // 最終誤差輸出 (給 DAC/Feedback)
wire o_step_sync;                   // 步進同步脈衝 (給 Feedback Generator)
wire o_step_sync_dly;               // 延遲的步進同步脈衝
wire o_rate_sync;                   // 速率同步脈衝
wire o_ramp_sync;                   // 緩坡同步脈衝


// -------------------------------------------------------------------------
// B. 調制產生器 (Modulation Generator)
// -------------------------------------------------------------------------
my_modulation_gen_v1 u_mod_gen (
    .i_clk         ( CLOCK_CPU ),
    .i_rst_n       ( RST_SYNC_N ),
    .i_freq_cnt    ( var_freq_cnt ),
    .i_amp_H       ( var_amp_H ),
    .i_amp_L       ( var_amp_L ),
    .o_mod_out     ( mod_out_data ),
    .o_status      ( mod_status ),
    .o_stepTrig    ( mod_step_trig )
);

// -------------------------------------------------------------------------
// B-2. ADC 跨時鐘域緩衝區 (ADC Synchronization Buffer)
// -------------------------------------------------------------------------
adc_sync_buffer #(.DATA_WIDTH(14)) u_adc_sync_fifo (
    .i_clk_wr   ( CLOCK_ADC ),
    .i_clk_rd   ( CLOCK_CPU ),
    .i_rst_n    ( RST_SYNC_N ),
    .i_data_wr  ( ADC ),              // 來自外部 ADC (CLOCK_ADC domain)
    .o_data_rd  ( adc_synced_data )   // 給解調核心 (CLOCK_CPU domain)
);

// -------------------------------------------------------------------------
// C. 錯誤訊號產生器 (解調核心)
// -------------------------------------------------------------------------
my_err_signal_gen_v1 #(.ADC_BIT(14)) u_err_gen (
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
    .o_step_sync   ( o_step_sync ),    // 步進同步脈衝
    .o_step_sync_dly( o_step_sync_dly ),// 延遲步進同步脈衝
    .o_rate_sync   ( o_rate_sync ),    
    .o_ramp_sync   ( o_ramp_sync )     
    // 省略了 Simulation 用的輸出 Port...
);


// -------------------------------------------------------------------------
// D. 回饋步進產生器 (Feedback Step Generator)
//    功能: 根據 o_err_DAC 計算出最終的 o_step
// -------------------------------------------------------------------------
feedback_step_gen_v1 u_fb_step_gen (
    .i_clk         ( CLOCK_CPU ),      // 運行在 CPU 邏輯時鐘域
    .i_rst_n       ( RST_SYNC_N ),     // 同步重置
    
    // 來自錯誤產生器 (my_err_signal_gen_v1) 的訊號
    .i_trig        ( o_step_sync ),
    .i_trig_dly    ( o_step_sync_dly ),
    .i_err         ( o_err_DAC ),      // 來自解調後的誤差
    
    // 來自 NIOS II 的控制參數 (新加入的 port)
    .i_gain_sel    ( var_gain_sel ),
    .i_fb_ON       ( var_fb_ON ),
    .i_const_step  ( var_const_step ),
    
    // 輸出
    .o_step        ( o_step )          // 連接到 HINS_fog_v1 的輸出 port
    // 省略了 Simulation 用的輸出 Port...
);


// *************************************************************************
// * 頂層輸出連接 (External Output Assignment) *
// *************************************************************************

assign o_DAC_data      = mod_out_data;
assign o_mod_status    = mod_status;
assign o_step_sync_out = o_step_sync; // 將內部訊號連接到外部 Port
// o_step 已經在 u_fb_step_gen 實例化中直接連接

endmodule