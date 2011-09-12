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
endmodule
