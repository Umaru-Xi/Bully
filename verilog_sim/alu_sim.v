`timescale 1ns/1ps

module alu_sim();

parameter bus_width = 32;

parameter NUL_CMD = 4'b0000;
parameter ADD_CMD = 4'b0001;
parameter SUB_CMD = 4'b0010;
parameter AND_CMD = 4'b0100;
parameter OR_CMD = 4'b1000;
parameter XOR_CMD = 4'b0011;

reg [3:0]opcode = NUL_CMD;
reg [bus_width - 1 : 0]num_0 = 'd0;
reg [bus_width - 1 : 0]num_1 = 'd0;
wire [bus_width - 1 : 0]num_out;
wire over_flag;
wire zero_flag;
wire greater_flag;
wire equal_flag;

initial
begin
    $dumpfile("wave.vcd");
    $dumpvars;
    opcode = NUL_CMD;
    #10 num_0 = 32'hfffffff1; num_1 = 32'h00000001;
    #10 num_0 = 32'h00000001; num_1 = 32'hfffffff1;
    #10 num_0 = 32'hfffffff1; num_1 = 32'h0000000f;
    #10 num_0 = 32'h0000000f; num_1 = 32'hfffffff1;
    #10 num_0 = 32'h0000ffff; num_1 = 32'h0000ffff;
    #10 num_0 = 32'h7e7e7e7e; num_1 = 32'h5555aaaa;
    #10 opcode = ADD_CMD;
    num_0 = 32'hfffffff1; num_1 = 32'h00000001;
    #10 num_0 = 32'h00000001; num_1 = 32'hfffffff1;
    #10 num_0 = 32'hfffffff1; num_1 = 32'h0000000f;
    #10 num_0 = 32'h0000000f; num_1 = 32'hfffffff1;
    #10 num_0 = 32'h0000ffff; num_1 = 32'h0000ffff;
    #10 num_0 = 32'h7e7e7e7e; num_1 = 32'h5555aaaa;
    #10 opcode = SUB_CMD;
    num_0 = 32'hfffffff1; num_1 = 32'h00000001;
    #10 num_0 = 32'h00000001; num_1 = 32'hfffffff1;
    #10 num_0 = 32'hfffffff1; num_1 = 32'h0000000f;
    #10 num_0 = 32'h0000000f; num_1 = 32'hfffffff1;
    #10 num_0 = 32'h0000ffff; num_1 = 32'h0000ffff;
    #10 num_0 = 32'h7e7e7e7e; num_1 = 32'h5555aaaa;
    #10 opcode = AND_CMD;
    num_0 = 32'hfffffff1; num_1 = 32'h00000001;
    #10 num_0 = 32'h00000001; num_1 = 32'hfffffff1;
    #10 num_0 = 32'hfffffff1; num_1 = 32'h0000000f;
    #10 num_0 = 32'h0000000f; num_1 = 32'hfffffff1;
    #10 num_0 = 32'h0000ffff; num_1 = 32'h0000ffff;
    #10 num_0 = 32'h7e7e7e7e; num_1 = 32'h5555aaaa;
    #10 opcode = OR_CMD;
    num_0 = 32'hfffffff1; num_1 = 32'h00000001;
    #10 num_0 = 32'h00000001; num_1 = 32'hfffffff1;
    #10 num_0 = 32'hfffffff1; num_1 = 32'h0000000f;
    #10 num_0 = 32'h0000000f; num_1 = 32'hfffffff1;
    #10 num_0 = 32'h0000ffff; num_1 = 32'h0000ffff;
    #10 num_0 = 32'h7e7e7e7e; num_1 = 32'h5555aaaa;
    #10 opcode = XOR_CMD;
    num_0 = 32'hfffffff1; num_1 = 32'h00000001;
    #10 num_0 = 32'h00000001; num_1 = 32'hfffffff1;
    #10 num_0 = 32'hfffffff1; num_1 = 32'h0000000f;
    #10 num_0 = 32'h0000000f; num_1 = 32'hfffffff1;
    #10 num_0 = 32'h0000ffff; num_1 = 32'h0000ffff;
    #10 num_0 = 32'h7e7e7e7e; num_1 = 32'h5555aaaa;
    #10 $finish;
end

alu #(
    .BUS_WIDTH(bus_width)
)
ALU0(
    .opcode(opcode),
    .num_0(num_0),
    .num_1(num_1),
    .num_out(num_out),
    .over_flag(over_flag),
    .zero_flag(zero_flag),
    .greater_flag(greater_flag),
    .equal_flag(equal_flag)
);

endmodule
