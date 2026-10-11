
module alu(
    input [31:0] operand_a,
    input [31:0] operand_b,
    input [3:0] alu_control,

    output reg [31:0] result
);

    // ALU operation codes: must match control_unit.v
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

    always @(*) begin

        // Default result
        result = 32'b0;

        case (alu_control)

            ALU_ADD: begin
                result = operand_a + operand_b;
            end

            ALU_SUB: begin
                result = operand_a - operand_b;
            end

            ALU_SLL: begin
                result = operand_a << operand_b[4:0];
            end

            ALU_SLT: begin
                result = ($signed(operand_a) < $signed(operand_b))
                         ? 32'd1 : 32'd0;
            end

            ALU_SLTU: begin
                result = (operand_a < operand_b)
                         ? 32'd1 : 32'd0;
            end

            ALU_XOR: begin
                result = operand_a ^ operand_b;
            end

            ALU_SRL: begin
                result = operand_a >> operand_b[4:0];
            end

            ALU_SRA: begin
                result = $signed(operand_a) >>> operand_b[4:0];
            end

            ALU_OR: begin
                result = operand_a | operand_b;
            end

            ALU_AND: begin
                result = operand_a & operand_b;
            end

            default: begin
                result = 32'b0;
            end

        endcase
    end

endmodule