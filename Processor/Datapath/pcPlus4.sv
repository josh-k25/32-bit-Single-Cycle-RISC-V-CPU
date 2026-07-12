module pcPlus4(
    input [31:0] pc,

    output [31:0] pcNext
);

assign pcNext = pc + 4;

endmodule