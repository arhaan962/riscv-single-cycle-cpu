module instruction_memory(
    input [31:0] address,
    output [31:0] instruction
);

    reg [31:0] memory [0:15];

    // Temporary test program
    initial begin
        memory[0] = 32'h00500093;
        memory[1] = 32'h00A00113;
        memory[2] = 32'h002081B3;
        memory[3] = 32'h00302023;
        memory[4] = 32'h00000013;
        memory[5] = 32'h00000013;
        memory[6] = 32'h00000013;
        memory[7] = 32'h00000013;
        memory[8] = 32'h00000013;
        memory[9] = 32'h00000013;
        memory[10] = 32'h00000013;
        memory[11] = 32'h00000013;
        memory[12] = 32'h00000013;
        memory[13] = 32'h00000013;
        memory[14] = 32'h00000013;
        memory[15] = 32'h00000013;
    end

    // Convert byte address into a word index
    assign instruction = memory[address[5:2]];

endmodule