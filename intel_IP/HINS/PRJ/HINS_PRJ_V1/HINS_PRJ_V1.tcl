# ----------------------------------------------------
# 腳本名稱: setup_project.tcl
# 目的: 自動化建立 HINS Quartus 專案 (.qpf & .qsf)
# ----------------------------------------------------

# 1. 定義專案變數
set project_name "HINS_PRJ_V1"
set top_entity_name "HINS_TOP_V1"
set top_file_name "HINS_TOP_V1.sv"
set device_family "Cyclone IV E"
set device_part "EP4CE15F17I7"

# --- 關鍵路徑定義 (基準點: HINS/PRJ/HINS_PRJ_V1) ---

# 頂層目錄 (HINS/TOP)
set top_dir "../../TOP" 

# 硬體 IP 目錄 (HINS/HW_IP)
set hw_ip_dir "../../HW_IP" 

# FOG IP 子目錄 (HINS/HW_IP/FOG)
set fog_ip_dir  "../../HW_IP/FOG" 

# 頂層檔案的完整相對路徑
set top_file_path "${top_dir}/${top_file_name}" 

### 2. 建立專案 Tcl 命令


# 2. 建立專案
puts "--> 正在建立或覆蓋 Quartus 專案: ${project_name}"
project_new -overwrite -part $device_part $project_name

# 3. 設定專案設定 (.qsf)
set_global_assignment -name FAMILY $device_family
set_global_assignment -name TOP_LEVEL_ENTITY $top_entity_name

# 新增 SystemVerilog 語言標準設定 (重點修正)
set_global_assignment -name VERILOG_INPUT_VERSION SYSTEMVERILOG_2005

# 4. 新增頂層檔案
puts "--> 正在新增頂層設計檔案: ${top_file_path}"
set_global_assignment -name SYSTEMVERILOG_FILE $top_file_path

# 5. 新增其他必要的 Verilog 檔案 (FOG 核心和 HW_IP 根目錄)
puts "--> 正在新增 FOG 核心 IP 檔案..."
# set_global_assignment -name SYSTEMVERILOG_FILE "${fog_ip_dir}/HINS_fog_v1.sv"
# set_global_assignment -name SYSTEMVERILOG_FILE "${fog_ip_dir}/adc_sync_buffer.sv"
# set_global_assignment -name SYSTEMVERILOG_FILE "${fog_ip_dir}/my_err_signal_gen_v1.sv"
# set_global_assignment -name SYSTEMVERILOG_FILE "${fog_ip_dir}/my_modulation_gen_v1.sv"

# 6. 新增 IP 檔案 (位於 QPF 目錄下)
puts "--> 正在新增 PLL/FIFO IP 檔案 (位於 QPF 目錄)..."
# set_global_assignment -name VERILOG_FILE "./pll.v"
# set_global_assignment -name VERILOG_FILE "./fifo.v"
set_global_assignment -name QIP_FILE "./fifo.qip" 
set_global_assignment -name QIP_FILE "./pll.qip" 

# 7. 設定程式庫路徑 (Project Libraries)
puts "--> 正在設定程式庫路徑..."
set_global_assignment -name SEARCH_PATH "${top_dir}" 
set_global_assignment -name SEARCH_PATH "${hw_ip_dir}"
set_global_assignment -name SEARCH_PATH "${fog_ip_dir}"


# 8. 執行腳位和時序約束 (關鍵步驟)
puts "--> 正在載入腳位和時序約束檔案..."
# <--- 確保 HINS_PINS_V1.tcl 位於相同目錄下 --->
source ./HINS_PINS_V1.tcl  

# 9. 儲存專案
project_close
puts "✅ 專案建立完成。請在 Quartus Prime 中開啟 ${project_name}.qpf。"