
module decoder
#(
    parameter BUS_WIDTH = 32
)
(
    input clk,
    input nreset,
    input [BUS_WIDTH - 1 : 0]data_in,
    output admin_flag,
    output [2:0]code_type,
    output [BUS_WIDTH - 5 : 0]opcode,
    output [BUS_WIDTH - 1 : 0]opdata0,
    output [BUS_WIDTH - 1 : 0]opdata1,
    output cmd_ready,
    output decoder_error
);

parameter CODE_MODE_USR = 1'b0;
parameter CODE_MODE_ADM = 1'b1;
parameter CODE_TYPE_CTL = 3'b111;
parameter CODE_TYPE_INT = 3'b000;
parameter CODE_TYPE_REG = 3'b001;
parameter CODE_TYPE_IMM = 3'b010;
parameter CODE_TYPE_JMP = 3'b100;
parameter CODE_OPCD_HLT = 'd0;
parameter CODE_OPCD_MOV = 'd0;
parameter CODE_OPCD_ADD = 'd1;
parameter CODE_OPCD_SUB = 'd2;
parameter CODE_OPCD_AND = 'd3;
parameter CODE_OPCD_OR  = 'd4;
parameter CODE_OPCD_XOR = 'd5;
parameter CODE_OPCD_CMP = 'd6;
parameter CODE_OPCD_JMP = 'd0;
parameter CODE_OPCD_JE  = 'd1;
parameter CODE_OPCD_JG  = 'd2;
parameter CODE_OPCD_SJF = 'd3;
parameter CODE_OPCD_SJB = 'd4;

reg admin_flag_internal = 1'b0;
reg [2:0]code_type_internal = 3'b000;
reg [BUS_WIDTH - 5 : 0]opcode_internal = 'd0;
reg [BUS_WIDTH - 1 : 0]opdata0_internal = 'd0;
reg [BUS_WIDTH - 1 : 0]opdata1_internal = 'd0;
reg cmd_ready_internal = 1'b0;
reg decoder_error_internal = 1'b0;

assign admin_flag = admin_flag_internal;
assign code_type = code_type_internal;
assign opcode = opcode_internal;
assign opdata0 = opdata0_internal;
assign opdata1 = opdata1_internal;
assign cmd_ready = cmd_ready_internal;
assign decoder_error = decoder_error_internal;

parameter fsm_state_stage0 = 4'b0001;
parameter fsm_state_stage1 = 4'b0010;
parameter fsm_state_stage2 = 4'b0100;
parameter fsm_state_stage3 = 4'b1000;
reg [3:0]fsm_state = fsm_state_stage0;

wire admin_flag_read;
wire [2:0]code_type_read;
wire [BUS_WIDTH - 5 : 0]opcode_read;

assign {admin_flag_read, code_type_read, opcode_read} = data_in;

always @(posedge clk or negedge nreset)
begin
    if(!nreset)
    begin
        admin_flag_internal <= 1'b0;
        code_type_internal <= 3'b000;
        opcode_internal <= 'd0;
        opdata0_internal <= 'd0;
        opdata1_internal <= 'd0;
        cmd_ready_internal <= 1'b0;
        fsm_state <= fsm_state_stage0;
        decoder_error_internal <= 1'b0;
    end
    else
    begin
        case(fsm_state)
            fsm_state_stage0:
            begin
                {admin_flag_internal, code_type_internal, opcode_internal} <= {admin_flag_read, code_type_read, opcode_read};
                cmd_ready_internal <= ((code_type_read == CODE_TYPE_CTL) || (code_type_read == CODE_TYPE_INT))? 1'b1 : 1'b0;
                fsm_state <= ((code_type_read == CODE_TYPE_CTL) || (code_type_read == CODE_TYPE_INT))? fsm_state_stage0 : fsm_state_stage1;
            end
            fsm_state_stage1:
            begin
                opdata0_internal <= data_in;
                cmd_ready_internal <= (code_type_internal == CODE_TYPE_JMP)? 1'b1 : 1'b0;
                fsm_state <= (code_type_internal == CODE_TYPE_JMP)? fsm_state_stage0 : fsm_state_stage2;
            end
            fsm_state_stage2:
            begin
                opdata1_internal <= data_in;
                cmd_ready_internal <= ((code_type_internal == CODE_TYPE_INT) || (code_type_internal == CODE_TYPE_IMM))? 1'b1 : 1'b0;
                fsm_state <= ((code_type_internal == CODE_TYPE_INT) || (code_type_internal == CODE_TYPE_IMM))? fsm_state_stage0 : fsm_state_stage3;
            end
            fsm_state_stage3:
            begin
                cmd_ready_internal <= 1'b0;
                fsm_state <= fsm_state_stage3;
                decoder_error_internal <= 1'b1;
            end
            default: fsm_state <= fsm_state_stage3;
        endcase
    end
end

/* Code:
======USER MODE======
Interrupt Type:        {4'b0000}{(BUS_WIDTH-4)'bOPCODE}
   ASM          OPCODE                 OP
INT IMM          IMM          trig USER interrupt IMM

Registers Type:      {4'b0001}{(BUS_WIDTH-4)'bOPCODE}{BUS_WIDTH'bADDR0}{BUS_WIDTH'bADDR1}
   ASM          OPCODE                 OP
MOV R0,R1          0                  R1=R0
ADD R0,R1          1                R1=R0+R1
SUB R0,R1          2                R1=R0-R1
AND R0,R1          3                R1=R0&R1
OR  R0,R1          4                R1=R0|R1
XOR R0,R1          5                R1=R0^R1
CMP R0,R1          6         check R0>R1 or R0==R1

Immidiate Type:     {4'b0010}{(BUS_WIDTH-4)'bOPCODE}{BUS_WIDTH'bADDR0}{BUS_WIDTH'bIMMIDIATE_NUM}
   ASM          OPCODE                 OP
MOV IMM,R0         0                 R0=IMM
ADD IMM,R0         1                R0=R0+IMM
SUB IMM,R0         2                R0=R0-IMM
AND IMM,R0         3                R0=R0&IMM
OR  IMM,R0         4                R0=R0|IMM
XOR IMM,R0         5                R0=R0^IMM
CMP IMM,R0         6         check IMM>R0 or R0==IMM

Jump Type:          {4'b0100}{(BUS_WIDTH-4)'bOPCODE}{BUS_WIDTH'bADDR0 or BUS_WIDTH'bIMMIDIATE_NUM}
   ASM          OPCODE                 OP
JMP R0             0             jump to addr in R0
JE  R0             1       jump to addr in R0 if CMP EQUAL
JG  R0             2      jump to addr in R0 if CMP GREATER
SJF IMM            3             jump forward IMM word
SJB IMM            4               jump back IMM word

======ADMIN MODE======
Control Type:          {4'b1111}{(BUS_WIDTH-4)'bOPCODE}
   ASM          OPCODE                 OP
HLT               0             halt the system
PRO IMM          IMM      go into protected mode, addr=IMM

Interrupt Type:        {4'b1000}{(BUS_WIDTH-4)'bOPCODE}
   ASM          OPCODE                 OP
INT IMM        IMM             trig interrupt IMM

Registers Type:      {4'b1001}{(BUS_WIDTH-4)'bOPCODE}{BUS_WIDTH'bADDR0}{BUS_WIDTH'bADDR1}
   ASM          OPCODE                 OP
MOV R0,R1          0                  R1=R0
ADD R0,R1          1                R1=R0+R1
SUB R0,R1          2                R1=R0-R1
AND R0,R1          3                R1=R0&R1
OR  R0,R1          4                R1=R0|R1
XOR R0,R1          5                R1=R0^R1
CMP R0,R1          6         check R0>R1 or R0==R1

Immidiate Type:     {4'b1010}{(BUS_WIDTH-4)'bOPCODE}{BUS_WIDTH'bADDR0}{BUS_WIDTH'bIMMIDIATE_NUM}
   ASM          OPCODE                 OP
MOV IMM,R0         0                 R0=IMM
ADD IMM,R0         1                R0=R0+IMM
SUB IMM,R0         2                R0=R0-IMM
AND IMM,R0         3                R0=R0&IMM
OR  IMM,R0         4                R0=R0|IMM
XOR IMM,R0         5                R0=R0^IMM
CMP IMM,R0         6         check IMM>R0 or R0==IMM

Jump Type:          {4'b1100}{(BUS_WIDTH-4)'bOPCODE}{BUS_WIDTH'bADDR0 or BUS_WIDTH'bIMMIDIATE_NUM}
   ASM          OPCODE                 OP
JMP R0             0             jump to addr in R0
JE  R0             1       jump to addr in R0 if CMP EQUAL
JG  R0             2      jump to addr in R0 if CMP GREATER
SJF IMM            3             jump forward IMM word
SJB IMM            4               jump back IMM word
*/

endmodule
