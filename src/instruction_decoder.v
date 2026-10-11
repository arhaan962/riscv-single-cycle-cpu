
module instruction_decoder(
    input [31:0] instruction,

    // Common instruction fields
    output [6:0]  opcode,       // Bits [6:0]
    output [2:0]  bits_14_12,   // Bits [14:12]
    output [4:0]  bits_19_15,   // Bits [19:15]
    output [4:0]  bits_24_20,   // Bits [24:20]
    output [4:0]  bits_11_7,    // Bits [11:7]
    output [6:0]  bits_31_25,   // Bits [31:25]

    // Contiguous immediate fields
    output [11:0] bits_31_20,   // Bits [31:20], I-type immediate
    output [19:0] bits_31_12,   // Bits [31:12], U-type immediate

    // Additional fields for S-type and B-type
   
    output        bit_31,
    output [30:25] bits_30_25,
    output [11:8]  bits_11_8,
    output        bit_7,

    // Additional fields for J-type
    output [30:21] bits_30_21,
    output [19:12] bits_19_12
);

    // Extract fixed bit ranges directly from the instruction
    assign opcode            = instruction[6:0];
    assign bits_14_12        = instruction[14:12];
    assign bits_19_15        = instruction[19:15];
    assign bits_24_20        = instruction[24:20];
    assign bits_11_7         = instruction[11:7];
    assign bits_31_25        = instruction[31:25];

    assign bits_31_20        = instruction[31:20];
    assign bits_31_12        = instruction[31:12];

    
    assign bit_31            = instruction[31];
    assign bits_30_25        = instruction[30:25];
    assign bits_11_8         = instruction[11:8];
    assign bit_7             = instruction[7];

    assign bits_30_21        = instruction[30:21];
    assign bits_19_12        = instruction[19:12];

endmodule
