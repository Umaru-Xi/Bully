
module ram_memory
#(
    parameter BUS_WIDTH = 32,
    parameter ADDR_BASE = 0,
    parameter MEM_SIZE = 256
)
(
    input clk,
    input nreset,
    input write_en,
    input [BUS_WIDTH - 1 : 0]addr_write,
    input [BUS_WIDTH - 1 : 0]data_write,
    input [BUS_WIDTH - 1 : 0]addr_read,
    output [BUS_WIDTH - 1 : 0]data_read,
    output ready
);

reg [BUS_WIDTH - 1 : 0]ram_memory_reg[MEM_SIZE - 1 : 0];
reg ready_buffer = 1'b0;

wire [BUS_WIDTH - 1 : 0]addr_write_internal;
wire [BUS_WIDTH - 1 : 0]addr_read_internal;

assign ready = ready_buffer;
assign addr_write_internal = addr_write - ADDR_BASE;
assign addr_read_internal = addr_read - ADDR_BASE;
assign data_read = (addr_read_internal < MEM_SIZE)? ram_memory_reg[addr_read_internal] : 'd0;

integer index = 0;
initial
begin
    ready_buffer <= 1'b0;
    for(index = 0; index < MEM_SIZE; index = index + 1)
    begin
        ram_memory_reg[index] <= 'd0;
    end
end

always @(posedge clk or negedge nreset)
begin
    if(!nreset)
    begin
        ready_buffer <= 1'b0;
        for(index = 0; index < MEM_SIZE; index = index + 1)
        begin
            ram_memory_reg[index] <= 'd0;
        end
    end
    else
    begin
        ready_buffer <= 1'b1;
        if(addr_read_internal < MEM_SIZE)
            ram_memory_reg[addr_write_internal] <= (write_en)? data_write : ram_memory_reg[addr_write_internal];
        else
            for(index = 0; index < MEM_SIZE; index = index + 1)
            begin
                ram_memory_reg[index] <= ram_memory_reg[index];
            end
    end
end

endmodule
