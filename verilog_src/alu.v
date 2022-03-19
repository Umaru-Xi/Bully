 
module alu
#(
    parameter BUS_WIDTH = 32
)
(
    input [3:0]opcode,
    input [BUS_WIDTH - 1 : 0]num_0,
    input [BUS_WIDTH - 1 : 0]num_1,
    output [BUS_WIDTH - 1 : 0]num_out,
    output over_flag,
    output zero_flag,
    output greater_flag,
    output equal_flag
);

parameter NUL_CMD = 4'b0000;
parameter ADD_CMD = 4'b0001;
parameter SUB_CMD = 4'b0010;
parameter AND_CMD = 4'b0100;
parameter OR_CMD = 4'b1000;
parameter XOR_CMD = 4'b0011;

wire [BUS_WIDTH : 0]add_out;
wire [BUS_WIDTH : 0]sub_out;
wire [BUS_WIDTH - 1 : 0]and_out;
wire [BUS_WIDTH - 1 : 0]or_out;
wire [BUS_WIDTH - 1 : 0]xor_out;

assign add_out = num_0 + num_1;
assign sub_out = (num_0 >= num_1)? num_0 - num_1 : num_1 - num_0;
assign and_out = num_0 & num_1;
assign or_out = num_0 | num_1;
assign xor_out = num_0 ^ num_1;

assign num_out = 
    (opcode == ADD_CMD)? add_out[BUS_WIDTH - 1 : 0] : (
    (opcode == SUB_CMD)? sub_out[BUS_WIDTH - 1 : 0] : (
    (opcode == AND_CMD)? and_out : (
    (opcode == OR_CMD)? or_out : (
    (opcode == XOR_CMD)? xor_out : 'd0
    ))));
assign over_flag = 
    (opcode == ADD_CMD)? add_out[BUS_WIDTH] : (
    (opcode == SUB_CMD)? ((num_0 >= num_1)? 1'b0 : 1'b1) : 
    1'b0);

assign equal_flag = (num_0 == num_1)? 1'b1 : 1'b0;
assign greater_flag = (num_0 > num_1)? 1'b1 : 1'b0;
assign zero_flag = (num_out == 0)? 1'b1 : 1'b0;

endmodule
