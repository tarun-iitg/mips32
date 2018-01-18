`include "main.v"
module test ;
   reg clk;
  // reg en=0 ;

   mips32 m(clk);

   initial begin 
        clk=0 ;
        end
        
   
   always begin
     #20 clk= ~clk ;
//     m.PC=0;
   end
   
   initial
     begin
//m.PC=1 ;
	m.Mem_C[1] = 32'b00000011111000001010100000000000 ; //ADD R21,R31,R0 ;
		//	m.Mem_C[1] = 32'b00000011111000001010100000000000 ; //ADD R21,R31,R0 ;

	m.Mem_C[0] = 32'b00000111111000001010100000000000 ; //SUB R21,R31,R0 ;

	m.Mem_C[2] = 32'b00001011111000001010100000000000 ; //AND R21,R31,R0 ;
	m.Mem_C[3] = 32'b00001111111000001010100000000000 ; //OR R21,R31,R0 ;
	
	m.Mem_C[4] = 32'b00001111111000001010100000000000 ; //MULT R21,R31,R0 ;
	m.Mem_C[5] = 32'b00010011111000001010100000000000 ; //SLT R21,R31,R0 

 	m.Mem_C[6] = 32'b00101011111101010000000000000011 ; //ADDI R21,R31(3) ;
	m.Mem_C[7] = 32'b00101111111101010000000000000011 ; //SUBI R21,R31(3);
	m.Mem_C[8] = 32'b00110011111101010000000000000011 ; //SLTI R21,R31(3);
	m.Mem_C[9] = 32'b00100011111101010000000000000111 ; //LW R21,R31(7);
   m.Mem_C[10] = 32'b00100111111101000000000000001000 ; //SW R20,R31(8);
   
   m.Mem_C[11] = 32'b01000011111111111111111111111111 ; //J
   m.Mem_C[12] = 32'b00111000000000001111111111111111 ; //BEQZ R0,
  // m.Mem_C[13] = 32'b00110100000000001111111111111111 ; //BNEQZ R0,
      
        

	#200 $finish ;
     end
 initial begin
 m.Mem_D[38] = 32'd4 ; 
  m.Mem_D[39] = 32'd5 ; 

 end
 
     
initial begin
m.R1.Reg[31]=32'd31 ;
m.R1.Reg[0]=32'd1 ;
m.R1.Reg[1]=32'd1 ;
m.R1.Reg[2]=32'd2 ;
m.R1.Reg[20]=32'd20 ;


end

   initial begin
   
      
     $monitor("clk=%b  PC=%d ctrlC0=%b EX_MEM_Cond_w0=%b ctrlCF=%b EX_MEM_Cond_wf=%b  EX_MEM_Cond=%b IF_ID_IR=%b  A=%d B=%d ctrl1=%b  mux_EX_out1=%d ctrl2=%b   mux_EX_out2=%d  EX_MEM_AluOut_w=%d AluOutEM=%d AluOutMW=%d rd_in=%d R20=%d R21=%d m.Mem_D[39]=%d",clk,m.PC,m.ctrlC0,m.EX_MEM_Cond_w0,m.ctrlCF,m.EX_MEM_Cond_wf,m.EX_MEM_Cond,m.IF_ID_IR,m.ID_EX_A,m.ID_EX_B,m.ctrl1,m.mux_EX_out1,m.ctrl2,m.mux_EX_out2,m.EX_MEM_AluOut_w,m.EX_MEM_AluOut,m.MEM_WB_AluOut,m.rd_in,m.R1.Reg[20],m.R1.Reg[21],m.Mem_D[39]);
   //$finish(200);
   end
initial begin	 
$dumpfile("mips.vcd");
$dumpvars(0);
//#3000 $finish ;
end	
   
endmodule // test


