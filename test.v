`include "main.v"
module test ;
   reg clk;
   reg en=0 ;

   mips32 m(clk,en);

   initial begin 
        clk=0 ;
        end
        
   
   always begin
     #5 clk= ~clk ;
     m.PC=0;
   end
   
   initial
     begin
	m.Mem_C[0] = 32'b00000011111000001010100000000000 ; //ADD R21,R31,R0 ;
	m.Mem_C[1] = 32'b00000111111000001010100000000000 ; //SUB R21,R31,R0 ;
	m.Mem_C[2] = 32'b00001011111000001010100000000000 ; //AND R21,R31,R0 ;
	m.Mem_C[3] = 32'b00001111111000001010100000000000 ; //OR R21,R31,R0 ;
     end
     
initial begin
m.R1.Reg[31]=32'd3 ;
m.R1.Reg[0]=0 ;
end

   initial begin
   
      
     $monitor("clk=%b  memCo=%b  rd=%b  IR=%b  R21=%b",clk,m.Mem_C[0],m.rd,m.MEM_WB_IR,m.R1.Reg[21]);
   //$finish(200);
   end
   
endmodule // test


