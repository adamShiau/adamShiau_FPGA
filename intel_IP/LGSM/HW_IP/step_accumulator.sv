// =============================================================
// 檔案: step_accumulator.sv
// 功能: 在 100Hz (sync_out) 週期內累加 300kHz 的 o_step 數據
// =============================================================

module step_accumulator (
    input  logic        i_clk,         // 使用 pll_clk_cpu_int
    input  logic        i_rst_n,       // 使用 RST_SYNC_N
    
    // 來自 FOG 核心的訊號
    input  logic        i_step_sync,   // 來自 u_err_gen.o_step_sync
    input  logic signed [31:0] i_step, // 來自 u_fb_step_gen.o_step
    
    // 來自 Top 的 Data Rate 同步訊號
    input  logic        i_sync_out,    // 來自 my_sync_gen.o_sync_out
    
    // 輸出至 Nios II (varset_1_i_var23, 24, 25)
    output logic [31:0] o_acc_step_low,
    output logic [31:0] o_acc_step_high,
    output logic [31:0] o_acc_count
);

    // 內部累加暫存器 (使用 64-bit 避免溢位)
    logic signed [63:0] r_acc_step;
    logic [31:0]        r_acc_count;
    
    // 影子暫存器 (用於穩定 Nios II 讀取)
    logic [63:0]        r_shadow_step;
    logic [31:0]        r_shadow_count;

    // 邊緣檢測 sync_out
    logic r_sync_out_d1;
    wire  w_sync_edge = (i_sync_out && !r_sync_out_d1);

    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            r_sync_out_d1  <= 1'b0;
            r_acc_step     <= 64'd0;
            r_acc_count    <= 32'd0;
            r_shadow_step  <= 64'd0;
            r_shadow_count <= 32'd0;
        end else begin
            r_sync_out_d1 <= i_sync_out;

            if (w_sync_edge) begin
                // 1. 鎖存當前累加結果到影子暫存器
                r_shadow_step  <= r_acc_step;
                r_shadow_count <= r_acc_count;
                
                // 2. 立即重置累加器，開始下一段 10ms 的計算
                // 如果在 sync_edge 同時有 i_step_sync，則保留該筆數據
                if (i_step_sync) begin
                    r_acc_step  <= 64'($signed(i_step));
                    r_acc_count <= 32'd1;
                end else begin
                    r_acc_step  <= 64'd0;
                    r_acc_count <= 32'd0;
                end
            end 
            else if (i_step_sync) begin
                // 平時根據調制週期進行累加
                r_acc_step  <= r_acc_step + 64'($signed(i_step));
                r_acc_count <= r_acc_count + 1'b1;
            end
        end
    end

    // 連接到輸出埠
    assign o_acc_step_low  = r_shadow_step[31:0];
    assign o_acc_step_high = r_shadow_step[63:32];
    assign o_acc_count     = r_shadow_count;

endmodule