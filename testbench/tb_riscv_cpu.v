
`timescale 1ns/1ps

module tb_riscv_cpu;

    reg clk;
    reg reset;

    wire [31:0] debug_pc;
    wire [31:0] debug_instruction;

    // Information about the instruction being executed
reg [31:0] executed_pc;
reg [31:0] executed_instruction;

// Previous state, used to identify changes
reg [31:0] previous_registers [0:31];
reg [7:0]  previous_memory [0:1023];

integer i;
integer j;

initial begin
    executed_pc          = 32'b0;
    executed_instruction = 32'b0;

    for (i = 0; i < 32; i = i + 1)
        previous_registers[i] = 32'bx;

    for (i = 0; i < 1024; i = i + 1)
        previous_memory[i] = 8'bx;
end

    // Instantiate the CPU
    riscv_cpu dut (
        .clk(clk),
        .reset(reset),
        .debug_pc(debug_pc),
        .debug_instruction(debug_instruction)
    );

   
    // Generate clock: 10 ns period
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        // Keep reset active initially
        #12;
        reset = 0;

        // Execute instructions and display results
        repeat (20) begin
            @(posedge clk);
            #1;

            $display("\n========================================");
            $display("         RISC-V CPU EXECUTION");
            $display("========================================");
            $display("PC          : 0x%08h", debug_pc);
            $display("Instruction : 0x%08h", debug_instruction);

            $display("\n--- REGISTER FILE ---");
            $display("x0  = %08h  x1  = %08h  x2  = %08h  x3  = %08h",
                dut.regfile_unit.registers[0],
                dut.regfile_unit.registers[1],
                dut.regfile_unit.registers[2],
                dut.regfile_unit.registers[3]);

            $display("x4  = %08h  x5  = %08h  x6  = %08h  x7  = %08h",
                dut.regfile_unit.registers[4],
                dut.regfile_unit.registers[5],
                dut.regfile_unit.registers[6],
                dut.regfile_unit.registers[7]);

            $display("x8  = %08h  x9  = %08h  x10 = %08h  x11 = %08h",
                dut.regfile_unit.registers[8],
                dut.regfile_unit.registers[9],
                dut.regfile_unit.registers[10],
                dut.regfile_unit.registers[11]);

            $display("x12 = %08h  x13 = %08h  x14 = %08h  x15 = %08h",
                dut.regfile_unit.registers[12],
                dut.regfile_unit.registers[13],
                dut.regfile_unit.registers[14],
                dut.regfile_unit.registers[15]);

            $display("x16 = %08h  x17 = %08h  x18 = %08h  x19 = %08h",
                dut.regfile_unit.registers[16],
                dut.regfile_unit.registers[17],
                dut.regfile_unit.registers[18],
                dut.regfile_unit.registers[19]);

            $display("x20 = %08h  x21 = %08h  x22 = %08h  x23 = %08h",
                dut.regfile_unit.registers[20],
                dut.regfile_unit.registers[21],
                dut.regfile_unit.registers[22],
                dut.regfile_unit.registers[23]);

            $display("x24 = %08h  x25 = %08h  x26 = %08h  x27 = %08h",
                dut.regfile_unit.registers[24],
                dut.regfile_unit.registers[25],
                dut.regfile_unit.registers[26],
                dut.regfile_unit.registers[27]);

            $display("x28 = %08h  x29 = %08h  x30 = %08h  x31 = %08h",
                dut.regfile_unit.registers[28],
                dut.regfile_unit.registers[29],
                dut.regfile_unit.registers[30],
                dut.regfile_unit.registers[31]);

            $display("\n--- DATA MEMORY (first 16 bytes) ---");
            $display("MEM[0-3]   : %02h %02h %02h %02h",
                dut.data_mem_unit.memory[0],
                dut.data_mem_unit.memory[1],
                dut.data_mem_unit.memory[2],
                dut.data_mem_unit.memory[3]);

            $display("MEM[4-7]   : %02h %02h %02h %02h",
                dut.data_mem_unit.memory[4],
                dut.data_mem_unit.memory[5],
                dut.data_mem_unit.memory[6],
                dut.data_mem_unit.memory[7]);

            $display("MEM[8-11]  : %02h %02h %02h %02h",
                dut.data_mem_unit.memory[8],
                dut.data_mem_unit.memory[9],
                dut.data_mem_unit.memory[10],
                dut.data_mem_unit.memory[11]);

            $display("MEM[12-15] : %02h %02h %02h %02h",
                dut.data_mem_unit.memory[12],
                dut.data_mem_unit.memory[13],
                dut.data_mem_unit.memory[14],
                dut.data_mem_unit.memory[15]);

            $display("========================================");
        end

        $finish;
    end

endmodule