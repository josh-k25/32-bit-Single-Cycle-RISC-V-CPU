# 32-bit Single-Cycle RISC-V CPU

A SystemVerilog implementation of a single-cycle RISC-V processor supporting a subset of RV32I. The design is based on the architecture from Digital Design and Computer Architecture RISC-V edition by Harris and Harris, and verified with self-checking testbenches.

## Supported Instructions

| Category | Instructions |
|---|---|
| Arithmetic | `add`, `sub`, `addi` |
| Logical | `and`, `or` |
| Comparison | `slt` |
| Memory | `lw`, `sw` |
| Control flow | `beq`, `jal` |

## Architecture

This processor utilizes a single-cycle architecture, meaning that each instaruciton completes in one clock cycle. 

The design is divided into three main sections:

- **Controller:** Decodes the instruction and generates the required control signals.
- **Datapath:** Contains the program counter, register file, ALU, immediate extender, adders, and multiplexers.
- **Memory system:** Contains separate instruction and data memories.

The controller is further divided into:

- `mainDecoder`: Generates the main control signals from the opcode.
- `aluDecoder`: Selects the ALU operation using the instruction fields and `ALUOp`.

## Design Behavior
- The program counter and register file are updated on the rising edge of the clock.
- Instruction-memory reads are asynchronous.
- Data-memory reads are asynchronous.
- Data-memory writes occur on the rising edge of the clock.
- Register x0 always reads as zero and cannot be modified.
- The program counter normally advances by four.
- Taken branches and jumps replace PC + 4 with the calculated target address.
- Branch decisions are made using the ALU zero flag.
- Instructions and data are accessed using word-aligned addresses.

## Verification

The project contains 3 self checking testbenches

| Testbench | Purpose |
|---|---|
| controller_tb.sv | Verifies instruction decoding and generated control signals |
| datapath_tb.sv | Verifies register writes, ALU operations, immediate extension, PC updates, branches, jumps, and datapath selection |
| top_tb.sv | Runs a complete program through the processor, instruction memory, and data memory |

The testbenches use $fatal to stop the simulation when an incorrect result is detected.

## Integration Test

The integration test loads a program from program.hex. The program performs operations including:
- Register-immediate arithmetic
- Register-register arithmetic
- Loads and stores
- A loop using beq and jal
- Signed comparison using slt
- Taken and not-taken branches

The program reads the values 7 and -3 from data memory, processes them, and stores the expected result 5 at byte address 0x48.

The final pass condition is:
`dataMemory.memory[18] = 5`

## Running the Integration Test

The project can be compiled from the repository root using Icarus Verilog.

`iverilog -g2012 -s top_tb -o top_tb.vvp \
Processor/Controller/*.sv \
Processor/Datapath/*.sv \
Processor/Memory/*.sv \
Processor/processor.sv \
top.sv \
Processor/Testbenches/top_tb.sv`

Run the compiled simulation with:

`vvp top_tb.vvp`