
module control_unit(
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,

    output reg [3:0] alu_control,
    output reg [2:0] imm_src,
    output reg [1:0] alu_a_src,
    output reg alu_b_imm,

    output reg reg_write,
    output reg mem_read,
    output reg mem_write,
    output reg [1:0] result_src,

    output reg branch,
    output reg jump,
    output reg jalr,

    output reg [1:0] mem_width,
    output reg load_unsigned,
    output reg valid
);

    // ALU operations
    localparam ALU_ADD  = 4'b0000;
    localparam ALU_SUB  = 4'b0001;
    localparam ALU_SLL  = 4'b0010;
    localparam ALU_SLT  = 4'b0011;
    localparam ALU_SLTU = 4'b0100;
    localparam ALU_XOR  = 4'b0101;
    localparam ALU_SRL  = 4'b0110;
    localparam ALU_SRA  = 4'b0111;
    localparam ALU_OR   = 4'b1000;
    localparam ALU_AND  = 4'b1001;

    // Immediate formats
    localparam IMM_I = 3'b000;
    localparam IMM_S = 3'b001;
    localparam IMM_B = 3'b010;
    localparam IMM_U = 3'b011;
    localparam IMM_J = 3'b100;

    // ALU input A selection
    localparam A_REG  = 2'b00;
    localparam A_PC   = 2'b01;
    localparam A_ZERO = 2'b10;

    // Write-back result selection
    localparam RES_ALU = 2'b00;
    localparam RES_MEM = 2'b01;
    localparam RES_PC4 = 2'b10;

    // Memory access width
    localparam WIDTH_BYTE = 2'b00;
    localparam WIDTH_HALF = 2'b01;
    localparam WIDTH_WORD = 2'b10;

    always @(*) begin

        // Safe default values
        alu_control = ALU_ADD;
        imm_src = IMM_I;
        alu_a_src = A_REG;
        alu_b_imm = 1'b0;

        reg_write = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        result_src = RES_ALU;

        branch = 1'b0;
        jump = 1'b0;
        jalr = 1'b0;

        mem_width = WIDTH_WORD;
        load_unsigned = 1'b0;
        valid = 1'b0;

        case (opcode)

            // R-type: ADD, SUB, SLL, SLT, SLTU,
            // XOR, SRL, SRA, OR, AND
            7'b0110011: begin
                case (funct3)
                    3'b000: begin
                        if (funct7 == 7'b0000000) begin
                            alu_control = ALU_ADD;
                            valid = 1'b1;
                        end
                        else if (funct7 == 7'b0100000) begin
                            alu_control = ALU_SUB;
                            valid = 1'b1;
                        end
                    end

                    3'b001: begin
                        if (funct7 == 7'b0000000) begin
                            alu_control = ALU_SLL;
                            valid = 1'b1;
                        end
                    end

                    3'b010: begin
                        if (funct7 == 7'b0000000) begin
                            alu_control = ALU_SLT;
                            valid = 1'b1;
                        end
                    end

                    3'b011: begin
                        if (funct7 == 7'b0000000) begin
                            alu_control = ALU_SLTU;
                            valid = 1'b1;
                        end
                    end

                    3'b100: begin
                        if (funct7 == 7'b0000000) begin
                            alu_control = ALU_XOR;
                            valid = 1'b1;
                        end
                    end

                    3'b101: begin
                        if (funct7 == 7'b0000000) begin
                            alu_control = ALU_SRL;
                            valid = 1'b1;
                        end
                        else if (funct7 == 7'b0100000) begin
                            alu_control = ALU_SRA;
                            valid = 1'b1;
                        end
                    end

                    3'b110: begin
                        if (funct7 == 7'b0000000) begin
                            alu_control = ALU_OR;
                            valid = 1'b1;
                        end
                    end

                    3'b111: begin
                        if (funct7 == 7'b0000000) begin
                            alu_control = ALU_AND;
                            valid = 1'b1;
                        end
                    end
                endcase

                if (valid)
                    reg_write = 1'b1;
            end

            // I-type arithmetic and logical instructions
            7'b0010011: begin
                alu_b_imm = 1'b1;
                imm_src = IMM_I;

                case (funct3)
                    3'b000: begin
                        alu_control = ALU_ADD; // ADDI
                        valid = 1'b1;
                    end

                    3'b010: begin
                        alu_control = ALU_SLT; // SLTI
                        valid = 1'b1;
                    end

                    3'b011: begin
                        alu_control = ALU_SLTU; // SLTIU
                        valid = 1'b1;
                    end

                    3'b100: begin
                        alu_control = ALU_XOR; // XORI
                        valid = 1'b1;
                    end

                    3'b110: begin
                        alu_control = ALU_OR; // ORI
                        valid = 1'b1;
                    end

                    3'b111: begin
                        alu_control = ALU_AND; // ANDI
                        valid = 1'b1;
                    end

                    3'b001: begin
                        if (funct7 == 7'b0000000) begin
                            alu_control = ALU_SLL; // SLLI
                            valid = 1'b1;
                        end
                    end

                    3'b101: begin
                        if (funct7 == 7'b0000000) begin
                            alu_control = ALU_SRL; // SRLI
                            valid = 1'b1;
                        end
                        else if (funct7 == 7'b0100000) begin
                            alu_control = ALU_SRA; // SRAI
                            valid = 1'b1;
                        end
                    end
                endcase

                reg_write = valid;
            end

            // Loads: LB, LH, LW, LBU, LHU
            7'b0000011: begin
                alu_control = ALU_ADD;
                alu_b_imm = 1'b1;
                imm_src = IMM_I;
                mem_read = 1'b1;
                result_src = RES_MEM;

                case (funct3)
                    3'b000: begin
                        mem_width = WIDTH_BYTE; // LB
                        valid = 1'b1;
                    end
                    3'b001: begin
                        mem_width = WIDTH_HALF; // LH
                        valid = 1'b1;
                    end
                    3'b010: begin
                        mem_width = WIDTH_WORD; // LW
                        valid = 1'b1;
                    end
                    3'b100: begin
                        mem_width = WIDTH_BYTE; // LBU
                        load_unsigned = 1'b1;
                        valid = 1'b1;
                    end
                    3'b101: begin
                        mem_width = WIDTH_HALF; // LHU
                        load_unsigned = 1'b1;
                        valid = 1'b1;
                    end
                endcase

                reg_write = valid;
                mem_read = valid;
            end

            // Stores: SB, SH, SW
            7'b0100011: begin
                alu_control = ALU_ADD;
                alu_b_imm = 1'b1;
                imm_src = IMM_S;

                case (funct3)
                    3'b000: begin
                        mem_width = WIDTH_BYTE; // SB
                        valid = 1'b1;
                    end
                    3'b001: begin
                        mem_width = WIDTH_HALF; // SH
                        valid = 1'b1;
                    end
                    3'b010: begin
                        mem_width = WIDTH_WORD; // SW
                        valid = 1'b1;
                    end
                endcase

                mem_write = valid;
            end

            // Branches: BEQ, BNE, BLT, BGE, BLTU, BGEU
            7'b1100011: begin
                imm_src = IMM_B;
                case (funct3)
                    3'b000, 3'b001,
                    3'b100, 3'b101,
                    3'b110, 3'b111: begin
                        branch = 1'b1;
                        valid = 1'b1;
                    end
                endcase
            end

            // JAL
            7'b1101111: begin
                imm_src = IMM_J;
                reg_write = 1'b1;
                result_src = RES_PC4;
                jump = 1'b1;
                valid = 1'b1;
            end

            // JALR
            7'b1100111: begin
                if (funct3 == 3'b000) begin
                    imm_src = IMM_I;
                    reg_write = 1'b1;
                    result_src = RES_PC4;
                    jalr = 1'b1;
                    valid = 1'b1;
                end
            end

            // LUI
            7'b0110111: begin
                imm_src = IMM_U;
                alu_a_src = A_ZERO;
                alu_b_imm = 1'b1;
                alu_control = ALU_ADD;
                reg_write = 1'b1;
                valid = 1'b1;
            end

            // AUIPC
            7'b0010111: begin
                imm_src = IMM_U;
                alu_a_src = A_PC;
                alu_b_imm = 1'b1;
                alu_control = ALU_ADD;
                reg_write = 1'b1;
                valid = 1'b1;
            end

        endcase
    end

endmodule