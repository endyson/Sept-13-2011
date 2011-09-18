/* File:            thumb_expand_imm.v
 * Author:          Xiao,Chang
 * Email:           chngxiao@gmail.com
 * Original Date:   9/15/2011
 * Last Modified:   9/15/2011
 * Description:     Used to expand immediate numbers used in the ARMv7-M
 *                  profile
 * Copyright:       All right reserved by Xiao,Chang
 * Notice: Please do me a favor to NOT remove the content above. 
 *         If you have any modification and description on this, please add it anywhere you like!.
 *         This is all I need when I do this.
 *         Thank you very much for concernning and Welcome to join into my work!
 *         Please Feel free to email me by the email address above.
 */
`ifndef THUMB_EXPAND_IMM_H
`define THUMB_EXPAND_IMM_H
`include "shift.v"

module thumb_expand_imm(
input [11:0]imm12,
input carry_in,
output reg [31:0]imm32,
output reg carry_out
);
always @ * begin
    if (imm12[11:10] == 2'b00)begin
        case(imm12[9:8])
            2'b00:imm32 = {24'b0,imm12[7:0]};
            2'b01:imm32 = {8'b0,imm12[7:0],8'b0,imm12[7:0]};
            2'b10:imm32 = {imm12[7:0],8'b0,imm12[7:0],8'b0};
            2'b11:imm32 = {imm12[7:0],imm12[7:0],imm12[7:0],imm12[7:0]};
        endcase
        carry_out = carry_in;
    end
    else begin
        shift(2'b11, imm12[11:7],{24'b0,1'b1,imm12[6:0]}, carry_in, imm32, carry_out); 
    end

end
endmodule
`endif
