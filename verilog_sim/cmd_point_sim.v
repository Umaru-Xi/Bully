`timescale 1ns/1ps

module cmd_point_sim();

parameter bus_width = 32;
parameter cmd_point_base = 0;
parameter freq = 1000000;

parameter NUL_CMD = 3'b000;
parameter JMP_CMD = 3'b001;
parameter SJF_CMD = 3'b010;
parameter SJB_CMD = 3'b100;

reg clk = 1'b0;
reg nreset = 1'b1;
reg [2:0]opcode = NUL_CMD;
reg [bus_width - 1 : 0]addr_to = 'd0;

wire [bus_width - 1 : 0]addr_point;
wire ready;

parameter clk_cnt_max = ((1000000000 / freq) >> 1);

initial
begin
    $dumpfile("wave.vcd");
    $dumpvars;
    nreset = 1'b1;
    #(2 * clk_cnt_max * 2ns) nreset = 1'b0;
    #(2 * clk_cnt_max * 2ns) 
        nreset = 1'b1;
        addr_to = 32'h00001234;
    #(10 * clk_cnt_max * 2ns) opcode = JMP_CMD;
    #(1 * clk_cnt_max * 2ns) 
        opcode = NUL_CMD;
        addr_to = 32'h00000002;
    #(10 * clk_cnt_max * 2ns) opcode = SJF_CMD;
    #(1 * clk_cnt_max * 2ns) 
        opcode = NUL_CMD;
        addr_to = 32'h00000002;
    #(10 * clk_cnt_max * 2ns) opcode = SJB_CMD;
    #(1 * clk_cnt_max * 2ns) opcode = NUL_CMD;
    #(5 * clk_cnt_max * 2ns) $finish;
end

always #clk_cnt_max clk <= ~clk;

cmd_point #(
    .BUS_WIDTH(bus_width),
    .CMD_POINT_BASE(cmd_point_base)
)
CMD_POINT0(
    .clk(clk),
    .nreset(nreset),
    .opcode(opcode),
    .addr_to(addr_to),
    .addr_point(addr_point),
    .ready(ready)
);

endmodule
