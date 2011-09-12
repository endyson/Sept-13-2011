/*
* Author:	Xiao, Chang
* Date:		8/3/2011
* Version:	0.0
* File:		tb_decoder.v
*/
`timescale 1ns/10ps

`include "cat.v"

module tb_decoder;

reg [31:0]inst;
reg inst_16;
reg clk;

wire arith;
wire dp;
wire sdibe;
wire llp;
wire lssd;
wire gpca;
wire gspa;
wire misc;
wire smr;
wire lmr;
wire cbsc;
wire ucb;

reg of;
integer file;

decoder top(inst,inst_16,clk,
			arith,dp,sdibe,llp,lssd,gpca,gspa,misc,smr,lmr,cbsc,ucb);

    initial begin
        inst    = 0;
        inst_16 = 1;  
        clk     = 0;
        of      = 0;
    end

    always #5 clk = ~clk;
    
    initial begin
    #10 forever  @(posedge clk) begin
            #5 {of,inst[31:26]}<={of,inst[31:26]}+1;
        end
    end
    
    initial begin
        file    =   $fopen("./decoder.log","w"); 
        $fdisplay(file,"inst[31:26] inst_16 [arith,dp,sdibe,llp,lssd,gpca,gspa,misc,smr,lmr,cbsc,ucb]   time");
        forever @ (posedge clk)begin
     #1 $fdisplay(file,"%b\t\t%b\t\t%b\t\t\t\t@%d",inst[31:26],inst_16,{arith,dp,sdibe,llp,lssd,gpca,gspa,misc,smr,lmr,cbsc,ucb},$time);      
        end
    end
    
    always @(posedge clk) begin
        if(of == 1'b1)begin
            $fclose(file);
            $finish;
        end
    end

endmodule
