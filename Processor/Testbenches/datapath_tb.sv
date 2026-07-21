`timescale 1ns/1ps

module datapath_tb;

logic clk;
logic reset;

logic [31:0] instruction;
logic [31:0] readData;

logic pcSource;
logic aluSource;
logic [1:0] resultSource;
logic [1:0] immediateSource;
logic registerWrite;
logic [2:0] aluControl;

logic [31:0] pc;
logic [31:0] aluResult;
logic [31:0] writeData;
logic zero;

logic [31:0] oldPC;

datapath dut(
    .clk(clk),
    .reset(reset),
    .instruction(instruction),
    .readData(readData),

    .pcSource(pcSource),
    .aluSource(aluSource),
    .resultSource(resultSource),
    .immediateSource(immediateSource),
    .registerWrite(registerWrite),
    .aluControl(aluControl),

    .pc(pc),
    .aluResult(aluResult),
    .writeData(writeData),
    .zero(zero)
);

always #5 clk = ~clk;

initial begin

clk = 0;
reset = 0;
instruction = 32'b0;
readData = 32'b0;

pcSource = 1'b0;
aluSource = 1'b0;
resultSource = 2'b0;
immediateSource = 2'b0;
registerWrite = 1'b0;
aluControl = 3'b0;

// assert reset and check if pc = 0; 
// first set reset to 1 and deassert it so that pc sets to 0, then let pc count up a few times
// test reset after

reset = 1;
#1;
reset = 0;
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);

reset = 1'b1;
#1;

if (pc !== 32'd0)
$fatal(1, 
    "Reset test failed."
);

reset = 1'b0;

//check that pc advances by 4 every clock edge
pcSource = 1'b0;
#1;

@(posedge clk);
#1;

if (pc !== 32'd4)
$fatal(1,
    "PC plus 4 test failed."
);


// addi x4, x0, 12
// sets the base address register for lw and sw
instruction     = 32'b000000001100_00000_000_00100_0010011;
resultSource    = 2'b00;
pcSource        = 1'b0;
aluSource       = 1'b1;
registerWrite   = 1'b1;
immediateSource = 2'b00;
aluControl      = 3'b000;
#1;

if (aluResult !== 32'd12)
    $fatal(1,
        "Positive addi failed: expected 12, got %0d", aluResult
    );


// writes 12 into x4
@(posedge clk);
#1;

if (dut.registerFile.registerArray[4] !== 32'd12)
$fatal(1,
    "addi failed: expected 12, got %0d", dut.registerFile.registerArray[4]
);


// addi x3, x0, -12
// sets the data register that sw will store
instruction     = 32'b111111110100_00000_000_00011_0010011;
resultSource    = 2'b00;
pcSource        = 1'b0;
aluSource       = 1'b1;
registerWrite   = 1'b1;
immediateSource = 2'b00;
aluControl      = 3'b000;
#1;

if (aluResult !== 32'hFFFF_FFF4)
    $fatal(1,
        "Negative addi failed: expected -12, got %0d", $signed(aluResult)
    );

// Writes -12 into x3
@(posedge clk);
#1;

//lw 
readData = 32'h0000_00F0;
instruction = 32'b000000000100_00000_010_00110_0000011;
resultSource    = 2'b01;
pcSource        = 1'b0;
aluSource       = 1'b1;
registerWrite   = 1'b1;
immediateSource = 2'b00;
aluControl      = 3'b000;
#1;

// x0 contains 0 and the immediate is 4
if (aluResult !== 32'd4)
$fatal(1, 
    "lw instruction failed: expected address 4, got %0d", aluResult
);

@(posedge clk);
#1;

if (dut.registerFile.registerArray[6] !== readData)
$fatal(1,
    "lw writeback failed: expected x6 = %0d, got %0d",
    readData,
    dut.registerFile.registerArray[6]
);

// sw x3, 4(x4)
@(negedge clk);
instruction = 32'b0000000_00011_00100_010_00100_0100011;
pcSource        = 1'b0;  
aluSource       = 1'b1;  
registerWrite   = 1'b0;  
immediateSource = 2'b01; 
aluControl      = 3'b000;
#1;

if (aluResult !== 32'd16)
$fatal(1, 
    "sw instruction failed: expected address 16, got %0d", aluResult
);

if (writeData !== 32'hFFFF_FFF4)
$fatal(1, 
    "sw instruction failed: expected writeData -12, got %0d", $signed(writeData)
);

//beq not taken (compared x0 to x4)
instruction = 32'b0000000_00000_00100_000_00110_1100011;
pcSource        = 1'b0;
aluSource       = 1'b0;
registerWrite   = 1'b0;
immediateSource = 2'b10;
aluControl      = 3'b001;
#1;

if (aluResult !== 32'd12 || zero !== 1'b0)
    $fatal(1,
    "beq alu result or zero failed."
);

oldPC = pc;

@(posedge clk);
#1;

if (pc !== oldPC + 32'd4)
    $fatal(1,
        "beq not-taken failed: expected PC %0d, got %0d", oldPC + 32'd4, pc
    );

//beq x4, x4, 8
//comparing x4 against itself means the branch is taken
instruction = 32'b0000000_00100_00100_000_01000_1100011;
resultSource    = 2'b00; 
pcSource        = 1'b1;
aluSource       = 1'b0;
registerWrite   = 1'b0;
immediateSource = 2'b10;
aluControl      = 3'b001;
#1;

@(negedge clk);
if (aluResult !== 32'd0 || zero !== 1'b1)
    $fatal(1,
    "beq taken comparison failed: aluResult = %0d, zero = %b", aluResult, zero
);

oldPC = pc;

@(posedge clk);
#1;

// cncoded b-type immediate is 8
if (pc !== oldPC + 32'd8)
$fatal(1,
    "beq taken failed: expected PC %0d, got %0d", oldPC + 32'd8, pc
);

//beq x4, x4, -8
//comparing x4 against itself means the branch is taken (backwards)
instruction = 32'b1111111_00100_00100_000_11001_1100011;
resultSource    = 2'b00; 
pcSource        = 1'b1;
aluSource       = 1'b0;
registerWrite   = 1'b0;
immediateSource = 2'b10;
aluControl      = 3'b001;
#1;

@(negedge clk);
if (aluResult !== 32'd0 || zero !== 1'b1)
    $fatal(1,
    "beq taken (backwards) comparison failed: aluResult = %0d, zero = %b", aluResult, zero
);

oldPC = pc;

@(posedge clk);
#1;

// cncoded b-type immediate is -8
if (pc !== oldPC - 32'd8)
$fatal(1,
    "beq taken (backwards) failed: expected PC %0d, got %0d", oldPC - 32'd8, pc
);

//jal 
// jal x5, target ( PC + 8 )
instruction = 32'b00000000100000000000_00101_1101111;
resultSource    = 2'b10;
pcSource        = 1'b1;
registerWrite   = 1'b1;
immediateSource = 2'b11;
#1;

oldPC = pc;

@(posedge clk);
#1;

if (pc !== oldPC + 32'd8 )
$fatal(1,
    "jal PC failed: expected %0d, got %0d", oldPC + 32'd8, pc
);

if (dut.registerFile.registerArray[5] !== oldPC + 32'd4)
$fatal(1,
        "jal link register failed: expected x5 = %0d, got %0d", oldPC + 32'd4, dut.registerFile.registerArray[5]
);

//write to x0
instruction = 32'b000000000101_00000_000_00000_0010011;
resultSource    = 2'b00;
pcSource        = 1'b0;
aluSource       = 1'b1;
registerWrite   = 1'b1;
immediateSource = 2'b00;
aluControl      = 3'b000;
#1;

oldPC = pc;

@(posedge clk);
#1;

if (pc !== oldPC + 32'd4)
$fatal(1,
    "addi x0 PC failed: expected %0d, got %0d", oldPC + 32'd4, pc
);

//alu source selection 
//initialize x1 = 5
instruction     = 32'b000000000101_00000_000_00001_0010011;
resultSource    = 2'b00;
pcSource        = 1'b0;
aluSource       = 1'b1;
registerWrite   = 1'b1;
immediateSource = 2'b00;
aluControl      = 3'b000;
#1;


if (aluResult !== 32'd5)
$fatal(1,
    "x1 setup failed: expected ALU result 5, got %0d",aluResult
);

@(posedge clk);
#1;

//addi x2, x1, 3
//expected: 5 + 3 = 8
@(negedge clk);
instruction     = 32'b000000000011_00001_000_00010_0010011;
aluSource       = 1'b1;
#1;

if (aluResult !== 32'd8)
$fatal(1,
    "consecutive addi failed: expected 8, got %0d",aluResult
);

@(posedge clk);
#1;

//add x3, x1, x2
//expected: 5 + 8 = 13
instruction     = 32'b0000000_00010_00001_000_00011_0110011;
aluSource       = 1'b0;
#1;

if (aluResult !== 32'd13)
$fatal(1,
    "register ALU source failed: expected 13, got %0d", aluResult
);

@(posedge clk);
#1;

$display("Datapath_tb tests passed.");
$finish;

end

endmodule