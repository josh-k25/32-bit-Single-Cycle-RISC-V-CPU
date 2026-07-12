module pcTarget(
    input logic [31:0] pc,
    input logic [31:0] immediateExtended,

    output logic [31:0] pcNextbeq
);

assign pcNextbeq = pc + immediateExtended;

endmodule
