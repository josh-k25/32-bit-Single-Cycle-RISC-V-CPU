module datapath(
    input logic clk,
    input logic reset,
    input logic [31:0] instruction,
    input logic [31:0] writeData

    input logic pcSource,
    input logic aluSource,
    input logic [1:0] resultSource,
    input logic [1:0] immediateSource,
    input logic registerWrite,
    input logic [2:0] aluControl,

    output logic [31:0] pc,
    output logic [31:0] aluResult,
    output logic [31:0] writeData,
    output logic zero
);
//internal signals for registerFile output
logic [31:0] registerData1;
logic [31:0] registerData2;

//internal signal for immediate extender output
logic [31:0] extendedImmediate;

//internal siignal for immediate for programCounter input
logic [31:0] pcNextInternal;
logic [31:0] pcPlus4Output;
logic [31:0] pcTargetOutput;

//alu second opearand
logic [31:0] aluInput;

//rd value written back
logic [31:0] result;

//program counter path
pcPlus4 pcPlus4Adder(
    pc, pcPlus4Output
);

pcTarget pcTargetAdder(
    pc, extendedImmediate, pcTargetOutput
);

pcNext pcNextMux(
    pcSource, pcPlus4Output, pcTargetOutput, pcNextInternal
);

programCounter pcRegister(
    clk, reset, pcNextInternal, pc
);


//register file and immediate path
registerFile registerFile(
    clk, instruction[19:15], instruction[24:20], instruction[11:7], result, writeData, registerWrite, registerData1, registerData2
    );

immediateExtender immediat eExtender(
    immediateSource, instruction[31:7], extendedImmediate
    );


//alu path
aluSource aluSource(
    aluControl, registerData2, extendedImmediate, aluInput
    );

alu aluInstance(
    registerData1, aluInput, aluControl, aluResult
);

assign zero = (aluResult == 32'b0);

//writeback path
resultSource resultSourceMux(
    resultSource, aluResult, readData, pcPlus4Output, result
);

//rd2 supplie vaoue stored by sw
assign writeData = registerData2;

endmodule