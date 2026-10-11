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
    end

    // Convert byte address into a word index
    assign instruction = memory[address[5:2]];

endmodule