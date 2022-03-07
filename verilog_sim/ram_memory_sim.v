`timescale 1ns/1ps

module ram_memory_sim();

parameter bus_width = 32;
parameter addr_base = 10;
parameter mem_size = 32;
parameter freq = 1000000;

reg clk = 1'b0;
reg nreset = 1'b1;
reg write_en = 1'b0;

reg [bus_width - 1 : 0]addr_write = 0;
reg [bus_width - 1 : 0]data_write = 0;
reg [bus_width - 1 : 0]addr_read = 0;

wire [bus_width - 1 : 0]data_read;

parameter clk_cnt_max = ((1000000000 / freq) >> 1);

initial
begin
    $dumpfile("wave.vcd");
    $dumpvars;
    nreset = 1'b1;
    #(2 * clk_cnt_max * 2ns) nreset = 1'b0;
    #(2 * clk_cnt_max * 2ns) nreset = 1'b1;
    #(2 * clk_cnt_max * 2ns) addr_read = addr_base;
    #(2 * clk_cnt_max * 2ns)
        data_write = 2;
        addr_write = addr_base + 1;
    #(1 * clk_cnt_max * 2ns) write_en = 1'b1;
    #(1 * clk_cnt_max * 2ns) addr_read = addr_write;
    #(1 * clk_cnt_max * 2ns) data_write = 1;
    #(1 * clk_cnt_max * 2ns) write_en = 1'b0;
    #(1 * clk_cnt_max * 2ns) addr_write = addr_base + mem_size - 1;
    #(1 * clk_cnt_max * 2ns) write_en = 1'b1;
    #(1 * clk_cnt_max * 2ns) write_en = 1'b1;
    #(1 * clk_cnt_max * 2ns) addr_read = addr_base + mem_size - 1;
    #(2 * clk_cnt_max * 2ns) addr_read = addr_base + mem_size;
    #(5 * clk_cnt_max * 2ns) $finish;
end

always #clk_cnt_max clk <= ~clk;

ram_memory #(
    .BUS_WIDTH(bus_width),
    .ADDR_BASE(addr_base),
    .MEM_SIZE(mem_size)
)
RAM_MEMORY0(
    .clk(clk),
    .nreset(nreset),
    .write_en(write_en),
    .addr_write(addr_write),
    .data_write(data_write),
    .addr_read(addr_read),
    .data_read(data_read)
);

endmodule
