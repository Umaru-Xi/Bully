`timescale 1ns/1ps

module decoder_sim();

parameter bus_width = 32;
parameter freq = 1000000;

reg clk = 1'b0;
reg nreset = 1'b1;

wire [bus_width - 1 : 0]data_in;

wire admin_flag;
wire [2:0]code_type;
wire [bus_width - 5 : 0]opcode;
wire [bus_width - 1 : 0]opdata0;
wire [bus_width - 1 : 0]opdata1;
wire cmd_ready;
wire decoder_error;

parameter CODE_MODE_USR = 1'b0;
parameter CODE_MODE_ADM = 1'b1;
parameter CODE_TYPE_CTL = 3'b111;
parameter CODE_TYPE_INT = 3'b000;
parameter CODE_TYPE_REG = 3'b001;
parameter CODE_TYPE_IMM = 3'b010;
parameter CODE_TYPE_JMP = 3'b100;
parameter CODE_OPCD_HLT = 'd0;
parameter CODE_OPCD_MOV = 'd0;
parameter CODE_OPCD_ADD = 'd1;
parameter CODE_OPCD_SUB = 'd2;
parameter CODE_OPCD_AND = 'd3;
parameter CODE_OPCD_OR  = 'd4;
parameter CODE_OPCD_XOR = 'd5;
parameter CODE_OPCD_CMP = 'd6;
parameter CODE_OPCD_JMP = 'd0;
parameter CODE_OPCD_JE  = 'd1;
parameter CODE_OPCD_JG  = 'd2;
parameter CODE_OPCD_SJF = 'd3;
parameter CODE_OPCD_SJB = 'd4;

parameter clk_cnt_max = ((1000000000 / freq) >> 1);

reg is_command = 1'b0;
reg [bus_width - 1 : 0]opdata = 'd0;
reg admin_flag_input = 1'b0;
reg [2:0]code_type_input = 3'b000;
reg [bus_width - 5 : 0]opcode_input = 'd0;
assign data_in = (is_command)? {admin_flag_input, code_type_input, opcode_input} : opdata;


initial
begin
    $dumpfile("wave.vcd");
    $dumpvars;
    nreset = 1'b1;
    #(2 * clk_cnt_max * 2ns) nreset = 1'b0;
    #(2 * clk_cnt_max * 2ns) 
        nreset = 1'b1;
        is_command = 1'b1;
        admin_flag_input = 1'b0;
        code_type_input = CODE_TYPE_IMM;
        opcode_input = CODE_OPCD_ADD;
    #(1 * clk_cnt_max * 2ns) 
        is_command = 1'b0;
        opdata = 'd1;
    #(1 * clk_cnt_max * 2ns) 
        is_command = 1'b0;
        opdata = 'd4;
    #(1 * clk_cnt_max * 2ns) 
        is_command = 1'b1;
        admin_flag_input = 1'b1;
        code_type_input = CODE_TYPE_INT;
        opcode_input = 'd1;
    #(1 * clk_cnt_max * 2ns) 
        is_command = 1'b1;
        admin_flag_input = 1'b1;
        code_type_input = CODE_TYPE_JMP;
        opcode_input = CODE_OPCD_JG;
    #(1 * clk_cnt_max * 2ns) 
        is_command = 1'b0;
        opdata = 'd2;
    #(1 * clk_cnt_max * 2ns) 
        is_command = 1'b1;
        admin_flag_input = 1'b1;
        code_type_input = 3'b101;
        opcode_input = CODE_OPCD_SJB;
    #(1 * clk_cnt_max * 2ns) 
        is_command = 1'b0;
        opdata = 'd0;
    #(5 * clk_cnt_max * 2ns) $finish;
end

always #clk_cnt_max clk <= ~clk;

decoder #(
    .BUS_WIDTH(bus_width)
)
DECODER0(
    .clk(clk),
    .nreset(nreset),
    .data_in(data_in),
    .admin_flag(admin_flag),
    .code_type(code_type),
    .opcode(opcode),
    .opdata0(opdata0),
    .opdata1(opdata1),
    .cmd_ready(cmd_ready),
    .decoder_error(decoder_error)
);

endmodule
