module dataMemory(
    input logic clk,
    input logic we,
    input logic [31:0] address,
    input logic [31:0] writeData,
    
    output logic [31:0] readData
);

logic [31:0] memory[127:0];

assign readData = memory[address[8:2]];

always_ff @(posedge clk)
    if (we) 
        memory[address[8:2]] <= writeData;

endmodule