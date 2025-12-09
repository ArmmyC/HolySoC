# HolySoC: RISC-V RV32I Soft-Core SoC on Basys 3 (Artix-7)

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen)]() [![License](https://img.shields.io/badge/license-NonCommercial-blue)](LICENSE)

## What the Project Does

HolySoC is a fully functional System-on-Chip (SoC) implementation based on a custom RISC-V RV32I soft-core processor **from the [RV32I Core Repository](https://github.com/ArmmyC/ArmmyRV32I)**. Designed for deployment on the Digilent Basys 3 FPGA development board (featuring the Xilinx Artix-7 XC7A35T), this project integrates a custom CPU core with essential peripherals to create a complete programmable embedded system. It demonstrates the power of hardware-software co-design by combining custom hardware modules with firmware written in C.

## Why the Project is Useful

HolySoC provides a platform for learning and experimenting with:
- **Custom CPU Design**: Implements a RISC-V RV32I processor with single-cycle datapath and control logic. **Source Code is available in the [RV32I Core Repository](https://github.com/ArmmyC/ArmmyRV32I)**
- **Hardware-Software Co-Design**: Integrates peripherals like UART, LEDs, switches, and 7-segment displays with software running on the CPU.
- **FPGA Development**: Demonstrates how to build and deploy a fully functional SoC on the Basys 3 FPGA.
- **Educational Value**: Ideal for students and hobbyists to explore processor design, memory-mapped I/O, and embedded systems programming.

### Key Features
- **Custom RISC-V RV32I Processor**: Implements the 32-bit integer instruction set.
- **Memory-Mapped I/O**: Interfaces with switches, buttons, LEDs, and 7-segment displays.
- **UART Communication**: Enables interaction with a host terminal for debugging and data transfer.
- **Programmable Firmware**: Supports C/Assembly programs compiled with the RISC-V GNU toolchain.
- **Example Applications**: Includes a simple LED game and test programs to demonstrate functionality.

## How Users Can Get Started

### Prerequisites
1. **Hardware**: Digilent Basys 3 FPGA board.
2. **Software**:
   - Xilinx Vivado (tested with version 2025.1 or later).
   - RISC-V GNU toolchain (`riscv-none-embed-gcc`).

### Installation and Setup
1. **Clone the Repository**:
   
   ```bash
   git clone https://github.com/your-repo/HolySoC.git
   cd HolySoC
   ```
   
2. **Compile the Firmware**:
  - Use the RISC-V toolchain to compile C/Assembly programs in the game_1/ directory.
  - Example:
   
   ```bash
   riscv-none-embed-gcc -o game_LED.elf game_LED.c
   ```

3. **Generate Instruction Memory**:
  -  Convert the compiled program to a memory file:
    
  ```bash
  riscv-none-embed-objcopy -O verilog game_LED.elf instruction.mem
  ```

  - Replace the existing instruction.mem file with the generated one.

4. **Synthesize and Implement the Design**:
  - Open the project in Vivado.
  - Run synthesis, implementation, and generate the bitstream.

5. **Program the FPGA**:
  - Load the generated bitstream onto the Basys 3 board.
  - Ensure the instruction.mem file is correctly loaded into the instruction memory.
  
## Usage Example
  - **LED Game**:
    - Use the switches to adjust the game speed.
    - Press the buttons to interact with the game.
    - LEDs and the 7-segment display provide feedback.
    
## Where Users Can Get Help
  - Documentation: Refer to the comments in the source files for detailed explanations of each module.
  - Issues: Report bugs or request features via the GitHub Issues page.

## Who Maintains and Contributes
**Maintainer**:
  - ArmmyC: [ArmmyC's GitHub Profile](https://github.com/ArmmyC)

**Contributing**:
  - Contributions are welcome! Please follow the guidelines in the CONTRIBUTING.md file.

## License
This project is licensed under the Non-Commercial License. See the **[LICENSE](LICENSE)** file for details.
