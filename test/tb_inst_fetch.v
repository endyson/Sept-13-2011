/*
* Author:	Xiao, Chang
* Date:		8/3/2011
* Version:	0.0
* File:		tb_inst_fetch.v
*/
`timescale 1ns/10ps

`include "inst_fetch.v"
/*
*Instruction memory emulation module
*/

module mem(
    //    input   [15:0]  in_data,
    //    input   [4:0]   in_addr,
    input  [5:0]   out_addr,
    output  [15:0]  out_data);

parameter ADDR_WIDTH=6;
parameter DEPTH     =1<<ADDR_WIDTH;

reg [15:0]  mem_data[DEPTH-1:0];

assign out_data = mem_data[out_addr];    

endmodule

/*
* Top level TestBench
* */
module tb_instFetch;

//Port declarition
reg clk;
reg [5:0]mem_addr;
reg rst;
wire [31:0]inst;
wire valid;
wire [15:0]inst_hw;
wire is_inst_len_16;
integer fl;

//Module instancise
inst_fetch  top(inst_hw,clk,rst,inst,valid,is_inst_len_16);
mem         inst_mem(mem_addr,inst_hw);

//input Signals initialization 
initial begin
    clk     = 0;
    mem_addr= 0;
    rst     = 1;
#6  rst     = 0;
end

//Clock generation
always #5 clk = ~clk;

//PC emulation
always @ (posedge clk)begin
    if(valid == 1'b1 || valid == 1'b0)begin
        mem_addr = mem_addr + 1;
    end
end

//Logging 
initial begin  
    $readmemh("./inst.dat",inst_mem.mem_data);
    fl  =   $fopen("./inst_fetch.log","w");
    $fdisplay(fl,"valid\tis_lsb_hw\tis_inst_len_16\tinst_hw\tinst\tmem_addr\ttime");
    $fsdbDumpfile("./waveform.fsdb");
    $fsdbDumpvars();
end

always @ (posedge clk)begin
    if(mem_addr == 36 )begin
        $finish;
    end
    else begin
    #1  $fdisplay(fl,"%b\t%b\t%b\t%h\t%h\t%d\t@ %d",valid,top.is_lsb_hw,is_inst_len_16,inst_hw,inst,mem_addr,$time);
    end
end
endmodule
