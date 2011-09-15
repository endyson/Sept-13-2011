/* File:            reg.v
 * Author:          Xiao,Chang
 * Email:           chngxiao@gmail.com
 * Original Date:   9/14/2011 
 * Last Modified:   9/14/2011
 * Description:     For registers and D-FFs modules reuse purpose.
 * Copyright:       All right reserved by Xiao,Chang.
 *
 * Notice: Please do me a favor to NOT remove the content above. 
 *         If you have any modification and description on this, please add it anywhere you like!.
 *         This is all I need when I do this.
 *         Thank you very much for concernning and Welcome to join into my work!
 *         Please Feel free to email me by the email address above.
 */
`ifndef REG_V
`define REG_V
module dff_en(
    input d,
    input en,
    input clk,
    output reg q
);
always @ (posedge clk)begin
    if(en)q <= d;
end
endmodule

module dff_en_rst(
    input d,
    input en,
    input rst,
    input clk,
    output reg q
);
always @ (posedge clk)begin
    if(rst) q <= 0;
    else if(en)q <= d;
end
endmodule

module reg_8(
    input [7:0] in,
    input clk,
    output reg [7:0]out);
always @ (posedge clk) begin
    out <= in;
end
endmodule

module reg_8_en(
    input [7:0] in,
    input clk,
    input en,
    output reg [7:0]out);
always @ (posedge clk) begin
    if(en) out <= in;
end
endmodule


module reg_16_en(
    input [15:0]in,
    input clk,
    input en,
    output reg [15:0]out);
always @(posedge clk)begin
    if(en == 1'b1)  out <= in;
end
endmodule

module reg_32_en(
    input [31:0]in,
    input clk,
    input en,
    output reg [31:0]out);
always @(posedge clk)begin
    if(en) out <= in;
end
endmodule
`endif
