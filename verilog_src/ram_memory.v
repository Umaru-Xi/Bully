
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
    output [BUS_WIDTH - 1 : 0]data_read
);

reg [BUS_WIDTH - 1 : 0]ram_memory_reg[MEM_SIZE - 1 : 0];
reg [BUS_WIDTH - 1 : 0]data_read_buffer = 0;

wire [BUS_WIDTH - 1 : 0]addr_write_internal;
wire [BUS_WIDTH - 1 : 0]addr_read_internal;

assign data_read = data_read_buffer;
assign addr_write_internal = addr_write - ADDR_BASE;
assign addr_read_internal = addr_read - ADDR_BASE;

integer index = 0;
initial
begin
    for(index = 0; index < MEM_SIZE; index = index + 1)
    begin
        ram_memory_reg[index] <= 0;
    end
end

always @(posedge clk or negedge nreset)
begin
    if(!nreset)
    begin
        for(index = 0; index < MEM_SIZE; index = index + 1)
        begin
            ram_memory_reg[index] <= 0;
        end
    end
    else
    begin
        data_read_buffer <= (addr_read_internal < MEM_SIZE)? ram_memory_reg[addr_read_internal] : 0;
        if(addr_read_internal < MEM_SIZE)
            ram_memory_reg[addr_write_internal] <= (write_en)? data_write : ram_memory_reg[addr_write_internal];
        else
            ram_memory_reg[addr_write_internal] <= ram_memory_reg[addr_write_internal];
    end
end

endmodule
