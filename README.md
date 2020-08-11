# Five-stage-pipeline

Designed implementation and testing of the five stages (Instruction Fetch, Instruction
Decode, Instruction Execute, Memory, Write back) of the five-stage pipelined CPU using the Xilinx design package for
FPGAs. 

Instruction Fetch - n the IF stage, there is an instruction memory module and an adder between two pipeline registers. The left most pipelineregister is the PC; it holds 100. In the end of the first cycle (at the rising edge of clk), the instruction fetched from instruction memory is written into the IF/ID register. Meanwhile, the output of the adder (PC + 4, the next PC)is written into PC. 


Instriction Decode- There are two jobs in the second cycle: to decode the first instruction in the ID stage, and to fetch the second instruction in the IF stage. The two instructions are shown on the top of the figures: the first instruction is in the ID stage, and the second instruction is in the IF stage. The first instruction in the ID stage comes from the IF/ID register. Two operands are read from the register file (Regfile in the figure) based on rs and rt, although the lw instruction does not use the operand in the register rt. The immediate (imm) is sign-extended into 32 bits. The regrt signal is used in the ID stage that selects the destination register number; all others must be written into the ID/EXE register for later use. At the end of the second cycle, all the data and control signals, except for regrt, in the ID stage are written into the ID/EXEregister. At thesame time, the PC and the IF/ID register are also updated.


Instruction Execute-The ALU performs addition, and the multiplexer selects the immediate. A letter “e” is prefixed to each control signal in order to distinguish it from that in the ID stage. The second instruction is being decoded in the ID stage and the third instruction is being fetched in the IF stage. All the four pipeline registers are updated at the end of the cycle. 


Memory - The only task in this stage is to read data memory. All the control signals have a prefix “m”. The second instruction entered the EXE stage; the third instruction is being decoded inthe ID stage; and the fourth instruction is being fetched in the IF stage. All the five pipeline registers are updated at the end of the cycle.


Write Back- The memory data is selected
and will be written into the register file at the end of the cycle. All the control signal have a prefix “w”. The
second instruction entered the MEM stage; the third instruction entered the EXE stage; the fourth instruction is
being decoded in the ID stage; and the fifth instruction is being fetched in the IF stage. All the six pipeline
registers are updated at the end of the cycle (the destination register is considered as the six pipeline register).
Then the first instruction is committed. In each of the forth coming clock cycles, an instruction will be commited
and a new instruction will enter the pipeline

![Pipeline](https://i1.wp.com/www.ankitcodinghub.com/wp-content/uploads/2018/10/605.png?w=980&ssl=1)
