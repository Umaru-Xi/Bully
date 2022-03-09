
module regs
#(
    parameter BUS_WIDTH = 32,
    parameter REGS_NUM = 16
)
(
    input clk,
    input nreset,
    input [BUS_WIDTH - 1 : 0]addr_write,
    input [BUS_WIDTH - 1 : 0]data_write,
    input [BUS_WIDTH - 1 : 0]addr_read,
    output [BUS_WIDTH - 1 : 0]data_read,
    output ready
);

reg [BUS_WIDTH - 1 : 0]regs_group[REGS_NUM - 1 : 0];
reg [BUS_WIDTH - 1 : 0]data_read_buffer = 0;
reg ready_buffer = 1'b0;

assign ready = ready_buffer;

assign addr_write_internal = addr_write;

assign data_read = (addr_read < REGS_NUM)? regs_group[addr_read] : 0;

integer index = 0;
initial
begin
    ready_buffer <= 1'b0;
    for(index = 0; index < REGS_NUM; index = index + 1)
    begin
        regs_group[index] <= 0;
    end
end

always @(posedge clk or negedge nreset)
begin
    if(!nreset)
    begin
        ready_buffer <= 1'b0;
        for(index = 0; index < REGS_NUM; index = index + 1)
        begin
            regs_group[index] <= 0;
        end
    end
    else
    begin
        ready_buffer <= 1'b1;
        if(addr_write < REGS_NUM)
            regs_group[addr_write] <= data_write;
        else
            for(index = 0; index < REGS_NUM; index = index + 1)
            begin
                regs_group[index] <= regs_group[index];
            end
    end
end

endmodule
