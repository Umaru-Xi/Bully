`timescale 1ns/1ps

module regs_sim();

parameter bus_width = 32;
parameter regs_num = 16;
parameter freq = 1000000;

reg clk = 1'b0;
reg nreset = 1'b1;

reg [bus_width - 1 : 0]addr_write = 0;
reg [bus_width - 1 : 0]data_write = 0;
reg [bus_width - 1 : 0]addr_read = 0;

wire [bus_width - 1 : 0]data_read;
wire ready;

parameter clk_cnt_max = ((1000000000 / freq) >> 1);

initial
begin
    $dumpfile("wave.vcd");
    $dumpvars;
    nreset = 1'b1;
    #(5 * clk_cnt_max * 2ns)  nreset = 1'b0;
    #(5 * clk_cnt_max * 2ns)  nreset = 1'b1;
    #(5 * clk_cnt_max * 2ns)  addr_read = 0;
    #(5 * clk_cnt_max * 2ns)  
        addr_write = 1;
        data_write = 2;
    #(5 * clk_cnt_max * 2ns)  addr_read = addr_write;
    #(5 * clk_cnt_max * 2ns)  
        data_write = 1;
        addr_write = regs_num - 1;
    #(5 * clk_cnt_max * 2ns)  addr_read = regs_num - 1;
    #(5 * clk_cnt_max * 2ns)  addr_read = regs_num;
    #(5 * clk_cnt_max * 2ns) $finish;
end

always #clk_cnt_max clk <= ~clk;

regs #(
    .BUS_WIDTH(bus_width),
    .REGS_NUM(regs_num)
)
REGS0(
    .clk(clk),
    .nreset(nreset),
    .addr_write(addr_write),
    .data_write(data_write),
    .addr_read(addr_read),
    .data_read(data_read),
    .ready(ready)
);

endmodule
