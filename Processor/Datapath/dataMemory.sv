module dataMemory(
    input logic clk,
    input logic we,
    input logic [31:0] address,
    input logic [31:0] writeData,
    
    output logic [31:0] readData
);

logic [31:0] memory[255:0];

assign readData = memory[address[31:2]];

always_ff @(posedge clk)
    if (we) 
        memory[address[31:2]] <= writeData;

endmodule