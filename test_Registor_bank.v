module test ;

   reg   [4:0]rd_addr1,rd_addr2,rw_addr ;
  reg [31:0] rw_data ;
      wire  [31:0] rd_data1,rd_data2;

 Registor_Bank r(rd_addr1,rd_data1,rd_addr2,rd_data2,rw_addr,rw_data);

   initial begin
      rd_addr1=5'b00000 ;
      rd_addr2=5'b00001 ;
      #5 rd_addr1=5'b00010 ;
      rd_addr2=5'b00011 ;
      
      rw_addr=5'b11111;
      rw_data=32'h00000007 ;
       #5 rw_data=32'h00000008 ;
       #5 rw_data=32'h00000009 ;
   end

   initial begin
      r.Reg[0]=32'd0 ;
      r.Reg[1]=32'd2 ;
      r.Reg[2]=32'd3 ;
      r.Reg[3]=32'd4 ;
   end
   initial
     $monitor("Reg[31]=%d rd_data1=%d rd_data2=%d",r.Reg[31],rd_data1,rd_data2);
endmodule 
      
     
     
