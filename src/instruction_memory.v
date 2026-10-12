module instruction_memory(
    input [31:0] address,
    output [31:0] instruction
);

    reg [31:0] memory [0:15];

    // Temporary test program
 



    initial begin
    memory[0]  = 32'h08000093; // ADDI x1, x0, 128
    memory[1]  = 32'h00100023; // SB   x1, 0(x0)
    memory[2]  = 32'h00000103; // LB   x2, 0(x0)
    memory[3]  = 32'h00004183; // LBU  x3, 0(x0)
    memory[4]  = 32'h00008237; // LUI  x4, 8
    memory[5]  = 32'h00401123; // SH   x4, 2(x0)
    memory[6]  = 32'h00201283; // LH   x5, 2(x0)
    memory[7]  = 32'h00205303; // LHU  x6, 2(x0)
    memory[8]  = 32'h00300383; // LB   x7, 3(x0)
    memory[9]  = 32'h00304403; // LBU  x8, 3(x0)

    memory[10] = 32'h00000013; // NOP
    memory[11] = 32'h00000013; // NOP
    memory[12] = 32'h00000013; // NOP
    memory[13] = 32'h00000013; // NOP
    memory[14] = 32'h00000013; // NOP
    memory[15] = 32'h00000013; // NOP
end


    // Convert byte address into a word index
    assign instruction = memory[address[5:2]];

endmodule