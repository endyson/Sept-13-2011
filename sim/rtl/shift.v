/* File:
 * Author:Xiao,Chang
 * Email: chngxiao@gmail.com
 * Original Date:  
 * Last Modified:
 * Description: 
 * Copyright:
 * Notice: Please do me a favor to NOT remove the content above. 
 *         If you have any modification and description on this, please add it anywhere you like!.
 *         This is all I need when I do this.
 *         Thank you very much for concernning and Welcome to join into my work!
 *         Please Feel free to email me by the email address above.
 */
`ifndef SHIFT_H
`define SHIFT_H
module shift(
    input [1:0]s_type,
    input [4:0]offset,
    input [31:0]op_m,
    input carry_in,

    output reg [31:0]result,
    output reg carry
);

//reg carry_container;

always @ ( s_type or offset)begin
    case(s_type)
        //SRTYPE_LSL
        2'b00:begin
//            result  = offset == 5'b0 ? 32'b0 : {op_m[(31-offset) :0], offset{1'b0} };
//            carry   = offset == 5'b0 ? op_m[0] : op_m[31-offset +1];
            {carry,result} = offset ==0 ? {op_m[0],32'b0} : {carry,op_m}<<offset;
        end
        //SRTYPE_LSR
        2'b01:begin
  //          result  = offset == 5'b0 ? 32'b0 : {offset{1'b0},op_m[31:offset]};
    //        carry   = offset == 5'b0 ? op_m[31] : op_m[offset-1];
            {result,carry} = offset == 0 ? {32'b0,op_m[31]} : {op_m,carry}>>offset;
        end
        //SRTYPE_ASR
        2'b10:begin
//            result  = offset == 5'b0 ? {32{op_m[31]}} : {offset[op_m[31],op_m[31:offset]};
  //          carry   = offset == 5'b0 ? op_m[31] : op_m[offset-1];
              {result,carry} = offset == 0 ? {33{op_m[31]}}  : {op_m,carry}>>offset | { {32{op_m[31]}}<<(32-offset) , 1'b0 };            
        end
        //SRTYPE_RRX & SRTYPE_ROR
        2'b11:begin
            {result,carry}  = offset == 0 ? {carry_in,op_m} : {op_m,carry}>>offset | {op_m<<(32-offset), 1'b0};
  //          carry   = offset == 0 ? op_m[0] : op_m[offset-1];
                  

        end
    endcase
end
endmodule 

`endif
