// =========================================================================
// 檔案: my_modulation_gen_v1_init.sv
// 目的: 範例化介面 (Instantiation Template) for my_modulation_gen_v1
// 建議: 將此區塊複製到 HINS_TOP_V1.sv 的 "核心 IP 例化區"
// =========================================================================

// -------------------------------------------------------------------------
// 內部訊號宣告 (Internal Signals)
// -------------------------------------------------------------------------

// 假設 NIOS Avalon-MM 總線連接到這個 IP 的參數
// [請替換為您的 NIOS 總線訊號，或使用專門的 Bridge]
// wire [31:0] ni_mod_freq; 
// wire signed [31:0] ni_mod_amp_h; 
// wire signed [31:0] ni_mod_amp_l; 

// 建議在內部宣告區段宣告這些訊號，例如：
// logic [31:0] mod_gen_freq_cnt;
// logic signed [31:0] mod_gen_amp_H; 
// logic signed [31:0] mod_gen_amp_L; 


// -------------------------------------------------------------------------
// MODULATION GEN V1 例化
// -------------------------------------------------------------------------

// 模組名稱: my_modulation_gen_v1
// 例化名稱: u_mod_gen

my_modulation_gen_v1 u_mod_gen (
    // 1. 時鐘與重置 (Clock & Reset)
    // ⚠️ 使用系統主時鐘和同步重置
    .i_clk         ( pll_clk_cpu_int ),   // 連接到系統主時鐘 (例如 pll_clk_cpu_int)
    .i_rst_n       ( RST_SYNC_N ),        // 連接到同步重置訊號 (RST_SYNC_N)
    
    // 2. 參數輸入 (來自 NIOS II 總線/控制邏輯)
    .i_freq_cnt    ( ni_mod_freq ),       // 頻率參數 (來自 NIOS 的暫存器輸出)
    .i_amp_H       ( ni_mod_amp_h ),      // 正半週振幅參數 (來自 NIOS 的暫存器輸出)
    .i_amp_L       ( ni_mod_amp_l ),      // 負半週振幅參數 (來自 NIOS 的暫存器輸出)
    
    // 3. 輸出 (連接到頂層 Port 或其他邏輯區塊)
    .o_mod_out     ( mod_out ),           // 方波數據輸出 (連接到 解調區塊 或 頂層 Port)
    .o_status      ( mod_status ),        // 方波當前極性狀態 (連接到 解調區塊)
    .o_stepTrig    ( mod_step_trig )      // 極性切換觸發訊號 (連接到 解調區塊 或除錯 Port)
);

// -------------------------------------------------------------------------
// 頂層訊號橋接 (Top-Level Signal Assignments)
// -------------------------------------------------------------------------

// 將模組的數據輸出連接到頂層 Port DAC_DATA_OUT (如果沒有混頻邏輯)
// assign DAC_DATA_OUT = mod_out;

// 如果需要經過解調和混頻邏輯，則 mod_out 需連接到解調模組