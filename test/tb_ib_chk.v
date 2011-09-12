`timescale 1ns/10ps
`include "ib_chk.v"

module tb_ib_chk();
reg [15:0]   inst;
reg         over_flag;

wire [7:0]cond;
wire b;
wire it;
integer fd;

ib_chk u0(inst,cond,b,it);

initial begin
    {over_flag,inst[15:8] }=0;
    
    inst[7:0] = 8'b01010101;

    fd = $fopen("./ib_chk.log","w");
    $fdisplay(fd,"inst\tcond\tb\tit\ttime");
end

always #5 begin
    $fdisplay(fd,"%b\t%b\t%b\t @%d",inst,cond,b,it,$time);
    {over_flag,inst[15:8]} = {over_flag,inst[15:8]}+1;
    if(over_flag)begin
        $fclose(fd);
        $finish;
    end
end
endmodule

