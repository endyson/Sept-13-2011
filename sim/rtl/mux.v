/* File:            arm_core.v
 * Author:          Xiao,Chang
 * Email:           chngxiao@gmail.com
 * Original Date:   9/14/2011 
 * Last Modified:   9/14/2011
 * Description:     Muxs reused in the design.
 * Copyright:       All right reserved by Xiao,Chang.
 *
 * Notice: Please do me a favor to NOT remove the content above. 
 *         If you have any modification and description on this, please add it anywhere you like!.
 *         This is all I need when I do this.
 *         Thank you very much for concernning and Welcome to join into my work!
 *         Please Feel free to email me by the email address above.
 */
`ifndef MUX_V
`define MUX_V
module mux_16_32(
    input [15:0] in_16,
    input sel,
    output  [31:0]out_32,
    output  [1:0]en_2
);

assign out_32[31:16] = in_16; 
assign en_2 = sel ?2'b01: 2'b10;
assign out_32[15:0]	= in_16;

endmodule

module mux_32_32(
    input [31:0]a,
    input [31:0]b,
    input sel,
    output [31:0]out);

assign out = sel ? a : b;

endmodule

module mux_4_4(
    input [3:0]a,
    input [3:0]b,
    input sel,
    output [3:0]out);
assign out = sel ? a : b;
endmodule
`endif
