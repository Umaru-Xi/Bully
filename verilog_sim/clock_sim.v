`timescale 1ns/1ps

module clock_sim();

parameter bus_width = 32;
parameter freq_in = 1000000;
parameter freq_out = 1000;

reg clk_in = 1'b0;

wire clk_out;

parameter clk_in_cnt_max = ((1000000000 / freq_in) >> 1);

initial
begin
    $dumpfile("wave.vcd");
    $dumpvars;
    #1000000000 $finish;
end

always #clk_in_cnt_max clk_in <= ~clk_in;

clock #(
    .BUS_WIDTH(bus_width),
    .FREQ_IN(freq_in),
    .FREQ_OUT(freq_out)
)
CLOCK0(
    .clk_in(clk_in),
    .clk_out(clk_out)
);

endmodule
