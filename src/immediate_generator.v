
module immediate_generator(
    input [2:0] imm_src,

    // Raw fields from instruction_decoder
    input [11:0] bits_31_20,
    input [19:0] bits_31_12,
    input [6:0]  bits_31_25,
    input [4:0]  bits_11_7,
    input        bit_31,
    input [30:25] bits_30_25,
    input [11:8] bits_11_8,
    input        bit_7,
    input [30:21] bits_30_21,
    input [19:12] bits_19_12,
    input [4:0]  bits_24_20,

    output reg [31:0] immediate
);

    localparam IMM_I = 3'b000;
    localparam IMM_S = 3'b001;
    localparam IMM_B = 3'b010;
    localparam IMM_U = 3'b011;
    localparam IMM_J = 3'b100;

    always @(*) begin
        // Default value
        immediate = 32'b0;

        case (imm_src)

            // I-type: ADDI, loads, JALR, etc.
            IMM_I: begin
                immediate = {
                    {20{bits_31_20[11]}},
                    bits_31_20
                };
            end

            // S-type: SB, SH, SW
            IMM_S: begin
                immediate = {
                    {20{bits_31_25[6]}},
                    bits_31_25,
                    bits_11_7
                };
            end

            // B-type: BEQ, BNE, BLT, BGE, BLTU, BGEU
            IMM_B: begin
                immediate = {
                    {19{bit_31}},
                    bit_31,
                    bit_7,
                    bits_30_25,
                    bits_11_8,
                    1'b0
                };
            end

            // U-type: LUI, AUIPC
            IMM_U: begin
                immediate = {
                    bits_31_12,
                    12'b0
                };
            end

            // J-type: JAL
            IMM_J: begin
                immediate = {
                    {11{bit_31}},
                    bit_31,
                    bits_19_12,
                    bits_24_20[0],
                    bits_30_21,
                    1'b0
                };
            end

            default: begin
                immediate = 32'b0;
            end

        endcase
    end

endmodule