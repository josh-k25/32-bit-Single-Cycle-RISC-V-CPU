module programCounter(
    input logic clk,
    input logic reset,
    input logic [31:0] pcNext,

    output logic [31:0] pc
);

always_ff @(posedge clk or posedge reset) begin
    if (reset)
        pc <= 32'h00000000;

    else 
        pc <= pcNext;
end
endmodule