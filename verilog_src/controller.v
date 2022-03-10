 
module controller
#(
    parameter BUS_WIDTH = 32
)
(
    input clk,
    input nreset
);

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
JMP IMM            0               jump to imm
JE  IMM            1          jump to imm if CMP EQUAL
JNE IMM            2        jump to imm if CMP not EQUAL
JG  IMM            3         jump to imm if CMP GREATER
JNG IMM            4       jump to imm if CMP not GREATER
JL  IMM            5           jump to imm if CMP LESS
JNL IMM            6        jump to imm if CMP not LESS
JMP RO             7             jump to addr in R0
JE  R0            8       jump to addr in R0 if CMP EQUAL
JNE R0            9     jump to addr in R0 if CMP not EQUAL
JG  R0           10      jump to addr in R0 if CMP GREATER
JNG R0           11    jump to addr in R0 if CMP not GREATER
JL  R0           12        jump to addr in R0 if CMP LESS
JNL R0           13      jump to addr in R0 if CMP not LESS
SJF IMM          14             jump forward IMM word
SJB IMM          15               jump back IMM word

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
JMP IMM            0               jump to imm
JE  IMM            1          jump to imm if CMP EQUAL
JNE IMM            2        jump to imm if CMP not EQUAL
JG  IMM            3         jump to imm if CMP GREATER
JNG IMM            4       jump to imm if CMP not GREATER
JL  IMM            5           jump to imm if CMP LESS
JNL IMM            6        jump to imm if CMP not LESS
JMP RO             7             jump to addr in R0
JE  R0             8       jump to addr in R0 if CMP EQUAL
JNE R0             9     jump to addr in R0 if CMP not EQUAL
JG  R0            10      jump to addr in R0 if CMP GREATER
JNG R0            11    jump to addr in R0 if CMP not GREATER
JL  R0            12        jump to addr in R0 if CMP LESS
JNL R0            13      jump to addr in R0 if CMP not LESS
SJF IMM           14             jump forward IMM word
SJB IMM           15               jump back IMM word
*/

endmodule
