
module clock
#(
    parameter BUS_WIDTH = 32,
    parameter FREQ_IN = 25000000,
    parameter FREQ_OUT = 1000000
)
(
    input clk_in,
    output clk_out
);

parameter CNT_MAX = ((FREQ_IN / FREQ_OUT) >> 1);

reg clk_out_inner = 1'b0;
reg [BUS_WIDTH - 1 : 0]clk_in_cnt = 'd0;

assign clk_out = clk_out_inner;

always @(posedge clk_in)
begin
    if(clk_in_cnt < CNT_MAX)
    begin
        clk_in_cnt <= clk_in_cnt + 1'b1;
        clk_out_inner <= clk_out_inner;
    end
    else
    begin
        clk_in_cnt <= 'd0;
        clk_out_inner <= ~clk_out_inner;
    end
end

endmodule
