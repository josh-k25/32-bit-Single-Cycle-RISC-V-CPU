module immediateExtender(
    input logic [1:0] immediateSource,
    input logic [24:0] immediate,

    output logic [31:0] extendedImmediate
);


always_comb case (immediateSource)
    2'b00: extendedImmediate = {{20{immediate[24]}}, immediate[24:13]};
    2'b01: extendedImmediate = {{20{immediate[24]}}, immediate[24:18], immediate[4:0]};
    2'b10: extendedImmediate = {{20{Instr[24]}}, Instr[0], Instr[23:18], Instr[4:1], 1’b0}
    default: extendedImmediate = 32'h0000_0000;
endcase

endmodule