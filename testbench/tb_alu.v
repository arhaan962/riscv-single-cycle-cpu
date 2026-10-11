
module tb_alu;

    reg [31:0] operand_a;
    reg [31:0] operand_b;
    reg [3:0] alu_control;

    wire [31:0] result;

    alu dut (
        .operand_a(operand_a),
        .operand_b(operand_b),
        .alu_control(alu_control),
        .result(result)
    );

    // Check the result of one ALU operation
    task check_result;
        input [8*30-1:0] test_name;
        input [31:0] expected;
        begin
            #1;
            if (result !== expected)
                $display("FAIL: %0s | Expected=%h Got=%h",
                         test_name, expected, result);
            else
                $display("PASS: %0s | Result=%h",
                         test_name, result);
        end
    endtask

    initial begin
        // Test 1: ADD (10 + 5 = 15)
        operand_a = 32'd10;
        operand_b = 32'd5;
        alu_control = 4'b0000;
        check_result("ADD", 32'd15);

        // Test 2: SUB (10 - 5 = 5)
        alu_control = 4'b0001;
        check_result("SUB", 32'd5);

        // Test 3: SLL (1 << 4 = 16)
        operand_a = 32'd1;
        operand_b = 32'd4;
        alu_control = 4'b0010;
        check_result("SLL", 32'd16);

        // Test 4: SLT signed (-1 < 1)
        operand_a = 32'hFFFFFFFF;
        operand_b = 32'd1;
        alu_control = 4'b0011;
        check_result("SLT signed", 32'd1);

        // Test 5: SLTU unsigned (4294967295 < 1 is false)
        alu_control = 4'b0100;
        check_result("SLTU unsigned", 32'd0);

        // Test 6: XOR
        operand_a = 32'h0000000F;
        operand_b = 32'h00000005;
        alu_control = 4'b0101;
        check_result("XOR", 32'h0000000A);

        // Test 7: SRL (128 >> 2 = 32)
        operand_a = 32'd128;
        operand_b = 32'd2;
        alu_control = 4'b0110;
        check_result("SRL", 32'd32);

        // Test 8: SRA (-16 >>> 2 = -4)
        operand_a = 32'hFFFFFFF0;
        operand_b = 32'd2;
        alu_control = 4'b0111;
        check_result("SRA signed", 32'hFFFFFFFC);

        // Test 9: OR
        operand_a = 32'h0000000F;
        operand_b = 32'h00000005;
        alu_control = 4'b1000;
        check_result("OR", 32'h0000000F);

        // Test 10: AND
        alu_control = 4'b1001;
        check_result("AND", 32'h00000005);

        $finish;
    end

endmodule