/* File:            inst_pattern_match.v
 * Author:          Xiao,Chang
 * Email:           chngxiao@gmail.com
 * Original Date:   9/14/2011 
 * Last Modified:   9/18/2011
 * Description:     Dectect the patterns of the current instruction and
 *                  establish the input for next stage.
 * Copyright:       All right reserved by Xiao,Chang.
 *
 * Notice: Please do me a favor to NOT remove the content above. 
 *         If you have any modification and description on this, please add it anywhere you like!.
 *         This is all I need when I do this.
 *         Thank you very much for concernning and Welcome to join into my work!
 *         Please Feel free to email me by the email address above.
 */
//`include "thumb_expand_imm.v"
module inst_pattern_match(
    input [31:0] inst,
    input clk,
    input carry_in,

    output reg [3:0] rd,
    output reg [3:0] rn,
    output reg [3:0] rm,

    output reg imm_or_reg,
    output reg shift_or_not,
    output reg thumb_or_not,

    output reg [31:0]imm32,
    output  [11:0]imm12,
    output reg [1:0]s_type,
    output reg [4:0] offset
);
//To be removed
function [31:0] thumb_expand_imm;
    input [11:0] imm12;
    begin
 if (imm12[11:10] == 2'b00)begin
        case(imm12[9:8])
            2'b00:thumb_expand_imm = {24'b0,imm12[7:0]};
            2'b01:thumb_expand_imm = {8'b0,imm12[7:0],8'b0,imm12[7:0]};
            2'b10:thumb_expand_imm = {imm12[7:0],8'b0,imm12[7:0],8'b0};
            2'b11:thumb_expand_imm = {imm12[7:0],imm12[7:0],imm12[7:0],imm12[7:0]};
        endcase
    end
    else begin
      thumb_expand_imm = {24'b0,1'b1,imm12[6:0]}>>imm12[11:7] | {24'b0,1'b1,imm12[6:0]}<<(32-imm12[11:7]); 
    end
end
endfunction

assign {s_type,offset} = shift_or_not ? {inst[5:4], {inst[14:12],inst[7:6]}} : 7'b0;
assign imm12 = thumb_or_not ==1'b0 ? 12'b0: {inst[26],inst[14:12],inst[7:0]};

always @ (posedge clk)begin
    casex(inst[31:15])
        //pattern 1:
        17'b11110?01010?????0,//ADC(imm) T1
        17'b11110?01000?????0,//ADD(imm) T3
        17'b11110?01000?11010://ADD(SP plus imm) T3
        begin
            rd = inst[11:8];
            rm = inst[19:16];
    //        {imm32,carry_out} = thumb_expand_imm({inst[26],inst[14:12],inst[7:0]}, carry_in);
            thumb_or_not = 1'b1;
            imm_or_reg = 1'b1;
            shift_or_not = 1'b0;
        end
        //pattern 2:
        17'b11110?100000????0,//ADD(imm) T4
        17'b11110?10000011010,//ADD(SP plus imm) T4
        17'b11110?10101011110,//ADR T2
        17'b11110?10000011110://ADR T3
        begin
            rd = inst[11:8];
            rm = inst[19:16];

            imm32 = {20'b0,inst[26],inst[14:12],inst[7:0]};
            imm_or_reg = 1'b1;
            thumb_or_not = 1'b0;
            shift_or_not = 1'b0;
        end
        //pattern 3:
        17'b11101011010?????0,//ADC(reg) T2
        17'b11101011000?????0,//ADD(reg) T3
        17'b11101011000?11010://ADD(SP plus reg) T3
        begin
            rd = inst[11:8];
            rm = inst[19:16];
            rn = inst[3:0];
            imm_or_reg = 1'b0;
            thumb_or_not = 1'b0;
            shift_or_not = 1'b1;
        end
        //pattern 4:
        17'b0100000101???????://ADC(reg) T1
        begin
            rd = {1'b0,inst[18:16]};
            rn = {1'b0,inst[18:16]};
            rm = {1'b0,inst[21:19]};
            imm_or_reg = 1'b0;
            thumb_or_not = 1'b0;
            shift_or_not = 1'b0;
        end
        //pattern 5:
        17'b0001110??????????://ADD(imm) T1
        begin
            rd = {1'b0,inst[18:16]};
            rm = {1'b0,inst[21:19]};
            imm32 = {29'b0,inst[24:22]};
            imm_or_reg = 1'b1;
            thumb_or_not = 1'b0;
            shift_or_not = 1'b0;
        end
        //pattern 6:
        17'b00110????????????,//ADD(imm) T2
        17'b10101????????????,//ADD(SP plus imm) T1
        17'b10100????????????://ADR T1
        begin
            rd = {1'b0,inst[26:24]};
            rm = {1'b0,inst[26:24]};
            imm32 = {24'b0,inst[23:16]};
            imm_or_reg = 1'b1;
            thumb_or_not = 1'b0;
            shift_or_not = 1'b0;
        end
        //pattern 7:
        17'b101100000????????://ADD(SP plus imm) T2
        begin
            rd = 4'b1101;
            rm = 4'b1101;
            imm32 = {23'b0,inst[22:16],2'b0};
            imm_or_reg = 1'b1;
            thumb_or_not = 1'b0;
            shift_or_not = 1'b0;
        end
        //pattern 8:
        17'b0001100??????????://ADD(reg) T1
        begin
            rd = {1'b0,inst[18:16]};
            rn = {1'b0,inst[21:19]};
            rm = {1'b0,inst[24:22]};
            imm_or_reg = 1'b0;
            thumb_or_not = 1'b0;
            shift_or_not = 1'b0;
        end
        //pattern 9:
        17'b01000100?????????,//ADD(reg) T2
        17'b010001001????101?://ADD(SP plus reg) T2
        begin
            rd = {inst[23],inst[18:16]};
            rn = inst[22:19];
            rm = {inst[23],inst[18:16]};
            imm_or_reg = 1'b0;
            thumb_or_not = 1'b0;
            shift_or_not = 1'b0;
        end
    endcase
end
endmodule 

