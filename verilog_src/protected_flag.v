 
module protected_flag
#(
    parameter BUS_WIDTH = 32
)
(
    input clk,
    input nreset,
    input set,
    input [BUS_WIDTH - 1 : 0]protected_addr_in,
    output protected_flag,
    output [BUS_WIDTH - 1 : 0]protected_addr
);

reg protected_flag_inner_sync = 1'b0;
reg protected_flag_inner_asyn = 1'b0;

reg [BUS_WIDTH - 1 : 0]protected_addr_inner = 0;

assign protected_flag = protected_flag_inner_sync | protected_flag_inner_asyn;
assign protected_addr = protected_addr_inner;

always @(posedge set or negedge nreset)
begin
    if(!nreset) 
    begin
        protected_flag_inner_asyn <= 1'b0;
        protected_addr_inner <= 0;
    end
    else
    begin
        protected_flag_inner_asyn <= 1'b1;
        protected_addr_inner <= (!protected_flag)? protected_addr_in : protected_addr_inner;
    end
end

always @(posedge clk or negedge nreset)
begin
    if(!nreset) 
        protected_flag_inner_sync <= 1'b0;
    else
    begin
        if(set) protected_flag_inner_sync <= 1'b1;
        else protected_flag_inner_sync <= protected_flag_inner_sync;
    end
end

endmodule
