/* File:            tb_arm_core.v
 * Author:          Xiao,Chang
 * Email:           chngxiao@gmail.com
 * Original Date:   9/14/2011 
 * Last Modified:   9/14/2011
 * Description:     Test bench for the top level arm_core module.
 * Copyright:       All right reserved by Xiao,Chang.
 *
 * Notice: Please do me a favor to NOT remove the content above. 
 *         If you have any modification and description on this, please add it anywhere you like!.
 *         This is all I need when I do this.
 *         Thank you very much for concernning and Welcome to join into my work!
 *         Please Feel free to email me by the email address above.
 */
`timescale 1ns/10ps

`include "arm_core.v"
`include "xpsr_reg.v"

module tb_arm_core;

//Port declarition
wire [15:0]inst_hw;
reg clk;
reg rst;
reg [31:0] pc;
wire [31:0]inst;
integer fl;
parameter ADDR_END=9*256 + 3*16 + 4*16 + 9*256;

reg [15:0] inst_mem[ADDR_END + 100 : 0];
wire [7:0]it_status;
reg[4:0] en_apsr_reg;
reg en_ipsr_reg;

wire hint_or_exc = u_arm_core.u_pre_dec.hint_or_exc;
wire[3:0] cur_cond = u_arm_core.u_pre_dec.cur_cond;
//Module instancise
arm_core    u_arm_core(inst_hw,rst,clk,inst);

//Emulate the instruction memory
assign inst_hw = inst_mem[pc];

//Add inject probe
//used to set the APSR & IPSR registers to proper status
assign u_arm_core.u_xpsr_reg.en_apsr = en_apsr_reg;
assign u_arm_core.u_xpsr_reg.en_ipsr = en_ipsr_reg;

//Add drawout probe 
assign it_status = {u_arm_core.u_xpsr_reg.epsr[6:1],u_arm_core.u_xpsr_reg.epsr[9:8]};
wire[31:0] cur_inst= u_arm_core.u_if.valid_inst;
wire inst_valid = u_arm_core.inst_valid;
wire [4:0] apsr = u_arm_core.u_xpsr_reg.apsr;
wire in_it_blk = u_arm_core.u_xpsr_reg.in_it_blk;
//input Signals initialization 
initial begin
    clk     = 0;
    en_apsr_reg =5'b0;
    en_ipsr_reg =0;
    pc= 0;
    rst     = 1;
#6  rst     = 0;
end

//Clock generation
always #5 clk = ~clk;

//PC emulation
always @ (posedge clk)begin
    if(rst)pc = 0;
    else   pc = pc + 1;
end

//Logging 

//Initializition 
initial begin 
    $readmemh("./inst_it.dat",inst_mem);
    fl  =   $fopen("./arm_core.log","w");
//    $fdisplay(fl,"inst_hw\t|\tinst\t|\thint_or_exc\t|\tapsr\t|\t|\tpc\ttime");
    $fsdbDumpfile("./inst_it_wv.fsdb");
    $fsdbDumpvars();
end
/*
case cond<3:1> of
    when '000' result = (APSR.Z == '1'); // EQ or NE
    when '001' result = (APSR.C == '1'); // CS or CC
    when '010' result = (APSR.N == '1'); // MI or PL
    when '011' result = (APSR.V == '1'); // VS or VC
    when '100' result = (APSR.C == '1') && (APSR.Z == '0'); // HI or LS
    when '101' result = (APSR.N == APSR.V); // GE or LT
    when '110' result = (APSR.N == APSR.V) && (APSR.Z == '0'); // GT or LE
    when '111' result = TRUE; // AL
    NZCVQ
*/
//Print Log head
always @ (posedge clk )begin
    if ( u_arm_core.u_if.valid_inst[31:24] == 8'hbf)begin
    $fdisplay(fl,"*******************************************************************************************************");
$fdisplay(fl,"IT Status = [%b]\tAPSR = [%b]",u_arm_core.u_if.valid_inst[23:16], u_arm_core.u_xpsr_reg.apsr);
        case(it_status[7:5])
            3'b000:$fdisplay(fl,"Condition is EQ or NE:\tEQ[x1xxx]\tNE[x0xxx]");
        3'b001:$fdisplay(fl,"Condition is CS or CC:\tCS[xx1xx]\tCC[xx0xx]");
        3'b010:$fdisplay(fl,"Condition is MI or PL:\tMI[1xxxx]\tPL[0xxxx]");
        3'b011:$fdisplay(fl,"Condition is VS or VC:\tVS[xxx1x]\tVC[xxx0x]");
        3'b100:$fdisplay(fl,"Condition is HI or LS:\tHI[x01xx]\tLS[x??xx]");
        3'b101:$fdisplay(fl,"Condition is GE or LT:\tGE[SxxSx]\tLT[Sxxsx]");
        3'b110:$fdisplay(fl,"Condition is GT or LE:\tGT[S0xSx]\tLE[??x?x]");
        3'b111:$fdisplay(fl,"Condition is AL: Always Execute!");
    endcase
    $fdisplay(fl,"-------------------------------------------------------------------------------------------------------");
end
end
//Print Log body
always @ (posedge clk)begin
    if(pc == 9*256 + 3*16)begin
       // arm_core.u_xpsr_reg.apsr = ~arm_core.u_xpsr_reg.apsr;
    end

    if(pc == ADDR_END )begin
        $finish;
    end
    #1  $fdisplay(fl,"next_inst_hw = [%h]\tcur_inst = [%h]\thint_or_exc = [%b]\tinst_valid = %b\tvalid_inst = [%h]\tcur_cond = [%b]\tmask = [%b]\tpc = [%d]\t@ %d",
                      inst_hw,   u_arm_core.u_if.valid_inst, u_arm_core.u_pre_dec.hint_or_exc, inst_valid, inst, it_status[7:4],it_status[3:0], pc, $time);
end
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
