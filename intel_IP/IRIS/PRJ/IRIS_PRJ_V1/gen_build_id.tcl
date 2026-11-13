# ----------------------------------------------------
# 檔案名稱: gen_build_id.tcl
# 目的: 每次全編譯前產生 TOP/build_id.vh (編譯日期 / 時間)，
#       由 IRIS_TOP_V1.sv 接到 VarSet i_var31 / i_var32，NIOS 開機時印出，
#       用來確認板上燒錄的是哪一次編譯 (2026-11-13)
# 使用: IRIS_PRJ_V1.qsf  PRE_FLOW_SCRIPT_FILE "quartus_sh:gen_build_id.tcl"
#       (只有 Start Compilation 全編譯會執行；工作目錄為專案資料夾)
# ----------------------------------------------------

set now  [clock seconds]
set date [clock format $now -format "%Y%m%d"]
set time [clock format $now -format "%H%M%S"]

set path [file join [pwd] .. .. TOP build_id.vh]
set fh [open $path w]
puts $fh "// 由 PRJ/IRIS_PRJ_V1/gen_build_id.tcl 於每次全編譯前自動產生，請勿手動修改"
puts $fh "`define FPGA_BUILD_DATE 32'h$date"
puts $fh "`define FPGA_BUILD_TIME 32'h00$time"
close $fh

post_message "gen_build_id: FPGA build $date $time -> $path"
