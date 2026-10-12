
module riscv_cpu(
    input clk,
    input reset,
    output [31:0] debug_pc,
    output [31:0] debug_instruction
);

    // --------------------------------------------------
    // 1. Fetch
    // --------------------------------------------------

    wire [31:0] next_pc;

    

    program_counter pc_unit (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(debug_pc)
    );

    instruction_memory imem (
        .address(debug_pc),
        .instruction(debug_instruction)
    );


    // --------------------------------------------------
    // 2. Decode instruction fields
    // --------------------------------------------------

    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;

    wire [11:0] bits_31_20;
    wire [19:0] bits_31_12;
    wire bit_31;
    wire [30:25] bits_30_25;
    wire [11:8] bits_11_8;
    wire bit_7;
    wire [30:21] bits_30_21;
    wire [19:12] bits_19_12;

    instruction_decoder decoder (
        .instruction(debug_instruction),
        .opcode(opcode),
        .bits_14_12(funct3),
        .bits_19_15(rs1),
        .bits_24_20(rs2),
        .bits_11_7(rd),
        .bits_31_25(funct7),
        .bits_31_20(bits_31_20),
        .bits_31_12(bits_31_12),
        .bit_31(bit_31),
        .bits_30_25(bits_30_25),
        .bits_11_8(bits_11_8),
        .bit_7(bit_7),
        .bits_30_21(bits_30_21),
        .bits_19_12(bits_19_12)
    );


    // --------------------------------------------------
    // 3. Control signals
    // --------------------------------------------------

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

    control_unit control (
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


    // --------------------------------------------------
    // 4. Generate immediate
    // --------------------------------------------------

    wire [31:0] immediate;

    immediate_generator imm_gen (
        .imm_src(imm_src),
        .bits_31_20(bits_31_20),
        .bits_31_12(bits_31_12),
        .bits_31_25(funct7),
        .bits_11_7(rd),
        .bit_31(bit_31),
        .bits_30_25(bits_30_25),
        .bits_11_8(bits_11_8),
        .bit_7(bit_7),
        .bits_30_21(bits_30_21),
        .bits_19_12(bits_19_12),
        .bits_24_20(rs2),
        .immediate(immediate)
    );
    // Select the next PC

assign next_pc =
    (valid && jalr)
        ? ((read_data1 + immediate) & 32'hFFFFFFFE)
    : (valid && jump)
        ? (debug_pc + immediate)
    : (valid && branch && branch_condition)
        ? (debug_pc + immediate)
    : (debug_pc + 32'd4);


    // --------------------------------------------------
    // 5. Register file
    // --------------------------------------------------

    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire [31:0] write_back_data;
    // Branch condition checker
reg branch_condition;

always @(*) begin
    case (funct3)
        3'b000: branch_condition = (read_data1 == read_data2); // BEQ
        3'b001: branch_condition = (read_data1 != read_data2); // BNE

        3'b100: branch_condition =
            ($signed(read_data1) < $signed(read_data2));       // BLT

        3'b101: branch_condition =
            ($signed(read_data1) >= $signed(read_data2));      // BGE

        3'b110: branch_condition = (read_data1 < read_data2);  // BLTU
        3'b111: branch_condition = (read_data1 >= read_data2); // BGEU

        default: branch_condition = 1'b0;
    endcase
end

    register_file regfile_unit (
        .clk(clk),
        .write_enable(reg_write && valid),
        .read_addr1(rs1),
        .read_addr2(rs2),
        .write_addr(rd),
        .write_data(write_back_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );


    // --------------------------------------------------
    // 6. Select ALU operands
    // --------------------------------------------------

    reg [31:0] alu_operand_a;
    wire [31:0] alu_operand_b;

    always @(*) begin
        case (alu_a_src)
            2'b00: alu_operand_a = read_data1;
            2'b01: alu_operand_a = debug_pc;
            2'b10: alu_operand_a = 32'd0;
            default: alu_operand_a = 32'd0;
        endcase
    end

    assign alu_operand_b =
        alu_b_imm ? immediate : read_data2;


    // --------------------------------------------------
    // 7. ALU
    // --------------------------------------------------

    wire [31:0] alu_result;

    alu alu_unit (
        .operand_a(alu_operand_a),
        .operand_b(alu_operand_b),
        .alu_control(alu_control),
        .result(alu_result)
    );


    // --------------------------------------------------
    // 8. Data memory
    // --------------------------------------------------

    wire [31:0] memory_read_data;

    data_memory data_mem_unit (
        .clk(clk),
        .mem_read(mem_read && valid),
        .mem_write(mem_write && valid),
        .address(alu_result),
        .write_data(read_data2),
        .mem_width(mem_width),
        .load_unsigned(load_unsigned),
        .read_data(memory_read_data)
    );


    // --------------------------------------------------
    // 9. Write-back selection
    // --------------------------------------------------

    assign write_back_data =
        (result_src == 2'b00) ? alu_result :
        (result_src == 2'b01) ? memory_read_data :
        (result_src == 2'b10) ? (debug_pc + 32'd4) :
                                32'd0;

endmodule