module controller(
    input logic [6:0] opcode,
    input logic zero,
    input logic [2:0] funct3, 
    input logic funct7Bit5,

    output logic pcSource,
    output logic [1:0] resultSource,
    output logic memoryWrite,
    output logic aluSource,
    output logic [1:0] immediateSource,
    output logic registerWrite,
    output logic [2:0] aluControl
);

logic [1:0] aluOperation;
logic branch;
logic jump;

aluDecoder aluDecoder(
    opcode[5], 
    aluOperation, 
    funct3, 
    funct7Bit5, 
    aluControl
);

mainDecoder mainDecoder(
    opcode, 
    branch, 
    jump, 
    resultSource, 
    aluSource,
    immediateSource, 
    registerWrite, 
    memoryWrite, 
    aluOperation
);

assign pcSource = (branch & zero) | jump;

endmodule
