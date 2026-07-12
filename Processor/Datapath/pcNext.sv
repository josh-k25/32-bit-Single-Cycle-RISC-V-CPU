module pcNext(
    input logic pcSource,
    input logic [31:0] pcPlus4Output,
    input logic [31:0] pcTargetOutput,

    output logic [31:0] pcNextOutput
);

always_comb case(pcSource)
    1'b0: pcNextOutput = pcPlus4Output;
    1'b1: pcNextOutput = pcTargetOutput;
    default: pcNextOutput = 32'h0000_0000;
endcase

endmodule