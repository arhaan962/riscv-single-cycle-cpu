
module instruction_fetch(
    input clk,
    input reset,
    output [31:0] pc,
    output [31:0] instruction
);

    wire [31:0] next_pc;

    assign next_pc = pc + 32'd4;

    program_counter pc_unit (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    instruction_memory imem (
        .address(pc),
        .instruction(instruction)
    );

endmodule