module Registor_Bank(rd_addr1,rd_data1,rd_addr2,rd_data2,rw_addr,rw_data);
   input [4:0]rd_addr1,rd_addr2,rw_addr ;
   input [31:0] rw_data ;
   
   output [31:0] rd_data1,rd_data2;
   reg [31:0] 	 Reg[31:0] ;

   assign   rd_data1 = Reg[rd_addr1] ;
   assign   rd_data2 = Reg[rd_addr2] ;
   assign   Reg[rw_addr] = rw_data ;
endmodule // Registor_Bank

