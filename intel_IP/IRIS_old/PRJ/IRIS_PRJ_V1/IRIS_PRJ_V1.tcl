# ----------------------------------------------------
# 腳本名稱: setup_project.tcl
# 目的: 自動化建立 IRIS Quartus 專案 (.qpf & .qsf)
# ----------------------------------------------------

# 1. 定義專案變數
set project_name "IRIS_PRJ_V1"
set top_entity_name "IRIS_TOP_V1"
set top_file_name "IRIS1_TOP_V1.sv"
set device_family "Cyclone IV E"
set device_part "EP4CE40F23I7"

# --- 關鍵路徑定義 (基準點: IRIS/PRJ/IRIS_PRJ_V1) ---

# 頂層目錄 (IRIS/TOP)
set top_dir "../../TOP" 

# 硬體 IP 目錄 (IRIS/HW_IP)
set hw_ip_dir "../../HW_IP" 
set hw_ip_memory_dir "../../HW_IP/MEMORY" 
set hw_ip_adc_dir "../../HW_IP/ADC" 
set hw_ip_common_dir "../../HW_IP/Common"
set hw_ip_filter_dir "../../HW_IP/Filter"  
set hw_ip_accl_dir "../../HW_IP/ACCL"  
set fog_ip_dir  "../../HW_IP/FOG" 

# QSYS 檔案目錄 (IRIS/QSYS)
set qsys_dir "../../QSYS" 
set qsys_file_path "${qsys_dir}/CPU.qsys"

# SDC 檔案目錄 (IRIS/SDC)
set sdc_dir "../../SDC" 
set sdc_file_path "${sdc_dir}/IRIS_TIMING_V1.sdc"

# 頂層檔案的完整相對路徑
set top_file_path "${top_dir}/${top_file_name}" 

### 2. 建立專案 Tcl 命令


# 2. 建立專案
puts "--> Creating or overwriting Quartus project: ${project_name}"

project_new -overwrite -part $device_part $project_name

# 3. 設定專案設定 (.qsf)
set_global_assignment -name FAMILY $device_family
set_global_assignment -name TOP_LEVEL_ENTITY $top_entity_name

# 新增 SystemVerilog 語言標準設定 (重點修正)
set_global_assignment -name VERILOG_INPUT_VERSION SYSTEMVERILOG_2005

# 4. 新增頂層檔案
puts "--> Adding top-level design file: ${top_file_path}"
set_global_assignment -name SYSTEMVERILOG_FILE $top_file_path

# >>> 新增要求 1: 新增 CPU.qsys 檔案 <<<
puts "--> Adding Qsys/Platform Designer file: ${qsys_file_path}"
set_global_assignment -name QSYS_FILE $qsys_file_path

# 5. 新增其他必要的 Verilog 檔案 (FOG 核心和 HW_IP 根目錄)
puts "--> Adding FOG core IP files..."
# set_global_assignment -name SYSTEMVERILOG_FILE "${fog_ip_dir}/IRIS_fog_v1.sv"
# set_global_assignment -name SYSTEMVERILOG_FILE "${fog_ip_dir}/adc_sync_buffer.sv"
# set_global_assignment -name SYSTEMVERILOG_FILE "${fog_ip_dir}/my_err_signal_gen_v1.sv"
# set_global_assignment -name SYSTEMVERILOG_FILE "${fog_ip_dir}/my_modulation_gen_v1.sv"

# 6. 新增 IP 檔案 (位於 QPF 目錄下)
puts "--> Adding PLL/FIFO IP files (in QPF directory)..."
# set_global_assignment -name VERILOG_FILE "./pll.v"
# set_global_assignment -name VERILOG_FILE "./fifo.v"
# set_global_assignment -name QIP_FILE "./fifo.qip" 
set_global_assignment -name QIP_FILE "./PLL0.qip" 

# 7. 設定程式碼搜尋路徑 (Verilog/SystemVerilog 程式碼)
puts "--> Setting up search paths for code and IP Catalog..."

# 原始程式碼搜尋路徑
set_global_assignment -name SEARCH_PATH "${top_dir}" 
set_global_assignment -name SEARCH_PATH "${hw_ip_dir}"
set_global_assignment -name SEARCH_PATH "${fog_ip_dir}" 
set_global_assignment -name SEARCH_PATH "${hw_ip_memory_dir}"
set_global_assignment -name SEARCH_PATH "${hw_ip_adc_dir}"
set_global_assignment -name SEARCH_PATH "${hw_ip_common_dir}"
set_global_assignment -name SEARCH_PATH "${hw_ip_filter_dir}" 
set_global_assignment -name SEARCH_PATH "${hw_ip_accl_dir}"


# >>> 新增要求 2: 設定 IP Catalog 搜尋路徑 (已修正) <<<
set ip_search_path "../../../2018.1"
set_global_assignment -name SEARCH_PATH "$ip_search_path"


# >>> 新增要求 3: 設定 Dual-Purpose Pins 為普通 I/O (最終且確定正確的修正) <<<
puts "--> Setting Dual-Purpose Pins to AS_REGULAR_IO (QSF documented syntax)..."

# 1. Data[0]: 設為普通 I/O
set_global_assignment -name RESERVE_DATA0_AFTER_CONFIGURATION "USE AS REGULAR IO"

# 2. Data[1]/ASDO: 設為普通 I/O
set_global_assignment -name RESERVE_DATA1_AFTER_CONFIGURATION "USE AS REGULAR IO"

# 3. FLASH_nCE/cCSO: 設為普通 I/O
set_global_assignment -name RESERVE_FLASH_NCE_AFTER_CONFIGURATION "USE AS REGULAR IO"

# 4. DCLK: 設為普通 I/O
set_global_assignment -name RESERVE_DCLK_AFTER_CONFIGURATION "USE AS REGULAR IO"

# 5. nECO: 設為普通 I/O
set_global_assignment -name CYCLONEII_RESERVE_NCEO_AFTER_CONFIGURATION "USE AS REGULAR IO"

# >>> 新增要求 4: 設定 SDC 時序約束檔案路徑 <<<
puts "--> Adding SDC timing constraint file: ${sdc_file_path}"
set_global_assignment -name SDC_FILE $sdc_file_path


# 8. 執行腳位和時序約束 (關鍵步驟)
puts "--> Loading pin and timing constraint file..."
# <--- 確保 IRIS_PINS_V1.tcl 位於相同目錄下 --->
source ./IRIS_PINS_V1.tcl  

# 9. 儲存專案
project_close
puts "✅ Project creation complete. Open ${project_name}.qpf in Quartus Prime."