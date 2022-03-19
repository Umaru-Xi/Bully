`timescale 1ns/1ps

module protected_flag_sim();

parameter bus_width = 32;
parameter freq = 1000000;

reg clk = 1'b0;
reg nreset = 1'b1;
reg set = 1'b0;
reg [bus_width - 1 : 0]protected_addr_in = 'd0;
wire protected_flag;
wire [bus_width - 1 : 0]protected_addr;

parameter clk_cnt_max = ((1000000000 / freq) >> 1);

initial
begin
    $dumpfile("wave.vcd");
    $dumpvars;
    nreset = 1'b1;
    set = 1'b0;
    #(1 * clk_cnt_max * 2ns) nreset = 1'b0;
    #(1 * clk_cnt_max * 2ns) nreset = 1'b1;
    #(3 * clk_cnt_max * 2ns) protected_addr_in = 'd3;
    #(1 * clk_cnt_max * 2ns) set = 1'b1;
    #(1 * clk_cnt_max * 2ns) set = 1'b0;
    #(3 * clk_cnt_max * 2ns) protected_addr_in = 'd2;
    #(1 * clk_cnt_max * 2ns) set = 1'b1;
    #(1 * clk_cnt_max * 2ns) set = 1'b0;
    #(1 * clk_cnt_max * 2ns) set = 1'b1;
    #(1 * clk_cnt_max * 2ns) set = 1'b0;
    #(1 * clk_cnt_max * 2ns) nreset = 1'b0;
    #(1 * clk_cnt_max * 2ns) nreset = 1'b1;
    #(3 * clk_cnt_max * 2ns) protected_addr_in = 'd1;
    #(5 * clk_cnt_max * 2ns) $finish;
end

always #clk_cnt_max clk <= ~clk;

protected_flag #(
    .BUS_WIDTH(bus_width)
)
PROTECTED_FLAG0(
    .clk(clk),
    .nreset(nreset),
    .set(set),
    .protected_addr_in(protected_addr_in),
    .protected_flag(protected_flag),
    .protected_addr(protected_addr)
);

endmodule 
