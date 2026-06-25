<!-- prettier-ignore -->
<div align="center">

# HolySoC

*Small FPGA system-on-chip with a custom RV32I-style processor, memory-mapped I/O, and bare-metal firmware examples.*

![Verilog](https://img.shields.io/badge/Verilog-RTL-blue?style=flat-square)
![RISC-V](https://img.shields.io/badge/RISC--V-RV32I-283272?style=flat-square&logo=riscv&logoColor=white)
![FPGA](https://img.shields.io/badge/FPGA-Basys_3-ff6f00?style=flat-square)
![Vivado](https://img.shields.io/badge/Vivado-project-8a2be2?style=flat-square)
![UART](https://img.shields.io/badge/UART-115200_baud-009688?style=flat-square)

[Overview](#overview) • [Features](#features) • [Get started](#get-started) • [Memory map](#memory-map) • [Firmware](#firmware) • [Simulation](#simulation)

</div>

HolySoC is a compact FPGA SoC built around a custom single-cycle, RV32I-style 32-bit processor. The design targets the Digilent Basys 3 board and connects the CPU to instruction memory, data memory, switches, push buttons, LEDs, a four-digit seven-segment display, and a 115200-baud UART through memory-mapped I/O.

> [!NOTE]
> This is a learning-oriented hardware project, not a drop-in replacement for a production RISC-V core. The RTL is designed to be readable, inspectable, and easy to extend.

## Overview

The top-level [`HolySoC`](./sources_1/new/HolySoC.v) module wires together the processor core, RAM, address decoder, board I/O registers, debounced button input, and UART peripherals. The Basys 3 board clock runs at 100 MHz. The CPU and data-path peripherals use a divided 1 MHz clock, while UART and button debouncing stay on the board clock.

```text
Basys 3 board
  ├─ 100 MHz clock, reset, switches, buttons
  ├─ HolySoC top-level RTL
  │   ├─ RV32I-style single-cycle CPU
  │   ├─ 1024-word instruction memory
  │   ├─ 1024-word data memory
  │   ├─ MMIO address decoder
  │   ├─ LED and seven-segment output registers
  │   ├─ button synchronizer, debouncer, and event latch
  │   └─ UART RX/TX
  └─ firmware loaded from instruction.mem
```

## Features

- **Custom 32-bit processor core** with program counter, register file, ALU, immediate generator, branch logic, load extension, and write-back muxes.
- **RV32I-style instruction support** for arithmetic, logic, shifts, loads, stores, branches, jumps, `LUI`, and `AUIPC` flows used by the examples.
- **Harvard-style memory split** with instruction memory loaded from `instruction.mem` and separate data RAM.
- **Memory-mapped board I/O** for switches, LEDs, buttons, seven-segment segments, seven-segment digit enables, and UART.
- **Button event capture** with synchronization, approximately 10 ms debounce filtering, and latched rising-edge flags.
- **UART peripheral** with 115200-baud transmit and receive from the 100 MHz board clock.
- **Example firmware** in C, generated assembly, and machine-code text files.
- **Simulation testbenches** for core modules and the full SoC.

## Project structure

```text
.
├── sources_1/new/      Synthesizable Verilog RTL and instruction memory image
├── sim_1/new/          Verilog simulation testbenches
├── constrs_1/new/      Basys 3 pin and clock constraints
├── game_1/             Example C programs, assembly, and machine-code files
├── img/                Documentation images
└── README.md
```

## Get started

### Prerequisites

- Digilent Basys 3 FPGA board, or the equivalent `xc7a35tcpg236-1` Artix-7 target
- AMD/Xilinx Vivado
- Optional: RV32I-capable bare-metal GCC toolchain for rebuilding example programs
- Optional: Verilog simulator for running the included testbenches

> [!IMPORTANT]
> This repository does not currently include a Vivado `.xpr` project or a scripted build flow. Create a Vivado RTL project and add the source, constraint, and memory files manually.

### Create a Vivado project

```bash
git clone https://github.com/ArmmyC/HolySoC.git
cd HolySoC
```

1. Create a new Vivado RTL project for the Basys 3 board, or select device `xc7a35tcpg236-1`.
2. Add every `.v` file in `sources_1/new/` as design sources.
3. Add `sources_1/new/instruction.mem` as a memory initialization file.
4. Add every `.xdc` file in `constrs_1/new/` as constraints.
5. Set `HolySoC` as the synthesis top module.
6. Run synthesis, implementation, and bitstream generation.
7. Program the Basys 3 board.

> [!WARNING]
> [`InstructionMemory.v`](./sources_1/new/InstructionMemory.v) currently uses an absolute local path in `$readmemh`. Replace that string with `instruction.mem`, or with the memory file path used by your Vivado project, before running the design on another machine.

## Architecture

### Core datapath

The CPU is organized as a single-cycle datapath. [`RV32I_Core.v`](./sources_1/new/RV32I_Core.v) connects the main control unit, instruction memory, register file, ALU, immediate extender, branch target adder, load extender, and muxes for PC and register write-back.

The control unit decodes the major RV32I instruction families used by the project:

| Instruction family | Opcode | Notes |
| --- | --- | --- |
| R-type ALU | `0110011` | Register-register arithmetic, logic, shifts, and comparisons |
| I-type ALU | `0010011` | Register-immediate arithmetic and logic |
| Loads | `0000011` | Byte, halfword, word, signed and unsigned extension |
| Stores | `0100011` | Byte, halfword, and word writes |
| Branches | `1100011` | Equality and signed/unsigned comparison branches |
| `JAL` | `1101111` | PC-relative jump and link |
| `JALR` | `1100111` | Register-relative jump and link |
| `LUI` | `0110111` | Upper-immediate write-back |
| `AUIPC` | `0010111` | PC plus upper immediate |

### Memory map

| Address | Access | Peripheral | Value |
| --- | --- | --- | --- |
| `0x00000000` and above | Read/write | Data RAM | 1024 x 32-bit words, indexed by address bits `[11:2]` |
| `0x10000000` | Read | Switches | Basys 3 switches in bits `[15:0]` |
| `0x10000004` | Write | LEDs | Basys 3 LEDs from bits `[15:0]` |
| `0x10000008` | Read/write | Buttons | Read latched rising-edge flags in bits `[3:0]`; any write clears them |
| `0x1000000C` | Write | Seven-segment segments | Segment outputs from bits `[6:0]` |
| `0x10000010` | Write | Seven-segment digits | Digit enables from bits `[3:0]` |
| `0x10000014` | Read | UART status | Bit 0: RX ready, bit 1: TX busy |
| `0x10000018` | Read/write | UART data | Read received byte or write transmit byte in bits `[7:0]` |

The Basys 3 seven-segment segment and digit outputs are active low.

## Firmware

Instruction memory is loaded from [`sources_1/new/instruction.mem`](./sources_1/new/instruction.mem). The file contains one 32-bit hexadecimal instruction per line and is addressed as 1024 words starting at `0x00000000`.

The [`game_1/`](./game_1) directory contains example programs:

| File | Purpose |
| --- | --- |
| `game_LED.c` | LED timing example controlled by switches and button events |
| `Test.c` | Basic LED and seven-segment output test |
| `*.s` | Generated RV32I assembly |
| `*.txt` | Machine-code output used as a reference for `instruction.mem` |

Example MMIO usage:

```c
#define ADDR_SWITCHES ((volatile unsigned int *)0x10000000)
#define ADDR_LEDS     ((volatile unsigned int *)0x10000004)

unsigned int switches = *ADDR_SWITCHES;
*ADDR_LEDS = switches;
```

To load a different program, build it for RV32I with the ILP32 ABI and a bare-metal entry point at address zero, convert the executable instructions into the same one-word-per-line hexadecimal format, then replace `instruction.mem`.

> [!NOTE]
> Firmware build automation and a linker script are not included yet. The exact compile, link, and conversion commands depend on the RISC-V toolchain you install.

## Simulation

Testbenches are available in [`sim_1/new/`](./sim_1/new):

| Testbench | Scope |
| --- | --- |
| `tb_ALU.v` | Steps through ALU control values |
| `tb_InstructionMemory.v` | Reads the first instruction words |
| `tb_RV32I_Core.v` | Clocks and resets the processor core |
| `tb_HolySoC.v` | Clocks and resets the top-level SoC |

Add the desired testbench as a Vivado simulation source and set it as the simulation top.

> [!CAUTION]
> The included testbenches are waveform-oriented, not self-checking. Some interfaces have evolved, so strict simulators may require small port-list updates before a testbench runs cleanly.

## Known limitations

- No checked-in Vivado project file or automated build script.
- `InstructionMemory.v` needs its `$readmemh` path made portable before use outside the original workspace.
- Testbenches are useful for waveform inspection, but they are not a complete regression suite.
- Firmware examples are minimal and do not include a full linker script or build pipeline.
- The CPU is intended as a readable educational core and has not been presented as formally verified RV32I compliance.

## Suggested next steps

- Replace the absolute instruction memory path with a portable project-relative path.
- Add a Vivado TCL build script for project creation, synthesis, implementation, and bitstream generation.
- Add a small firmware linker script and repeatable `make` flow for C-to-`instruction.mem` builds.
- Convert key testbenches into self-checking tests.
- Document supported instruction behavior with directed tests for every implemented opcode family.
