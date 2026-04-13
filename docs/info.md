## How it works

This project implements a programmable clock generator that produces a wide range of output frequencies from a fixed 50 MHz input clock.

The output frequency is controlled using two inputs:
- Radix (ui_in[3:0]): selects a value from 1 to 9  
- Scale (ui_in[5:4]): selects frequency range  
  - 00 → kHz  
  - 01 → 10 kHz  
  - 10 → 100 kHz  
  - 11 → MHz  

Based on these inputs, a precomputed division factor (N) is selected using combinational logic. This value determines how many input clock cycles are required before toggling the output clock.

To ensure glitch-free operation during dynamic changes:
- The next division value (N_next) is computed continuously  
- It is updated into a register (N_reg) only when the counter resets (counter == 0)  

A 16-bit counter increments every clock cycle:
- When counter reaches N_reg, it resets to zero  
- At the same time, the output clock toggles  

This generates a stable square wave output with frequency:

f_out = f_in / (2 × N)

Key features:
- Glitch-free frequency switching  
- Fully synchronous design  
- Safe boundary-based updates  
- Wide programmable frequency range  

The TinyTapeout top module maps:
- ui_in[3:0] → radix  
- ui_in[5:4] → scale  
- uo_out[0] → clock output  

All unused IOs are safely tied off.

---

## How to test

1. Apply clock and reset:
   - Provide a 50 MHz clock to clk  
   - Set rst_n = 0 to reset  
   - Set rst_n = 1 to start  

2. Set control inputs:
   - Choose radix (1–9) using ui_in[3:0]  
   - Choose scale using ui_in[5:4]  

3. Observe output:
   - Output clock is available on uo_out[0]  
   - Measure using waveform viewer or hardware tools  

4. Verify behavior:
   - Changing radix or scale changes frequency  
   - Output updates only at safe boundaries (no glitches)  
   - Output remains a stable square wave  

Example:
- radix = 1, scale = 00 → ~1 kHz  
- radix = 5, scale = 11 → higher frequency (MHz range)  

---

## External hardware

No external hardware is required.

