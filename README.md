RISC(Reduced instruction set computer) ISA(instruction set architecture) based mips32 processor.

A basic processor is modeled with five stage pipeline approach.
>IF (Instruction Fetch)
>ID (Instruction decode)
>EX (Operation Execution)
>MEM (Memory Operations)
>WB (Register write back)




Currently following instrunctions are supported -:


>LW r1, off(r2) (Load word into register r1 from memory[[r2]+off] )

>SW r1, off(r2) (Store word from register r1 to memory[[r2]+off])

>ADD Rd,Rs,Rt   ([Rd] << [Rs]+[Rt])

>SUB Rd,Rs,Rt   ([Rd] << [Rs]-[Rt])

>AND Rd,Rs,Rt   ([Rd] << [Rs]&[Rt])

>OR  Rd,Rs,Rt   ([Rd] << [Rs] | [Rt])

>MUL Rd,Rs,Rt   ([Rd] << [Rs]*[Rt])

>SLT Rd,Rs,Rt   ([Rd] = ([Rs]<[Rt]))

>ADDI Rd,Rs,off   ([Rd] << [Rs]+off)

>SUBI Rd,Rs,off   ([Rd] << [Rs]-off)

>SLTI Rd,Rs,off   ([Rd] << ([Rs]<off))

>BEQZ R,off	  if(R==0) [PC]=[PC]+off

>BNEQZ	R,off	  if(R!=0) [PC]=[PC]+off

>J off		  [PC]=[PC]+off


Note : Above instructions are subset of  standard MIPS32 processor and function in similar way.
     Instruction are encoded as 32bit each as per MIPS32 standard format.

Pipeline approach have its own hazards, the version till now don't not solve those hazards, i am currently working on those.

At present i am trying to add isntructions and solve Hazards in processor due various reasons.

Design functioning is checked in Vivado Design Suite, and is implemented over FPGA (ZedBoard).
