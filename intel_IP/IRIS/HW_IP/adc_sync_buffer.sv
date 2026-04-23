// =========================================================================
// 檔案: adc_sync_buffer.sv
// 目的: 異步 FIFO 封裝 (Asynchronous FIFO Wrapper)
//    簡化接口，將 ADC 數據從 CLK_ADC 域傳輸到 CLK_CPU 域
// =========================================================================

module adc_sync_buffer #(
    parameter DATA_WIDTH = 14   // ADC 數據位寬 (根據 fifo.v 定義為 14)
) (
    // -------------------------------------------------------------------
    // 時鐘與重置
    // -------------------------------------------------------------------
    input  logic    i_clk_wr,    // 寫入時鐘域 (CLOCK_ADC)
    input  logic    i_clk_rd,    // 讀取時鐘域 (pll_clk_cpu_int)
    input  logic    i_rst_n,    // 系統重置 (RST_SYNC_N, Active Low)

    // -------------------------------------------------------------------
    // 數據 Port
    // -------------------------------------------------------------------
    input  logic [DATA_WIDTH-1:0] i_data_wr, // 來自 ADC_DATA_IN (外部 Port)
    output logic [DATA_WIDTH-1:0] o_data_rd // 同步後的輸出數據 (給解調模組)
);

// -------------------------------------------------------------------
// 內部 FIFO 訊號連接 (與 IP Port 名稱對應)
// -------------------------------------------------------------------
// 這些訊號必須存在，以控制 FIFO 的運作
wire aclr_sig;   // FIFO 異步清除訊號
wire rdreq_sig;   // 讀取請求
wire rdempty_sig;  // FIFO 空訊號
wire wrfull_sig;  // FIFO 滿訊號

// -------------------------------------------------------------------
// 內部邏輯驅動
// -------------------------------------------------------------------

// 1. 異步清除訊號 (aclr):
//   連接到重置訊號的反向 (假設 FIFO aclr 為 Active High)
assign aclr_sig = !i_rst_n; 


// 2. 寫入請求 (wrreq):
//   假設 ADC 數據持續有效，只要 FIFO 不滿就寫入
assign wrreq_sig = !wrfull_sig; 


// 3. 讀取請求 (rdreq):
//   假設解調模組持續消費，只要 FIFO 不空就讀取
assign rdreq_sig = !rdempty_sig;


// -------------------------------------------------------------------
// 異步 FIFO 核心例化 (使用您提供的 'fifo' 模組)
// -------------------------------------------------------------------

fifo fifo_inst (
  .aclr  ( aclr_sig ),    // 異步清除
  .data  ( i_data_wr ),   // 寫入數據 (ADC 域)
  .rdclk  ( i_clk_rd ),    // 讀取時鐘 (CPU 域)
  .rdreq  ( rdreq_sig ),   // 讀取請求 (內部自動驅動)
  .wrclk  ( i_clk_wr ),    // 寫入時鐘 (ADC 域)
  .wrreq  ( wrreq_sig ),   // 寫入請求 (內部自動驅動)
  .q    ( o_data_rd ),   // 讀出數據 (CPU 域)
  .rdempty ( rdempty_sig ),  // 讀取空訊號 (內部使用)
  .wrfull ( wrfull_sig )   // 寫入滿訊號 (內部使用)
);

endmodule