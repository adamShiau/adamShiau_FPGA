# ----------------------------------------------------
# 檔案名稱: IRIS_TIMING_V1_IO.sdc
# 目的: DAC (AD9747 x2)、SDRAM (AS4C8M16SA-6) 介面與低速非同步 I/O 時序約束 (2026-11-10)
# 使用: IRIS_PRJ_V1.qsf 中放在 IRIS_TIMING_V1.sdc 之後 (需 derive_pll_clocks 先產生 PLL 時鐘)
# 板上長度: LOGICAL 板 layout 量測；datasheet 存於 myKicad prj\IRIS\V2\doc
# ----------------------------------------------------

set TPD_MIN 0.006   ;# ns/mm, FR4 表層估算
set TPD_MAX 0.007   ;# ns/mm, FR4 內層估算

# ====================================================
# 1. DAC: AD9747 dual-port, IC17 P1 = DAC_1_1, IC18 P1 = DAC_2_1, IC18 P2 = DAC_2_2
# ====================================================
# FPGA 端: DAC 資料由 c3 的 IOE 輸出暫存器 (FAST_OUTPUT_REGISTER) 送出；
#         c1 相位 -2500 ps (-90°)，讓 DAC 時鐘早於資料，平衡 setup / hold (2026-11-11)
# 時鐘: PLL c1 -> CLOCK_DAC 腳 AA3 (PLL1 dedicated CLKOUTp) -> R87 0R -> /DAC/PLL_DAC_CLK 33.9 mm (含兩分支，取上限)
#       -> IC13 / IC14 DS90LV011A (TTL->LVDS, tPHLD/tPLHD 0.3 / 1.5 ns) -> DAC_x_CLK_P_IN <= 3.4 mm
#       -> 0.1u AC 耦合 -> DAC_x_CLK_P <= 2.6 mm -> AD9747 CLKP，極性同相 (OUT+ -> CLKP)
# 資料: FPGA 直連 AD9747 P1D / P2D，5.3 - 18.4 mm，無串聯電阻
# AD9747 (datasheet Rev. A Table 5): tDBS setup 0.4 ns、tDBH hold 1.2 ns (相對 CLKP 上升緣)
set DAC_TS 0.4
set DAC_TH 1.2
set DAC_CLK_DLY_MAX [expr {(0.4 + 33.9 + 3.4 + 2.6) * $TPD_MAX + 1.5}]
set DAC_CLK_DLY_MIN 0.3
set DAC_DATA_MAX [expr {18.4 * $TPD_MAX}]
set DAC_DATA_MIN [expr {5.3 * $TPD_MIN}]

create_generated_clock -name {DAC_CLK_PIN} -source [get_pins {pll_inst|altpll_component|auto_generated|pll1|clk[1]}] [get_ports {CLOCK_DAC}]

set DAC_DATA_PORTS [get_ports {DAC_1_1[*] DAC_2_1[*] DAC_2_2[*]}]
set_output_delay -clock {DAC_CLK_PIN} -max [expr {$DAC_TS + $DAC_DATA_MAX - $DAC_CLK_DLY_MIN}] $DAC_DATA_PORTS
set_output_delay -clock {DAC_CLK_PIN} -min [expr {$DAC_DATA_MIN - $DAC_TH - $DAC_CLK_DLY_MAX}] $DAC_DATA_PORTS

# ====================================================
# 2. SDRAM: AS4C8M16SA-6 (128 Mb, 8M x16)，CAS latency 3，NIOS 程式在此執行
# ====================================================
# 時鐘: PLL c2 (-1250 ps) -> CLOCK_SDRAM 腳 A20 -> R66 0R -> /SDRAM/SDRAM_CLK -> IC9 CLK，共 <= 15.1 mm
# 訊號: A/BA/控制/DQ/DQM 5.2 - 22.3 mm
# AS4C8M16SA (datasheet v2.0 AC Characteristics, -6, CL = 3):
#   tAC 5 ns max、tOH 2.5 ns min、tIS 1.5 ns、tIH 0.8 ns
#   (註 9: CLK 上升時間 > 1 ns 時需加 tR/2 - 0.5 ns)
set SD_TAC 5.0
set SD_TOH 2.5
set SD_TIS 1.5
set SD_TIH 0.8
set SD_CLK_MAX [expr {15.1 * $TPD_MAX}]
set SD_CLK_MIN [expr {15.1 * $TPD_MIN}]
set SD_DATA_MAX [expr {22.3 * $TPD_MAX}]
set SD_DATA_MIN [expr {5.2 * $TPD_MIN}]

create_generated_clock -name {SDRAM_CLK_PIN} -source [get_pins {pll_inst|altpll_component|auto_generated|pll1|clk[2]}] [get_ports {CLOCK_SDRAM}]

set SD_OUT_PORTS [get_ports {SDRAM_ADDR[*] SDRAM_BA[*] SDRAM_CAS_N SDRAM_RAS_N SDRAM_WE_N SDRAM_CS_N SDRAM_CKE SDRAM_DQM[*] SDRAM_DQ[*]}]
set_output_delay -clock {SDRAM_CLK_PIN} -max [expr {$SD_TIS + $SD_DATA_MAX - $SD_CLK_MIN}] $SD_OUT_PORTS
set_output_delay -clock {SDRAM_CLK_PIN} -min [expr {$SD_DATA_MIN - $SD_TIH - $SD_CLK_MAX}] $SD_OUT_PORTS

set SD_IN_PORTS [get_ports {SDRAM_DQ[*]}]
set_input_delay -clock {SDRAM_CLK_PIN} -max [expr {$SD_CLK_MAX + $SD_TAC + $SD_DATA_MAX}] $SD_IN_PORTS
set_input_delay -clock {SDRAM_CLK_PIN} -min [expr {$SD_CLK_MIN + $SD_TOH + $SD_DATA_MIN}] $SD_IN_PORTS

# 讀取: SDRAM 在 CLK 上升緣後 tAC 才輸出，控制器 (c3) 在下一個 c3 邊緣取樣；
#       預設分析會取 SDRAM_CLK_PIN 之後最近的 c3 邊緣 (1.25 ns)，改為 setup 2
set_multicycle_path -from [get_clocks {SDRAM_CLK_PIN}] -to [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[3]}] -setup -end 2

# ====================================================
# 3. 低速 / 非同步 I/O：UART、I2C、SPI 設定介面、DRDY、同步輸出
#    (頻率 <= 數 MHz 或與 FPGA 時鐘無關，不需 I/O 時序關係)
# ====================================================
set_false_path -from [get_ports {FPGA_RX DBG_RX EXT_SYNC_IN DRDY_357 DRDY_ADC_TEMP ADC_CFG_MISO DAC_CFG_MISO SDA_357 SDA_ADC_TEMP SDA_EEPROM SCL_357 SCL_ADC_TEMP SCL_EEPROM}]
set_false_path -to [get_ports {FPGA_TX DBG_TX INT_SYNC DAC_RST ADC_CFG_MOSI ADC_CFG_SCLK DAC_CFG_MOSI DAC_CFG_SCLK CS_ADC_1 CS_ADC_2 CS_DAC_1 CS_DAC_2 SCL_357 SCL_ADC_TEMP SCL_EEPROM SDA_357 SDA_ADC_TEMP SDA_EEPROM}]
