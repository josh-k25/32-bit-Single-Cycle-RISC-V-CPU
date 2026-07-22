module top(
    input logic clk,
    input logic reset,

    output logic memoryWrite,
    output logic [31:0] dataAddress,
    output logic [31:0] writeData
);

logic [31:0] pc;
logic [31:0] instruction;
logic [31:0] readData;

processor processor(
    clk,
    reset,
    instruction,
    readData,
    memoryWrite,
    pc,
    dataAddress,
    writeData
);

dataMemory dataMemory(
    clk,
    memoryWrite,
    dataAddress,
    writeData,
    readData
);

instructionMemory instructionMemory(
    pc,
    instruction
);

endmodule
