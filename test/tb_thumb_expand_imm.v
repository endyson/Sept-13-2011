/*
* Author:	Xiao, Chang
* Date:		9/25/2011
* Version:	0.0
* File:		tb_thumb_expand_imm.v
*/
`timescale 1ns/10ps
`include "thumb_expand_imm.v"

module tb_thumb_expand_imm;
reg [12:0] test_vec;
reg carry_in;
reg overflow;
wire [31:0] imm32;
wire carry_out;
integer fd;

initial begin
    fd =  $fopen("./thumb_expand_imm.log","w");
    {overflow,test_vec} = 0;
    forever #5 {overflow,test_vec} = {overflow,test_vec} + 1;
end


thumb_expand_imm u_thumb_expand_imm(test_vec[11:0],test_vec[12], imm32, carry_out);

always @ overflow begin
    if(overflow) $finish;
end
always @ *
    $fmonitor(fd,"imm12=[%b]\tcarry_in=[%b]\timm32=[%h]\tcarry_out=[%b]",test_vec[11:0],test_vec[12],imm32,carry_out);

endmodule
