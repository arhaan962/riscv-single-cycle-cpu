
module tb_data_memory;

    reg clk;
    reg mem_read;
    reg mem_write;

    reg [31:0] address;
    reg [31:0] write_data;

    reg [1:0] mem_width;
    reg load_unsigned;

    wire [31:0] read_data;

    data_memory dut (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(address),
        .write_data(write_data),
        .mem_width(mem_width),
        .load_unsigned(load_unsigned),
        .read_data(read_data)
    );

    // Clock with a 10 ns period
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        mem_read = 0;
        mem_write = 0;
        address = 0;
        write_data = 0;
        mem_width = 2'b10;
        load_unsigned = 0;

        // Test 1: SW stores a full word
        address = 32'd100;
        write_data = 32'h12345678;
        mem_width = 2'b10;
        mem_write = 1;

        @(posedge clk);
        #1;
        mem_write = 0;

        // Test 2: LW reads the same word
        mem_read = 1;
        #1;

        if (read_data !== 32'h12345678)
            $display("FAIL LW: %h", read_data);
        else
            $display("PASS LW: %h", read_data);

        // Test 3: LB reads the lowest byte (78)
        address = 32'd100;
        mem_width = 2'b00;
        load_unsigned = 0;
        #1;

        if (read_data !== 32'h00000078)
            $display("FAIL LB: %h", read_data);
        else
            $display("PASS LB: %h", read_data);

        // Test 4: LBU reads the same byte
        load_unsigned = 1;
        #1;

        if (read_data !== 32'h00000078)
            $display("FAIL LBU: %h", read_data);
        else
            $display("PASS LBU: %h", read_data);

        // Test 5: LH reads bytes 78 and 56
        address = 32'd100;
        mem_width = 2'b01;
        load_unsigned = 0;
        #1;

        if (read_data !== 32'h00005678)
            $display("FAIL LH: %h", read_data);
        else
            $display("PASS LH: %h", read_data);

        // Test 6: SB overwrites address 200 with 80
        mem_read = 0;
        mem_width = 2'b00;
        address = 32'd200;
        write_data = 32'h00000080;
        mem_write = 1;

        @(posedge clk);
        #1;
        mem_write = 0;

        // Test 7: LB sign-extends 80
        mem_read = 1;
        load_unsigned = 0;
        #1;

        if (read_data !== 32'hFFFFFF80)
            $display("FAIL signed LB: %h", read_data);
        else
            $display("PASS signed LB: %h", read_data);

        // Test 8: LBU zero-extends 80
        load_unsigned = 1;
        #1;

        if (read_data !== 32'h00000080)
            $display("FAIL unsigned LBU: %h", read_data);
        else
            $display("PASS unsigned LBU: %h", read_data);

        $finish;
    end

endmodule