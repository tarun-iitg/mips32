module test ;
   wire [31:0]out;
   reg 	      sel ;
   reg [31:0] in0,in1;

   
 mux_32_2_1 muxC(out,sel,in0,in1);

   initial begin
      
      in0=0 ;
      in1=32'd1 ;
     #5  sel=1'b1 ;
      #5 in1=32'b11111111111111111111111111111111 ;
   end
  initial  $monitor("in0=%b in1=%b sel=%b out=%b",in0,in1,sel,out) ;
endmodule // test

      
