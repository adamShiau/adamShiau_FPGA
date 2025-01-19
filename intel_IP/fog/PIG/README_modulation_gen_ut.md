# Usage Overview for `modulation_gen_ut`

The `modulation_gen_ut` module is a configurable square-wave generator that produces a waveform with distinct positive and negative amplitudes for its half-cycles. The output is synchronized with a clock signal and includes additional control signals for external monitoring or synchronization.

---

## Inputs

1. **`i_clk` (1 bit)**  
   - Clock signal driving the operation of the module.

2. **`i_rst_n` (1 bit)**  
   - Active-low asynchronous reset signal. When low, the module resets all internal states and outputs to their initial values.

3. **`i_freq_cnt` (32 bits)**  
   - Specifies the duration (in clock cycles) of one half-cycle of the waveform.  
   - For example, if `i_freq_cnt = 100`, the positive# Usage Overview for `modulation_gen_ut`

The `modulation_gen_ut` module is a configurable square-wave generator that produces a waveform with distinct positive and negative amplitudes for its half-cycles. The output is synchronized with a clock signal and includes additional control signals for external monitoring or synchronization.

---

## Inputs

1. **`i_clk` (1 bit)**  
   - Clock signal driving the operation of the module.

2. **`i_rst_n` (1 bit)**  
   - Active-low asynchronous reset signal. When low, the module resets all internal states and outputs to their initial values.

3. **`i_freq_cnt` (32 bits)**  
   - Specifies the duration (in clock cycles) of one half-cycle of the waveform.  
   - For example, if `i_freq_cnt = 100`, the positive or negative phase lasts 100 clock cycles, resulting in a full period of 200 clock cycles.

4. **`i_amp_H` (32 bits, signed)**  
   - The amplitude value for the positive half-cycle of the waveform.

5. **`i_amp_L` (32 bits, signed)**  
   - The amplitude value for the negative half-cycle of the waveform.

---

## Outputs

1. **`o_mod_out` (32 bits, signed)**  
   - The square-wave output, alternating between `i_amp_H` (positive phase) and `i_amp_L` (negative phase).

2. **`o_status` (1 bit)**  
   - Indicates the current cycle phase:
     - `1`: Positive half-cycle.
     - `0`: Negative half-cycle.

3. **`o_stepTrig` (1 bit)**  
   - A single-cycle trigger signal that pulses high every time the waveform switches phase (positive to negative or vice versa).  
   - Useful for downstream circuits that need to synchronize with the phase change.

---

## Functionality

1. **Waveform Generation**  
   - The module uses an internal counter (`cnt`) to measure clock cycles.  
   - When the counter reaches `i_freq_cnt - 1`, it resets and toggles the polarity (`polarity`) to alternate between positive and negative phases.  
   - The waveform's amplitude is determined by `i_amp_H` during the positive phase and by `i_amp_L` during the negative phase.

2. **Trigger Signal**  
   - The `o_stepTrig` output goes high for one clock cycle whenever the polarity switches, signaling the start of a new half-cycle.

3. **Cycle Status**  
   - The `o_status` output reflects the current phase:
     - `1` during the positive half-cycle.
     - `0` during the negative half-cycle.

---

## Example Usage

Here’s an example scenario for using the module:

- **Clock Frequency**: 100 MHz (`10 ns` per clock cycle).  
- **Desired Waveform Period**: 20 µs (50 kHz).  
  - Set `i_freq_cnt = 1000` (10 µs per half-cycle).  
- **Amplitude Settings**:
  - Positive amplitude: `i_amp_H = 1000`.  
  - Negative amplitude: `i_amp_L = -1000`.  

Expected outputs:
- `o_mod_out`: A square wave alternating between 1000 and -1000 every 10 µs.
- `o_stepTrig`: A single clock pulse every 10 µs, at the phase change.
- `o_status`: High during the positive half-cycle and low during the negative half-cycle.

---

## Advantages and Applications

1. **Configurable Square Wave**  
   - Easily adjust frequency and amplitudes by modifying `i_freq_cnt`, `i_amp_H`, and `i_amp_L`.

2. **Synchronization**  
   - The `o_stepTrig` output enables precise synchronization with other circuits at each phase change.

3. **Applications**  
   - Modulation, signal processing, or as a clock-like signal for testing other digital modules.

This module provides a flexible and efficient way to generate a controlled square waveform with phase monitoring and trigger capabilities.
 or negative phase lasts 100 clock cycles, resulting in a full period of 200 clock cycles.

4. **`i_amp_H` (32 bits, signed)**  
   - The amplitude value for the positive half-cycle of the waveform.

5. **`i_amp_L` (32 bits, signed)**  
   - The amplitude value for the negative half-cycle of the waveform.

---

## Outputs

1. **`o_mod_out` (32 bits, signed)**  
   - The square-wave output, alternating between `i_amp_H` (positive phase) and `i_amp_L` (negative phase).

2. **`o_status` (1 bit)**  
   - Indicates the current cycle phase:
     - `1`: Positive half-cycle.
     - `0`: Negative half-cycle.

3. **`o_stepTrig` (1 bit)**  
   - A single-cycle trigger signal that pulses high every time the waveform switches phase (positive to negative or vice versa).  
   - Useful for downstream circuits that need to synchronize with the phase change.

---

## Functionality

1. **Waveform Generation**  
   - The module uses an internal counter (`cnt`) to measure clock cycles.  
   - When the counter reaches `i_freq_cnt - 1`, it resets and toggles the polarity (`polarity`) to alternate between positive and negative phases.  
   - The waveform's amplitude is determined by `i_amp_H` during the positive phase and by `i_amp_L` during the negative phase.

2. **Trigger Signal**  
   - The `o_stepTrig` output goes high for one clock cycle whenever the polarity switches, signaling the start of a new half-cycle.

3. **Cycle Status**  
   - The `o_status` output reflects the current phase:
     - `1` during the positive half-cycle.
     - `0` during the negative half-cycle.

---

## Example Usage

Here’s an example scenario for using the module:

- **Clock Frequency**: 100 MHz (`10 ns` per clock cycle).  
- **Desired Waveform Period**: 20 µs (50 kHz).  
  - Set `i_freq_cnt = 1000` (10 µs per half-cycle).  
- **Amplitude Settings**:
  - Positive amplitude: `i_amp_H = 1000`.  
  - Negative amplitude: `i_amp_L = -1000`.  

Expected outputs:
- `o_mod_out`: A square wave alternating between 1000 and -1000 every 10 µs.
- `o_stepTrig`: A single clock pulse every 10 µs, at the phase change.
- `o_status`: High during the positive half-cycle and low during the negative half-cycle.

---

## Advantages and Applications

1. **Configurable Square Wave**  
   - Easily adjust frequency and amplitudes by modifying `i_freq_cnt`, `i_amp_H`, and `i_amp_L`.

2. **Synchronization**  
   - The `o_stepTrig` output enables precise synchronization with other circuits at each phase change.

3. **Applications**  
   - Modulation, signal processing, or as a clock-like signal for testing other digital modules.

This module provides a flexible and efficient way to generate a controlled square waveform with phase monitoring and trigger capabilities.
