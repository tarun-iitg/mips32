module  mux_32_2_1(out,sel,in0,in1);
   output [31:0]out;
   input 	sel ;
   input [31:0] in0,in1;

   genvar 	i ;
   generate
      for(i=0; i<32; i=i+1)
	mux_2_1 m(out[i],sel,in0[i],in1[i]);
      endgenerate
   
endmodule // mux_32_2_1



module mux_2_1(out,sel,in0,in1);
   output out ;
   input  sel,in0,in1 ;
   assign out=sel ? in1 :in0 ;
endmodule // mux_2_1
