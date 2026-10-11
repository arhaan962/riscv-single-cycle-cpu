
`timescale 1ns/1ps

module tb_instruction_fetch;

    reg clk;
    reg reset;
    wire [31:0] pc;
    wire [31:0] instruction;

    instruction_fetch dut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instruction(instruction)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("build/instruction_fetch.vcd");
        $dumpvars(0, tb_instruction_fetch);

        clk = 0;
        reset = 1;

        #12;
        reset = 0;

        #2;
        $display("PC = %0d, Instruction = %h", pc, instruction);

        #10;
        $display("PC = %0d, Instruction = %h", pc, instruction);

        #10;
        $display("PC = %0d, Instruction = %h", pc, instruction);

        #10;
        $display("PC = %0d, Instruction = %h", pc, instruction);

        $finish;
    end

endmodule