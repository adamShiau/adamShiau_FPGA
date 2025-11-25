# ----------------------------------------------------
# 腳本名稱: setup_project.tcl
# 目的: 自動化建立 HINS Quartus 專案 (.qpf & .qsf)
# ----------------------------------------------------

# 1. 定義專案變數
set project_name "HINS_TOP_V1"
set top_file_name "HINS_TOP_V1.sv"
set top_file_path "../TOP/${top_file_name}"  ;# <--- 修正路徑為相對 Scripts 的路徑
set device_family "Cyclone IV E"
set device_part "EP4CE15F17I7"

# 2. 建立專案
# 注意：將專案名稱 ($project_name) 放在最後，並將 -device 改為 -part
puts "--> 正在建立或覆蓋 Quartus 專案: ${project_name}"
project_new -overwrite -part $device_part $project_name

# 3. 設定專案設定 (.qsf)
set_global_assignment -name FAMILY $device_family
set_global_assignment -name TOP_LEVEL_ENTITY $project_name

# 4. 新增頂層檔案
# 這裡的路徑是相對於 QPF (即 HINS 資料夾)
puts "--> 正在新增頂層設計檔案: ${top_file_path}"
set_global_assignment -name VERILOG_FILE $top_file_path

# 5. 設定程式庫路徑 (Project Libraries)
# 這裡的路徑是相對於 QPF (即 HINS 資料夾)。
# 因為 TOP 資料夾就在 HINS 裡面，所以使用 TOP。
puts "--> 正在設定專案程式庫路徑: ../TOP 和 ../HW_IP"
set_global_assignment -name SEARCH_PATH "../TOP"
set_global_assignment -name SEARCH_PATH "../HW_IP"

# 6. 儲存專案
project_close
puts "✅ 專案建立完成。請在 Quartus Prime 中開啟 ${project_name}.qpf。"