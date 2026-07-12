module instructionMemory(
    input logic [31:0] pc,

    output logic [31:0] rd
);

logic [31:0] dataArray [127:0];


initial begin
    $readmemh("program.hex", dataArray);
end

assign rd = dataArray[pc[31:2]];

endmodule