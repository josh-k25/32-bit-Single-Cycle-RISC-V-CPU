module immediateExtender(
    input logic [1:0] immediateSource,
    input logic [24:0] immediate,

    output logic [31:0] extendedImmediate
);


always_comb case (immediateSource)
    //I type 
    2'b00: extendedImmediate = {{20{immediate[24]}}, immediate[24:13]};
    //S type
    2'b01: extendedImmediate = {{20{immediate[24]}}, immediate[24:18], immediate[4:0]};
    //B type 
    2'b10: extendedImmediate = {{20{immediate[24]}}, immediate[0], immediate[23:18], immediate[4:1], 1'b0};
    //J type
    2'b11: extendedImmediate = {{12{immediate[24]}}, immediate[12:5], immediate[13], immediate[23:14], 1’b0};
    default: extendedImmediate = 32'h0000_0000;
endcase

endmodule