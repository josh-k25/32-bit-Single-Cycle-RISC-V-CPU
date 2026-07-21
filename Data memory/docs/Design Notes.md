## July 11th, 2026

### dataMemory 
- Chose a depth of 256 (256/4 = 64 instructions) as it is a large enough amount of data to run test programs while remaining simple to address and simulate

- readData is assigned to memory[address[31:2]] since RISC-V is byte addressable, meaning the first 2 bits can be ignored

### instructionMemory
- dataArray has the same depth as the above for the same reason

## July 15th, 2026

### controller testbench

Testing the following to ensure that the implemented instructions function as intended:

- lw
- sw
- add
- sub
- slt
- or
- and
- addi
- slti
- ori
- andi
- beq (not taken)
- beq (taken)
- jal
- unsupported opcode

## July 18th, 2026

### datapath testbench

Testing the following to ensure that the implemented instructions function as intended (what to look for):

- reset (PC = 0)
- PC update (PC increases by 4 when PCSource = 0)
- positive addi (immediate selected as ALU input, correct addition, result written to rd)
- negative addi (immediate is sign-extended correctly)
- add (two register values added and result written to rd)
- lw (address equals base register plus immediate, readData selected and written to rd)
- sw (address equals base register plus immediate, writeData equals the value from rs2)
- beq not taken (unequal registers produce zero = 0, next PC is PC + 4)
- beq taken (equal registers produce zero = 1, next PC is PC + branch immediate)
- backward beq (negative B-type immediate is sign-extended and added to the PC correctly)
- jal (next PC becomes PC + jump immediate, while the original PC + 4 is written to rd)
- write to x0 (attempted write is ignored and x0 remains zero)
- result-source selection (00 selects ALU result, 01 selects memory data, 10 selects PC + 4)
- ALU-source selection (0 selects register data, 1 selects the extended immediate)
