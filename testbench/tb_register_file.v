
`timescale 1ns/1ps

module tb_register_file;

    reg clk;
    reg write_enable;
    reg [4:0] read_addr1;
    reg [4:0] read_addr2;
    reg [4:0] write_addr;
    reg [31:0] write_data;

    wire [31:0] read_data1;
    wire [31:0] read_data2;

    register_file dut (
        .clk(clk),
        .write_enable(write_enable),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .write_addr(write_addr),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        write_enable = 0;
        read_addr1 = 0;
        read_addr2 = 0;
        write_addr = 0;
        write_data = 0;

        // Write 10 into x1
        #2;
        write_enable = 1;
        write_addr = 1;
        write_data = 10;

        #8;

        // Write 20 into x2
        write_addr = 2;
        write_data = 20;

        #10;

        // Disable writing and read x1 and x2 together
        write_enable = 0;
        read_addr1 = 1;
        read_addr2 = 2;

        #1;
        $display("x1 = %0d, x2 = %0d", read_data1, read_data2);

        // Attempt to write 99 into x0
        write_enable = 1;
        write_addr = 0;
        write_data = 99;

        #10;

        write_enable = 0;
        read_addr1 = 0;

        #1;
        $display("x0 = %0d", read_data1);

        $finish;
    end

endmodule