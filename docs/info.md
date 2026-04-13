<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

# FlexiClock: Programmable Frequency Generator

## Project Description  
This project implements a programmable clock generator capable of producing output frequencies across multiple ranges using a fixed input clock. The design allows dynamic control over frequency using two parameters: radix and scale, enabling flexible and precise clock division.

The module is optimized for glitch-free operation, ensuring stable output even when configuration inputs change during runtime. This makes it suitable for digital systems requiring configurable timing signals.

---

## How it works  

The design is based on a counter-driven clock divider with runtime programmability.

### Core Concept  
The input clock (50 MHz) is divided using a programmable division factor N. The output clock toggles when a counter reaches N, generating a square wave.

### Frequency Control Parameters  

Radix (4-bit input):  
Range: 1 to 9  
Acts as a fine-grained frequency selector  

Scale (2-bit input):  
00 → kHz range  
01 → 10 kHz range  
10 → 100 kHz range  
11 → MHz range  

### Internal Operation  

A combinational block computes the required division factor N_next based on radix and scale. This value is not directly used to avoid glitches.

Instead, it is safely transferred into a register (N_reg) only when the counter resets. The counter increments every clock cycle:

- When counter == N_reg, the output toggles  
- Otherwise, the counter increments  

This ensures a stable and symmetric output waveform.

### Glitch-Free Switching  

Parameter updates occur only when the counter resets (counter = 0). This prevents frequency glitches, duty cycle distortion, and instability.

---

## How to test  

1. Apply a 50 MHz clock input  
2. Assert reset (rst_n = 0), then release (rst_n = 1)  
3. Provide different combinations of radix (1–9) and scale (00–11)  
4. Observe clk_out  

Expected behavior:  
- Output frequency changes based on inputs  
- No glitches during transitions  
- Output remains a stable square wave  

Example cases:

Scale 00, Radix 1 → ~1 kHz  
Scale 00, Radix 5 → ~5 kHz  
Scale 01, Radix 2 → ~20 kHz  
Scale 10, Radix 4 → ~400 kHz  
Scale 11, Radix 1 → ~1 MHz  

---

## Pin Mapping (Tiny Tapeout)

Inputs (ui_in):  
[3:0] → radix (1–9)  
[5:4] → scale  
[7:6] → unused  

Outputs (uo_out):  
[0] → clk_out  
[7:1] → unused (0)  

Bidirectional (uio):  
Not used  

Other signals:  
clk → system clock (50 MHz)  
rst_n → active-low reset  
ena → internally consumed  

---

## Architecture Overview  

- Combinational logic computes N_next  
- Register stores stable value N_reg  
- Counter performs clock division  
- Output toggles to generate clock  

---

## Key Features  

- Programmable frequency generation  
- Multi-scale operation (kHz to MHz)  
- Glitch-free dynamic reconfiguration  
- Efficient hardware design  
- Fully synchronous implementation  
- Tiny Tapeout compatible  

---

## External hardware  

Not required  

---

## Conclusion  

This project demonstrates a robust and scalable clock generation architecture suitable for FPGA and ASIC designs. Its glitch-free switching and flexible control make it reliable for timing-critical applications.
