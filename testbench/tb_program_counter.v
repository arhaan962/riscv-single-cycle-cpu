`timescale 1ns/1ps

module tb_program_counter;

    reg clk;
    reg reset;
    reg [31:0] next_pc;
    wire [31:0] pc;

    // Connect the testbench to the PC module
    program_counter dut (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    // Generate a clock with a 10 ns period
    always #5 clk = ~clk;

    initial begin
        $dumpfile("build/pc.vcd");
        $dumpvars(0, tb_program_counter);

        clk = 0;
        reset = 1;
        next_pc = 0;

        // First rising edge: reset PC to zero
        #10;
        reset = 0;
        next_pc = 4;

        // Next rising edge: PC becomes 4
        #10;
        next_pc = 8;

        // Next rising edge: PC becomes 8
        #10;

        $display("Final PC = %0d", pc);
        $finish;
    end

endmodule