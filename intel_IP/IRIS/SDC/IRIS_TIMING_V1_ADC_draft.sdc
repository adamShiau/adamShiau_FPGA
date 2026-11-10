# ----------------------------------------------------
# 檔案名稱: IRIS_TIMING_V1_ADC_draft.sdc
# 目的: ADC (LTC2145-14 x2) 介面時序約束草案 (2026-11-10)
# 狀態: 草案，2026-11-10 已加入 IRIS_PRJ_V1.qsf（第 64 行）：
#       set_global_assignment -name SDC_FILE ../../SDC/IRIS_TIMING_V1_ADC_draft.sdc
#       （放在 IRIS_TIMING_V1.sdc 之後，需要 derive_pll_clocks 先產生 PLL 時鐘）
# ----------------------------------------------------
#
# 時鐘路徑（LOGICAL 板 layout 量測）:
#   PLL_1 c0 (pll_clk_adc_int) -> Global clock -> CLOCK_ADC 腳 B20
#   -> R67 0R -> /PLL_ADC_CLK 走線 62.5 mm (整條 net 含兩分支，取作上限)
#   -> IC11 / IC12 DS90LV011A (TTL->LVDS) -> ADC_x_CLK_P/N 約 2-5 mm
#   -> 0.1u AC 耦合 (如 C94/C95、C101) -> ENC_x+/- 約 3 mm (R80/R85 100R 終端)
#   -> IC15 / IC16 LTC2145-14 ENC，極性為同相 (OUT+ -> ENC+)
# 資料路徑:
#   LTC2145-14 D1_x/D2_x (1.8 V CMOS, full rate) -> FPGA 腳
#   ADC_1_1 (IC15 D1): 4.8-9.5 mm；ADC_2_1 (IC16 D1): 4.1-12.4 mm；ADC_2_2 (IC16 D2): 4.5-13.1 mm
#   FPGA 以 PLL c4 (pll_clk_adc_cap_int，相位延後) 經 IOE 輸入暫存器 (FAST_INPUT_REGISTER) 取樣
#
# 注意: CLOCK_ADC 腳 B20 是 PLL2 的 dedicated CLKOUT，但目前 PLL 被放在 PLL_1，
#       所以實際走的是 global clock 到一般 IO，FPGA 輸出延遲較大，由 TimeQuest 計算。

# 1. 走線延遲 (ns/mm，FR4 估算: 表層約 0.006、內層約 0.007)
set TPD_MIN 0.006
set TPD_MAX 0.007

# 2. 時鐘到 ADC ENC 的板上延遲
#    走線: /PLL_ADC_CLK 62.5 mm + ADC_x_CLK 5.4 mm + ENC 3.6 mm (上限)；下限取 0 (hold 保守)
set CLK_TRACE_MAX [expr {(62.5 + 5.4 + 3.6) * $TPD_MAX}]
set CLK_TRACE_MIN 0.0
#    DS90LV011A tPHLD/tPLHD: 0.3 / 1.5 ns (min / max，TI datasheet SNLS094 Switching Characteristics)
set DRV_MIN 0.3
set DRV_MAX 1.5

# 3. LTC2145-14 ENC 到資料輸出延遲 tD (Full Rate CMOS, CL = 5 pF): 1.1 / 1.7 / 3.1 ns (min / typ / max)
#    出處: LTC2145-14 datasheet 21454314fa p.18 "Digital Data Outputs (CMOS Modes)"
#    （myKicad prj\IRIS\V2\doc\ADC_14bit_LTC2145.pdf）
#    輸出模式: NIOS 只寫 A0 reset 與 A4 = 0x01 (two's complement)，A3 保持預設 OUTMODE = 00 = Full Rate CMOS
set ADC_TD_MIN 1.1
set ADC_TD_MAX 3.1

# 4. 資料走線延遲 (三組匯流排一起約束，取最短 / 最長)
set DATA_TRACE_MIN [expr {4.1 * $TPD_MIN}]
set DATA_TRACE_MAX [expr {13.1 * $TPD_MAX}]

# 5. 輸入延遲 (相對於 FPGA 腳 CLOCK_ADC 的時鐘)
set ADC_IN_MAX [expr {$CLK_TRACE_MAX + $DRV_MAX + $ADC_TD_MAX + $DATA_TRACE_MAX}]
set ADC_IN_MIN [expr {$CLK_TRACE_MIN + $DRV_MIN + $ADC_TD_MIN + $DATA_TRACE_MIN}]

# 6. 送出到 ADC 的時鐘 (FPGA 腳上的 c0)，TimeQuest 會自動算入 FPGA 內部到 B20 的輸出延遲
create_generated_clock -name {ADC_ENC_PIN} \
    -source [get_pins {pll_inst|altpll_component|auto_generated|pll1|clk[0]}] \
    [get_ports {CLOCK_ADC}]

# 7. ADC 資料輸入延遲
set ADC_DATA_PORTS [get_ports {ADC_1_1[*] ADC_2_1[*] ADC_2_2[*]}]
set_input_delay -clock {ADC_ENC_PIN} -max $ADC_IN_MAX $ADC_DATA_PORTS
set_input_delay -clock {ADC_ENC_PIN} -min $ADC_IN_MIN $ADC_DATA_PORTS

# 8. 擷取時鐘 c4 (pll_clk_adc_cap_int) 相位延後於 c0，資料在 ENC 邊緣後下一個 c4 邊緣才收進 IOE 暫存器
#    預設分析會取同一週期的 c4 邊緣 (setup relationship = 相位)，改為 setup -end 2 (= 10 ns + 相位)。
#    hold 不另設：setup 2 之後預設 hold 對的就是同一週期的 c4 邊緣 (相位)，即前一筆資料被收進的那個邊緣，正是實際要檢查的。
#    (若再加 -hold -end 1，hold 會被推到前一週期，裕度看起來多出 10 ns，是錯的)
set ADC_CAP_CLK [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[4]}]
set_multicycle_path -from [get_clocks {ADC_ENC_PIN}] -to $ADC_CAP_CLK -setup -end 2

# 9. FIFO 寫入端 aclr 同步器 (dcfifo 內 dffpipe wraclr)：重置來源 r_locked_sync2 在 c3 域，
#    寫入端改用 c4 後 c3 -> c4 的 recovery relationship 只剩相位差 (1.5 ns)。
#    wraclr 本身就是非同步重置的同步器，此路徑不需時序關係，設 false path。
set_false_path -from [get_registers {r_locked_sync2}] -to [get_registers {*u_adc_sync_fifo|*|dffpipe_*:wraclr|*}]

# 10. 時鐘不確定度 (PLL jitter 等)，原 SDC 未設定
derive_clock_uncertainty
