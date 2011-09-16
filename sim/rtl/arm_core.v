/* File:            arm_core.v
 * Author:          Xiao,Chang
 * Email:           chngxiao@gmail.com
 * Original Date:   9/14/2011 
 * Last Modified:   9/14/2011
 * Description:     Top level module of ARM processor
 * Copyright:       All right reserved by Xiao,Chang.
 *
 * Notice: Please do me a favor to NOT remove the content above. 
 *         If you have any modification and description on this, please add it anywhere you like!.
 *         This is all I need when I do this.
 *         Thank you very much for concernning and Welcome to join into my work!
 *         Please Feel free to email me by the email address above.
 */

`include "inst_fetch.v"
`include "xpsr_reg.v"
`include "pre_dec.v"

module arm_core(
input [15:0]inst_hw,
input rst,
input clk,

//temperary output
output [31:0]inst
);
//////////////////////////////////
//Signals within Stage One
//
//Stage Input Signals:
//[15:0]inst_hw;
//rst;
//clk;
//
//Stage Output Signals:
//[31:0]inst;
//////////////////////////////////
wire [31:0]inst_w;
wire inst_valid;
wire [4:0] en_apsr;
wire en_ipsr;
wire en_epsr;
wire [4:0] apsr;
wire [8:0] ipsr;
wire [9:0] epsr;
wire [31:0]set_xpsr;
wire [7:0] it_status;
wire [3:0] cond;
wire in_it_blk;

assign cond = epsr[6:3];
assign {set_xpsr[15:12],set_xpsr[11:10],set_xpsr[26:25]} = it_status;
xpsr_reg    u_xpsr_reg(set_xpsr,clk,rst,en_apsr,en_ipsr,en_epsr,inst_valid,in_it_blk,apsr,ipsr,epsr);
inst_fetch  u_if(inst_hw,clk,rst,inst_w,inst_valid);
pre_dec     u_pre_dec(inst_w, cond,apsr,in_it_blk, inst, en_epsr,it_status);

//////////////////////////////////
//Signals within Stage Two
//
//Stage Input Signals:
//[31:0]inst;
//clk;
//rst;
//
//
//////////////////////////////////

wire cur_carry  =   apsr[2];
wire next_carry =   set_xpsr[29]; 
wire [3:0]rd_addr, rn_addr, rm_addr;
wire imm_or_reg;
wire shift_or_not;
wire [1:0]s_type;
wire [4:0]s_offset;
wire [31:0]imm32;
wire rf_w_en;
wire [31:0] rn_data, rm_data, rd_data;
wire [31:0] shifted_rn_data;
wire [31:0] valid_rn_data;
wire [31:0]oprand1,oprand2;

inst_pattern_match  u_inst_pattern_match(inst, clk, cur_carry, rd_addr, rn_addr, rm_addr, imm_or_reg, shift_or_not, imm32, s_type, s_offset);
reg_file            u_reg_file(rn_addr, rm_addr, rd_addr, rf_w_en, clk, rn_data, rm_data, rd_data);
shift               u_shift(s_type, s_offset, rn_data, cur_carry, shifted_rn_data, next_carry);

valid_rn_data   = shift_or_not ? shifted_rn_data: rn_data;
oprand2         = imm_or_reg ? imm32: valid_rn_data;
oprand1         = rm_data;
endmodule
