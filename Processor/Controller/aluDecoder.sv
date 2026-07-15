module aluDecoder(
    input logic op5,
    input logic [1:0] aluOperation,
    input logic [2:0] funct3,
    input logic funct7Bit5,

    output logic [2:0] aluControl
);

always_comb case(aluOperation)
    //add (lw, sw)
    2'b00: aluControl = 3'b000;
    
    //sub (beq)
    2'b01: aluControl = 3'b001;

    2'b10: case(funct3)
            3'b000: if ({op5, funct7Bit5} != 2'b11)
                        //add (add)
                        aluControl = 3'b000;
                        else 
                            //sub (sub)
                            aluControl = 3'b001;
            
            //slt (slt)
            3'b010: aluControl = 3'b101;
            
            //or (or)
            3'b110: aluControl = 3'b011;

            //and (and)
            3'b111: aluControl = 3'b010;
            
            default: aluControl = 3'bxxx;
            endcase
    default: aluControl = 3'bxxx;
endcase

endmodule