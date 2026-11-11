# FPGA 校正模組規劃（EM0 / IRIS V2）

> 建立：2026-11-11。狀態：**規劃，尚未開始實作**。
> 目的：把 MCU `sensor_data_cali()` 的校正運算移到 FPGA（Verilog），MCU 只保留姿態（AHRS）計算，以提高輸出更新率。
> 相關：MCU `D:\github\adamShiau_Arduino\IRIS1_MCU_V1.5-5`、本 repo `intel_IP\IRIS`、硬體紀錄 `myKicad\prj\IRIS\V2\doc\EM0_韌體對接核對.md`。

---

## 1. 背景與動機

| 項目 | 現況 | 說明 |
|---|---|---|
| NIOS | Nios II/e（`impl = Tiny`），無硬體乘法器、無除法器（`no_div`）、無 FPU；程式在 SDRAM 執行 | 軟體浮點很慢，因此目前盡量不讓 NIOS 算浮點 |
| MCU | ATSAMD21G18A，Cortex-M0+ 48 MHz，無 FPU | 校正（約 75 個 float 運算）＋ AHRS（約 500 個 float 運算＋約 25 次超越函數） |
| FPGA 資源（2026-11-11 編譯） | LE 32%、9-bit 乘法器 **0 / 232**、記憶體 3% | 硬體運算資源充裕 |
| 可用浮點 IP（Quartus Lite 18.1） | `altfp_mult`、`altfp_add_sub`、`altfp_div`、`altfp_inv_sqrt`、`altfp_sqrt`、`altfp_compare`、`altfp_convert`、`altfp_sincos`、`altfp_atan` 等 | `sincos`／`atan` 是否支援 Cyclone IV 待確認；校正只需 mult／add_sub／compare |

### 更新率估算（2026-11-11，未實測）
- FPGA → MCU 115200、48 B：每筆 4.17 ms，上限 240 Hz（實用約 200 Hz）。
- MCU → GUI 230400、64 B：每筆 2.78 ms，上限 360 Hz（實用約 290 Hz）；目前超過 230400 會不穩定（原因待查）。
- MCU 姿態運算估算每筆約 2–4 ms（超越函數影響最大）；校正約 0.1–0.2 ms。
- 只把校正移到 FPGA 對 MCU 負擔幫助有限；它的價值在於：資料出 FPGA 時已校正、NIOS 不必算浮點、之後可再把 step 平均與單位換算一併硬體化。
- 提高更新率另需：FPGA → MCU baud 提高（`uart` 為 `fixedBaud=false`，NIOS 可軟體設定）、MCU → GUI 不穩定問題、AHRS 程式優化（歐拉角只算一次、pitch／roll 不用圓形平均）、AHRS `init(100.0f)` 與資料率定義（目前只有 50／100／200 Hz）。

---

## 2. 要搬移的運算（MCU `src\common.cpp` `sensor_data_cali()`，V1.5-5）

以下 X／Y／Z 為 **MCU 感測器座標**（`sensor_raw.fog.fogx` 等）。注意與 FPGA 通道對應：MCU fogx ← FPGA `step_avg_z`（ch3，ADC_2_2）、fogy ← ch2（ADC_2_1）、fogz ← ch1（ADC_1_1）；溫度 tempx ← FPGA `tempz`、tempz ← FPGA `tempx`；加速度不對調。參數容器 paramX ↔ 指令 ch=3、paramZ ↔ ch=1（`update_parameter_container()`）。

### 2.1 運算順序（照 C 原始碼，硬體需保持相同順序）
1. 溫度：`tx, ty, tz`（各軸 PD 溫度）、`tacc`（ADXL357 溫度）。
2. Gyro SF：`sf_g = slope·T + offset`（各軸用自己的 T）。
3. Accel SF：`sf_a = slope·tacc + offset`。
4. Gyro bias（三段）：`T < T1` 用 (s1, o1)；`T < T2` 用 (s2, o2)；否則 (s3, o3)；`b_g = s·T + o`。
5. Accel bias：`b_a = slope·tacc + offset`。
6. 溫補：`g_comp = raw_g · sf_g − b_g`；`a_comp = raw_a · sf_a − b_a`。
7. Gyro misalignment：`g_cal = G · g_comp + c_g`（3×3＋偏移）。
8. Gyro 飽和：若 `limit > 0`，`g_cal` 夾在 ±limit。
9. Accel misalignment：`a_cal = A · a_comp + c_a`（3×3＋偏移）；**accel 不做飽和**。
10. 溫度、ADXL 溫度、time 原值輸出。

運算量：約 75 個 float 乘／加＋ 6 次三段比較＋ 3 次限幅比較；無除法、無超越函數。

### 2.2 參數對應（`PAR_LEN = 40`、`MIS_LEN = 30`）

| 用途 | 位置（paramX／Y／Z 各軸） | 數量 |
|---|---|---|
| Gyro 飽和上限 limit | `param[12]` | 3 |
| Gyro SF slope／offset | `param[17]`／`param[18]` | 6 |
| Gyro bias T1／T2 | `param[23]`／`param[24]` | 6 |
| Gyro bias s1, o1, s2, o2, s3, o3 | `param[25]`–`param[30]` | 18 |
| Accel SF slope／offset | `param[31]`／`param[32]` | 6 |
| Accel bias slope／offset | `param[33]`／`param[34]` | 6 |
| Accel 偏移 cax, cay, caz | `misalignment[0]`–`[2]` | 3 |
| Accel 矩陣 a11…a33 | `misalignment[3]`–`[11]` | 9 |
| Gyro 偏移 cgx, cgy, cgz | `misalignment[12]`–`[14]` | 3 |
| Gyro 矩陣 g11…g33 | `misalignment[15]`–`[23]` | 9 |
| **合計** | | **69 個 float32** |

參數本來就存在 FPGA 端 EEPROM（NIOS `memory_manage.c`），MCU 開機時以 `boot_capture_all` 從 FPGA 讀取，所以 FPGA 端不需另外搬參數。

---

## 3. 實作步驟

| 步驟 | 內容 | 需改硬體 | 產出 |
|---|---|---|---|
| 0. 建立基準 | Python float32（numpy）重寫 `sensor_data_cali()` 當標準答案；側錄 FPGA → MCU UART 原始封包（115200、48 B）當測試輸入；用 MCU 實際輸出比對，確認 Python 版與 MCU 一致 | 否 | `golden_cali.py`、測試向量 |
| 1. Verilog 模組＋模擬 | 獨立模組（暫名 `imu_cali.sv`），`altfp_mult`／`altfp_add_sub`／`altfp_compare`，float32、運算順序同 C；ModelSim（Quartus 附）跑測試向量，與 Python 逐筆比對 | 否（僅模擬） | 模組、testbench、比對報告 |
| 2. 接進 FPGA | 先用改動最少的接法：NIOS 照舊算好 11 個 float → 寫入模組 → 觸發 → 讀回 6 個校正值 → 打包。參數由 NIOS 開機時寫入新的參數暫存器組（現有 `GyroVarSet_60` 只有 60 個且大多已用，需新增一組或改用小型 RAM） | 是（QSYS／TOP） | 新 `.sof` |
| 3. 上板對照 | 除錯模式：FPGA 同時送原始值與校正值，MCU 也照舊自算一份，三者比較，差異應為 0 或極小 | 是（MCU 協定加模式或旗標） | 驗證紀錄 |
| 4. 正式切換 | MCU 新模式不再呼叫 `sensor_data_cali()`，只算 AHRS | 是（MCU、NIOS） | 新版韌體 |

### 之後可延伸
- `combine_step_avg()`（`lib\acq_imu.c`）：64-bit 整數轉 float 再相除，在 Nios II/e 上是軟體運算；可改硬體（`altfp_convert`＋`altfp_div`，或已知 count 時乘倒數）。
- ADXL357 刻度（`SENS_ADXL357_20G = 39e-6`）、ADXL 溫度 `(2332873 − 1105·raw)/10000`、ADS122C04 溫度換算、time × `COE_TIMER` 一併硬體化 → NIOS 只負責打包與傳送。
- AHRS：可做（共用浮點乘加單元＋狀態機＋`inv_sqrt`／CORDIC），但分支多、修改成本高，建議留在 MCU。

---

## 4. 驗證標準（待步驟 0 決定）
- 若步驟 0 確認 MCU 軟體浮點與 IEEE float32（round-to-nearest）結果一致，Verilog 版目標為 **bit-exact**。
- 否則以「每個輸出誤差 ≤ 1 ulp」為標準，並記錄最大差異。
- 測試向量需涵蓋：三段溫度區間與兩個邊界（T = T1、T = T2）、gyro 飽和上下限、`limit ≤ 0`（不飽和）、零輸入。

---

## 5. 開始前待決定
1. 步驟 0 的原始資料來源：USB-UART 轉接器側錄 FPGA → MCU 線（不改程式），或 MCU 開 `dumpPkt()`（`common.cpp`，目前 `acq_imu.cpp:52` 已註解）。
2. 參數暫存器做法：新增 register bank（Avalon-MM）或小型 RAM。
3. MCU 協定：新增模式，或在現有封包加「已校正」旗標。
4. 是否同時處理 MCU 的 `Serial.print("tx: ")`（`common.cpp:1479`，每筆執行、未受 `DEBUG_PRINT` 控制）。
