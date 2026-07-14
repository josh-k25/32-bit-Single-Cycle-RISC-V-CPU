module aluDecoder(
    input logic op5,
    input logic [1:0] aluOperation,
    input logic [2:0] funct3,
    input logic funct7,

    output logic [2:0] aluControl
);

always_comb case(aluOperation)
    2'b00: aluControl = 3'b000;

    2'b01: aluControl = 3'b001;

    2'b10: case(funct3)
            3'b000: if ({op5, funct7} != 2'b11)
                        aluControl = 3'b000;
                        else 
                            aluControl = 3'b001;
            
            3'b010: aluControl = 3'b101;
            
            3'b110: aluControl = 3'b011;

            3'b111: aluControl = 3'b010;
            
            default: 3'bxxx;
            endcase
    default: 3'bxxx;
endcase

endmodule