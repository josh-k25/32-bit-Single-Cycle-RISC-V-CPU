## July 11th, 2026

### dataMemory 
- Chose a depth of 256 (256/4 = 64 instructions) as it is a large enough amount of data to run test programs while remaining simple to address and simulate

- readData is assigned to memory[address[31:2]] since RISC-V is byte addressable, meaning the first 2 bits can be ignored

### instructionMemory
- dataArray has the same depth as the above for the same reason

- 