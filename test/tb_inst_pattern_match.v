/*
* Author:	Xiao, Chang
* Date:		9/25/2011
* Version:	0.0
* File:		tb_inst_pattern_match.v
*/
`timescale 1ns/10ps
`include "inst_pattern_match.v"

module tb_inst_pattern_match;
reg [31:0] inst;
reg carry_in;
wire [3:0] rd;
wire [3:0] rd2;
wire [3:0] ra;
wire [3:0] rb;

wire imm_or_reg;
wire shift_or_not;
wire thumb_or_not;
wire [31:0] imm32;
wire [11:0] imm12;
wire [1:0] s_type;
wire [4:0] s_offset;
wire index;
wire add;
wire wback;
wire reg_mask;

integer fd;
inst_pattern_match u(inst,carry_in,rd,rd2,ra,rb,imm_or_reg,shift_or_not,thumb_or_not,imm32,imm12,s_type,s_offset,index,add,wback,reg_mask);

initial begin
    fd =  $fopen("./tb_inst_pattern_match.log","w");
    inst = 0;
 #1 inst = 32'h41480000;
 #5 $fdisplay(fd,"rd=%x,rm=%x,rn=%x",rd,rb,ra);
end
initial begin
    //Dump waveform
    $fsdbDumpfile("./tb_inst_pattern_match.fsdb");
    $fsdbDumpvars();
end
endmodule
