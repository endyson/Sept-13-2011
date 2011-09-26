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
    input carry_in,

    output reg [3:0] rd,
    output reg [3:0] ra,
    output reg [3:0] rb,

    output reg imm_or_reg,
    output reg shift_or_not,
    output reg thumb_or_not,

    output reg [31:0]imm32,
    output  [11:0]imm12,
    output reg [1:0]s_type,
    output reg [4:0] offset
);


assign {s_type,offset} = shift_or_not ? {inst[5:4], {inst[14:12],inst[7:6]}} : 7'b0;
assign imm12 = thumb_or_not ==1'b0 ? 12'b0: {inst[26],inst[14:12],inst[7:0]};

/*
*Instructions Pattern match Logical.Please refer to instructions_pattern_specification.docx for details
*a>,Mainly used to fetch register addresses or immediate numbers for later operands access.
*b>,Certain register address (mainly SP or PC) or immediate number fetch are not achieved within this module, and these will marked out in the following.
*/

always @ * begin
    casex(inst[31:15])
        //pattera 1:
        17'b11110?01010?????0,//ADC(imm) T1
        17'b11110?01000?????0://ADD(imm) T3
//      17'b11110?01000?11010://ADD(SP imm) T3 :Intergrated into the "ADD(imm) T3"
        begin
            rd = inst[11:8];
            ra = inst[19:16];
            thumb_or_not = 1'b1;
            imm_or_reg = 1'b1;
            shift_or_not = 1'b0;
        end
        //pattern 2:
        17'b11110?100000????0,//ADD(imm) T4
//      17'b11110?10000011110,//ADR T3  :Intergrated into "ADD(imm) T4"
//      17'b11110?10000011010,//ADD(SP imm) T4:Intergrated into "ADD(imm) T4"
        17'b11110?10101011110://ADR T2
        begin
            rd = inst[11:8];
            ra = inst[19:16];

            imm32 = {20'b0,inst[26],inst[14:12],inst[7:0]};
            imm_or_reg = 1'b1;
            thumb_or_not = 1'b0;
            shift_or_not = 1'b0;
        end
        //pattera 3:
        17'b11101011010?????0,//ADC(reg) T2
        17'b11101011000?????0://ADD(reg) T3
//      17'b11101011000?11010://ADD(SP reg) T3 :Intergrated into "ADD(reg) T3"
        begin
            rd = inst[11:8];
            ra = inst[19:16];
            rb = inst[3:0];
            imm_or_reg = 1'b0;
            thumb_or_not = 1'b0;
            shift_or_not = 1'b1;
        end
        //pattern 4:
        17'b0100000101???????://ADC(reg) T1
        begin
            rd = {1'b0,inst[18:16]};
            ra = {1'b0,inst[18:16]};
            rb = {1'b0,inst[21:19]};
            imm_or_reg = 1'b0;
            thumb_or_not = 1'b0;
            shift_or_not = 1'b0;
        end
        //pattern 5:
        17'b0001110??????????://ADD(imm) T1
        begin
            rd = {1'b0,inst[18:16]};
            ra = {1'b0,inst[21:19]};
            imm32 = {29'b0,inst[24:22]};
            imm_or_reg = 1'b1;
            thumb_or_not = 1'b0;
            shift_or_not = 1'b0;
        end
        //pattern 6:
        17'b00110????????????,//ADD(imm) T2
        17'b10101????????????,//ADD(SP imm) T1  *ra here is meanless, it will be muxed to SP later
        17'b10100????????????://ADR T1          *ra here is meanless, it will be muxed to PC later
        begin
            rd = {1'b0,inst[26:24]};
            ra = {1'b0,inst[26:24]};
            imm32 = {24'b0,inst[23:16]};
            imm_or_reg = 1'b1;
            thumb_or_not = 1'b0;
            shift_or_not = 1'b0;
        end
        //pattern 7:
        17'b101100000????????://ADD(SP imm); T2  *rd & ra are assigned to 13 (SP) 
        begin
            rd = 4'b1101;
            ra = 4'b1101;
            imm32 = {23'b0,inst[22:16],2'b0};
            imm_or_reg = 1'b1;
            thumb_or_not = 1'b0;
            shift_or_not = 1'b0;
        end
        //pattern 8:
        17'b0001100??????????://ADD(reg) T1
        begin
            rd = {1'b0,inst[18:16]};
            ra = {1'b0,inst[21:19]};
            rb = {1'b0,inst[24:22]};
            imm_or_reg = 1'b0;
            thumb_or_not = 1'b0;
            shift_or_not = 1'b0;
        end
        //pattern 9:
        17'b01000100?????????://ADD(reg) T2     *ra here refers to rm and rb refers to rn in ARMv7-M reference
//      17'b01000100?1101????,//ADD(SP reg) T1 :Intergrated into "ADD(reg) T2"
//      17'b010001001????101?://ADD(SP reg) T2 :Intergrated into "ADD(reg) T2"  *ra here refers to rm and rb refers to rn in ARMv7-M reference
        begin
            rd = {inst[23],inst[18:16]};
            ra = inst[22:19];
            rb = {inst[23],inst[18:16]};
            imm_or_reg = 1'b0;
            thumb_or_not = 1'b0;
            shift_or_not = 1'b0;
        end
    endcase
end
endmodule 

