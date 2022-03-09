
module cmd_point
#(
    parameter BUS_WIDTH = 32
)
(
    input clk,
    input nreset,
    input [2:0]opcode,
    input [BUS_WIDTH - 1 : 0]addr_to,
    output [BUS_WIDTH - 1 : 0]addr_point,
    output ready
);

parameter NUL_CMD = 3'b000;
parameter JMP_CMD = 3'b001;
parameter SJF_CMD = 3'b010;
parameter SJB_CMD = 3'b100;

reg [BUS_WIDTH - 1 : 0]addr_point_internal = 0;
reg ready_buffer = 1'b0;

assign addr_point = addr_point_internal;
assign ready = ready_buffer;

always @(posedge clk or negedge nreset)
begin
    if(!nreset)
    begin
        ready_buffer <= 1'b0;
        addr_point_internal <= 0;
    end
    else
    begin
        ready_buffer <= 1'b1;
        case(opcode)
            JMP_CMD: addr_point_internal <= addr_to;
            SJF_CMD: addr_point_internal <= addr_point + addr_to;
            SJB_CMD: addr_point_internal <= addr_point - addr_to;
            default: addr_point_internal <= addr_point + 1'b1;
        endcase
    end
end

endmodule
