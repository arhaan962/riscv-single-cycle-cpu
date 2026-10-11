
module data_memory(
    input clk,
    input mem_read,
    input mem_write,

    input [31:0] address,
    input [31:0] write_data,

    input [1:0] mem_width,
    input load_unsigned,

    output reg [31:0] read_data
);

    // Memory containing 1024 bytes
    reg [7:0] memory [0:1023];

    integer i;

    // Initialize memory to zero for simulation
    initial begin
        for (i = 0; i < 1024; i = i + 1)
            memory[i] = 8'b0;
    end

    // Read operations: combinational
    always @(*) begin
        read_data = 32'b0;

        if (mem_read) begin
            case (mem_width)

                // LB / LBU
                2'b00: begin
                    if (load_unsigned)
                        read_data = {
                            24'b0, memory[address[9:0]]
                        };
                    else
                        read_data = {
                            {24{memory[address[9:0]][7]}},
                            memory[address[9:0]]
                        };
                end

                // LH / LHU
                2'b01: begin
                    if (load_unsigned)
                        read_data = {
                            16'b0,
                            memory[address[9:0] + 10'd1],
                            memory[address[9:0]]
                        };
                    else
                        read_data = {
                            {16{memory[address[9:0] + 10'd1][7]}},
                            memory[address[9:0] + 10'd1],
                            memory[address[9:0]]
                        };
                end

                // LW
                2'b10: begin
                    read_data = {
                        memory[address[9:0] + 10'd3],
                        memory[address[9:0] + 10'd2],
                        memory[address[9:0] + 10'd1],
                        memory[address[9:0]]
                    };
                end

                default: read_data = 32'b0;

            endcase
        end
    end

    // Write operations: occur on the rising clock edge
    always @(posedge clk) begin
        if (mem_write) begin
            case (mem_width)

                // SB: store one byte
                2'b00: begin
                    memory[address[9:0]] <= write_data[7:0];
                end

                // SH: store two bytes
                2'b01: begin
                    memory[address[9:0]] <= write_data[7:0];
                    memory[address[9:0] + 10'd1]
                        <= write_data[15:8];
                end

                // SW: store four bytes
                2'b10: begin
                    memory[address[9:0]] <= write_data[7:0];
                    memory[address[9:0] + 10'd1]
                        <= write_data[15:8];
                    memory[address[9:0] + 10'd2]
                        <= write_data[23:16];
                    memory[address[9:0] + 10'd3]
                        <= write_data[31:24];
                end

                default: begin
                end

            endcase
        end
    end

endmodule