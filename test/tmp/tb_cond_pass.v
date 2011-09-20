`timescale 1ns/10ps
`include "cond_pass.v"

module tb_cond_pass();
reg [3:0]cond;
reg [3:0]nzcv;
reg over_flag;
wire pass;
integer fd;

cond_pass u0(cond,nzcv,pass);

initial begin
    {over_flag,cond,nzcv}=0;
    fd = $fopen("./cond_pass.log","w");
    $fdisplay(fd,"cond\tnzcv\tpass\ttime");
end

always #5 begin
    $fdisplay(fd,"%b\t%b\t%b\t @%d",cond,nzcv,pass,$time);
    {over_flag,cond,nzcv} = {over_flag,cond,nzcv}+1;
    if(over_flag)begin
        $fclose(fd);
        $finish;
    end
end
endmodule

