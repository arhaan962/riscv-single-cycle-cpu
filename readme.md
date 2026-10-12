# RISC-V Single-Cycle CPU

A Verilog implementation of a single-cycle RISC-V processor supporting 37 RV32I instructions, with a simulation testbench to observe register and data memory values during execution.

## Requirements

* [Icarus Verilog](https://steveicarus.github.io/iverilog/) — for compiling and simulating Verilog code.
* A terminal (VS Code recommended).

## How to Run

**1. Clone the repository**

```bash
git clone https://github.com/arhaan962/riscv-single-cycle-cpu.git
cd riscv-single-cycle-cpu
```

**2. Add instructions**

Open `src/instruction_memory.v` and edit the `initial` block to provide your own RISC-V machine instructions.

Instructions are stored as 32-bit hexadecimal values, for example:

```verilog
memory[0] = 32'h00A00093; // ADDI x1, x0, 10
memory[1] = 32'h00300113; // ADDI x2, x0, 3
memory[2] = 32'h002081B3; // ADD x3, x1, x2
```

Keep the instruction memory declaration and indexing unchanged unless you intend to modify the design.

**3. Compile**

Run from the project root:

```bash
iverilog -g2012 -Wall -o cpu_test.vvp src/*.v testbench/tb_riscv_cpu.v
```

**4. Run the simulation**

```bash
vvp cpu_test.vvp
```

The testbench displays the program counter, current instruction, register file, and the first 16 bytes of data memory after each clock cycle.

## Project Structure

```text
src/                  CPU and component modules
testbench/
                      Simulation testbench
```

## Notes

* Instructions are supplied as 32-bit machine-code values in hexadecimal.
* Instruction memory contains 16 words.
* The testbench runs a fixed number of clock cycles; adjust the `repeat` count in `tb_riscv_cpu.v` if needed.
* This project is intended for simulation using Icarus Verilog.
