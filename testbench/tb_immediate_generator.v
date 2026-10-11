
`timescale 1ns/1ps

module tb_immediate_generator;

    reg [31:0] instruction;
    reg [2:0] imm_src;

    wire [6:0] opcode;
    wire [2:0] bits_14_12;
    wire [4:0] bits_19_15;
    wire [4:0] bits_24_20;
    wire [4:0] bits_11_7;
    wire [6:0] bits_31_25;

    wire [11:0] bits_31_20;
    wire [19:0] bits_31_12;
    wire bit_31;
    wire [30:25] bits_30_25;
    wire [11:8] bits_11_8;
    wire bit_7;
    wire [30:21] bits_30_21;
    wire [19:12] bits_19_12;

    wire [31:0] immediate;

    // Extract fields from the instruction
    instruction_decoder decoder (
        .instruction(instruction),
        .opcode(opcode),
        .bits_14_12(bits_14_12),
        .bits_19_15(bits_19_15),
        .bits_24_20(bits_24_20),
        .bits_11_7(bits_11_7),
        .bits_31_25(bits_31_25),
        .bits_31_20(bits_31_20),
        .bits_31_12(bits_31_12),
        .bit_31(bit_31),
        .bits_30_25(bits_30_25),
        .bits_11_8(bits_11_8),
        .bit_7(bit_7),
        .bits_30_21(bits_30_21),
        .bits_19_12(bits_19_12)
    );

    // Construct the immediate
    immediate_generator imm_gen (
        .imm_src(imm_src),
        .bits_31_20(bits_31_20),
        .bits_31_12(bits_31_12),
        .bits_31_25(bits_31_25),
        .bits_11_7(bits_11_7),
        .bit_31(bit_31),
        .bits_30_25(bits_30_25),
        .bits_11_8(bits_11_8),
        .bit_7(bit_7),
        .bits_30_21(bits_30_21),
        .bits_19_12(bits_19_12),
        .bits_24_20(bits_24_20),
        .immediate(immediate)
    );

    initial begin
        // I-type: ADDI with immediate -5
        instruction = {
            12'hFFB, 5'd1, 3'b000, 5'd3, 7'b0010011
        };
        imm_src = 3'b000;
        #1;
        if (immediate !== 32'hFFFFFFFB)
            $display("FAIL I-type: %h", immediate);
        else
            $display("PASS I-type: %h", immediate);

        // S-type: SW with immediate -8
        instruction = {
            7'h7F, 5'd2, 5'd1, 3'b010, 5'd24, 7'b0100011
        };
        imm_src = 3'b001;
        #1;
        if (immediate !== 32'hFFFFFFF8)
            $display("FAIL S-type: %h", immediate);
        else
            $display("PASS S-type: %h", immediate);

        // B-type: BEQ with branch offset -4
        instruction = {
            1'b1, 6'b111111, 5'd2, 5'd1,
            3'b000, 4'b1110, 1'b1, 7'b1100011
        };
        imm_src = 3'b010;
        #1;
        if (immediate !== 32'hFFFFFFFC)
            $display("FAIL B-type: %h", immediate);
        else
            $display("PASS B-type: %h", immediate);

        // U-type: LUI with upper immediate ABCDE
        instruction = {
            20'hABCDE, 5'd3, 7'b0110111
        };
        imm_src = 3'b011;
        #1;
        if (immediate !== 32'hABCDE000)
            $display("FAIL U-type: %h", immediate);
        else
            $display("PASS U-type: %h", immediate);

        // J-type: JAL with jump offset -4
        instruction = {
            1'b1, 8'hFF, 1'b1, 10'b1111111110,
            5'd1, 7'b1101111
        };
        imm_src = 3'b100;
        #1;
        if (immediate !== 32'hFFFFFFFC)
            $display("FAIL J-type: %h", immediate);
        else
            $display("PASS J-type: %h", immediate);

        $finish;
    end

endmodule