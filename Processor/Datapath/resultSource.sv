module resultSource(
    input logic resultSourceControl,
    input logic [31:0] aluResultData,
    input logic [31:0] dataMemoryData,

    output logic [31:0] resultSourceOutput
);

always_comb case(resultSourceControl) 
    1'b0: resultSourceOutput = dataMemoryData;
    1'b1: resultSourceOutput = aluResultData;
    default: resultSourceOutput = 32'h0000_0000;
endcase

end