
module tb_control_unit;

    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;

    wire [3:0] alu_control;
    wire [2:0] imm_src;
    wire [1:0] alu_a_src;
    wire alu_b_imm;

    wire reg_write;
    wire mem_read;
    wire mem_write;
    wire [1:0] result_src;

    wire branch;
    wire jump;
    wire jalr;

    wire [1:0] mem_width;
    wire load_unsigned;
    wire valid;

    control_unit dut (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .alu_control(alu_control),
        .imm_src(imm_src),
        .alu_a_src(alu_a_src),
        .alu_b_imm(alu_b_imm),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .result_src(result_src),
        .branch(branch),
        .jump(jump),
        .jalr(jalr),
        .mem_width(mem_width),
        .load_unsigned(load_unsigned),
        .valid(valid)
    );

    task check;
        input [8*24-1:0] test_name;
        input exp_valid;
        input exp_reg_write;
        input exp_mem_read;
        input exp_mem_write;
        input exp_branch;
        input exp_jump;
        input exp_jalr;
        input [3:0] exp_alu_control;
        input [2:0] exp_imm_src;
        input [1:0] exp_alu_a_src;
        input exp_alu_b_imm;
        input [1:0] exp_result_src;
        input [1:0] exp_mem_width;
        input exp_load_unsigned;

        begin
            #1;
            if (
                valid         !== exp_valid         ||
                reg_write     !== exp_reg_write     ||
                mem_read      !== exp_mem_read      ||
                mem_write     !== exp_mem_write     ||
                branch        !== exp_branch        ||
                jump          !== exp_jump          ||
                jalr          !== exp_jalr          ||
                alu_control   !== exp_alu_control   ||
                imm_src       !== exp_imm_src       ||
                alu_a_src     !== exp_alu_a_src     ||
                alu_b_imm     !== exp_alu_b_imm     ||
                result_src    !== exp_result_src    ||
                mem_width     !== exp_mem_width     ||
                load_unsigned !== exp_load_unsigned
            )
                $display("FAIL: %0s", test_name);
            else
                $display("PASS: %0s", test_name);
        end
    endtask

    initial begin

        // ADD: R-type
        opcode = 7'b0110011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        check("ADD", 1,1,0,0,0,0,0,
              4'b0000,3'b000,2'b00,0,2'b00,2'b10,0);

        // SUB: R-type
        funct7 = 7'b0100000;
        check("SUB", 1,1,0,0,0,0,0,
              4'b0001,3'b000,2'b00,0,2'b00,2'b10,0);

        // ADDI: I-type
        opcode = 7'b0010011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        check("ADDI", 1,1,0,0,0,0,0,
              4'b0000,3'b000,2'b00,1,2'b00,2'b10,0);

        // LW: word load
        opcode = 7'b0000011;
        funct3 = 3'b010;
        check("LW", 1,1,1,0,0,0,0,
              4'b0000,3'b000,2'b00,1,2'b01,2'b10,0);

        // LBU: unsigned byte load
        funct3 = 3'b100;
        check("LBU", 1,1,1,0,0,0,0,
              4'b0000,3'b000,2'b00,1,2'b01,2'b00,1);

        // SW: word store
        opcode = 7'b0100011;
        funct3 = 3'b010;
        check("SW", 1,0,0,1,0,0,0,
              4'b0000,3'b001,2'b00,1,2'b00,2'b10,0);

        // BEQ: branch
        opcode = 7'b1100011;
        funct3 = 3'b000;
        check("BEQ", 1,0,0,0,1,0,0,
              4'b0000,3'b010,2'b00,0,2'b00,2'b10,0);

        // JAL: jump and save PC+4
        opcode = 7'b1101111;
        funct3 = 3'b000;
        check("JAL", 1,1,0,0,0,1,0,
              4'b0000,3'b100,2'b00,0,2'b10,2'b10,0);

        // JALR
        opcode = 7'b1100111;
        check("JALR", 1,1,0,0,0,0,1,
              4'b0000,3'b000,2'b00,0,2'b10,2'b10,0);

        // LUI: immediate added to zero
        opcode = 7'b0110111;
        check("LUI", 1,1,0,0,0,0,0,
              4'b0000,3'b011,2'b10,1,2'b00,2'b10,0);

        // AUIPC: immediate added to PC
        opcode = 7'b0010111;
        check("AUIPC", 1,1,0,0,0,0,0,
              4'b0000,3'b011,2'b01,1,2'b00,2'b10,0);

        // Invalid R-type: funct7 not valid for ADD
        opcode = 7'b0110011;
        funct3 = 3'b000;
        funct7 = 7'b0000001;
        check("Invalid R-type", 0,0,0,0,0,0,0,
              4'b0000,3'b000,2'b00,0,2'b00,2'b10,0);

        $finish;
    end

endmodule