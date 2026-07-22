module processor(
    input logic clk,
    input logic reset,
    input logic [31:0] instruction,
    input logic [31:0] readData,

    output logic memoryWrite,
    output logic [31:0] pc,
    output logic [31:0] dataAddress,
    output logic [31:0] writeData
);

logic zero;
logic aluSource;
logic registerWrite;
logic pcSource;
logic [1:0] immediateSource;
logic [1:0] resultSource;
logic [2:0] aluControl;

controller controller(
    instruction[6:0],
    zero,
    instruction[14:12],
    instruction[30],
    pcSource,
    resultSource,
    memoryWrite,
    aluSource,
    immediateSource,
    registerWrite,
    aluControl
);

datapath datapath(
    clk,
    reset,
    instruction,
    readData,
    pcSource,
    aluSource,
    resultSource,
    immediateSource,
    registerWrite,
    aluControl,
    pc,
    dataAddress,
    writeData,
    zero
);

endmodule