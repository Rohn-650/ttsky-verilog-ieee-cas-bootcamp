## How it works

This project implements a programmable clock generator that produces a wide range of output frequencies from a fixed 50 MHz input clock.

The output frequency is controlled using two inputs:
- **Radix** (`ui_in[3:0]`): selects a multiplier value from 1 to 9
- **Scale** (`ui_in[5:4]`): selects the frequency range
  - `00` → 100 Hz base (output: 100 Hz – 900 Hz)
  - `01` → 1 kHz base  (output: 1 kHz – 9 kHz)
  - `10` → 10 kHz base (output: 10 kHz – 90 kHz)
  - `11` → 100 kHz base (output: 100 kHz – 900 kHz)

Based on these inputs, a precomputed division factor **N** is selected using combinational logic.
N represents the number of input clock cycles per half-period of the output clock.

The output frequency is:

**f_out = f_in / (2 × N)**

where N is precomputed as:

**N = 50,000,000 / (2 × radix × scale_base)**

To ensure glitch-free operation during dynamic changes:
- The next division value (`N_next`) is computed continuously in combinational logic
- It is latched into a register (`N_reg`) **only when the counter resets to zero**, ensuring updates happen only at a safe half-period boundary

An 18-bit counter increments every clock cycle:
- When the counter reaches `N_reg - 1`, it resets to zero
- At the same time, the output clock toggles

This generates a stable 50% duty-cycle square wave output.

Key features:
- Glitch-free frequency switching
- Fully synchronous design with active-low reset
- Safe boundary-based N updates (no mid-cycle glitches)
- Wide programmable frequency range: 100 Hz to 900 kHz in steps
- 18-bit counter to support large division factors (up to N = 250,000)

The TinyTapeout top module maps:
- `ui_in[3:0]` → radix
- `ui_in[5:4]` → scale
- `uo_out[0]`  → clock output

All unused IOs are safely tied off.

---

## How to test

1. **Apply clock and reset:**
   - Provide a 50 MHz clock to `clk`
   - Assert `rst_n = 0` to reset (counter, clk_out, and N_reg all cleared)
   - De-assert `rst_n = 1` to start

2. **Set control inputs:**
   - Set radix (1–9) on `ui_in[3:0]`
   - Set scale on `ui_in[5:4]`

3. **Observe output:**
   - Output clock is available on `uo_out[0]`
   - Measure period using a waveform viewer or oscilloscope

4. **Verify behavior:**
   - Changing radix or scale updates the output frequency
   - The update takes effect only at the next half-period boundary (no glitches)
   - Output remains a stable 50% duty-cycle square wave at all times

### Example Input–Output Mapping

| radix | scale | ui_in[5:0] | f_out    |
|-------|-------|------------|----------|
| 1     | 00    | 000001     | 100 Hz   |
| 5     | 00    | 000101     | 500 Hz   |
| 9     | 00    | 001001     | 900 Hz   |
| 1     | 01    | 010001     | 1 kHz    |
| 7     | 01    | 010111     | 7 kHz    |
| 4     | 10    | 100100     | 40 kHz   |
| 5     | 10    | 100101     | 50 kHz   |
| 1     | 11    | 110001     | 100 kHz  |
| 3     | 11    | 110011     | 300 kHz  |
| 6     | 11    | 110110     | 600 kHz  |

---

## External hardware

No external hardware is required.
