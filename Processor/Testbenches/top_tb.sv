`timescale 1ns/1ps

module top_tb;

logic clk;
logic reset;

logic memoryWrite;
logic [31:0] dataAddress;
logic [31:0] writeData;

logic programFinished;
integer cycle;

top dut(
    .clk(clk),
    .reset(reset),
    .memoryWrite(memoryWrite),
    .dataAddress(dataAddress),
    .writeData(writeData)
);

always #5 clk = ~clk;

initial begin

clk = 0;
reset = 1;
programFinished = 0;

//initialize input values at byte addresses 0x40 and 0x44
dut.dataMemory.memory[16] = 32'd7;
dut.dataMemory.memory[17] = 32'hFFFF_FFFD;

//initialize output at byte address 0x48
dut.dataMemory.memory[18] = 32'd0;

@(posedge clk);
#1;

reset = 0;

@(posedge clk);
#1;

//addi x1, x0, 5 
if (dut.pc !== 32'd4 || dut.processor.datapath.registerFile.registerArray[1] !== 32'd5)
$fatal(1,
    "addi failed! expected pc = 4 and x1 = 5, got pc = %0d and x1 = %0d.", dut.pc, dut.processor.datapath.registerFile.registerArray[1]
);

if (memoryWrite !== 1'b1 || dataAddress !== 32'd4 || writeData !== 32'd5)
$fatal(1,
    "sw signals failed! expected memoryWrite = 1, dataAddress = 4, and writeData = 5, got memoryWrite = %b, dataAddress = %0d, and writeData = %0d.", memoryWrite, dataAddress, writeData
);

@(posedge clk);
#1;

//sw x1, 4(x0)
if (dut.pc !== 32'd8 || dut.dataMemory.memory[1] !== 32'd5)
$fatal(1,
    "sw failed! expected pc = 8 and memory[1] = 5, got pc = %0d and memory[1] = %0d.", dut.pc, dut.dataMemory.memory[1]
);

//run the remaining program
cycle = 0;

while (cycle < 200 && !programFinished) begin

@(posedge clk);
#1;

if (dut.dataMemory.memory[18] === 32'd5)
programFinished = 1'b1;

cycle = cycle + 1;

end

if (!programFinished)
$fatal(1,
    "Program timed out! expected memory[18] = 5, got memory[18] = %0d.", dut.dataMemory.memory[18]
);

if (dut.pc !== 32'd72)
$fatal(1,
    "halt failed! expected pc = 72, got pc = %0d.", dut.pc
);

$display(
    "All tests passed successfully. memory[18] = %0d.", dut.dataMemory.memory[18]
);

$finish;

end

endmodule