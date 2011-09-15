/* File:            arm_core.v
 * Author:          Xiao,Chang
 * Email:           chngxiao@gmail.com
 * Original Date:   9/14/2011 
 * Last Modified:   9/14/2011
 * Description:     xPSR implementation module.
 * Copyright:       All right reserved by Xiao,Chang.
 *
 * Notice: Please do me a favor to NOT remove the content above. 
 *         If you have any modification and description on this, please add it anywhere you like!.
 *         This is all I need when I do this.
 *         Thank you very much for concernning and Welcome to join into my work!
 *         Please Feel free to email me by the email address above.
 */
`ifndef XPSR_REG_V
`define XPSR_REG_V

`include "reg.v"
//`include "xpsr_reg.psl"
module xpsr_reg(
    input [31:0] set_data,
//input [4:0] apsr_in,
//input [7:0] epsr_in,
input clk,
input rst,

input [4:0] en_apsr,
input en_ipsr,
input en_epsr,

//    input ici_or_it;
input inst_valid,

    output in_it_blk,
    output [4:0] apsr,
    output reg [8:0] ipsr,
    output reg [9:0] epsr
);

/*
*A P S R    b i t s     f l a g     p a t t e r n  
**************************************************
* -------------------------------------------
    *|  N  |  Z  |  C  |  V  |  Q  | ...
    * -------------------------------------------
    */

   /*
   * E P S R       b i t s     f l a g s       p a t t e r n
   **********************************************************
   * 31 ...  26    25 24 ... ..  15 14 13 12 11 10   9 ... 
       * ------------------------------------------------------
       *|  ...  | ICI/IT | T | ...   |     ICI/IT     |  a  |  
       * ------------------------------------------------------
       * EPSR[9:0]      = {xPSR[26:25], T, xPSR[15:10],a} 
       * IT_STATUS[7:0] = {xPSR[15:12],xPSR[11:10],xPSR[26:25]}
       * ICI[7:0]       = {xPSR[26:25],xPSR[15:12],xPSR[11:10]}
       * */
      //wire [7:0] ici_it;
      //wire [7:0] epsr_tmp_out;
      //wire [7:0] ici;
      //reg [7:0] it;
      //reg T, a;
      //reg [9:0] epsr_reg;
      //assign epsr[7]=T;
      //assign epsr[0]=a;
      //assign epsr = epsr_reg;

      //reg_8_en    u_epsr(ici_it, clk, en_epsr, epsr_tmp_out);
      //dff_en      u_T(T_in, t_en, clk, T_out); 
      //dff_en      u_a(a_in, a_en, clk, a_out);

      //assign ici_it = {epsr_in[9:8],epsr_in[6:1]};
      //assign it_wire = {epsr[6:3],epsr[2:1],epsr[9:8]};
      //assign {epsr[6:3],epsr[2:1],epsr[9:8]} = it;
      //assign ici = {epsr_in[9:8],epsr_in[6:1]};
      //assign T_in = epsr_in[7];
      //assign a_in = epsr_in[0];

      //assign ici_it = ici_or_it ? ici: {it[1:0],it[7:4],it[3:2]};
      //assign epsr = {epsr_tmp_out[7:6],T_out,epsr_tmp_out[5:0],a_out};


      /*
      * I P S R       b i t s     f l a g s       p a t t e r n
      * */


     /*
     * I n p u t     C o n n e c t i o n 
     */
    generate
    genvar i;
    for (i=0;i<5;i++)begin:NZCVQ_register
        dff_en_rst  u_dff_en_rst(set_data[31-i], en_apsr[4-i], rst, clk, apsr[4-i]);
    end
    endgenerate


    always @ (posedge clk)begin
        if(rst == 1'b1)begin
            ipsr <= 9'b0;
            epsr <= 10'b0010000000;
        end
        else begin
            if(en_ipsr)
                ipsr   <=  set_data[8:0];
            if(en_epsr)   
                epsr  <=  {set_data[26:24],set_data[15:9]};
            if({en_apsr, en_ipsr,en_epsr} == 7'b0 )begin
                //IT STATUS operation
                if(inst_valid)begin
       // IT_STATUS[7:0] = {xPSR[15:12],xPSR[11:10],xPSR[26:25]}
       // EPSR[9:0]      = {xPSR[26:25], T, xPSR[15:10],a} 
                    if({epsr[1],epsr[9:8]} == 3'b000)   {epsr[6:3],epsr[2:1],epsr[9:8]} <= 8'b0;
                    else                    {epsr[3:1],epsr[9:8]} <= {epsr[3:1],epsr[9:8]}<<1;
                end
            end
            //Other situations are left undefined, and should never occuer!
         end
    end
    
    assign in_it_blk ={epsr[2:1],epsr[9:8]} != 4'b0000;
    
endmodule
`endif 
