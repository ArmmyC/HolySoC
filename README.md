RISC-V RV32I Soft-Core SoC on Basys 3 (Artix-7)
🚀 Overview
This repository documents the implementation of a fully functional System-on-Chip (SoC) based on a custom RV32I (RISC-V 32-bit Integer) soft-core processor. The entire system is deployed on a Digilent Basys 3 FPGA development board (featuring the Xilinx Artix-7 XC7A35T).

The core differentiator of this project is the integration of a custom, in-house designed CPU (sourced from a separate core repository) with essential peripherals, demonstrating a complete programmable embedded system capability on the FPGA. This is a significant step beyond standard hardwired FPGA designs.

🔬 System-on-Chip (SoC) Architecture
Core CPU and Architecture
Core: Custom RV32I (32-bit Integer Instruction Set) Soft Processor.

Architecture: Implements a Pure/Modified Harvard Architecture (specify which one, as discussed previously) for instruction and data separation.

Datapath: Custom single-cycle/pipelined datapath implemented in VHDL/Verilog (specify which language), focusing on optimization for the Artix-7 fabric. (Reference the provided datapath image to highlight complexity.)

Integrated Peripherals
The CPU communicates with custom memory and I/O blocks via an on-chip bus fabric (e.g., AXI-Lite/custom bus).

UART Controller: Implemented for host communication (e.g., running printf and collecting user input via a terminal program).

I/O Handler: A dedicated memory-mapped peripheral to interface directly with the Basys 3 board's physical components:

Input: Reading state from switches and buttons.

Output: Controlling LEDs and displaying values on the 7-Segment Display.

💾 Software and Toolchain
This SoC is designed to execute programs compiled with the standard RISC-V GNU toolchain.

Toolchain: Utilizes the riscv-none-embed-gcc toolchain for cross-compilation.

Development Flow: Custom linker scripts and startup code allow C/C++ programs to be compiled directly into machine code that runs natively on the RV32I soft-core.

Demonstration: Includes example firmware demonstrating complex control logic (e.g., using the CPU to implement a software-based timer, state machine, or interrupt handler) that would be highly complex to implement using pure hardwired logic.

✨ Key Achievements & Showcase Value
This project goes beyond typical HDL labs by creating a truly programmable system.

Custom CPU Implementation: Successful creation and integration of a proprietary RISC-V core, demonstrating deep understanding of processor design principles.

Hardware-Software Co-Design: Shows the ability to write low-level C firmware that runs on the soft-core CPU to manage custom FPGA hardware peripherals.

Complete Embedded System: A functioning, self-contained system capable of running complex, high-level code, demonstrating capabilities closer to a microcontroller or dedicated ASIC than a standard FPGA.

📁 Repository Structure
cpu_core/: Source files for the RV32I datapath and control unit (linking to the base CPU repo).

peripherals/: HDL for the UART, I/O Handler, and Bus Interconnect logic.

hdl/top/: The top-level wrapper (.v or .vhd) that instantiates the CPU core and all peripherals.

software/: C/Assembly source code for bootloader (if applicable) and application firmware examples.

constraint/: Xilinx .xdc files for pin assignments on the Basys 3.

⚙️ Getting Started
Clone this repository and the base RV32I core repository.

Install the required RISC-V toolchain.

Compile the firmware in software/ to generate the .hex or .mem file for the Instruction Memory.

Synthesize and Implement the hardware design in Vivado (specify version if necessary).

Load the bitstream onto the Basys 3 and verify functionality via the UART terminal and board I/O.
