/*
* File:            tb_arm_core.v
* Author:          Xiao,Chang
* Email:           chngxiao@gmail.com
* Original Date:   9/14/2011 
* Last Modified:   9/14/2011
* Description:     Test bench for the top level arm_core module
* Copyright:       All right reserved by Xiao Chang
* Notice:          Please do me a favor to NOT remove the content above
*         If you have any modification and description on this, please add it anywhere you like
*         This is all I need when I do this
*         Thank you very much for concernning and Welcome to join into my work
*         Please Feel free to email me by the email address above
*/
 `timescale 1ns/10ps
 `include "arm_core.v"
 `include "xpsr_reg.v"

 module tb_arm_core;

 parameter ADDR_END=9*256 + 3*16 + 4*16 + 9*256;
 integer fd_stage_one;
 integer fd_stage_two;

 //Interconnection declarition
 wire [15:0]inst_hw;
 reg clk;
 reg rst;
 reg [31:0] pc;

 reg [15:0] inst_mem[ADDR_END + 100 : 0];
 reg[4:0] en_apsr_reg;
 reg en_ipsr_reg;

 reg [4:0]apsr_reg;

 //Module instancise
 arm_core    u_arm_core(inst_hw,rst,clk);


 //Instruction memory
 assign inst_hw = inst_mem[pc];

 //Add inject probe
 //used to set the APSR & IPSR registers to proper status
 assign u_arm_core.u_xpsr_reg.en_apsr = en_apsr_reg;
 assign u_arm_core.u_xpsr_reg.en_ipsr = en_ipsr_reg;

 //APSR set disabled now when initialization.It will be all ZERO during the
 //simulation.
 assign u_arm_core.u_xpsr_reg.set_data[31:27] = apsr_reg;

 //Add drawout probe 
 wire        hint_or_exc = u_arm_core.u_pre_dec.hint_or_exc;
 wire [3:0]  cur_cond    = u_arm_core.u_pre_dec.cur_cond;
 wire [7:0]  it_status   = {u_arm_core.u_xpsr_reg.epsr[6:1],u_arm_core.u_xpsr_reg.epsr[9:8]};
 wire [31:0] cur_inst    = u_arm_core.u_if.valid_inst;
 wire        inst_valid  = u_arm_core.inst_valid;
 wire [4:0]  apsr        = u_arm_core.u_xpsr_reg.apsr;
 wire        in_it_blk   = u_arm_core.u_xpsr_reg.in_it_blk;
 wire [31:0] inst        = u_arm_core.u_pre_dec.inst_out;

 //input Signals initialization 
 initial begin
     clk     = 0;
     apsr_reg = 5'b0;
     en_apsr_reg =5'b0;
     en_ipsr_reg =0;
     pc= 0;
     rst     = 1;
     #6  rst     = 0;
 end

 //Clock generation
 always #5 clk = ~clk;

 //PC
always @ (posedge clk)begin
    if(rst)pc = 0;
    else   pc = pc + 1;
end

//Logging 

//Initializition 
initial begin
    $readmemh("./inst.dat",inst_mem);
    
    //Logging TARGET signals 
    fd_stage_one  =   $fopen("./stage_1_output.log","w");
    fd_stage_two  =   $fopen("./stage_2_output.log","w");

    //Dump waveform
    $fsdbDumpfile("./wavevform.fsdb");
    $fsdbDumpvars();
end

//Register Initialization
wire [31:0]reg_out=u_arm_core.u_reg_file.regfile[1].u_reg_32_x.out;
/*
initial begin
integer i;
    for(i=0; i<16; i++)
       $readmemh("./reg_file_ini.dat",u_arm_core.u_reg_file.regfile[i].u_reg_32_x.out);
end
*/
//////////////////////////////////////////////////////////////
//S t a g e      O n e       L o g g i n g
//////////////////////////////////////////////////////////////
//Log head
always @ (posedge clk )begin
    if ( cur_inst[31:24] == 8'hbf)begin
        $fdisplay(fd_stage_one,"*******************************************************************************************************");
        $fdisplay(fd_stage_one,"IT Status = [%b]\tAPSR = [%b]",cur_inst[23:16], apsr);
        case(it_status[7:5])
            3'b000:$fdisplay(fd_stage_one,"Condition is EQ or NE:\tEQ[x1xxx]\tNE[x0xxx]");
            3'b001:$fdisplay(fd_stage_one,"Condition is CS or CC:\tCS[xx1xx]\tCC[xx0xx]");
            3'b010:$fdisplay(fd_stage_one,"Condition is MI or PL:\tMI[1xxxx]\tPL[0xxxx]");
            3'b011:$fdisplay(fd_stage_one,"Condition is VS or VC:\tVS[xxx1x]\tVC[xxx0x]");
            3'b100:$fdisplay(fd_stage_one,"Condition is HI or LS:\tHI[x01xx]\tLS[x??xx]");
            3'b101:$fdisplay(fd_stage_one,"Condition is GE or LT:\tGE[SxxSx]\tLT[Sxxsx]");
            3'b110:$fdisplay(fd_stage_one,"Condition is GT or LE:\tGT[S0xSx]\tLE[??x?x]");
            3'b111:$fdisplay(fd_stage_one,"Condition is AL: Always Execute!");
        endcase
        $fdisplay(fd_stage_one,"-------------------------------------------------------------------------------------------------------");
    end
end

//Log body
always @ (posedge clk)begin
    if(pc == 9*256 + 3*16)begin
         apsr_reg = ~apsr_reg;
    end
    #1  $fdisplay(fd_stage_one,"next_inst_hw = [%h]\tcur_inst = [%h]\thint_or_exc = [%b]\tinst_valid = %b\tvalid_inst = [%h]\tcur_cond = [%b]\tmask = [%b]\tpc = [%d]\t@ %d",
        inst_hw,   cur_inst, hint_or_exc, inst_valid, inst, cur_cond,it_status[3:0], pc, $time);
end


//////////////////////////////////////////////////////////////
//S t a g e      T w o       L o g g i n g
//////////////////////////////////////////////////////////////
//Log head
wire [3:0] rn_addr = u_arm_core.rn_addr;
wire [3:0] rm_addr = u_arm_core.rm_addr;
wire [3:0] rd_addr = u_arm_core.rd_addr;
wire [31:0] rn_data = u_arm_core.rn_data;
wire [31:0] rm_data = u_arm_core.rm_data;
wire [31:0] rd_data = u_arm_core.rd_data;
wire [31:0] op1 = u_arm_core.oprand1;
wire [31:0] op2 = u_arm_core.oprand2;
wire imm_or_reg = u_arm_core.imm_or_reg;
wire shift_or_not = u_arm_core.shift_or_not;
wire thumb_or_not = u_arm_core.thumb_or_not;

always @ (posedge clk)begin
   #1 $fdisplay(fd_stage_two,"Rn_A=[%d]\tRm_A=[%d]\tRd_A=[%d]\tRn_D=[%d]\tRm_D=[%d]\tRd_D=[%d]\timm_or_reg=[%b]\tshift_or_not=[%b]\tthumb_or_not=[%b]\top1=[%d]\top2=[%d]\n",
                rn_addr,rm_addr,rd_addr,rn_data,rm_data,rd_data,imm_or_reg,shift_or_not,thumb_or_not,op1,op2);
end

///////////////////////////////////////////////////////////////
//T e r m i n a t i o n
///////////////////////////////////////////////////////////////
always @ (posedge clk)begin
    if(pc == ADDR_END) $finish;
end




/************************************S t a g e      O n e       A s s e r t i o n*****************************************/

/*H I N T      O p e r a t i o n       A s s e r t i o n*/
//psl IT_EQ_HINT_ASSERTION: assert never { ~apsr[3]  && cur_cond == 4'b0000 && in_it_blk && ~hint_or_exc } @ (posedge clk);
//psl IT_NE_HINT_ASSERTION: assert never {  apsr[3]  && cur_cond == 4'b0001 && in_it_blk && ~hint_or_exc } @ (posedge clk);
//psl IT_CS_HINT_ASSERTION: assert never { ~apsr[2]  && cur_cond == 4'b0010 && in_it_blk && ~hint_or_exc } @ (posedge clk);
//psl IT_CC_HINT_ASSERTION: assert never {  apsr[2]  && cur_cond == 4'b0011 && in_it_blk && ~hint_or_exc } @ (posedge clk);
//psl IT_MI_HINT_ASSERTION: assert never { ~apsr[4]  && cur_cond == 4'b0100 && in_it_blk && ~hint_or_exc } @ (posedge clk);
//psl IT_PL_HINT_ASSERTION: assert never {  apsr[4]  && cur_cond == 4'b0101 && in_it_blk && ~hint_or_exc } @ (posedge clk);
//psl IT_VS_HINT_ASSERTION: assert never { ~apsr[1]  && cur_cond == 4'b0110 && in_it_blk && ~hint_or_exc } @ (posedge clk);
//psl IT_VC_HINT_ASSERTION: assert never {  apsr[1]  && cur_cond == 4'b0111 && in_it_blk && ~hint_or_exc } @ (posedge clk);
//psl IT_HI_HINT_ASSERTION: assert never { ~(~apsr[3] & apsr[2])  && cur_cond == 4'b1000 && in_it_blk && ~hint_or_exc } @ (posedge clk);
//psl IT_LS_HINT_ASSERTION: assert never {  (~apsr[3] & apsr[2]) && cur_cond == 4'b1001 && in_it_blk && ~hint_or_exc } @ (posedge clk);
//psl IT_GE_HINT_ASSERTION: assert never { ~(apsr[4] == apsr[1]) && cur_cond == 4'b1010 && in_it_blk && ~hint_or_exc } @ (posedge clk);
//psl IT_LT_HINT_ASSERTION: assert never {  (apsr[4] == apsr[1]) && cur_cond == 4'b1011 && in_it_blk && ~hint_or_exc } @ (posedge clk);

//psl IT_AL_EXC_ASSERTION: assert never { hint_or_exc && cur_cond[3:1] == 3'b111 } @ (posedge clk);

/*E X C     O p e r a t i o n       A s s e r t i o n*/
//psl IT_EQ_EXC_ASSERTION: assert never { ( apsr[3]  && cur_cond == 4'b0000 || ~in_it_blk) && cur_inst[31:24] != 8'hbf && inst_valid && hint_or_exc } @ (posedge clk);
//psl IT_NE_EXC_ASSERTION: assert never { (~apsr[3]  && cur_cond == 4'b0001 || ~in_it_blk) && cur_inst[31:24] != 8'hbf && inst_valid && hint_or_exc } @ (posedge clk);
//psl IT_CS_EXC_ASSERTION: assert never { ( apsr[2]  && cur_cond == 4'b0010 || ~in_it_blk) && cur_inst[31:24] != 8'hbf && inst_valid && hint_or_exc } @ (posedge clk);
//psl IT_CC_EXC_ASSERTION: assert never { (~apsr[2]  && cur_cond == 4'b0011 || ~in_it_blk) && cur_inst[31:24] != 8'hbf && inst_valid && hint_or_exc } @ (posedge clk);
//psl IT_MI_EXC_ASSERTION: assert never { ( apsr[4]  && cur_cond == 4'b0100 || ~in_it_blk) && cur_inst[31:24] != 8'hbf && inst_valid && hint_or_exc } @ (posedge clk);
//psl IT_PL_EXC_ASSERTION: assert never { (~apsr[4]  && cur_cond == 4'b0101 || ~in_it_blk) && cur_inst[31:24] != 8'hbf && inst_valid && hint_or_exc } @ (posedge clk);
//psl IT_VS_EXC_ASSERTION: assert never { ( apsr[1]  && cur_cond == 4'b0110 || ~in_it_blk) && cur_inst[31:24] != 8'hbf && inst_valid && hint_or_exc } @ (posedge clk);
//psl IT_VC_EXC_ASSERTION: assert never { (~apsr[1]  && cur_cond == 4'b0111 || ~in_it_blk) && cur_inst[31:24] != 8'hbf && inst_valid && hint_or_exc } @ (posedge clk);
//psl IT_HI_EXC_ASSERTION: assert never { ( (~apsr[3] & apsr[2]) && cur_cond == 4'b1000 || ~in_it_blk) && cur_inst[31:24] != 8'hbf && inst_valid && hint_or_exc } @ (posedge clk);
//psl IT_LS_EXC_ASSERTION: assert never { (~(~apsr[3] & apsr[2]) && cur_cond == 4'b1001 || ~in_it_blk) && cur_inst[31:24] != 8'hbf && inst_valid && hint_or_exc } @ (posedge clk);
//psl IT_GE_EXC_ASSERTION: assert never { ( (apsr[4] == apsr[1]) && cur_cond == 4'b1010 || ~in_it_blk) && cur_inst[31:24] != 8'hbf && inst_valid && hint_or_exc } @ (posedge clk);
//psl IT_LT_EXC_ASSERTION: assert never { (~(apsr[4] == apsr[1]) && cur_cond == 4'b1011 || ~in_it_blk) && cur_inst[31:24] != 8'hbf && inst_valid && hint_or_exc } @ (posedge clk);




endmodule
