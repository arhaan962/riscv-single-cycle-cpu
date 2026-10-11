`timescale 1ns/1ps

module tb_instruction_memory;

    reg [31:0] address;
    wire [31:0] instruction;

    integer i;

    instruction_memory dut (
        .address(address),
        .instruction(instruction)
    );

    initial begin
        $dumpfile("build/instruction_memory.vcd");
        $dumpvars(0, tb_instruction_memory);

        for (i = 0; i < 4; i = i + 1) begin
            address = i * 4;
            #1;
            $display("Address = %0d, Instruction = %h",
                     address, instruction);
        end

        $finish;
    end

endmodule