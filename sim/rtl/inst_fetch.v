/* File:            inst_fetch.v
 * Author:          Xiao,Chang
 * Email:           chngxiao@gmail.com
 * Original Date:   9/14/2011 
 * Last Modified:   9/14/2011
 * Description:     Instruction fetch unit 
 * Copyright:       All right reserved by Xiao,Chang.
 *
 * Notice: Please do me a favor to NOT remove the content above. 
 *         If you have any modification and description on this, please add it anywhere you like!.
 *         This is all I need when I do this.
 *         Thank you very much for concernning and Welcome to join into my work!
 *         Please Feel free to email me by the email address above.
 */
`include "reg.v"
`include "mux.v"

module inst_fetch (
    input [15:0]inst_hw,
    input clk,
    input rst,
  
    output [31:0]valid_inst,
    output reg valid
//    output reg is_inst_len_16
);
wire [31:0] inst_wire;
wire [31:0] inst_reg;
wire [1:0] en_2;
reg  is_lsb_hw;

mux_16_32	u0 (inst_hw, is_lsb_hw, inst_wire, en_2);

generate
genvar i;
for (i = 0; i<2; i=i+1)begin:reg_32
    reg_16_en		u_reg(inst_wire[(i+1)*16-1:i*16], clk,en_2[i], inst_reg[(i+1)*16-1:i*16] );
end
endgenerate

assign valid_inst = inst_reg & {32{valid}};

//FSM control logical
always @ (posedge clk)begin
    if(rst == 1'b1)begin
        valid <= 0;
        is_lsb_hw <= 0;
    end
    else begin
        if(is_lsb_hw == 1'b1)begin//lsb of 32 bits instruction
            valid <= 1'b1;
            is_lsb_hw <= 1'b0;
            //is_inst_len_16 <= 1'b0;
        end
        else begin
            if( inst_wire[31:29]==3'b111 && inst_wire[28:27] != 2'b00 )begin//32 bits instruction
                valid <= 1'b0;
                is_lsb_hw <= 1'b1;
            end
            else begin//16 bits instruction
                valid <= 1;
                is_lsb_hw <= 1'b0;
              //  is_inst_len_16 <= 1'b1;
            end
        end
    end
end
endmodule 
