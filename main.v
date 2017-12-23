`include "mux.v"
`include "Registor_Bank.v"


module mips32(clk,en);
   input clk,en ;   // not using enable at this point of time
   
   reg [31:0] Mem_C[31:0]; //code memory    
 //  reg [31:0] Reg[31:0];   // 32 GPRs as per mips32 architecture 

   reg [31:0] Mem_D[31:0]; //Data memory (as same memory can't be used due to pipeline limitaions
   reg [31:0] PC;          //special purpose registor < program counter > 


   reg [31:0] IF_ID_IR,IF_ID_NPC;  //pipeline 1st stage registors

   //-----------------------------------------------IF-------------------
   wire [31:0] mux_IF_out ; /* wire is mandatory, can't use registor of 2nd stage directly here <output of inner module can't be registor <verilog port limitations */

reg EX_MEM_Cond ; //error solution
   mux_32_2_1 mux_IF(mux_IF_out,EX_MEM_Cond,EX_MEM_ALU,PC+1); //32 2x1Mux for NPC
   always
     PC=mux_IF_out;     //combinational circuit linkage   

   always@(posedge clk)             //1st stage functioning
     begin
	IF_ID_NPC <= mux_IF_out;
	IF_ID_IR  <= Mem_C[PC];
     end

   //-----------------ID----------------
   wire [4:0]rs,rt,rd;             // registor bank addresses 
   wire [31:0] rs_out,rt_out,rd_in; // registor bank data
   wire [15:0] off1 ;              // offset data R-M ,R-I,conditional loop
   wire [25:0] off2;               // offset data unconditional loop 
   wire [31:0] ext_out1;          // after sign extension
   wire [31:0] ext_out2;
   wire [31:0] ext_out;          // final used per instruction 

   reg [31:0]  ID_EX_NPC,ID_EX_A,ID_EX_B,ID_EX_Imm,ID_EX_IR; //pipeline 2nd stage registors
   


   

  
   
//selecting credentials for registor bank according to planned instructions
   ///////////check if else ////////////
/*    
   case(IF_ID_IR[31:26])
   
   //case(opcode)
     6'b000000 :assign tempo=0 ;
     
     6'b010000 : assign  off2=IF_ID_IR[25:0];
     default   : begin
	assign 	rs=IF_ID_IR[25:21];
	assign	rt=IF_ID_IR[20:16];
     end
   endcase // case (IF_ID_IR[31:26])
*/


   
   case(IF_ID_IR[31:28])
     4'b0000 : begin
	assign rd=MEM_WB_IR[15:11] ;
	assign rd_in=mux_WB_out ;
     end
   endcase // case (IF_ID_IR[31:28])

   case(IF_ID_IR[31:29])
     3'b001 : assign off1= IF_ID_IR[15:0];
   endcase // case (IF_ID_IR[31:29])
   
//

   

//Registor Bank functioning
   
   Registor_Bank R1(rs,rs_out,rt,rt_out,rd,rd_in);    // 2 read 1 write registor bank
//
   

//2  sign extension code here 
   
   assign ext_out1={{16{off1[15]}},off1} ; // please check syntax 
  assign  ext_out2={{6{off2[25]}},off2} ;
   
//  
   
mux_32_2_1 mux_ID(ext_out,IF_ID_IR[30],ext_out1,ext_out2); //extension selection


//ID instruction decode finishing

   always@(posedge clk)
     begin
	ID_EX_NPC<=IF_ID_NPC;
	ID_EX_IR <= IF_ID_IR ;
	ID_EX_A <= rs_out ;
	ID_EX_B <= rt_out ;
	ID_EX_Imm <= ext_out ;
     end
//

   

//------------------------------------EX------------------------------------
   
//setup mux_EX1 and mux_EX2 according to instructions
wire ctrl1,ctrl2 ;
wire [31:0]mux_EX_out1 ;
wire [31:0] mux_EX_out2 ;
   
assign    ctrl1= ~(ID_EX_IR[30])+(ID_EX_IR[26]~^ID_EX_IR[27])+(~(ID_EX_IR[28]&ID_EX_IR[29]))    ;
assign    ctrl2=   ID_EX_IR[31]+ID_EX_IR[30]+ID_EX_IR[29];
   
   
   mux_32_2_1 mux_EX1(mux_EX_out1,ctrl1,ID_EX_NPC,ID_EX_A);
   mux_32_2_1 mux_EX2(mux_EX_out2,ctrl2,ID_EX_B,ID_EX_Imm);
   

//     

// pipeline 3rd stage registors
   reg [31:0] EX_MEM_AluOut,EX_MEM_B,EX_MEM_IR ;
   //reg EX_MEM_Cond ;
   
//


// jump conditions setup   
   wire ctrlC,EX_MEM_Cond_w;                        
   assign    ctrlC= (|ID_EX_A)^(ID_EX_IR[26]);
   
 
   mux_2_1 mux_cond(EX_MEM_Cond_w,ctrlC,1,0); // can't use EX_MEM_Cond directly 'oops'
//    


// setup ALU
   wire [31:0] EX_MEM_AluOut_w;
   case(ID_EX_IR[31:26])
     6'b001000 : assign EX_MEM_AluOut_w = mux_EX_out1 + mux_EX_out2 ;
     
     6'b001001: assign EX_MEM_AluOut_w = mux_EX_out1 + mux_EX_out2 ;
     
        6'b000000: assign EX_MEM_AluOut_w = mux_EX_out1 + mux_EX_out2 ;
     6'b000001: assign EX_MEM_AluOut_w = mux_EX_out1 - mux_EX_out2 ;
     6'b000010: assign EX_MEM_AluOut_w = mux_EX_out1 & mux_EX_out2 ;
     6'b000011: assign EX_MEM_AluOut_w = mux_EX_out1 * mux_EX_out2 ;
     6'b000100: assign EX_MEM_AluOut_w = (mux_EX_out1 < mux_EX_out2) ? 1 : 0 ;

     6'b001010: assign EX_MEM_AluOut_w = mux_EX_out1 + mux_EX_out2 ;
     6'b001011: assign EX_MEM_AluOut_w = mux_EX_out1 - mux_EX_out2 ;
     6'b001100: assign EX_MEM_AluOut_w = (mux_EX_out1 < mux_EX_out2) ? 1 : 0 ;

     6'b001110: assign EX_MEM_AluOut_w = mux_EX_out1 + mux_EX_out2 ;
     6'b001101: assign EX_MEM_AluOut_w = mux_EX_out1 + mux_EX_out2 ;
     6'b010000: assign EX_MEM_AluOut_w = mux_EX_out1 + mux_EX_out2 ;
   endcase // case (ID_EX_IR[31:26])
   
   
//   

//stage 3 main functioning
always@(posedge clk)
  begin
     EX_MEM_Cond <= EX_MEM_Cond_w ;
     EX_MEM_AluOut <= EX_MEM_AluOut_w;
     EX_MEM_B <= ID_EX_B;
     EX_MEM_IR <= ID_EX_IR;
  end
   
//




//-------------------````````````--------MEM--------`````````--------------   

   reg [31:0]MEM_WB_IR,MEM_WB_LMD,MEM_WB_AluOut ;
   
case(EX_MEM_IR[31:26])
  6'b001000 : always@(posedge clk) MEM_WB_LMD <= Mem_D[EX_MEM_AluOut] ;
 
    6'b001001 : always Mem_D[EX_MEM_AluOut] <= EX_MEM_B ;
endcase

always@(posedge clk)
begin
   MEM_WB_AluOut <= EX_MEM_AluOut ;
   MEM_WB_IR     <= EX_MEM_IR ;
end



//---------------------````````````````````WB'''''''''''''---------------

   wire [31:0]mux_WB_out ;
   wire       ctrlWB ;
   assign ctrlWB= (~MEM_WB_IR[31])&(~MEM_WB_IR[30])&(MEM_WB_IR[29])&(~MEM_WB_IR[28])&(~MEM_WB_IR[27])&(~MEM_WB_IR[26]) ;
   
   mux_32_2_1 mux_WB(mux_WB_out,ctrlWB,MEM_WB_AluOut,MEM_WB_LMD);

endmodule // mips32




   