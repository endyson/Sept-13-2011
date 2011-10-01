/*
* Author:	Xiao, Chang
* Date:		9/26/2011
* Version:	0.0
* File:		tb_reg_file.v
*/
`timescale 1ns/10ps

`include "reg_file.v"

module tb_reg_file;

reg [3:0]rn_addr,rm_addr,rd_addr;
reg w_en;
reg clk;
reg [31:0] rd_data;

wire [31:0] rn_data,rm_data;
integer fd;
reg [2:0] mode;
reg [3:0] cnt;
reg_file u_reg_file(rn_addr,rm_addr,rd_addr,w_en,clk, rd_data,rn_data,rm_data);

initial begin
    mode = 0;
    rn_addr=0;
    rm_addr=0;
    rd_addr=0;
    w_en = 1;
    clk = 0;
    cnt = 0;
    fd = $fopen("./reg_file.log","w");
end

always #5 clk = ~clk;

always @(posedge clk)begin
    {mode,cnt} <= {mode,cnt} + 1;
    case(mode)
        3'b000:begin//write 16 , read 16
            w_en <= 1'b1;
            rd_addr <= rd_addr+1;
            rd_data <= cnt;
        end
        3'b001:begin
            w_en <= 1'b0;
            rn_addr <= rn_addr +1;
            rm_addr <= rm_addr +1;
        end
        3'b010,
            3'b011: begin//write 1, read 1
            w_en <= ~w_en;
            if(w_en)begin
                rd_addr <=rd_addr+1;
                rd_data <=rd_data+1;
            end
            else begin
                rn_addr <=rn_addr+1;
                rm_addr <=rm_addr+1;
            end
        end
        3'b100:begin
            w_en <=1;
            rd_addr <= rd_addr+1;
            rd_data <= cnt;
        end
        3'b101:begin
            w_en <= 1;
            rd_addr <= rd_addr + 1;
            rd_data <= 4'hf - cnt;
        end
        3'b110:begin
            w_en <= 1'b0;
            rn_addr <= rn_addr +1;
            rm_addr <= rm_addr +1;
        end
        3'b111:$finish;
    endcase
    #1 $fdisplay (fd,"w_en=%b\trn=%h\trm=%h\trd=%h\trn_addr=%h\trm_addr=%h\trd_addr=%h",
        w_en,rn_data,rm_data,rd_data,rn_addr,rm_addr,rd_addr);
end

endmodule
