`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CompEng 331 Lab3 
// Engineer: Rachel Brooks
// Create Date: 07/01/2020 11:04:19 PM

// Module Name: ID and IF STAGES
//////////////////////////////////////////////////////////////////////////////////

//module 1 : pc - set current pc to next pc at edge of CPU
module pc(input [31:0] nextpc, output reg [31:0] outpc, input clk);
    always @ (posedge clk) 
    begin
        outpc <= nextpc; //updates pc with next one
    end
endmodule

//module 2: adder - take in PC and output next PC (PC+4)
module adder(input [31:0] inpc,output reg [31:0] outpc);
   initial 
   begin
       outpc <=100;  //starts at 100
   end
   always @(inpc)
       begin 
           outpc <= inpc + 4; //adds 4 to the pc for the next one
        end
endmodule
 
//module 3: IF/ID - takes in d0 and outputs it at edge of clk
module IF_ID(input clk, input [31:0] d, output reg [31:0] out);
    always @(posedge clk) 
    begin
        out <= d;
    end
endmodule

//module 4: Instruction Memory - takes in an address and outputs a 32 bit instruction d0
module instMem(input [31:0] add, output reg [31:0] instr);
    reg [31:0] MEM[0:127];
    initial 
    begin
        MEM[100] = 32'b10001100001000100000000000000000;//100: lw $v0, 00($at) 
        MEM[104] = 32'b10001100001000110000000000000100; //104: lw $v1, 04($at) # $3 ß? memory[$1+04]; load x[1]
        MEM[108] = 32'b10001100001001000000000000001000;
        MEM[112] = 32'b10001100001001010000000000001100;
    end
    always @(add) //at address put it in for instructions
    begin
        instr <= MEM[add] ;
    end
endmodule 

//module 5: RegFile - takes in source register and outputs data in register 
module regFile(input clk, input [4:0] rs, input [4:0] rt, input we, input [4:0] wn,input [31:0] d, output reg [31:0] qa, output reg [31:0] qb);
    integer i;
    reg [31:0] rf[31:0];

    initial 
    begin
        for (i=0;i<32;i=i+1) 
        begin
            rf[i] <= 32'd0;
           
        end
    end 
    
    always @(*)
    begin
        qa <= rf[rs];
        qb <= rf[rt];
    end
    
    always @ (negedge clk)
    begin
        if(we)
        begin
            rf[wn] <= d;
        end
     end   
    
endmodule

//module 6: Sign Extension - immediate (imm) is sign-extended into 32 bits
module signEx(input [15:0] in, output reg [31:0] signedout);
    always @(in) 
    begin
        signedout = { {16{in[15]}}, in[15:0]};
    end
endmodule

//module 7: Control Unit - Use the op and func to help determine output (incorporates ALU)
module controlUnit(input [5:0] op, input [5:0] func, output reg wreg, output reg m2reg, output reg wmem, output reg [3:0] aluc, output reg aluimm, output reg regrt);
    
    always @(op, func) 
    begin
        wreg <= 1;
        m2reg <= 1;
        wmem <= 0;
        aluc <= 4'b0010;
        aluimm <= 1;
        regrt <= 1;
    end
endmodule

//module 8 : Multiplexer - 2:1 mux w selector
module mux(input [31:0] rd, input [31:0] rt, input regrt, output reg [31:0] out);
    always @(*) 
    begin
        out <= (regrt) ? rt:rd;
    end
endmodule

//module 9:ID/EXE 
module ID_EXE(input clk, input wreg, input m2reg,input wmem, input [3:0] aluc, input aluimm, input [4:0] mux, input [31:0] qa, input [31:0] qb,
    input [31:0] exout, output reg ewreg, output reg em2reg,output reg ewmem, output reg [3:0] ealuc, output reg ealuimm, output reg [4:0] emux,
    output reg [31:0] eqa, output reg [31:0] eqb, output reg [31:0] eexout);

    always @(posedge clk) 
    begin
        ewreg<=wreg;
        em2reg<=m2reg;
        ewmem<=wmem;
        ealuc<=aluc;
        ealuimm<=aluimm;
        emux<=mux;
        eqa<=qa;
        eqb<=qb;
        eexout<=exout;
    end
endmodule

//module 10:ALU - performs additions
module ALU(input [31:0] a, input [31:0] b, input [3:0] ealuc, output reg [31:0] r);

    always @ (*) 
    begin
        if(ealuc==4'b0010) 
        begin
            r <= a+b;
        end
    end
endmodule

//module 11:Multiplexer in EXE - slects immediate
module exe_mux(input [31:0] eqb, input [31:0] exout , input ealuimm, output reg [31:0] b);
    always @(*) 
    begin
        b <= (ealuimm) ? exout:eqb;
    end
endmodule

//module 12: EXE/MEM
module EXE_MEM(input clk, input ewreg, input em2reg, input ewmem, input [4:0] emux, input [31:0] r, input [31:0] qb, 
    output reg mwreg, output reg mm2reg, output reg mwmem, output reg [4:0] mmux, output reg [31:0] mr, output reg [31:0] di);
    
    always @(posedge clk)
    begin 
        mwreg <= ewreg;
        mm2reg <= em2reg;
        mwmem <= ewmem;
        mmux <= emux;
        mr <=r;
        di <= qb;
    end
endmodule

//Module 13: Datamemory - reads data memory
module Datamem(input [31:0] a, input [31:0] di, input we, output reg [31:0] do);

    reg [31:0] MEM[0:127];
    
    initial
    begin   
        MEM[0] = 32'hA00000AA;
        MEM[4] = 32'h10000011;
        MEM[8] = 32'h20000022;
        MEM[12] = 32'h30000033;
        MEM[16] = 32'h40000044;
        MEM[20] = 32'h50000055;
        MEM[24] = 32'h60000066;
        MEM[28] = 32'h70000077;
        MEM[32] = 32'h80000088;
        MEM[36] = 32'h90000099;
    end
    
    always @ (*)
    begin 
        do <= MEM[a];
    end
endmodule

//Module 14:MEM/WB
module MEM_WB(input clk, input mwreg, input mm2reg, input [4:0] mmux, input [31:0] mr, input [31:0] do,
    output reg wwreg, output reg wm2reg, output reg [4:0] wmux,output reg [31:0] wr, output reg [31:0] wdo);

    always @(posedge clk)
    begin
        wwreg <= mwreg;
        wm2reg <= mm2reg;
        wmux <= mmux;
        wr <= mr;
        wdo <= do;
    end
endmodule

//Module 15: WB stage - the memory data is selected and will be written into the register file at the end of the cycle
module wb_mux(input [31:0] wr,input [31:0] wdo,input wm2reg, output reg [31:0] wb_d);
    always @(*) 
        begin
            wb_d <= (wm2reg) ? wdo:wr;
    end
endmodule
