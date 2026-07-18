`timescale 1ns/1ps

module datapath_tb;

logic clk;
logic reset;
logic [31:0] instruction;
logic [31:0] writeDataIn;

logic pcSource;
logic aluSource;
logic [1:0] resultSource;
logic [1:0] immediateSource;
logic registerWrite;
logic [2:0] aluControl;

logic [31:0] pc;
logic [31:0] aluResult;
logic [31:0] writeDataOut;
logic zero;

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

datapath dut(
    .clk(clk),
    .reset(reset),
    .instruction(instruction),
    .writeDataIn(writeDataIn),
    .pcSource(pcSource),
    .aluSource(aluSource),
    .resultSource(resultSource),
    .immediateSource(immediateSource),
    .registerWrite(registerWrite),
    .aluControl(aluControl)
);