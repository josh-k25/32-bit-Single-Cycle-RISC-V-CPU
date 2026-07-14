module resultSource(
    input logic [1:0] resultSourceControl,
    input logic [31:0] aluResultData,
    input logic [31:0] dataMemoryData,
    input logic [31:0] pcPlus4,

    output logic [31:0] resultSourceOutput
);

always_comb case(resultSourceControl) 
    2'b00: resultSourceOutput = aluResultData;
    2'b01: resultSourceOutput = dataMemoryData;
    2'b10: resultSourceOutput = pcPlus4;
    default: resultSourceOutput = 32'h0000_0000;
endcase

endmodule