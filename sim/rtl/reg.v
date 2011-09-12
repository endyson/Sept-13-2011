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
