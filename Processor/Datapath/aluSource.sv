module aluSource(
    input logic aluSourceControl,
    input logic [31:0] registerData,
    input logic [31:0] immediateExtenderData,

    output logic [31:0] aluInput
);

always_comb case(aluSourceControl)
    1'b0: aluInput = registerData;
    1'b1: aluInput = immediateExtenderData;
    default: aluInput = 32'h0000_0000;
endcase

endmodule
