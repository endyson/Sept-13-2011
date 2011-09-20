`timescale 1ns/10ps
`include "xpsr_reg.v"

module tb_xpsr_reg();
reg [31:0] inst;
reg clk;
reg rst;
reg en_apsr;
reg en_ipsr;
reg en_epsr;
reg en_carry;
reg inst_valid;

wire [4:0] apsr;
wire [8:0] ipsr;
wire [9:0] epsr;

integer fd;

xpsr_reg u0(inst,clk,rst,en_apsr,en_ipsr,en_epsr,en_carry,inst_valid,
            apsr,ipsr,epsr);
reg [31:0] inst_mem [256*6*2*2+1000:0];

initial begin
    clk = 0;
    rst = 1;
    #6 rst = 0;
    $readmemh("./inst_it.dat",inst_mem);
    fd = $fopen("./xpsr_reg.log","w");
    $fdisplay(fd,"inst\ten_apsr\ten_ipsr\ten_epsr\ten_carry\tinst_valid\tapsr\tipsr\tepsr\ttime");
end

always #5 begin
    $fdisplay(fd,"%h\t%b\t%b\t%b\t%b\t%b\t%b\t%h\t%b @%d",inst,en_apsr,en_ipsr,en_epsr,en_carry,inst_valid,apsr,ipsr,epsr,$time);
    {over_flag,inst[9:5]} = {over_flag,inst[9:5]}+1;
    if(over_flag)begin
        $fclose(fd);
        $finish;
    end
end
endmodule

