// =========================================================================
// 檔案: HINS_fog_v1.sv
// 目的: 整合調制、ADC同步、解調核心、回饋步進產生器和相位斜坡產生器
//      【更新：使用獨立的增益參數 var_gainSel_step 和 var_gainSel_ramp】
// =========================================================================

module HINS_fog_v1 (
    // ============================ Common/System Signals ============================
    input logic CLOCK_ADC,    
    input logic CLOCK_CPU,    
    input logic RST_SYNC_N,   

    // ============================ ADC 接口 ============================
    input logic [13:0] ADC,   

    // ============================ Modulator/Control Parameters (來自 NIOS II) ============================
    input logic [31:0] var_freq_cnt, 
    input logic [31:0] var_amp_H,    
    input logic [31:0] var_amp_L,    
    input logic var_polarity,         
    input logic [31:0] var_wait_cnt,  
    input logic [31:0] var_err_offset,
    input logic [31:0] var_avg_sel,   

    // ======== 新增回饋控制參數 (來自 NIOS II) ========
    input logic [31:0] var_gainSel_step,  // 【新增】Step Gen 的增益
    input logic [31:0] var_gainSel_ramp,  // 【新增】Ramp Gen 的增益
    input logic [31:0] var_fb_ON,         // 回饋啟用/模式
    input logic signed [31:0] var_const_step, // 常數步進值

    // ============================ 輸出 ============================
    output logic signed [31:0] o_err_DAC,    
    output logic signed [31:0] o_mod_out_DAC,// Phase Ramp 輸出
    output logic signed [31:0] o_step        // 步進輸出 (給 CPU/Monitor)
);

// *************************************************************************
// * 內部訊號宣告 (Internal Signals) *
// *************************************************************************
wire [13:0] adc_synced_data;
wire mod_status;        
wire mod_step_trig;     
wire o_step_sync;       
wire o_step_sync_dly;   
wire o_rate_sync;       
wire o_ramp_sync;       
wire signed [31:0] mod_out_w;        
wire signed [31:0] phase_ramp_out_w;


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


// =========================================================================
// D. 回饋步進產生器 (Feedback Step Generator)
// =========================================================================
feedback_step_gen_v1 u_fb_step_gen (
    .i_clk         ( CLOCK_CPU ),      
    .i_rst_n       ( RST_SYNC_N ),     
    
    .i_trig        ( o_step_sync ),
    .i_trig_dly    ( o_step_sync_dly ),
    .i_err         ( o_err_DAC ),      
    
    // 【修正連接】使用 var_gainSel_step
    .i_gain_sel    ( var_gainSel_step ),
    .i_fb_ON       ( var_fb_ON ),
    .i_const_step  ( var_const_step ), 
    
    .o_step        ( o_step )          
    // ... (省略 Simulation 輸出)
);

// =========================================================================
// E. 相位斜坡產生器 (Phase Ramp Generator)
// =========================================================================
phase_ramp_gen_v1 #(.OUTPUT_BIT(32)) u_ramp_gen (
    .i_clk         ( CLOCK_CPU ),      
    .i_rst_n       ( RST_SYNC_N ),     
    
    .i_mod_trig    ( mod_step_trig ),  
    
    .i_step        ( o_step ),         
    .i_fb_ON       ( var_fb_ON ),      
    .i_mod         ( mod_out_w ),      
    
    // 【修正連接】使用 var_gainSel_ramp
    .i_gain_sel    ( var_gainSel_ramp ),   

    .o_phaseRamp_pre (), 
    .o_phaseRamp     ( phase_ramp_out_w ) 
);


// =========================================================================
// 最終輸出 Port 連接
// =========================================================================

assign o_mod_out_DAC = phase_ramp_out_w;

endmodule